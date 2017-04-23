---
id: 186
title: Local values in DependencyObjects
date: 2009-11-04T21:38:00+00:00
author: Eli Arbel
layout: post
redirect_from:
  - /blog/archive/2009/11/04/local-values-in-dependencyobjects.aspx.html
guid: /blog/archive/2009/11/04/local-values-in-dependencyobjects.aspx
permalink: /2009/11/04/local-values-in-dependencyobjects/
categories:
  - Uncategorized
tags:
  - .NET 4
  - WPF
---
If you&rsquo;re writing a custom control in WPF, you may have encountered a very annoying bug: if you set the value of a DependencyProperty in your implementation code, the local value will trump any changes that you may try to apply to this property using bindings, styles, etc. You can read more about this in [this post](http://blogs.msdn.com/vinsibal/archive/2009/03/24/the-control-local-values-bug.aspx) in Vincent Sibal&rsquo;s blog.

<!--more-->

WPF 4 introduces a solution for this problem: the DependencyObject.SetCurrentValue() method. It allows changing the value of a DP without affecting the BaseValueSource. Vincent has a [nice post](http://blogs.msdn.com/vinsibal/archive/2009/05/21/the-control-local-values-bug-solution-and-new-wpf-4-0-related-apis.aspx) explaining this as well. As he says, a control author should generally use this method instead of SetValue().

However, if you&rsquo;re still working on a .NET 3-3.5 app, and are encountering this issue, fear not! For there is a workaround, albeit slightly cumbersome. This magic lies within the power of **coercion**. Like the new SetCurrentValue(), the good old CoreceValue() method does not change the BaseValueSource. So, instead of setting the value directly, put some logic in the coercion callback of your DP. Your bindings and styles will continue to work after that.

I&rsquo;ve changed the sample from Vincent&rsquo;s post to use this workaround (take a look at the CustomControl.CoerceTitle() method).

Attachment: [ControlLocalValuesSample.zip](https://arbel.net/attachments/ControlLocalValuesSample.zip)