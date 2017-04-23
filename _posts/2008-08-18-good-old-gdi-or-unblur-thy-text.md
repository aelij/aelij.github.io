---
id: 174
title: 'Good Old GDI+ (or: Unblur Thy Text)'
date: 2008-08-18T10:35:00+00:00
author: Eli Arbel
layout: post
redirect_from:
  - /blog/archive/2008/08/18/good-old-gdi-or-unblur-thy-text.aspx.html
guid: /blog/archive/2008/08/18/good-old-gdi-or-unblur-thy-text.aspx
permalink: /2008/08/18/good-old-gdi-or-unblur-thy-text/
categories:
  - Uncategorized
tags:
  - Windows Forms
  - WPF
---
It's been a while since I've done anything with GDI+ (i.e. System.Drawing). System.Windows (i.e. WPF) is so much more powerful.

<!--more-->

However, there's one area where it seems the good old GDI+ can still surpass it's shiny new successor: text.

There have been many complaints about text rendering in WPF. I [wrote](https://arbel.net/blog/archive/2007/02/02/give-me-back-my-cleartype.aspx) about some of them myself. You can find a lot of questions on the WPF forum ([to](http://forums.msdn.microsoft.com/en-US/wpf/thread/1ad9a62a-d1a4-4ca2-a950-3b7bf5240de5/) [name](http://forums.msdn.microsoft.com/en-US/wpf/thread/5289ee56-6d06-4f66-84f2-69865b6dc401/) [a](http://forums.msdn.microsoft.com/en-US/wpf/thread/9e79812a-5fcc-4287-8e70-55e905b408b2) [few](http://forums.msdn.microsoft.com/en-US/wpf/thread/1c8d8627-a527-4d5e-8ae3-575867e7ea47/)), but not a lot of answers.

The main issue is that small text is blurry and unreadable. When asked how to render **aliased** text in WPF, the answer was: it's impossible. However, I recently encountered a whitepaper on windowsclient.net called &#8220;[Text Clarity in WPF](http://windowsclient.net/wpf/white-papers/wpftextclarity.aspx)&#8220;, which suggests a way to do just that. It's worth a read, even though the aliased text solution provided there is not usable (they use FormattedText, convert it to a Geometry and render the Geometry aliased using RenderOptions.SetEdgeMode() &#8211; which indeed renders aliased text, but it's not quite legible.)

As you may have already guessed, my solution &#8211; **GdiTextBlock** &#8211; relies on GDI+. We render a bitmap that contains the text and display it. As you may know, rendering bitmaps in WPF also has it's problems, which is why I use the [Bitmap control](http://blogs.msdn.com/dwayneneed/archive/2007/10/05/blurry-bitmaps.aspx) in order to prevent bitmaps from becoming blurry as well.

Also, in order to maintain compatibility with WPF's TextBlock, and to avoid forcing the consumers of the control to add a reference to the System.Drawing assembly, the properties and their types are all the same as TextBlock's (in fact, the dependency properties are registered using DependencyProperty.AddOwner(), which also ensures that value inheritance down the visual tree works.) CoerceValueCallback is used in many places since GDI+ doesn't support all the options available in WPF (e.g. FontStyles.Oblique, non-solid Foreground, TextAlignment.Justify.) While I've included a property called TextQuality, which allows you to set the TextRenderingHint, you'll see that only the default (SingleBitPerPixelGridFit) provides legible results.

One last note about performance &#8211; this solution is not quite optimal. It creates a bitmap every measure pass. I haven't done any real performance tests, so I can't tell you what the real penalty is. Use it at your own discretion.

**Update:** Fixed a small bug and added size and color selectors to demo app.

**Another Update:** Fixed a leak when using InteropBitmap. See [this post](https://arbel.net/blog/archive/2008/10/22/improper-use-of-interopbitmap-can-cause-a-memory-leak.aspx).

Attachment: [GdiTextBlock.zip](https://arbel.net/attachments/GdiTextBlock.zip)