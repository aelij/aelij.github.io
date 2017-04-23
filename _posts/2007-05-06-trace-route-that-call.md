---
id: 167
title: Trace (route) that call!
date: 2007-05-06T19:50:00+00:00
author: Eli Arbel
layout: post
redirect_from:
  - /blog/archive/2007/05/06/trace-route-that-call.aspx.html
guid: /blog/archive/2007/05/06/trace-route-that-call.aspx
permalink: /2007/05/06/trace-route-that-call/
categories:
  - Uncategorized
tags:
  - WPF
---
Have you ever used **EventManager.RegisterClassHandler()**? If so, make sure you know what you're doing. This method allows you to listen to events _passing&nbsp;through_ (as I like to put it) an element (i.e.&nbsp;bubbling or tunneling), regardless of the class that invoked the call. Most of the times you would call it in a static constructor, and pass it a **typeof** of that class, but that is only a _recommendation_. The [documentation](http://msdn2.microsoft.com/en-us/library/ms747183.aspx) is a bit weak on this point.

<!--more-->

This can be a very powerful tool if you use it right. Let me demonstrate. Say you want to listen to all button clicks in your app. Normally you would put this in your main Window (by calling the above method or UIElement.AddHandler() instance method) so all the ButtonBase.Click event would bubble up to the Window and get caught.

But what you can actually do is call the RegisterClassHandler from _anywhere you like_ (it doesn't have to be a static constructor or even&nbsp;a DependencyObject. But remember that every call would add a handler, so beware of multiple registrations!):
  
```csharp
EventManager.RegisterClassHandler(typeof(ButtonBase), ButtonBase.ClickEvent, new RoutedEventHandler(SomeMethod), true);
```

This method has no idea from where it's called, nor does it care. All that matters is that the bubbling or tunneling _passes through_ an element of the type you specified.

Since the Click event would always pass through a ButtonBase (well,&nbsp;actually originate from one.&nbsp;That is, unless you invoke it from some custom class, which doesn't make too much sense _most_ of the time. But I'm going off on a tangent here.) the method would be invoke for every button click. The last parameter makes sure it's invoked even if you marked the event as&nbsp;handled somewhere along the way (albeit redundant in this case, since we handle it right at the root of the bubble.)
