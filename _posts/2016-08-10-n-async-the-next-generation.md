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
      * Each time there's an `await` in the method, the `AwaitOnCompleted` gets called (unless it completes synchronously). That's why `YieldReturnAwaiter.IsCompleted` always returns `false` - otherwise the state machine would skip `AwaitOnCompleted` for completed tasks, and we'd never get a chance to intercept the yield. If it's our special `YieldReturnAwaiter`, we stop executing and set the `MoveNext()` task result to `true`. We also fetch the value using the awaiter's `GetResult()` method. Otherwise (as in the `Task.Delay()` in the example), we just hook up the continuation and let it continue until hitting the next `yield return`.

There's a small "type safety" issue – the compiler won't stop us from using `YieldReturn()` on any type in the method. But of course we only take values from yields that match the method's return type.

Lastly, this is just a **prototype**. I'll have to review it more thoroughly to make sure it's thread safe. I'm also not sure if `ExecutionContext` capturing was done correctly.

You can see the full implementation in [SharpLab](https://sharplab.io/#v2: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) or below.

```csharp
using System;
using System.Runtime.CompilerServices;
using System.Security;
using System.Threading;
using System.Threading.Tasks;

var enumerable = GetValuesAsync();
await Print(enumerable);
await Print(enumerable);

static async Task Print(AsyncEnumerable<int> enumerable)
{
    var enumerator = enumerable.GetEnumerator();
    while (await enumerator.MoveNext())
    {
        Console.WriteLine(enumerator.Current);
    }
}

static async AsyncEnumerable<int> GetValuesAsync()
{
    for (int i = 0; i < 5; i++)
    {
        await Task.Delay(200);
        await Task.Run(() => i).YieldReturn();
    }

    return default; // dummy value
}


public interface IAsyncEnumerable<T>
{
    IAsyncEnumerator<T> GetEnumerator();
}

public interface IAsyncEnumerator<T> : IDisposable
{
    T Current { get; }
    Task<bool> MoveNext(CancellationToken cancellationToken = default(CancellationToken));

}

public static class YieldReturnExtensions
{
    public static YieldReturnAwaitable<T> YieldReturn<T>(this Task<T> task)
    {
        return new YieldReturnAwaitable<T>(task);
    }
}

public struct YieldReturnAwaitable<TResult>
{
    private readonly Task<TResult> _task;

    public YieldReturnAwaitable(Task<TResult> task)
    {
        _task = task;
    }

    public YieldReturnAwaiter GetAwaiter() => new YieldReturnAwaiter(_task);

    public struct YieldReturnAwaiter : ICriticalNotifyCompletion, INotifyCompletion
    {
        private readonly TaskAwaiter<TResult> _awaiter;

        // if we return true, the state machine would skip calling AwaitOnCompleted
        // and we won't be able to yield
        // instead we check IsCompletedInternal in the Await method to optimize the continuation
        public bool IsCompleted => false;

        internal bool IsCompletedInternal => _awaiter.IsCompleted;

        internal YieldReturnAwaiter(Task<TResult> task)
        {
            _awaiter = task.GetAwaiter();
        }

        [SecuritySafeCritical]
        public void OnCompleted(Action continuation) => _awaiter.OnCompleted(continuation);

        [SecurityCritical]
        public void UnsafeOnCompleted(Action continuation) => _awaiter.UnsafeOnCompleted(continuation);

        public TResult GetResult() => _awaiter.GetResult();
    }
}

[AsyncMethodBuilder(typeof(AsyncEnumerableTaskMethodBuilder<>))]
public sealed class AsyncEnumerable<T> : IAsyncEnumerable<T>
{
    private AsyncEnumerableTaskMethodBuilder<T> _builder;

    internal AsyncEnumerable(AsyncEnumerableTaskMethodBuilder<T> builder)
    {
        _builder = builder;
    }

    public IAsyncEnumerator<T> GetEnumerator() => _builder.GetEnumerator();
}

public class AsyncEnumerableTaskMethodBuilder<T>
{
    private T _current;
    private IAsyncStateMachine _stateMachine;
    private TaskCompletionSource<bool> _tcs;
    private YieldReturnAwaitable<T>.YieldReturnAwaiter? _yieldReturnAwaiter;

    public static AsyncEnumerableTaskMethodBuilder<T> Create() => new AsyncEnumerableTaskMethodBuilder<T>();

    public void Start<TStateMachine>(ref TStateMachine stateMachine) where TStateMachine : IAsyncStateMachine
    {
        _stateMachine = stateMachine;
    }

    public void SetStateMachine(IAsyncStateMachine stateMachine)
    {
    }

    public void SetResult(T result)
    {
        // ignore the result value

        if (_tcs != null)
        {
            _tcs.TrySetResult(false);
        }
    }

    public void SetException(Exception exception)
    {
        if (_tcs != null)
        {
            _tcs.TrySetException(exception);
        }
    }

    public AsyncEnumerable<T> Task => new AsyncEnumerable<T>(this);

    public void AwaitOnCompleted<TAwaiter, TStateMachine>(ref TAwaiter awaiter, ref TStateMachine stateMachine)
        where TAwaiter : INotifyCompletion
        where TStateMachine : IAsyncStateMachine
    {
        Await(ref awaiter, ref stateMachine);
    }

    public void AwaitUnsafeOnCompleted<TAwaiter, TStateMachine>(ref TAwaiter awaiter, ref TStateMachine stateMachine)
        where TAwaiter : ICriticalNotifyCompletion
        where TStateMachine : IAsyncStateMachine
    {
        Await(ref awaiter, ref stateMachine);
    }

    private void Await<TAwaiter, TStateMachine>(ref TAwaiter awaiter, ref TStateMachine stateMachine)
        where TAwaiter : INotifyCompletion
        where TStateMachine : IAsyncStateMachine
    {
        _yieldReturnAwaiter = awaiter as YieldReturnAwaitable<T>.YieldReturnAwaiter?;
        if (_yieldReturnAwaiter?.IsCompletedInternal == true)
        {
            InvokeMoveNext();
        }
        else
        {
            var runner = new MoveNextRunner(ExecutionContext.Capture(), _stateMachine, this);
            awaiter.OnCompleted(() => runner.Run());
        }
    }

    private void InvokeMoveNext()
    {
        if (_yieldReturnAwaiter == null)
        {
            _stateMachine.MoveNext();
            return;
        }
        try
        {
            _current = _yieldReturnAwaiter.Value.GetResult();
            _tcs.TrySetResult(true);
        }
        catch (Exception ex)
        {
            _tcs.TrySetException(ex);
        }
    }

    internal IAsyncEnumerator<T> GetEnumerator()
    {
        return new AsyncEnumerator(this);
    }

    private sealed class AsyncEnumerator : IAsyncEnumerator<T>
    {
        private AsyncEnumerableTaskMethodBuilder<T> _builder;

        public AsyncEnumerator(AsyncEnumerableTaskMethodBuilder<T> builder)
        {
            _builder = builder;
        }

        public T Current => _builder._current;

        public void Dispose()
        {
        }

        public Task<bool> MoveNext(CancellationToken cancellationToken)
        {
            _builder._tcs = new TaskCompletionSource<bool>();
            _builder._stateMachine.MoveNext();
            return _builder._tcs.Task;
        }
    }

    private sealed class MoveNextRunner
    {
        private readonly ExecutionContext _context;

        private readonly IAsyncStateMachine _stateMachine;

        private static ContextCallback _invokeMoveNext;

        private readonly AsyncEnumerableTaskMethodBuilder<T> _builder;

        internal MoveNextRunner(ExecutionContext context, IAsyncStateMachine stateMachine, AsyncEnumerableTaskMethodBuilder<T> builder)
        {
            _context = context;
            _stateMachine = stateMachine;
            _builder = builder;
        }

        internal void Run()
        {
            if (_context != null)
            {
                try
                {
                    ContextCallback contextCallback = _invokeMoveNext;
                    if (contextCallback == null)
                    {
                        contextCallback = (_invokeMoveNext = new ContextCallback(InvokeMoveNext));
                    }
                    ExecutionContext.Run(_context, contextCallback, _builder);
                    return;
                }
                finally
                {
                    _context.Dispose();
                }
            }
            _builder.InvokeMoveNext();
        }

        private static void InvokeMoveNext(object builder)
        {
            ((AsyncEnumerableTaskMethodBuilder<T>)builder).InvokeMoveNext();
        }
    }
}
```
