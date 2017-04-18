---
id: 159
title: Forcing WPF to use a specific Windows theme
date: 2006-11-03T07:21:00+00:00
author: Eli Arbel
layout: post
redirect_from:
  - /blog/archive/2006/11/03/Forcing-WPF-to-use-a-specific-Windows-theme.aspx.html
guid: /blog/archive/2006/11/03/Forcing-WPF-to-use-a-specific-Windows-theme.aspx
permalink: /2006/11/03/forcing-wpf-to-use-a-specific-windows-theme/
dsq_thread_id:
  - "5736696254"
categories:
  - Uncategorized
tags:
  - Themes
  - Windows 2003
  - Windows Vista
  - WPF
---
WPF comes with a few theme assemblies, one for each Windows theme (Luna, Royale and Aero and the fallback theme, Classic.) Usually the theme is loaded according to your current system theme, but if you want to create a consistent look for your application, you may want to force-load a specific one. 

To accomplish that, simply add the following code in your Application Startup event (this example shows how to use the Aero theme): 

<p style="MARGIN-LEFT:36pt;">
  <span style="FONT-SIZE:10pt;FONT-FAMILY:Consolas;"><span style="COLOR:teal;BACKGROUND-COLOR:white;">Uri</span><span style="BACKGROUND-COLOR:white;"> uri = <span style="COLOR:blue;">new</span> <span style="COLOR:teal;">Uri</span>(<span style="COLOR:maroon;">&#8220;PresentationFramework.Aero;V3.0.0.0;31bf3856ad364e35;component\\themes/aero.normalcolor.xaml&#8221;</span>, <span style="COLOR:teal;">UriKind</span>.Relative); </span></span>
</p>

<p style="MARGIN-LEFT:36pt;">
  <span style="FONT-SIZE:10pt;FONT-FAMILY:Consolas;"><span style="BACKGROUND-COLOR:white;">Resources.MergedDictionaries.Add(<span style="COLOR:teal;">Application</span>.LoadComponent(uri) <span style="COLOR:blue;">as</span> <span style="COLOR:teal;">ResourceDictionary</span>);</span> </span>
</p>

It's important to specify the version and the public key token. Otherwise you'll have to copy the theme assembly to the folder of your executable. The reason I'm adding it to the merged dictionaries collection&nbsp;is that I don't want to lose other resources I added to the App.xaml file. 

I usually put this code in a try&hellip;catch block (with an empty catch) since it doesn't really impair the application's functionality if it fails to execute. 

Last note: From my experience, Windows Server 2003 always shows the Classic theme in WPF (even if you activate the Windows Themes service), so if you're deploying applications for that platform, you may want to use this trick (you will also want to turn on your display adapter's hardware acceleration and the DirectX accelerations, as they are disabled by default in 2003.)

**Edit:** Robby Ingebretsen (notstatic.com)&nbsp;also [blogged](http://notstatic.com/archives/56) about this because the new [Zune theme](http://go.microsoft.com/fwlink/?LinkID=75078), which&nbsp;caused WPF to fallback to the Classic theme. However, he placed the code in XAML. Here is a version of that using merged dictionaries (which will allow you to add other resources to App.xaml):

<span style="color: #0000ff;"></p> 

<p style="FONT-SIZE:10pt;FONT-FAMILY:Consolas;">
  <<span style="color: #008080;">Application.Resources</span><span style="color: #0000ff;">><br />&nbsp;&nbsp;&nbsp; <</span><span style="color: #008080;">ResourceDictionary</span><span style="color: #0000ff;">><br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <</span><span style="color: #008080;">ResourceDictionary.MergedDictionaries</span><span style="color: #0000ff;">><br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <</span><span style="color: #008080;">ResourceDictionary</span><span style="color: #0000ff;"> </span>Source<span style="color: #0000ff;">=</span><span style="color: #800000;">&#8220;</span><span style="color: #000080;">/PresentationFramework.Aero;V3.0.0.0;31bf3856ad364e35;component\themes/aero.normalcolor.xaml</span><span style="color: #800000;">&#8220;</span><span style="color: #0000ff;"> /><br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </</span><span style="color: #008080;">ResourceDictionary.MergedDictionaries</span><span style="color: #0000ff;">></p> 
  
  <p>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span style="color: #0000ff;"><!&#8211;</span><span style="color: #008000;"> other resources go here </span><span style="color: #0000ff;">&#8211;><br /></span><br />&nbsp;&nbsp;&nbsp; </</span><span style="color: #008080;">ResourceDictionary</span><span style="color: #0000ff;">><br /></</span><span style="color: #008080;">Application.Resources</span><span style="color: #0000ff;">></span>
  </p>
  
  <p>
    <span style="color: #000000;"><b>Update:</b> The Orcas designer seems to be having problems with the relative URI. Using an absolute URI solves the issue: (I've also attached a sample <b>Orcas</b>&nbsp;project)</span>
  </p>
  
  <p>
    <span style="color: #000080;">pack://application:,,,/PresentationFramework.Aero;V3.0.0.0;31bf3856ad364e35;component\themes/aero.normalcolor.xaml</span>
  </p>
  
  <p>
    </span>
  </p>
  
  <p>
    Attachment: <a href="https://arbel.net/attachments/ForcedTheme.rar">ForcedTheme.rar</a>
  </p>