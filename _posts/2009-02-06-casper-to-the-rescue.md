---
title: Casper to the Rescue!
date: 2009-02-06T14:39:00+00:00
layout: post
redirect_from:
  - /blog/archive/2009/02/06/casper-to-the-rescue.aspx.html
permalink: /2009/02/06/casper-to-the-rescue/
tags:
  - ClearType
  - Windows
  - WPF
---
WPF has ClearType [issues](/2007/02/03/give-me-back-my-cleartype/). Hopefully some of them will be solved in the upcoming .NET 4.0. Meanwhile, however, I have concocted a nifty solution to one of the scenarios – placing stuff on the Aero Glass DWM frame.

<!--more-->

When you extend the DWM frame in a WPF application you must set the HwndTarget.BackgroundColor property to Transparent, which turns off ClearType for the entire window.

Most of the Ribbon implementations do this so they could place the application menu (the round button) halfway on the window title, as well as the quick access toolbar. Since Ribbon-based applications are mostly document-oriented, this is particularly bad, since it completely botches the text readability of the app.

I had an idea how to solve this a while ago, and just didn't have the time to code it. Now I'm working on a project that actually uses a Ribbon, and I wanted my app to be readable even on Vista, while retaining the nice glassy look.

## Introducing GhostContentPresenter

The [Ghost](http://en.wikipedia.org/wiki/Casper_the_Friendly_Ghost) Content Presenter is a custom control which displays arbitrary WPF content, with a special twist: the content is positioned as if it's part of the visual tree where the GCP is added, but in actuality it is rendered in a Popup, whose position and size are kept synchronized with the parent Window.

I needed to make a couple of changes to the Popup: make it non-top-most and make the Window that contains the GCP its owner. This way, the Popup will always be above the Window, but never above other windows.

Now, all I had to do is retemplate the Ribbon control (I used the Microsoft [CTP](http://www.codeplex.com/wpf/Wiki/View.aspx?title=WPF%20Ribbon%20Preview)) to use GhostContentPresenters (MS should really provide the XAML for the Ribbon).

There are still a few issues left to sort out: (1) Writing the title text (it needs to be offset according to the quick access toolbar, whose width is dynamic, and I didn't want to use another GCP just for it, though it's possible). (2) The Popups appear a split of a second before the Window when restoring a minimized window because of the DWM effect. (3) Binding to commands cannot be done the same way, since routed commands (which use routed events), bubble up the visual tree, and the Popup is not part of it. One solution would be to hook the commands statically using CommandManager.RegisterClassCommandBinding().

Let me know if you think of other original uses for the GCP (remember the popup can even appear beyond the window borders!) It will be included in the next version of [WPF Contrib](https://github.com/aelij/WPFContrib).

PS – I'm sorry I can't include a working demo this time. You'll have to obtain the Ribbon assembly separately from the [Office UI Licensing](http://msdn.microsoft.com/en-us/office/aa973809.aspx) site.

Attachment: [GhostContentPresenterDemo.zip](/attachments/2009/02/ghost-content-presenter-demo.zip)
