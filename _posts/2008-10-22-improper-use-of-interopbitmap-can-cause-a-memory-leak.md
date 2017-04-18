---
id: 177
title: Improper use of InteropBitmap can cause a memory leak
date: 2008-10-22T10:29:00+00:00
author: Eli Arbel
layout: post
redirect_from:
  - /blog/archive/2008/10/22/improper-use-of-interopbitmap-can-cause-a-memory-leak.aspx.html
guid: /blog/archive/2008/10/22/improper-use-of-interopbitmap-can-cause-a-memory-leak.aspx
permalink: /2008/10/22/improper-use-of-interopbitmap-can-cause-a-memory-leak/
dsq_thread_id:
  - "5736700260"
categories:
  - Uncategorized
tags:
  - WPF
---
I've been using InteropBitmap in my [GdiTextBlock](https://arbel.net/blog/archive/2008/08/18/good-old-gdi-or-unblur-thy-text.aspx). The control creates a new GDI+ Bitmap every measure pass, which it then converts to a WPF BitmapSource using the Imaging.CreateBitmapSourceFromHBitmap() method (this method returns an InteropBitmap).

After playing with the control for a while I noticed that the process' working set is constantly increasing. I realized I must have a problem with my bitmap conversion. So, I set out to seek an alternative solution, and I came up with a simple way of creating a BitmapSource directly from a GDI+ Bitmap. (See attached. I've also updated the GdiTextBlock post.)

After some more digging, I found out that the leakage was entirely _my fault_. To use the CreateBitmapSourceFromHBitmap() method, you have to convert the GDI+ bitmap to an HBITMAP by calling the Bitmap.GetHbitmap() method. Its documentation clearly states that &#8220;_You are responsible for calling the GDI DeleteObject method to free the memory used by the GDI bitmap object._&#8221; Well, there you have it.

I decided to benchmark the two options. Here are the results:

```
Interop Bitmap No Delete 
Time: 00:00:01.5989544, Process Memory: 396,936 KB 

Interop Bitmap With Delete 
Time: 00:00:01.5158545, Process Memory: 9,056 KB

Alternate
Time: 00:00:00.5108011, Process Memory: 9,080 KB
```

It would seem that the alternate method is preferable even after deleting the HBITMAP. I think the reason for the (time) overhead is that the GDI+ bitmap needs to be converted to an HBITMAP, and then converted to a WPF bitmap, while in the alternate method, we skip the middleman.

**Side note:** I'm using a new .NET 3.5 SP1 feature, which allows forcing a garbage collection using the GC.Collect() method (which has a few new overloads as well). Can be pretty useful for benchmarking or debugging.

Attachment: [InteropBitmapLeak.zip](https://arbel.net/attachments/InteropBitmapLeak.zip)