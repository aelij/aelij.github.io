---
id: 173
title: Writing Methods and Classes in LINQPad
date: 2008-08-18T08:54:00+00:00
author: Eli Arbel
layout: post
redirect_from:
  - /blog/archive/2008/08/18/writing-methods-and-classes-in-linqpad.aspx.html
guid: /blog/archive/2008/08/18/writing-methods-and-classes-in-linqpad.aspx
permalink: /2008/08/18/writing-methods-and-classes-in-linqpad/
dsq_thread_id:
  - "5736700270"
categories:
  - Uncategorized
tags:
  - 'C#'
  - Tips
---
[LINQPad](http://www.linqpad.net/) is a very useful code snippet IDE. I use it all the time to test small pieces of code. It's much more convenient than opening a new Visual Studio console application. It also formats the results very nicely.

<!--more-->

What seems to be missing in LINQPad is a way to add methods or classes. After digging a bit with reflector, I came up with a simple way:

  * Choose "C# Statement(s)" in the Type drop-down.
  * Write the code that LINQPad should execute.
  * Put a closing curly-bracket ("}") at the end.
  * Write as many classes and methods as you like.
  * On the last class/method, omit closing curly-bracket.

LINQPad simply compiles the code you're writing there, wrapping it in a class and a single method, which it then executes. By adding the closing bracket, we're actually ending the method it defines, and start writing our own methods and classes. Since a closing bracket will be added at the end of the code block, we omit it from our code.

If you want your classes to be proper (not inner), you will need to put two closing curly-brackets, and then define your class. This is important if you want to define extension methods (which must reside in a static, non-inner class).