---
id: 152
title: Force-Enable DWM in Vista 5308 CTP
date: 2006-02-02T09:45:00+00:00
author: Eli Arbel
layout: post
redirect_from:
  - /blog/archive/2006/02/02/Force_2D00_Enable-DWM-in-Vista-5308-CTP.aspx.html
guid: /blog/archive/2006/02/02/Force_2D00_Enable-DWM-in-Vista-5308-CTP.aspx
permalink: /2006/02/02/force-enable-dwm-in-vista-5308-ctp/
categories:
  - Uncategorized
tags:
  - Tips
  - Windows Vista
---
I've been toying around with the CTP for a couple of days. There are some very nice stuff to see, and everything seems to be much smoother and faster (_beside the setup_, that is; I tried a clean install &#8211; which took over an hour &#8211; and an upgrade from Windows XP [first available in this CTP] &#8211; which took well over **three hours**&#8230;)

I have a **very**&nbsp;old display adapter (ATI Rage Fury Pro) which, in earlier builds, was able to run the DCM/DWM (but not very smoothly, naturally.) This time, the registry hacks to get the DWM ignore the incompatibility didn't work. So I ventured on a mission to find where they hid it this time. This is what&nbsp;I came up with (copy and paste into notepad and save as **dwm.reg**):

```
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\DWM] <br />&#8220;UseMachineCheck&#8221;=dword:00000000
```

<p>
  After making this change, just open the task manager and kill <b>dwm.exe</b>. The service will restart itself, and if your adapter is good enough, you'll see <b>Aero Glass</b>. I haven't been thus fortunate myself, so I'll go ahead and buy a new adapter (which is long-due.) Note: if all you see is your desktop flickering like hell, hitting CTRL+ALT+F9 will <b>temporarily</b> disable DWM, and allow you to unsent that registry key (it's enough to change the `UseMachineCheck`&nbsp;value to 1.)
</p>

<p>
  Other settings I found under the same key: `Animations`, `AnimationsShiftKey`, `Blur`, `Composition`, `DisableDwmRotation`,&nbsp; `DisableDynamicShutdownUI`, `Schedule`, `ThreadPriority`, `UseAlternateButtons`, `UseDPIScaling` (I'm assuming these are all DWORDS, but you should try and see.)
</p>