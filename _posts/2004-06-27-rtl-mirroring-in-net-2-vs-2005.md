---
id: 139
title: RTL Mirroring in .NET 2.0/VS 2005
date: 2004-06-27T07:28:00+00:00
author: Eli Arbel
layout: post
redirect_from:
  - /blog/archive/2004/06/27/RTL-Mirroring-in-NET-2-VS-2005.aspx.html
guid: /blog/archive/2004/06/27/RTL-Mirroring-in-NET-2-VS-2005.aspx
permalink: /2004/06/27/rtl-mirroring-in-net-2-vs-2005/
categories:
  - Uncategorized
tags:
  - Windows Forms
---
Apparently there's a [new API method](http://weblogs.asp.net/jaybaz_ms/archive/2004/05/27/143329.aspx), **Application.EnableRTLMirroring(),** in the next version of the framework, which is supposed to handle the mirroring in Windows Forms for you.

<!--more-->

There are [rumors](http://www.eweek.com/article2/0,1759,1617343,00.asp?kc=EWRSS03119TX1K0000594) that the VS 2005 beta will be available for download by the end of next week. That would be nice, especially since I need the C# compiler with the generics for my thesis.

&nbsp;

**Update:** After downloading the beta, I've expetimented a bit with this. The above method is changes the behavior of the **RightToLeft** property (they didn't do this by default so that currect apps would work as expected,) When setting a Form's RightToLeft Property to RightToLeft.Yes, it mirrors (even at the designer). This means that **all** the controls in the form inherit this behavior as well. This renders the [RTL CommandBar](https://arbel.net/blog/archive/2004/06/24/152.aspx)&nbsp;useless (unless you need to deploy something right now), as Windows Forms 2.0 also has very nice customizable ToolStrip and MenuStrip controls, which can even mimic the look of the latest Office.