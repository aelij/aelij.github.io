---
title: '*N Async, the next generation'
date: 2016-08-10T15:28:38+00:00
layout: post
featured: 3
excerpt: "Building async iterators years before C# 8 added them."
permalink: /2016/08/10/n-async-the-next-generation/
---
In the [previous installment](/2010/11/12/n-async-part-1/), I discussed how to use iterators (`yield return`) to create async methods. This time, we're about to do almost the opposite – use async methods to implement async iterators.

<!--more-->

Here's what it looks like:

```csharp
public static async AsyncEnumerable<int> GetValuesAsync()
{
    for (int i = 0; i < 5; i++)
    {
        await Task.Delay(200);
        await Task.FromResult(i).YieldReturn();
    }

    return default(int); // dummy value
}
```

## What are async iterators?

In .NET we use the `IEnumerable<T>` and `IEnumerator<T>` interfaces to create forward-only iterators. The enumerator interface contains a `bool MoveNext()` method, that when called, advances the iterator to the next item.

Async iterators replace this method with `Task<bool> MoveNext()`, so that each step can be performed asynchronously. This is useful when the next item should be retrieved asynchronously – mainly because it incurs IO, such as when iterating over **Entity Framework** entities (materialized from a `DbDataReader`) and **Service Fabric** Reliable Collections (which may require disk IO if the items are not in memory). Both of these frameworks expose their own `IAsyncEnumerable<T>` and `IAsyncEnumerator<T>`, which work as I just described.

The [RX project](https://github.com/dotnet/reactive) has yet another [implementation for async enumerable](https://www.nuget.org/packages/System.Interactive.Async), which also provides a full LINQ implementation, so you can use operators such as `Where` and `Select`.

## Language support

Unfortunately, C# is lagging a bit behind. While it does support creating iterators using `yield return` and async methods using `async` and `await`, currently there's no way to combine the two. Or is there?

Roslyn 2.0 introduced a very nifty feature – "[arbitrary async returns](https://github.com/dotnet/csharplang/blob/main/proposals/csharp-7.0/task-types.md)". This was added mainly to address some allocation optimizations when dealing with Tasks (which are reference types) by providing an awaitable value type that defers the creation of the task until absolutely necessary, called `ValueTask`. But the compiler feature is much more flexible than that – it enables us to create custom "async method builder" classes that allow returning any type from an async method.

I realized this feature could be somewhat _abused_ to create async iterators, as seen in the above example.

## How does it work?

There are two main pieces:

  * A `YieldReturnAwaitable` which the extension method `YieldReturn()` returns. This awaitable/awaiter just wraps the task's awaiter, except for the `IsCompleted` property, which always returns `false`.
  * `AsyncEnumerableTaskMethodBuilder<T>` which allows the compiler to create the async state machine. It works differently from the task method builder, because when returning an enumerable, it can be invoked multiple times by calling `GetEnumerator()`. Also, the async state machine's `MoveNext()` is not invoked automatically, but rather by the enumerator's `MoveNext()`.
      * The state machine is started by calling `AsyncEnumerator<T>.MoveNext()`. A `TaskCompletionSource<bool>` is created to hold the return value of `MoveNext()`.
      * Each time there's an `await` in the method, the `AwaitOnCompleted` gets called (unless it completes synchronously). That's why `YieldReturnAwaiter.IsCompleted` always returns `false` - otherwise the state machine would skip `AwaitOnCompleted` for completed tasks, and we'd never get a chance to intercept the yield. If it's our special `YieldReturnAwaiter`, we stop executing and set the `MoveNext()` task result to `true`. We also fetch the value using the awaiter's `GetResult()` method. Otherwise (as in the `Task.Delay()` in the example), we just hook up the continuation and let it continue until hitting the next "yield return".

There's a small "type safety" issue – the compiler won't stop us from using `YieldReturn()` on any type in the method. But of course we only take values from yields that match the method's return type.

Lastly, this is just a **prototype**. I'll have to review it more thoroughly to make sure it's thread safe. I'm also not sure if `ExecutionContext` capturing was done correctly.

You can see the full implementation in [SharpLab](https://sharplab.io/#v2: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).
