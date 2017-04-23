---
id: 160
title: Revamped Style Snooper
date: 2006-11-05T21:09:00+00:00
author: Eli Arbel
layout: post
redirect_from:
  - /blog/archive/2006/11/05/Revamped-Style-Snooper.aspx.html
guid: /blog/archive/2006/11/05/Revamped-Style-Snooper.aspx
permalink: /2006/11/05/revamped-style-snooper/
dsq_thread_id:
  - "5736700245"
categories:
  - Uncategorized
tags:
  - WPF
---
**Update:** This&nbsp;utility has become a bit irrelevant since [Reflector](http://www.aisto.com/roeder/dotnet/) now has a [BAML Viewer](http://www.codeplex.com/reflectoraddins/Wiki/View.aspx?title=BamlViewer&referringTitle=Home) add-in. You can use it to view any assembly containing BAML resources, which it will automatically&nbsp;decompile into XAML.

<!--more-->

Style Snooper (or StyleSnooper?), originally [posted](http://blogs.msdn.com/llobo/archive/2006/07/17/Tool-to-Examine-WPF-control-styles.aspx) by Lester, is a tool that can extract control styles from a compiled assembly. Quite useful to take a peek at someone else's work. 🙂 

I added a couple of features: 

  * Switch to a FlowDocumentScrollViewer to view the style (much handier than a plain old TextBox; just try hitting Ctrl+F.) 
  * Primitive syntax-coloring. 
  * A bit of [glass](http://blogs.msdn.com/adam_nathan/archive/2006/05/04/589686.aspx). 
  * And the feature that made me start tinkering with this tool to begin with &ndash; **load other assemblies**. 
  * I also fixed the TargetType property to use the proper Type MarkupExtension ({x:Type &hellip;}) and removed the IsPublic restriction from the type list.

<a href="https://arbel.net/attachments/images/13.StyleSnooper.png" target="_blank"><img src="https://arbel.net/attachments/images/13.StyleSnooper.png" width="500" border="0" height="302" /></a>

P.S. If you're wondering about my wallpaper, it's &#8220;Song of the Sky&#8221; from [Digital Blasphemy](http://digitalblasphemy.com/). It used to be in the free gallery, but isn't anymore. It's very reminiscent of Vista's Aurora.

Attachment: [StyleSnooper.rar](https://arbel.net/attachments/StyleSnooper.rar)