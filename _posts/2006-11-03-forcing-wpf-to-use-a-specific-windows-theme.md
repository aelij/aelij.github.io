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
  - Windows
  - WPF
---
WPF comes with a few theme assemblies, one for each Windows theme (Luna, Royale and Aero and the fallback theme, Classic.) Usually the theme is loaded according to your current system theme, but if you want to create a consistent look for your application, you may want to force-load a specific one. 

<!--more-->

To accomplish that, simply add the following code in your Application Startup event (this example shows how to use the Aero theme): 

```csharp
Uri uri = new Uri(“PresentationFramework.Aero;V3.0.0.0;31bf3856ad364e35;component\\themes/aero.normalcolor.xaml”, UriKind.Relative);

Resources.MergedDictionaries.Add(Application.LoadComponent(uri) as ResourceDictionary); 
```

It's important to specify the version and the public key token. Otherwise you'll have to copy the theme assembly to the folder of your executable. The reason I'm adding it to the merged dictionaries collection is that I don't want to lose other resources I added to the App.xaml file. 

I usually put this code in a try&hellip;catch block (with an empty catch) since it doesn't really impair the application's functionality if it fails to execute. 

Last note: From my experience, Windows Server 2003 always shows the Classic theme in WPF (even if you activate the Windows Themes service), so if you're deploying applications for that platform, you may want to use this trick (you will also want to turn on your display adapter's hardware acceleration and the DirectX accelerations, as they are disabled by default in 2003.)

**Edit:** Robby Ingebretsen (notstatic.com) also [blogged](http://notstatic.com/archives/56) about this because the new [Zune theme](http://go.microsoft.com/fwlink/?LinkID=75078), which caused WPF to fallback to the Classic theme. However, he placed the code in XAML. Here is a version of that using merged dictionaries (which will allow you to add other resources to App.xaml):


```xml
<Application.Resources>
    <ResourceDictionary>
        <ResourceDictionary.MergedDictionaries>
            <ResourceDictionary Source="/PresentationFramework.Aero;V3.0.0.0;31bf3856ad364e35;component\themes/aero.normalcolor.xaml" />
        </ResourceDictionary.MergedDictionaries>

        <!– other resources go here –>

    </ResourceDictionary>
</Application.Resources> 
```

**Update:** The Orcas designer seems to be having problems with the relative URI. Using an absolute URI solves the issue: (I've also attached a sample Orcas project)

```
pack://application:,,,/PresentationFramework.Aero;V3.0.0.0;31bf3856ad364e35;component\themes/aero.normalcolor.xaml
```

Attachment: <a href="https://arbel.net/attachments/ForcedTheme.rar">ForcedTheme.rar</a>
