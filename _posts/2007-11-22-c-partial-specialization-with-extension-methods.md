---
id: 172
title: 'C# Partial Specialization With Extension Methods'
date: 2007-11-22T06:46:00+00:00
author: Eli Arbel
layout: post
redirect_from:
  - /blog/archive/2007/11/21/c-partial-specialization-with-extension-methods.aspx.html
guid: /blog/archive/2007/11/21/c-partial-specialization-with-extension-methods.aspx
permalink: /2007/11/22/c-partial-specialization-with-extension-methods/
dsq_thread_id:
  - "5736700149"
categories:
  - Uncategorized
tags:
  - 'C#'
  - Programming Languages
---
One of the things C# generics lacks ([compared](http://msdn2.microsoft.com/en-us/library/c6cyy67b.aspx) to C++ templates) is [specialization](http://msdn2.microsoft.com/en-us/library/c401y1kb.aspx) (neither explicit nor partial). This can be very useful in some cases where you want to perform something differently for a specific _T_ in a _Class<T>_.

With C# 3.0, there is a relatively easy way to achieve this, albeit not optimal, for reasons I'll specify later on. Take a look at the following piece of code:

<span style="font-size:10pt;line-height:115%;font-family:consolas;"></span>&nbsp;

<p class="MsoNormal" style="margin-bottom:0pt;line-height:8pt;">
  <span style="font-size:10pt;font-family:consolas;"><span>&nbsp;&nbsp;&nbsp; </span><span style="color:blue;">public</span> <span style="color:blue;">class</span> <span>SomeClass</span><T></span>
</p>

<p class="MsoNormal" style="margin-bottom:0pt;line-height:8pt;">
  <span style="font-size:10pt;font-family:consolas;"><span>&nbsp;&nbsp;&nbsp; </span>{</span>
</p>

<p class="MsoNormal" style="margin-bottom:0pt;line-height:8pt;">
  <span style="font-size:10pt;font-family:consolas;"><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><span style="color:blue;">private</span> <span style="color:blue;">readonly</span> <span>List</span><T> items = <span style="color:blue;">new</span> <span>List</span><T>();</span>
</p>

<p class="MsoNormal" style="margin-bottom:0pt;line-height:8pt;">
  <span style="font-size:10pt;font-family:consolas;">&nbsp;</span>
</p>

<p class="MsoNormal" style="margin-bottom:0pt;line-height:8pt;">
  <span style="font-size:10pt;font-family:consolas;"><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><span style="color:blue;">internal</span> <span style="color:blue;">void</span> AddInternal(T item)</span>
</p>

<p class="MsoNormal" style="margin-bottom:0pt;line-height:8pt;">
  <span style="font-size:10pt;font-family:consolas;"><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>{</span>
</p>

<p class="MsoNormal" style="margin-bottom:0pt;line-height:8pt;">
  <span style="font-size:10pt;font-family:consolas;"><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>items.Add(item);</span>
</p>

<p class="MsoNormal" style="margin-bottom:0pt;line-height:8pt;">
  <span style="font-size:10pt;font-family:consolas;"><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>}</span>
</p>

<p class="MsoNormal" style="margin-bottom:0pt;line-height:8pt;">
  <span style="font-size:10pt;font-family:consolas;"><span>&nbsp;&nbsp;&nbsp; </span>}</span>
</p>

<p class="MsoNormal" style="margin-bottom:0pt;line-height:8pt;">
  <span style="font-size:10pt;font-family:consolas;">&nbsp;</span>
</p>

<p class="MsoNormal" style="margin-bottom:0pt;line-height:8pt;">
  <span style="font-size:10pt;font-family:consolas;"><span>&nbsp;&nbsp;&nbsp; </span>[<span>EditorBrowsable</span>(<span>EditorBrowsableState</span>.Never)]</span>
</p>

<p class="MsoNormal" style="margin-bottom:0pt;line-height:8pt;">
  <span style="font-size:10pt;font-family:consolas;"><span>&nbsp;&nbsp;&nbsp; </span><span style="color:blue;">public</span> <span style="color:blue;">static</span> <span style="color:blue;">class</span> <span>SomeClassExtensions</span></span>
</p>

