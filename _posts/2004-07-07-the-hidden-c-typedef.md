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

<blockquote dir="ltr" style="margin-right:0px;">
  <p>
    <span style="color: #0000ff; font-size: x-small;"><span style="color: #0000ff; font-size: x-small;"></p> 
    
    <p>
      `using``<span style="color: #000000; font-size: x-small;"> `<span style="color: #008080; font-size: x-small;">IntList</span><span style="color: #000000; font-size: x-small;"> = System.Collections.Generic.</span><span style="color: #008080; font-size: x-small;">List</span><span style="color: #000000; font-size: x-small;"><</span><span style="color: #0000ff; font-size: x-small;">int</span><span style="font-size: x-small;"><span style="color: #000000;">>;</span></span></span>
    </p>
    
    <p>
      </span>`<span style="color: #000000; font-size: x-small;"> `<span style="color: #008080; font-size: x-small;">IntList</span><span style="color: #000000; font-size: x-small;"> = System.Collections.Generic.</span><span style="color: #008080; font-size: x-small;">List</span><span style="color: #000000; font-size: x-small;"><</span><span style="color: #0000ff; font-size: x-small;">int</span><span style="font-size: x-small;"><span style="color: #000000;">>;</span></span></span></span>
    </p></blockquote> 
    
    <p dir="ltr">
      Quite simple. This has been there since version 1, but it wasn't quite useful until now.
    </p>
    
    <p dir="ltr">
      Creating empty classes as suggested in the above link is a bad idea, in my opinion. You have to maintain them, and it can be awkward for interoperating assemblies (think of&nbsp;two assemblies defining different &ldquo;alias classes&rdquo; for the same type.)
    </p>
    
    <p dir="ltr">
      <i>Edit</i>: Also see this <a href="http://blogs.msdn.com/ericgu/archive/2004/08/17/215740.aspx">post</a> at Eric Gunnerson's blog.
    </p>