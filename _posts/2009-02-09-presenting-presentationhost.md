---
id: 184
title: Presenting PresentationHost
date: 2009-02-09T14:26:00+00:00
author: Eli Arbel
layout: post
redirect_from:
  - /blog/archive/2009/02/09/presenting-presentationhost.aspx.html
guid: /blog/archive/2009/02/09/presenting-presentationhost.aspx
permalink: /2009/02/09/presenting-presentationhost/
dsq_thread_id:
  - "5736700280"
categories:
  - Uncategorized
tags:
  - ClearType
  - Windows 7
  - Windows Vista
  - WPF
---
I always prefer simpler solutions. The solution I proposed on my [previous post](https://arbel.net/blog/archive/2009/02/06/casper-to-the-rescue.aspx) was not that simple, and was not complete. It may still be useful for other stuff, but for the purpose of preserving ClearType while using DWM, I just have to admit it has too many issues.

<!--more-->

The idea of using another window stayed in my head, and then I realized I could use a child window. WPF already has a mechanism for hosting Windows Forms and ActiveX controls. They derive from **HwndHost**,which allows creating a window handle and embedding it within the WPF visual tree.

My control, **PresentationHost**, does just that. It hosts an **HwndSource**, which provides the infrastructure of WPF windows. You give the HwndSource a root visual to display, and since it is a separate window within the main window, whose composition background remains opaque, ClearType works just fine. You don&rsquo;t have to modify anything in the Ribbon. Even routed commands work transparently!

The one downside I can think of is that everything inside the host is not part of the visual tree of the window. I did make sure it&rsquo;s a part of the logical tree, so there&rsquo;s a way to get into elements inside the host. XAML name references also work as usual.

Again, to compile/run the sample, you&rsquo;ll have to obtain the Ribbon assembly separately from the [Office UI Licensing](http://msdn.microsoft.com/en-us/office/aa973809.aspx) site.

Attachment: [PresentationHostDemo.zip](https://arbel.net/attachments/PresentationHostDemo.zip)