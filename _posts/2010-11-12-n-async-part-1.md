---
id: 194
title: '*N Async, Part 1'
date: 2010-11-12T17:49:07+00:00
author: Eli Arbel
layout: post
redirect_from:
  - /blog/archive/2010/11/12/n-async-part-1.aspx.html
guid: /blog/archive/2010/11/12/n-async-part-1.aspx
permalink: /2010/11/12/n-async-part-1/
tags:
  - Async
  - 'C#'
  - Experiments
---
You've all read about the asynchrony promise of C# 5 (if you haven't, I highly recommend reading Eric Lippert's [series](http://blogs.msdn.com/b/ericlippert/archive/tags/c_2300_+5-0/) about the subject or this post won't make much sense). I think it's a great step forward, and it would make asynchronous programming all a lot easier.

<!--more-->

We already know how to think in Tasks instead of threads, .NET 4.0 taught us that.

We already know how to use continuations (or at least some weak form of it), C# 2.0 iterators taught us that.

&#160;

So, as an experiment\*, I went ahead and implemented a weak form of the await/async magic\** using "the materials in the room", i.e. tasks and iterators - minus the syntactic sugar, of course. Let's have a look.

&#160;

**First, A Sample**

In C# 5 we would have (taken from Anders' Netflix sample):

```csharp
async void LoadMoviesAsync(int year)
{
	while (true)
	{
		var movies = await QueryMoviesAsync(year, imageCount, pageSize, cts.Token);
		if (movies.Length == 0) break;
		DisplayMovies(movies);
	}
}
```

While in my implementation it would look like this:

```csharp
IEnumerable<Task> LoadMovies(int year)
{
	while (true)
	{
		var moviesTask = Async.Await<Movie[]>(result =>
			QueryMovies(result, year, imageCount, pageSize, cts.Token));
		yield return moviesTask;
		var movies = moviesTask.Result;
		if (movies.Length == 0) break;
		DisplayMovies(movies);
	}
}
```

****

**What's going on here?**

First of all, as you can see, the methods look very similar. We have created an iterator that allows us to start running the method and break after every _yield_. The implementation of Async.Await() method is surprisingly simple:

  * The Await() method simply creates an enumerator, which starts up the state machine.
  * It calls MoveNext(), which executes the method up to the next _yield_.
  * We get a Task from the yield, and attach a _continuation_ to it, which calls MoveNext() again, and so on.

```csharp
public static Task<T> Await<T>(Func<TaskCompletionSource<T>, IEnumerable<Task>> func)
{
	var completionSource = new TaskCompletionSource<T>();
	Await(func(completionSource));
	return completionSource.Task;
}
 
public static void Await(IEnumerable<Task> iterator)
{
	IEnumerator<Task> enumerator = iterator.GetEnumerator();
	Run(enumerator);
}
 
private static void Run(IEnumerator<Task> enumerator)
{
	if (enumerator.MoveNext())
	{
		enumerator.Current.ContinueWith(t => Run(enumerator));
	}
}
```

****

**Why do we need TaskCompletionSource?**

The return value of the iterator method must always be _IEnumerable<Task>_. But what if we want to return a value from a method? Remember, it doesn't execute synchronously anymore! That is why methods that (originally) do not return _void_, have the option of adding an argument of TaskCompletionSource. In the method, we can call TaskCompletionSource.SetResult() to set the result. We also return the Task the TCS creates, so the caller could access the result. The overload of Await() that we use in this case simply wraps around this functionality, and enables a more concise syntax.

When an asynchronous method has no return value, TaskCompletionSource is not needed.

&#160;

**What's missing?**

In the next installment(s) we will discuss:

  * Task Schedulers (how to make sure we're in the right context for UI operations)
  * Limited exception handling

&#160;

* Yes, it means I wouldn't recommend using this in "real" code - just wait for C# 5. This is just for fun.

** And I use the term very [figuratively](http://blogs.msdn.com/b/ericlippert/archive/2009/03/20/it-s-not-magic.aspx).