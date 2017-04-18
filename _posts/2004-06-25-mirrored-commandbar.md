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

This is my tweaked CommandBar:

<img border="0" height="238" src="https://arbel.net/attachments/images/41.rtl1.png" width="568" />&nbsp;

As you may have noticed, I have custom-drawn the MenuItems. Aren't round rectangles just swell? (c:

Nothing wrong in this picture, but take a look at the next one. The phenomena surfaces when you hover with the mouse from the second menu to the third. The menu&nbsp;text disappears, and the hottracking remains. This is obviously a mirroring issue.

<img border="0" height="135" src="https://arbel.net/attachments/images/42.rtl2.png" width="282" />&nbsp;

You may find interest in [Middle East MSDN](http://www.microsoft.com/middleeast/msdn/mirror.aspx)'s article about mirroring (there are a few useful mirrored controls downloadable there). Mirroring a Windows Forms control is easy: <font color="#0000ff"></p> 

<p>
  <font face="Courier New" size="2">protected</font><font face="Courier New"><font size="2"> <font color="#0000ff">override</font></font></font><font face="Courier New" size="2"> CreateParams CreateParams<br />{<br /></font><font color="#0000ff" face="Courier New" size="2">&nbsp;&nbsp;&nbsp; get<br /></font><font face="Courier New"><font size="2"><font color="#0000ff">&nbsp;&nbsp;&nbsp; </font>{<br /><font color="#0000ff">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </font>CreateParams CP;<br /><font color="#0000ff">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </font>CP = <font color="#0000ff">base</font></font></font><font face="Courier New"><font size="2">.CreateParams;<br /><font color="#0000ff">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if</font>(!<font color="#0000ff">base</font></font></font><font face="Courier New"><font size="2">.DesignMode)<br /><font color="#0000ff">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </font>CP.ExStyle |= WS_EX_LAYOUTRTL | WS_EX_NOINHERITLAYOUT;<br /><font color="#0000ff">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return</font></font></font><font face="Courier New" size="2"> CP;<br /><font color="#0000ff">&nbsp;&nbsp;&nbsp; </font>}<br />} </font>
</p>

<p>
  </font>
</p>

<p>
  <font face="Courier New" size="2">protected</font><font face="Courier New"><font size="2"> <font color="#0000ff">override</font></font></font><font face="Courier New" size="2"> CreateParams CreateParams<br />{<br /></font><font color="#0000ff" face="Courier New" size="2">&nbsp;&nbsp;&nbsp; get<br /></font><font face="Courier New"><font size="2"><font color="#0000ff">&nbsp;&nbsp;&nbsp; </font>{<br /><font color="#0000ff">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </font>CreateParams CP;<br /><font color="#0000ff">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </font>CP = <font color="#0000ff">base</font></font></font><font face="Courier New"><font size="2">.CreateParams;<br /><font color="#0000ff">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if</font>(!<font color="#0000ff">base</font></font></font><font face="Courier New"><font size="2">.DesignMode)<br /><font color="#0000ff">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </font>CP.ExStyle |= WS_EX_LAYOUTRTL | WS_EX_NOINHERITLAYOUT;<br /><font color="#0000ff">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return</font></font></font><font face="Courier New" size="2"> CP;<br /><font color="#0000ff">&nbsp;&nbsp;&nbsp; </font>}<br />} </font>
</p>

<p>
  <font face="Courier New" size="2">protected</font><font face="Courier New"><font size="2"> <font color="#0000ff">override</font></font></font><font face="Courier New" size="2"> CreateParams CreateParams<br />{<br /></font><font color="#0000ff" face="Courier New" size="2">&nbsp;&nbsp;&nbsp; get<br /></font><font face="Courier New"><font size="2"><font color="#0000ff">&nbsp;&nbsp;&nbsp; </font>{<br /><font color="#0000ff">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </font>CreateParams CP;<br /><font color="#0000ff">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </font>CP = <font color="#0000ff">base</font></font></font><font face="Courier New"><font size="2">.CreateParams;<br /><font color="#0000ff">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if</font>(!<font color="#0000ff">base</font></font></font><font face="Courier New"><font size="2">.DesignMode)<br /><font color="#0000ff">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </font>CP.ExStyle |= WS_EX_LAYOUTRTL | WS_EX_NOINHERITLAYOUT;<br /><font color="#0000ff">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return</font></font></font><font face="Courier New" size="2"> CP;<br /><font color="#0000ff">&nbsp;&nbsp;&nbsp; </font>}<br />} </font>
</p>

<p>
  <font color="#0000ff"></p> 
  
  <p>
    <font face="Courier New" size="2">public</font><font face="Courier New"><font size="2"> <font color="#0000ff">const</font> <font color="#0000ff">int</font></font></font><font face="Courier New"><font size="2"> WS_EX_LAYOUTRTL = 0x400000;<br /><font color="#0000ff">public</font> <font color="#0000ff">const</font> <font color="#0000ff">int</font> WS_EX_NOINHERITLAYOUT = 0x100000;</font></font>
  </p>
  
  <p>
    </font><font face="Courier New"><font size="2"><font color="#0000ff">const</font> <font color="#0000ff">int</font></font></font><font face="Courier New"><font size="2"> WS_EX_LAYOUTRTL = 0x400000;<br /><font color="#0000ff">public</font> <font color="#0000ff">const</font> <font color="#0000ff">int</font> WS_EX_NOINHERITLAYOUT = 0x100000;</font></font>
  </p>
  
  <p>
    &nbsp;
  </p>
  
  <p>
    You can also create a property to control this.
  </p>
  
  <p>
    The above problem <em>could</em> be a bug in GDI+. I started to suspect that it was the culprit when the menu image, which was drawn using <strong>Graphics.DrawImage</strong>,&nbsp;appeared on the left side. In mirroring, the entire coordinate system of a window&nbsp;changes, so if you specify a point (<em>x</em>,<em>y</em>), the <em>x</em> would be the distance from the <em>right</em>, not from the left. Lutz used a function from ImageList (using P/Invoke) called <strong>ImageList_DrawIndirect</strong> to draw the &ldquo;disabled&rdquo; image, and I noticed they were drawn correctly. So I copied the code to the non-disabled part as well, and it worked. The bottom line is, that the Framework's DrawImage method couldn't handle a mirrored control, which made me wonder if this is the reason for the bug described above.
  </p>
  
  <p>
    Wow, that was a long post. I hope it was clear enough. I will be releasing the source code here as soon as I get it working. I haven't found an RTL [Command/Re/Cool/]Bar for .NET anywhere else&#8230;
  </p>