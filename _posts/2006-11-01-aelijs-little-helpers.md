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

* These helpers are a extension methods in [WPF Contrib](https://github.com/aelij/WPFContrib).

## Dependency Helpers 

```csharp
    DependencyProperty GetDependencyProperty(DependencyObject o, string propertyName)
```
* Retrieves a dependency property according to its name. 

## Binding Helpers 

```csharp
void UpdateSourceDefaultProperty(DependencyObject o)
```

* If you ever set UpdateSourceTrigger of a Binding to _Explicit_, you may have felt it was a bit tedious to create the BindingExpression every time and call the UpdateSource() method. I realized that in many of the cases, the dependency property I'm updating is actually the default (or the content) property that the control author tagged using an attribute. So, instead of: 

```csharp
BindingExpression exp = BindingOperations.GetBindingExpression(TheTextBox, TextBox.TextProperty);
exp.UpdateSource();
```
We get:

```csharp
UpdateSourceDefaultProperty(TheTextBox);
```

## Storyboard Helpers 

```csharp
public static void Reverse(Storyboard storyboard)
```
* Reverses the To and From properties of each _linear_ AnimationTimeline in a Storyboard. 

```csharp
public static Storyboard GetReversed(Storyboard storyboard)
```
* Clones the Storyboard and reverses it. 

```csharp
public static TAnimation AddLinearAnimation<TAnimation, T>(Storyboard storyboard, PropertyPath path, T? from, T? to, Duration duration)
```
* Creates and adds a _linear_ AnimationTimeline to a Storyboard. This one also saves quite a few lines. For example, instead of: 

```csharp
DoubleAnimation anim = new DoubleAnimation(from, to, new Duration(TimeSpan.FromSeconds(1)));
Storyboard.SetTargetProperty(anim, new PropertyPath(Control.OpacityProperty));
story.Children.Add(anim);
```

We get: 

```csharp
AddLinearAnimation<DoubleAnimation, double>(story, new PropertyPath(Control.OpacityProperty), from, to, new Duration(TimeSpan.FromSeconds(1)))
```

The one drawback of all of these methods is the use of Reflection. Had DoubleAnimation inherited from `LinearAnimationBase<double>` (see previous [post](https://arbel.net/blog/archive/2006/10/31/Creating-new-animation-types.aspx)) the use of Reflection could have been spared.

Attachment: [Helpers.rar](https://arbel.net/attachments/Helpers.rar)