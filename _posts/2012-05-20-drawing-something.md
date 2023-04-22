---
id: 243
title: Drawing Something?
date: 2012-05-20T12:38:38+00:00
author: Eli Arbel
layout: post
permalink: /2012/05/20/drawing-something/
image: /wp-content/uploads/2012/05/DrawingSomething.png
categories:
  - Uncategorized
tags:
  - Performance
  - WPF
---
WPF enables you to develop great looking applications very fast. But sometimes with this rapid approach one can overlook an important aspect - performance. It's very common for developers to look into UI performance last, especially in LOB applications, but performance can have a significant effect on how professional your application is perceived to be.

<!--more-->

While I completely agree with Donald Knuth's famous quote "_premature [optimization](http://en.wikipedia.org/wiki/Program_optimization)_ _is the root of all evil_", there are some cases where you can think of UI performance while developing your app. In this post I wish to examine one of WPF's slightly overlooked but very effective performance optimization - the `Drawing` class.

Many times we need to create gauges or dashboards in our applications, in which we represent some state visually. We can do this using 3rd party control suites that offer gauges and such, but sometimes we need to create something specialized for our application.

A conceivable development iteration for this kind of thing would be be to start with a sketch the **graphic designer** made, then the **XAML designer** creates it in Blend, and finally the **developer** adds the required data binding and interaction.

The XAML designer might use _panels, borders and shapes_ to create the desired control. These objects are all fully-fledged WPF controls: they handle LIFE (Layout, Input, Focus, and Eventing), templates, tooltips, etc. Most of the times we don't need all that (especially when we **don't required interactivity** for each element in the control), and we're paying a performance penalty for no reason. There are (at least) two ways to deal with this possible performance problem: use `Drawing`s or create a custom control and override the `OnRender` method. I will focus on the former. Note that if your control is used only a small number of times, this optimization is probably redundant. But if it appears many times and needs to be created on the fly (e.g. in some `ItemsControl`'s data template), you will experience a significant performance boost.

Drawings allow us to create (in XAML) a visual that can be comprised of `Geometry` objects (`GeometryDrawing`), `ImageSource` objects (`ImageDrawing`), text (`GlyphDrawing`), video (`VideoDrawing`) or any combination of the above (`DrawingGroup`). Here are two easy ways to create Drawings:

  * Design the desired visuals in _Expression Blend_ (using panels and shapes), select them and use **Tools > Make Brush Resource > Make Drawing Brush**.
  * Use _Expression Design_ and export your art as a **XAML WPF Drawing Brush**.

It is usually advisable to keep the source, so you can edit it. Editing Drawings directly is currently not supported in Blend.

## 

## Dynamic Drawings

Usually when we create such controls, we need them to respond to data changes. Luckily, Drawings are `DependencyObject`s, and you can add bindings to them. We can add the bindings after we create the Drawing from our art. We can bind elements such as brushes, width, height, angles and opacity.

**Important!** When we create a drawing with bindings that is intended to be used multiple times in our application, we must use **`x:Shared=&#8221;False&#8221;`**, so that a new instance would be created each time. Read more about this attribute [here](http://msdn.microsoft.com/en-us/library/aa970778.aspx).

 

## Demo

In the provided demo you will find the same visual created using controls and using Drawings. The initial render time is displayed in a message box. Usually the controls take **twice as much** as the Drawings to render. Another way to experience the difference is to try to **resize the window** in both cases.

[Download](https://arbel.net/wp-content/uploads/2012/05/DrawingSomething1.zip)