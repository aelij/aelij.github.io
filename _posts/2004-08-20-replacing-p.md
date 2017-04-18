---
id: 148
title: 'Replacing P#'
date: 2004-08-20T06:57:00+00:00
author: Eli Arbel
layout: post
redirect_from:
  - /blog/archive/2004/08/20/Replacing-P_2300_.aspx.html
guid: /blog/archive/2004/08/20/Replacing-P_2300_.aspx
permalink: /2004/08/20/replacing-p/
dsq_thread_id:
  - "5736700107"
categories:
  - Uncategorized
tags:
  - 'C#'
  - Programming Languages
  - Prolog
---
I've decided to replace P# with a great [C# SWI-Prolog Interface](http://gollem.swi.psy.uva.nl/twiki/pl/bin/view/Foreign/CSharpInterface), written by Uwe Lesta (I changed it a bit. See attachment.) The main reason for this decision was **performance**. P# was considerably slower, and the project had to meet certain standards.

Unfortunately, the C# interface does not work with .NET 2.0, and I hadn't the time to investigate it, so I've&nbsp;downgraded the application to v1.1. The only real loss was the ToolStrip with the Office 2003 look, but I managed just fine without it.

I submitted the project today. That's one down &#8212; one to go!

You may download my [Connect 4](https://arbel.net/downloads/details.aspx?familyid=7d83fab0-7067-49c9-b86e-16df315b3901)&nbsp;(includes SWI runtime). The _source code_ will be available after the project's presentation.

Attachment: [Swi.cs.txt](https://arbel.net/attachments/Swi.cs.txt)