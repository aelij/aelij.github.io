---
id: 1341
title: '*N Async, the next generation'
date: 2016-08-10T15:28:38+00:00
author: Eli Arbel
layout: post
permalink: /2016/08/10/n-async-the-next-generation/
image: /wp-content/uploads/2016/03/pAsKfi7B_400x4001.png
categories:
  - Uncategorized
---
In the [previous installment](https://arbel.net/2010/11/12/n-async-part-1/), I discussed how to use iterators (`yield return`) to create async methods. This time, we're about to do almost the opposite &#8211; use async methods to implement async iterators.

<!--more-->

Here's what it looks like:

<script src="https://gist.github.com/aelij/dd36d8df93eacb004949af95298de61a.js"></script>

## What are async iterators?

In .NET we use the `IEnumerable<T>` and `IEnumerator<T>` interfaces to create forward-only iterators. The enumerator interface contains a `bool MoveNext()` method, that when called, advances the iterator to the next item.

Async iterators replace this method with `Task<bool> MoveNext()`, so that each step can be performed asynchronously. This is useful when the next item should be retrieved asynchronously &#8211; mainly because it incurs IO, such as when iterating over **Entity Framework** entities (materialized from a `DbReader`) and **Service Fabric** Reliable Collections (which may require disk IO if the items are not in memory). Both of these frameworks expose their own `IAsyncEnumerable<T>` and `IAsyncEnumerator<T>`, which work as I just described.

The [RX project](https://github.com/Reactive-Extensions/Rx.NET) has yes another [implementation for async enumerable](https://www.nuget.org/packages/System.Interactive.Async), which also provides a full LINQ implementation, so you can use operators such as `Where` and `Select`.

## Language support

Unfortunately, C# is lagging a bit behind. While it does support creating iterators using `yield return` and async methods using `async` and `await`, currently there's no way to combine the two. Or is there? 🙂

A very nifty feature has been added to the latest Roslyn beta (2.0.0-beta4 &#8211; not yet released) &#8211; &#8220;[arbitrary async returns](https://github.com/ljw1004/roslyn/blob/features/async-return/docs/specs/feature%20-%20arbitrary%20async%20returns.md)&#8220;. This was added mainly to address some allocation optimizations when dealing with Tasks (which are reference types) by providing an awaitable value type that defers the creation of the task until absolutely necessary, called `ValueTask`. But the compiler feature is much more flexible than that &#8211; it enables us to create custom &#8220;async method builder&#8221; classes that allow returning any<sup>1</sup> type from an async method.

I realized this feature could be somewhat _abused_ to create async iterators, as seen in the above example.

## How does it work?

  * A `YieldReturnAwaitable` which the extension method `YieldReturn()` returns. This awaitable/awaiter just wraps the task's awaiter, except for the `IsCompleted` property. More on that later.
  * `AsyncEnumerableTaskMethodBuilder<T>` which allows the compiler to create the async state machine. It works differently from the task method builder, because when returning an enumerable, it can be invoked multiple times by calling `GetEnumerator()`. Also, the async state machine's `MoveNext()` is not invoked automatically, but rather by the enumerator's `MoveNext()`. 
      * The state machine is started by calling `AsyncEnumerator<T>.MoveNext()`. A `TaskContinuationSource<bool>` is created to hold the return value of `MoveNext()`.
      * Each time there's an `await` in the method, the `AwaitOnCompleted` gets called (unless it completes synchronously). If it's our special `YieldReturnAwaiter`, we stop executing and set the `MoveNext()` task result to `true`. We also fetch the value using the awaiter's `GetResult()` method. Otherwise (as in the `Task.Delay()` in the example), we just hook up the continuation and let it continue until hitting the next &#8220;yield return&#8221;.

There's a small &#8220;type safety&#8221; issue &#8211; the compiler won't stop us from using `YieldReturn()` on any type in the method. But of course we only take values from yields that match the method's return type.

Lastly, this is just a **prototype**. I'll have to review it more thoroughly to make sure it's thread safe. I'm also not sure if `ExecutionContext` capturing was done correctly.

You can see the full implementation in [this gist](https://gist.github.com/aelij/5d046b86bfca13fb682c411852d08cfd). Note that compiling it requires launching VS using the current Roslyn `master` branch. You can also view the decompilation results on [Try Roslyn](http://tryroslyn.azurewebsites.net/#b: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).

* * *

<sup>1</sup> Somewhat inaccurate &#8211; the return type must have a static method called `CreateAsyncMethodBuilder`, so you can't extend types you don't own.