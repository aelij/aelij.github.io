---
id: 144
title: 'The Hidden C# &quot;Typedef&quot;'
date: 2004-07-07T17:44:00+00:00
author: Eli Arbel
layout: post
redirect_from:
  - /blog/archive/2004/07/07/The-Hidden-C_2300_-_2200_Typedef_2200_.aspx.html
guid: /blog/archive/2004/07/07/The-Hidden-C_2300_-_2200_Typedef_2200_.aspx
permalink: /2004/07/07/the-hidden-c-typedef/
dsq_thread_id:
  - "5736700089"
categories:
  - Uncategorized
tags:
  - 'C#'
  - Programming Languages
---
I've just seen a [blog entry](http://blogs.msdn.com/mitchw/archive/2004/07/06/174412.aspx) about C# generics, concerning C#'s lack of **typedef**s. Actually, C# has a way of aliasing classes, using the **using directive**:

<!--more-->

```csharp
using IntList = System.Collections.Generic.List<int>; 
```

Quite simple. This has been there since version 1, but it wasn't useful until now.

Creating empty classes as suggested in the above link is a bad idea, in my opinion. You'd have to maintain additional types, and it can be awkward for interoperating assemblies (think of two assemblies defining different "alias classes" for the same type.)
      
*Edit*: Also see this [post](http://blogs.msdn.com/ericgu/archive/2004/08/17/215740.aspx) at Eric Gunnerson's blog.
