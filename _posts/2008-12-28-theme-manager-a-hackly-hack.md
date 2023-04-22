---
id: 181
title: 'Theme Manager: A Hackly Hack'
date: 2008-12-28T19:47:00+00:00
author: Eli Arbel
layout: post
redirect_from:
  - /blog/archive/2008/12/28/theme-manager-a-hackly-hack.aspx.html
guid: /blog/archive/2008/12/28/theme-manager-a-hackly-hack.aspx
permalink: /2008/12/28/theme-manager-a-hackly-hack/
categories:
  - Uncategorized
tags:
  - .NET
  - WPF
---
One of the most popular posts in this blog is the [one](https://arbel.net/blog/archive/2006/11/03/Forcing-WPF-to-use-a-specific-Windows-theme.aspx) explaining how to override the system theme and get the Vista look on non-Vista systems. This is possible because WPF ships with the theme files for all operation systems (well, all Microsoft OSs that WPF works on, i.e. XP, XP Media Center and Vista) and due to the fact that WPF doesn&rsquo;t really use the system resources to get the OS theme, but rather relies on a private implementation of them that resides in the PresentationFramework.{Classic, Luna, Royale, Aero} assemblies.

<!--more-->

The solution offered in the aforementioned post loads a selected theme dictionary from one of these assemblies to the Application resource dictionary. While this is enough to modify the theme for all the built-in controls, you may encounter problems in the following scenarios:

  * You&rsquo;re using third-party controls that have their own themes for each of the system themes. Many of these controls have a method of bypassing the system theme. (For example, see the [Theme](http://doc.xceedsoft.com/products/XceedWpfDataGrid/Xceed.Wpf.DataGrid%7EXceed.Wpf.DataGrid.Views.ViewBase%7ETheme.html) property on the Xceed DataGrid.)
  * You&rsquo;re writing a theme for your own control. Resources in the _Themes_ folder do not go through the same lookup chain as other resources, so when you&rsquo;re using built-in controls there, their theme may not be affected by the Application resource dictionary.

As an experiment , I&rsquo;ve decided to hack into the bowels of WPF and force it to recognize a different theme as the system theme. I must say this is one of the ugliest hacks I&rsquo;ve ever done. The result is the class _ThemeManager_, which exposes a single static method:

```csharp
public static void ChangeTheme(string themeName, string themeColor);

public static void ChangeTheme(string themeName, string themeColor);
```

Examples of theme name and color pairs: { &ldquo;luna&rdquo;, &ldquo;homestead&rdquo; }, { &ldquo;royale&rdquo;, &ldquo;normalcolor&rdquo; }, { &ldquo;classic&rdquo;, &ldquo;&rdquo; }. If you pass two empty strings, the default system theme will return. You can also invent a new theme of your own, give it a name and load it this way. I haven&rsquo;t tried it, but it should work, as long as you conform to the theme dictionary location conventions.

I also hooked into the message loop and am intercepting the theme change message that is sent to all windows. This blocks WPF from attempting to apply a new theme when the system theme changes.

Needless to say I&rsquo;m using **tons** of reflection and it&rsquo;s likely to break in the next version, so **don&rsquo;t use it**. I think this should have been part of the API to begin with.

PS &ndash; A helpful tip for the theme author: you can find the sources (XAML) for all the themes in the Windows SDK samples (look in WPFSamples.zip/Core/{Classic, Luna, Royale, Aero}Theme.)

 

**Update**: Apparently this still works in .NET 4 (as of Beta 2).

Attachment: [ThemeMangerDemo.zip](https://arbel.net/attachments/ThemeMangerDemo.zip)