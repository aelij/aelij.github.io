---
title: Async-friendly stack traces
date: 2016-02-19T09:34:08+00:00
layout: post
featured: 4
excerpt: "Async stack traces are long and noisy, full of state machine and awaiter frames. Here is a library that formats them much more concisely."
permalink: /2016/02/19/async-friendly-stack-traces/
---
If you're using async/await a lot (a given nowadays), you may have noticed stack traces are not very readable. For example, this is the stack trace of a chain of async methods:

<!--more-->

```
System.Exception: Crash! Boom! Bang!
at AsyncFriendlyStackTrace.Test.Example1.<C>d__3.MoveNext() in C:\Source\Repos\AsyncFriendlyStackTrace\src\AsyncFriendlyStackTrace.Test\Example1.cs:line 26
--- End of stack trace from previous location where exception was thrown ---
at System.Runtime.CompilerServices.TaskAwaiter.ThrowForNonSuccess(Task task)
at System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNotification(Task task)
at AsyncFriendlyStackTrace.Test.Example1.<B>d__2.MoveNext() in C:\Source\Repos\AsyncFriendlyStackTrace\src\AsyncFriendlyStackTrace.Test\Example1.cs:line 20
--- End of stack trace from previous location where exception was thrown ---
at System.Runtime.CompilerServices.TaskAwaiter.ThrowForNonSuccess(Task task)
at System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNotification(Task task)
at AsyncFriendlyStackTrace.Test.Example1.<A>d__1.MoveNext() in C:\Source\Repos\AsyncFriendlyStackTrace\src\AsyncFriendlyStackTrace.Test\Example1.cs:line 15
--- End of stack trace from previous location where exception was thrown ---
at System.Runtime.CompilerServices.TaskAwaiter.ThrowForNonSuccess(Task task)
at System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNotification(Task task)
at AsyncFriendlyStackTrace.Test.Example1.<Run>d__0.MoveNext() in C:\Source\Repos\AsyncFriendlyStackTrace\src\AsyncFriendlyStackTrace.Test\Example1.cs:line 10
--- End of stack trace from previous location where exception was thrown ---
at System.Runtime.CompilerServices.TaskAwaiter.ThrowForNonSuccess(Task task)
at System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNotification(Task task)
at AsyncFriendlyStackTrace.Test.Program.Run[TExample](TextWriter writer) in C:\Source\Repos\AsyncFriendlyStackTrace\src\AsyncFriendlyStackTrace.Test\Program.cs:line 45
```

I've been using Service Fabric lately, and async is used everywhere. It made the logs hard to read and larger than they should be.

So (after some [deliberation](https://github.com/dotnet/runtime/issues/4996) with a Microsoft diagnostics engineer) I decided to create a library that formats stack traces much more concisely:

[AsyncFriendlyStackTrace](https://github.com/aelij/AsyncFriendlyStackTrace)

Usage is a single extension method call:

```csharp
exception.ToAsyncString()
```

Here's what the above stack trace would look like:

```
System.Exception: Crash! Boom! Bang!
at async AsyncFriendlyStackTrace.Test.Example1.C(?) in C:\Source\Repos\AsyncFriendlyStackTrace\src\AsyncFriendlyStackTrace.Test\Example1.cs:line 26
at async AsyncFriendlyStackTrace.Test.Example1.B(?) in C:\Source\Repos\AsyncFriendlyStackTrace\src\AsyncFriendlyStackTrace.Test\Example1.cs:line 20
at async AsyncFriendlyStackTrace.Test.Example1.A(?) in C:\Source\Repos\AsyncFriendlyStackTrace\src\AsyncFriendlyStackTrace.Test\Example1.cs:line 15
at async AsyncFriendlyStackTrace.Test.Example1.Run(?) in C:\Source\Repos\AsyncFriendlyStackTrace\src\AsyncFriendlyStackTrace.Test\Example1.cs:line 10
at AsyncFriendlyStackTrace.Test.Program.Run[TExample](TextWriter writer) in C:\Source\Repos\AsyncFriendlyStackTrace\src\AsyncFriendlyStackTrace.Test\Program.cs:line 45
```

Try the library, review the motivating examples in the repo, and let me know what you think. If this gets enough traction perhaps Microsoft could be convinced to add an extensibility point that would allow changing the default stack trace format.

**Update:** Since .NET 6, the runtime formats async stack traces concisely out of the box, so this library is no longer needed and its repo has been archived.
