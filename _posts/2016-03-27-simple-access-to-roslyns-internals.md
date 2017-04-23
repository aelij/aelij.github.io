---
id: 891
title: 'Simple access to Roslyn`s internals'
date: 2016-03-27T16:42:48+00:00
author: Eli Arbel
layout: post
guid: https://arbel.net/?p=891
permalink: /2016/03/27/simple-access-to-roslyns-internals/
dsq_thread_id:
  - "5736700444"
image: /wp-content/uploads/2016/03/pAsKfi7B_400x4001.png
categories:
  - Uncategorized
---
TL;DR Just grab the [.snk](https://github.com/dotnet/roslyn/blob/master/build/Strong%20Name%20Keys/RoslynInternalKey.Private.snk) from the Roslyn repo, name your bridge assembly to something from the InternalsVisibleTo (e.g. Roslyn.Hosting.Diagnostics), sign it with the key, and you can access all the internals at compile time, with IntelliSense!

<!--more-->

* * *

&nbsp;

[Roslyn](https://github.com/dotnet/roslyn) has a lot of very useful internal types. In fact, most of the functionality in [RoslynPad](https://roslynpad.net/) could not exist without them.

When I started out the &#8216;Pad, I naturally turned to Reflection to access those types. Even Roslyn's @jaredpar agrees:

<blockquote class="twitter-tweet" data-lang="en">
  <p dir="ltr" lang="en">
    In C++ every problem can be solved with a template<br /> In .NET every problem can be solved with private reflection
  </p>
  
  <p>
    — Jared Parsons (@jaredpar) <a href="https://twitter.com/jaredpar/status/712323795923513345">March 22, 2016</a>
  </p>
</blockquote>

There are things you can't do even with private Reflection. While you can access existing types, you can't inherit from an internal class or implement an internal interface. Fortunately, Roslyn's assemblies have an InternalsVisibleTo to DynamicProxyGenAssembly2, so I used Castle to generate implementations for what I needed. This was cumbersome, but it worked.

However I recently came to realize there's **a far better way**: Roslyn's has a lot of InternalsVisibleTo its test assemblies, and the [.snk](https://github.com/dotnet/roslyn/blob/master/build/Strong%20Name%20Keys/RoslynInternalKey.Private.snk) with the private key is in the public repo. So I just created a bridge assembly, named it to one of the test assemblies, signed it with the .snk, and now I can access all the internal types as if they were public. Super!