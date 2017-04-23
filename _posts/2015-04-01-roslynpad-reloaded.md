---
id: 419
title: RoslynPad Reloaded
date: 2015-04-01T21:14:35+00:00
author: Eli Arbel
layout: post
guid: http://arbel.net/?p=419
permalink: /2015/04/01/roslynpad-reloaded/
dsq_thread_id:
  - "5736700195"
image: /wp-content/uploads/2015/04/RoslynPadReloaded.png
categories:
  - Uncategorized
tags:
  - 'C#'
  - Roslyn
  - RoslynPad
---
**[Updated Post](https://arbel.net/2016/02/22/roslynpad-01/)**

<!--more-->

A [while back](https://arbel.net/2013/05/11/roslynpad/ "RoslynPad") I created a small sample that exposed the Roslyn code completion (a.k.a. Intellisense) APIs via Reflection. This was during the CTP days of Roslyn, and I hoped these APIs would become public when Roslyn hits RTM.

Much has changed in Roslyn during these past two years, and I wanted to update the sample. The completion APIs are still internal, but fortunately now Roslyn is an open-source project. I compiled my own version, and exposed both **ICompletionService** and **ISignatureHelpProvider**. The latter allows me to display method signatures and overloads. I've created a new assembly, _Microsoft.CodeAnalysis.EditorFeatures.Minimal_ in lieu of _Microsoft.CodeAnalysis.EditorFeatures_ that does not depend on Visual Studio's (proprietary) assemblies.

Download the sources (with the modified Roslyn binaries) from
  
<https://github.com/aelij/roslynpad>

&nbsp;