<p class="MsoNormal" style="margin-bottom:0pt;line-height:8pt;">
  <span style="font-size:10pt;font-family:consolas;"><span>&nbsp;&nbsp;&nbsp; </span>{</span>
</p>

<p class="MsoNormal" style="margin-bottom:0pt;line-height:8pt;">
  <span style="font-size:10pt;font-family:consolas;"><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><span style="color:blue;">public</span> <span style="color:blue;">static</span> <span style="color:blue;">void</span> Add<T>(<span style="color:blue;">this</span> <span>SomeClass</span><T> c, T item)</span>
</p>

<p class="MsoNormal" style="margin-bottom:0pt;line-height:8pt;">
  <span style="font-size:10pt;font-family:consolas;"><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>{</span>
</p>

<p class="MsoNormal" style="margin-bottom:0pt;line-height:8pt;">
  <span style="font-size:10pt;font-family:consolas;"><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>c.AddInternal(item);</span>
</p>

<p class="MsoNormal" style="margin-bottom:0pt;line-height:8pt;">
  <span style="font-size:10pt;font-family:consolas;"><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>}</span>
</p>

<p class="MsoNormal" style="margin-bottom:0pt;line-height:8pt;">
  <span style="font-size:10pt;font-family:consolas;">&nbsp;</span>
</p>

<p class="MsoNormal" style="margin-bottom:0pt;line-height:8pt;">
  <span style="font-size:10pt;font-family:consolas;"><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><span style="color:blue;">public</span> <span style="color:blue;">static</span> <span style="color:blue;">void</span> Add(<span style="color:blue;">this</span> <span>SomeClass</span><<span style="color:blue;">int</span>> c, <span style="color:blue;">int</span> item)</span>
</p>

<p class="MsoNormal" style="margin-bottom:0pt;line-height:8pt;">
  <span style="font-size:10pt;font-family:consolas;"><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>{</span>
</p>

<p class="MsoNormal" style="margin-bottom:0pt;line-height:8pt;">
  <span style="font-size:10pt;font-family:consolas;"><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><span style="color:blue;">if</span> (item <= 0)</span>
</p>

<p class="MsoNormal" style="margin-bottom:0pt;line-height:8pt;">
  <span style="font-size:10pt;font-family:consolas;"><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>{</span>
</p>

<p class="MsoNormal" style="margin-bottom:0pt;line-height:8pt;">
  <span style="font-size:10pt;font-family:consolas;"><span style="font-size:10pt;font-family:consolas;"><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><span style="color:blue;">throw</span> <span style="color:blue;">new</span> <span>ArgumentOutOfRangeException</span>(<span>"item"</span>, <span>"Value must be a positive integer."</span>);</span></span>
</p>

<p class="MsoNormal" style="margin-bottom:0pt;line-height:8pt;">
  <span style="font-size:10pt;font-family:consolas;"><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>}</span>
</p>

<p class="MsoNormal" style="margin-bottom:0pt;line-height:8pt;">
  <span style="font-size:10pt;font-family:consolas;"></span><span style="font-size:10pt;font-family:consolas;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; c.Add<span style="color:blue;"></span>Internal(item);</span>
</p>

<p class="MsoNormal" style="margin-bottom:0pt;line-height:8pt;">
  <span style="font-size:10pt;font-family:consolas;"></span><span style="font-size:10pt;font-family:consolas;"><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>}</span>
</p>

<p class="MsoNormal" style="line-height:8pt;">
  <span style="font-size:10pt;font-family:consolas;"><span>&nbsp;&nbsp;&nbsp; </span>}</span>
</p>

<p class="MsoNormal" style="line-height:8pt;">
  <span style="font-size:10pt;font-family:consolas;"></span>&nbsp;
</p>

Instead of placing the **Add** method in SomeClass<T>, we put it in a static class that has [extension methods](http://msdn2.microsoft.com/en-us/library/ms364047.aspx#cs3spec_topic3). This allows the compiler to select the appropriate method according to the type parameter. (Side note: I've specified the EditorBrowsable attribute so that the class with the extensions would not appear in VS intellisense.)

The biggest caveat about this is that extension methods do no have access to private members, so the only option is to make the members **internal**, which, in many cases, leads to a bad design. If only extension method classes could be written as inner classes&#8230;

Also, extension methods, being static, could not be virtualized. You can, however, make the internal method "_protected internal virtual_".