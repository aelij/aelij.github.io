---
id: 158
title: Aelij's Little Helpers
date: 2006-11-01T20:26:00+00:00
author: Eli Arbel
layout: post
redirect_from:
  - /blog/archive/2006/11/01/_C600_lij_1920_s-Little-Helpers.aspx.html
guid: /blog/archive/2006/11/01/_C600_lij_1920_s-Little-Helpers.aspx
permalink: /2006/11/01/aelijs-little-helpers/
categories:
  - Uncategorized
tags:
  - WPF
  - WPFContrib
---

## Dependency Helpers 

> <span style="font-size:10pt;font-family:Consolas;background-color:white;"><span style="font-size:10pt;color:teal;font-family:Consolas;background-color:white;">DependencyProperty </span>GetDependencyProperty(<span style="color:teal;">DependencyObject</span> o, <span style="color:blue;">string</span> propertyName)</span>  
> Retrieves a dependency property according to its name. 

## Binding Helpers 

> <span style="font-size:10pt;font-family:Consolas;"><span style="color:blue;background-color:white;">void</span><span style="background-color:white;"> UpdateSourceDefaultProperty(<span style="color:teal;">DependencyObject</span> o)</span></span>  
> If you ever set UpdateSourceTrigger of a Binding to _Explicit_, you may have felt it was a bit tedious to create the BindingExpression every time and call the UpdateSource() method. I realized that in many of the cases, the dependency property I'm updating is actually the default (or the content) property that the control author tagged using an attribute. So, instead of: 
> 
> > <span style="font-size:10pt;font-family:Consolas;"><span style="color:teal;background-color:white;">BindingExpression</span><span style="background-color:white;"> exp = <span style="color:teal;">BindingOperations</span>.GetBindingExpression(TheTextBox, <span style="color:teal;">TextBox</span>.TextProperty);</span><br />exp.UpdateSource(); </span>
> 
> We get:
> 
> > <span style="font-size:10pt;font-family:Consolas;"><span style="background-color:white;">UpdateSourceDefaultProperty</span>(<span style="background-color:white;">TheTextBox</span>); </span>

## Storyboard Helpers 

> <span style="font-size:10pt;font-family:Consolas;"><span style="color:blue;background-color:white;">public</span><span style="background-color:white;"> <span style="color:blue;">static</span> <span style="color:blue;">void</span> Reverse(<span style="color:teal;">Storyboard</span> storyboard)</span></span>  
> Reverses the To and From properties of each _linear_ AnimationTimeline in a Storyboard. 
> 
> <span style="font-size:10pt;font-family:Consolas;"><span style="color:blue;background-color:white;">public</span><span style="background-color:white;"> <span style="color:blue;">static</span> <span style="color:teal;">Storyboard</span> GetReversed(<span style="color:teal;">Storyboard</span> storyboard)</span></span>  
> Clones the Storyboard and reverses it. 
> 
> <span style="font-size:10pt;font-family:Consolas;"><span style="color:blue;background-color:white;">public</span><span style="background-color:white;"> <span style="color:blue;">static</span> TAnimation AddLinearAnimation<TAnimation, T>(<span style="color:teal;">Storyboard</span> storyboard, <span style="color:teal;">PropertyPath</span> path, T? from, T? to, <span style="color:teal;">Duration</span> duration)</span></span>  
> Creates and adds a _linear_ AnimationTimeline to a Storyboard. This one also saves quite a few lines. For example, instead of: 
> 
> > <span style="font-size:10pt;font-family:Consolas;"><span style="color:teal;background-color:white;">DoubleAnimation</span><span style="background-color:white;"> anim = <span style="color:blue;">new</span> <span style="color:teal;">DoubleAnimation</span>(from, to, <span style="color:blue;">new</span> <span style="color:teal;">Duration</span>(<span style="color:teal;">TimeSpan</span>.FromSeconds(1)));<br /></span></span><span style="font-size:10pt;font-family:Consolas;"><span style="color:teal;background-color:white;">Storyboard</span><span style="background-color:white;">.SetTargetProperty(anim, <span style="color:blue;">new</span> <span style="color:teal;">PropertyPath</span>(<span style="color:teal;">Control</span>.OpacityProperty));<br /></span></span><span style="font-size:10pt;font-family:Consolas;background-color:white;">story.Children.Add(anim);</span> 
> 
> We get: 
> 
> > <span style="font-size:10pt;font-family:Consolas;"><span style="background-color:white;">AddLinearAnimation<<span style="color:teal;">DoubleAnimation</span>, <span style="color:blue;">double</span>>(story, <span style="color:blue;">new</span> <span style="color:teal;">PropertyPath</span>(<span style="color:teal;">Control</span>.OpacityProperty), from, to, <span style="color:blue;">new</span> <span style="color:teal;">Duration</span>(<span style="color:teal;">TimeSpan</span>.FromSeconds(1)))</span>;</span> 

The one drawback of all of these methods is the use of Reflection. Had DoubleAnimation inherited from LinearAnimationBase<double> (see previous [post](https://arbel.net/blog/archive/2006/10/31/Creating-new-animation-types.aspx)) the use of Reflection could have been spared.

Attachment: [Helpers.rar](https://arbel.net/attachments/Helpers.rar)