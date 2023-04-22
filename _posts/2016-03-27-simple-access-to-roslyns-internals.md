---
id: 891
title: 'Simple access to Roslyn`s internals'
date: 2016-03-27T16:42:48+00:00
author: Eli Arbel
layout: post
permalink: /2016/03/27/simple-access-to-roslyns-internals/
dsq_thread_id:
  - "5736700444"
image: /wp-content/uploads/2016/03/pAsKfi7B_400x4001.png
categories:
  - Uncategorized
---

Update: Just use [IgnoresAccessChecksToGenerator](https://github.com/aelij/IgnoresAccessChecksToGenerator)

~~TL;DR Just grab the [.snk](https://github.com/dotnet/roslyn/blob/master/build/Strong%20Name%20Keys/RoslynInternalKey.Private.snk) from the Roslyn repo, name your bridge assembly to something from the InternalsVisibleTo (e.g. Roslyn.Hosting.Diagnostics), sign it with the key, and you can access all the internals at compile time, with IntelliSense!~~
