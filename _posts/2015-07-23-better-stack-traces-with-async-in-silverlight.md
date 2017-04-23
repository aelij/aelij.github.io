---
id: 424
title: Better stack traces with async in Silverlight
date: 2015-07-23T16:19:01+00:00
author: Eli Arbel
layout: post
guid: http://arbel.net/?p=424
permalink: /2015/07/23/better-stack-traces-with-async-in-silverlight/
image: /wp-content/uploads/2015/07/microsoft-silverlight-logo-mini1.jpg
categories:
  - Uncategorized
tags:
  - Async
  - Silverlight
---
I recently found out that using the [Microsoft.Bcl.Async](https://www.nuget.org/packages/Microsoft.Bcl.Async/) package to support async/await in Silverlight has a major downside &#8211; it rethrows exceptions without preserving the stack trace. That's because Silverlight lacks [ExceptionDispatchInfo](https://msdn.microsoft.com/en-us/library/system.runtime.exceptionservices.exceptiondispatchinfo), a mechanism that was added in .NET 4.5 that allows rethrowing exceptions while keeping their stack traces intact.

So I wrote this this gist to solve the problem:
  
<https://gist.github.com/aelij/7d37fa3657921cbd9d3d>

It works essentially the same as the original code from the async NuGet package, except for one thing &#8211; before rethrowing an async exception, it attempts to wrap it in a new exception of the same type, and place the old one as its inner exception. This way, try..catch blocks work as expected, and the stack trace is preserved.

Note that for C#'s method overload resolution to prefer this over the original implementation, you should place the <code>AwaitExtensions2</code> class in your app's root namespace. To verify that it does, you can call GetAwaiter and check the return type is TaskAwaiter2 (and not TaskAwaiter).

Enjoy!