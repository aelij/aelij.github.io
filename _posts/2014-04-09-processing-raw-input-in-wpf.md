---
title: Processing Raw Input in WPF
date: 2014-04-09T11:44:17+00:00
layout: post
permalink: /2014/04/09/processing-raw-input-in-wpf/
tags:
  - WPF
---
One of my clients recently needed to hook up a USB barcode reader to their app. Input from the reader needed to be redirected and handled by a special service, and ignored by the rest of the application. WPF has a property named **Device** in its **KeyEventArgs** class, but unfortunately it turns out that it uses the same instance for all input devices hooked up to the PC.

<!--more-->

So I set out to look for a solution. It seems that normally Windows does not provide this information in **WM_KEY{UP, DOWN}** messages. You had to register your process to receive **WM_INPUT** messages, which contain information about which HID (Human Interface Device) was used. These messages are sent _in addition_ to the standard input messages (keyboard, mouse, touch).

I found a good project in [Code Project](http://www.codeproject.com/Articles/17123/Using-Raw-Input-from-C-to-handle-multiple-keyboard) that encapsulated most of the functionality I needed.

<https://github.com/aelij/RawInputProcessor>

This solution contains a unified API for both WPF and Windows Forms. It also allows marking events as _handled_. It uses the **PeekMessage** function to remove the **WM_KEY{UP, DOWN}** messages, so WPF's **InputManager** never receives them. I've also cleaned up the code and fixed a few bugs and a few possible leaks.
