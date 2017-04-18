---
id: 165
title: BitmapEffect Begone
date: 2007-02-09T12:30:00+00:00
author: Eli Arbel
layout: post
redirect_from:
  - /blog/archive/2007/02/09/bitmapeffect-begone.aspx.html
guid: /blog/archive/2007/02/09/bitmapeffect-begone.aspx
permalink: /2007/02/09/bitmapeffect-begone/
dsq_thread_id:
  - "5736700140"
categories:
  - Uncategorized
tags:
  - WPF
---
You can do really neat things with Bitmap Effects in WPF. Shadow, Bevel, Outer Glow can all have a great impact on how your application looks. But you should be aware that they don't come cheap. They are rendered in **software**, which yields very poor performance. Also, [ClearType is turned off](https://arbel.net/blog/archive/2007/02/02/give-me-back-my-cleartype.aspx) on elements that have them applied, so your text&nbsp;becomes blurry.

So, what to do?

  * **Abstinence**. Now, I'm not really a prude, but in this case, minimizing the use of bitmap effects can significantly improve performance. 
  * **<span style="color: #8000ff;">Apply only on simple Visuals</span>**.&nbsp;Probably the most important advice here.&nbsp;If you want to apply an effect on a complex Visual, use layers! Apply the BitmapEffect on a simple **Shape** (e.g. Rectangle, Path), and use a Grid, for example, to position it below your complex Visual. Do not apply the effect on a Decorator (such as a Border) that contains your Visual, since that will cause the **entire visual tree** to suffer from the effect. 
  * **Avoid Animations**. Especially on large Visuals, avoid animating the BitmapEffect's properties, and animating elements that have effects applied on them. TextBoxes, for example, animate the cursor frequently when they are focused, so if an element that has an effect contains a TextBox, it is forced to render itself entirely every blink. 
  * **Use Bitmaps**. Yes, it's true&nbsp;bitmaps don't scale like vectors, but in some places they are a very viable alternative. 
  * <div class="wlWriterSmartContent" id="6960CE03-38FC-44df-87D4-FA4540212B06:b45ee0d3-3425-4b1d-9b0c-1369c3f35216" style="PADDING-RIGHT:10px;DISPLAY:inline;PADDING-LEFT:10px;FLOAT:right;PADDING-BOTTOM:10px;MARGIN:0px;PADDING-TOP:10px;TEXT-ALIGN:center;">
      <img style="width: 132px; height: 132px;" src="https://arbel.net/attachments/images/1955.shadow.png" /><br />How nine-grid images work
    </div>
    
    **Use Nine-Grid Images**. Have you ever wondered how the themes on XP and Vista work? You can stretch a button as much as you like and it still looks good. They use nine grid images. The idea is very simple: divide the image to nine areas and stretch it as shown in the illustration. The effect is that the proportions of the corners&nbsp;and borders&nbsp;are always maintained. I've attached a project with a NineGridBorder class that can be used to draw these images. After I wrote it, I discovered [another implementation](http://wpf.netfx3.com/files/folders/code_snippets/entry7532.aspx), so I took the best of both of them.&nbsp; </li> 
    
      * **Vectorize**. When exporting from [Expression Design](http://www.microsoft.com/products/expression/en/Expression-Design/) to XAML, you have the option to either rasterize (i.e. create a bitmap) or vectorize some of the effects. For example, when applying soft edges to a vector drawing, ED exporter will create a Canvas that contains a few layers with different opacities, which will simulate the effect. 
      * **Use WpfPerf**. This is a great tool that comes with the Windows SDK. You can use Perforator to detect whether your careless colleagues used BitmapEffects or other ill-advised features that may&nbsp;hinder your application's performance. Check &#8220;_Draw software rendering with purple tint_&#8221; to immediately view what causes problems. Try to resize the window or run animations while this is checked.</ul> 
    
    Attachment: [BitmapEffectBegone.rar](https://arbel.net/attachments/BitmapEffectBegone.rar)