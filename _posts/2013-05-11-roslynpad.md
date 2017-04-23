---
id: 284
title: RoslynPad
date: 2013-05-11T21:35:10+00:00
author: Eli Arbel
excerpt: |  
  The first experiment I'm about to present in this post is a simple code editor (similar to the acclaimed LINQPad) that uses two parts of Roslyn: the Script Engine and Completion Service.
layout: post
guid: http://arbel.net/?p=284
permalink: /2013/05/11/roslynpad/
dsq_thread_id:
  - "5736700289"
image: /wp-content/uploads/2013/05/RoslynPad.png
categories:
  - Uncategorized
tags:
  - 'C#'
  - Roslyn
  - RoslynPad
  - WPF
---
**[Updated Post](https://arbel.net/2016/02/22/roslynpad-01/)**

<!--more-->

Hacking the [Roslyn](http://msdn.microsoft.com/en-us/vstudio/roslyn.aspx) code has been fun. It is a very impressive piece of well engineered code.

The first experiment I'm about to present in this post is a simple code editor (similar to the acclaimed LINQPad) that uses two parts of Roslyn: the **Script Engine** and **Completion Service**.

&nbsp;

## Script Engine

Used to compile and run pieces of code. You can create sessions in which you continuously add statements to the session, and the engine would interpret them as they come along. This is sometimes referred to as REPL, a read-eval-print loop. Using the ScriptEngine class is extremely straightforward: create an instance, add reference assemblies, import namespaces and then create sessions to evaluate code. You immediately get the result of any expression as an object.

&nbsp;

## Completion Service

AKA IntelliSense. Who can program without it nowadays? You'd have to be a walking MSDN library. No code editor would be complete without it.

Unfortunately the Roslyn completion service (ICompletionService) was made internal in their last release. Well, that didn't deter me. I quickly created a wrapper that uses reflection to access it. Hopefully this is just due to the CTP nature of the current release.

Using the completion service is slightly more complex: you have to use Roslyn's Workspace API to create a solution (ISolution), a project (IProject) and documents (IDocument) that contain your code. You can open actual Visual Studio solutions and project files with this API. Very neat. But for our Pad, we need everything in memory most of the time. No worries, Roslyn supports that as well.

Once you setup a solution, you can use its ILanguageServiceProviderFactory to create an ILanguageServiceProvider for a language of your choice (C#, naturally). From there we can produce the completion service. To get the completion items, we need to pass a document and a position within it, and Roslyn does the rest.

&nbsp;

## Editing Code

Our Pad needs a code editor. Fortunately, [AvalonEdit](https://github.com/icsharpcode/SharpDevelop/wiki/AvalonEdit)**** is a pretty descent free editor. It originated within the SharpDevelop project, and supports highlighting, completion and lots of other features. To make it work with Roslyn, I had to create a few adapters.

Roslyn documents use two primary interfaces for dealing with text: ITextContainer that represents, well, the container. It produces the current text and notifies the document of changes; and IText which represents the actual text. Roslyn has a built-in IText implementation called StringText which suited my needs, but I had to create my own container.

To display the completion results, AvalonEdit includes the CompletionWindow class. It can be filled with ICompletionData items, for which I created a class that wrapped Roslyn's CompletionItem.

&nbsp;

## Printing

I've created an extension method for System.Object called "Dump", similarly to LINQPad. I'm using a FlowDocument to format the results, and currently it recursively walks all the public properties of objects and iterates all enumerators. Note that performance can be a problem since it's not done lazily.

&nbsp;

## Conclusion

Roslyn provides a powerful API that can both parse code, provide metadata and run it. Though the Pad's implementation is far from complete, you can see how relatively simple it is to setup (once you know what you're doing 😉

Documentation for Roslyn is still mostly nonexistent, with only a few "getting started" documents. Luckily there are a few samples and Reflector always comes to the rescue when needed.

To run the sample, first get all the NuGet dependencies (Roslyn still has no go-live license, so this is the only way to distribute it.)

[Download](https://arbel.net/wp-content/uploads/2013/05/RoslynPad.zip)