---
id: 138
title: Mirrored CommandBar
date: 2004-06-25T05:43:00+00:00
author: Eli Arbel
layout: post
guid: /blog/archive/2004/06/24/Mirrored-CommandBar.aspx
permalink: /2004/06/25/mirrored-commandbar/
redirect_from:
  - /blog/archive/2004/06/24/Mirrored-CommandBar.aspx.html
categories:
  - Uncategorized
tags:
  - Windows Forms
---
I've been working on a **mirrored**&nbsp;**RTL** (right-to-left) version of [Lutz Roeder](http://www.aisto.com/roeder/DotNet/)'s great CommandBar control for Windows Forms. There's one problem left, which I haven't solved yet, so I'd appreciate any comment on the matter. 

<!--more-->

This is my tweaked CommandBar:

<img border="0" height="238" src="https://arbel.net/attachments/images/41.rtl1.png" width="568" />

As you may have noticed, I have custom-drawn the MenuItems. Aren't round rectangles just swell? (c:

Nothing wrong in this picture, but take a look at the next one. The phenomena surfaces when you hover with the mouse from the second menu to the third. The menu&nbsp;text disappears, and the hottracking remains. This is obviously a mirroring issue.

<img border="0" height="135" src="https://arbel.net/attachments/images/42.rtl2.png" width="282" />

You may find interest in the [Middle East MSDN](http://www.microsoft.com/middleeast/msdn/mirror.aspx) article about mirroring (there are a few useful mirrored controls downloadable there). Mirroring a Windows Forms control is easy:

```csharp
protected override CreateParams CreateParams
{
    get
    {
        CreateParams CP;
        CP = base.CreateParams;
        if(!base.DesignMode)
            CP.ExStyle |= WS_EX_LAYOUTRTL | WS_EX_NOINHERITLAYOUT;
        return CP;
    }
}

protected override CreateParams CreateParams
{
    get
    {
        CreateParams CP;
        CP = base.CreateParams;
        if(!base.DesignMode)
            CP.ExStyle |= WS_EX_LAYOUTRTL | WS_EX_NOINHERITLAYOUT;
        return CP;
    }
}

protected override CreateParams CreateParams
{
    get
    {
        CreateParams CP;
        CP = base.CreateParams;
        if(!base.DesignMode)
            CP.ExStyle |= WS_EX_LAYOUTRTL | WS_EX_NOINHERITLAYOUT;
        return CP;
    }
}

const int WS_EX_LAYOUTRTL = 0x400000;
const int WS_EX_NOINHERITLAYOUT = 0x100000;

const int WS_EX_LAYOUTRTL = 0x400000;
const int WS_EX_NOINHERITLAYOUT = 0x100000; 
```

You can also create a property to control this.

The above problem <em>could</em> be a bug in GDI+. I started to suspect that it was the culprit when the menu image, which was drawn using <strong>Graphics.DrawImage</strong>,&nbsp;appeared on the left side. In mirroring, the entire coordinate system of a window&nbsp;changes, so if you specify a point (<em>x</em>,<em>y</em>), the <em>x</em> would be the distance from the <em>right</em>, not from the left. Lutz used a function from ImageList (using P/Invoke) called <strong>ImageList_DrawIndirect</strong> to draw the &ldquo;disabled&rdquo; image, and I noticed they were drawn correctly. So I copied the code to the non-disabled part as well, and it worked. The bottom line is, that the Framework's DrawImage method couldn't handle a mirrored control, which made me wonder if this is the reason for the bug described above.

Wow, that was a long post. I hope it was clear enough. I will be releasing the source code here as soon as I get it working. I haven't found an RTL {Command,Re,Cool}Bar for .NET anywhere else&#8230;
