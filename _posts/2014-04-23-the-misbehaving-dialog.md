---
id: 382
title: The Misbehaving Dialog
date: 2014-04-23T08:55:23+00:00
author: Eli Arbel
layout: post
permalink: /2014/04/23/the-misbehaving-dialog/
image: /wp-content/uploads/2014/04/1398270438_chat-bubble.png
categories:
  - Uncategorized
tags:
  - WPFContrib
---
## Windows' dialogs can be bad for your app

<!--more-->

  * They don't allow you to resize, minimize or do anything with the containing window
  * As a consequence of the above, when you use WIN+D to show the desktop, then open another window, they suddenly pop back up from nowhere (along with the containing window, of course)
  * You can't have dialogs that are context-specific (e.g. a certain tab)
  * They misbehave if you don't set their parent explicitly (sometimes hiding behind other windows, accessible only via crazy ALT-tabbing)
  * They make that annoying 'ding' sound when you click the containing window ;)

 

## There's a better way

**InlineModalDialog**, available in the latest version of [WPF Contrib,](https://www.nuget.org/packages/AvalonLibrary) works a bit differently:

  * It creates an _inline_ dialog that is contained within the window
  * It constrains the input (keyboard, mouse & touch) to the dialog; WPF can easily do that with its sophisticated keyboard navigation options and hit-testing invisibility
  * It uses a Dispatcher frame to block the caller of the Show() method, just like a regular dialog does
  * You can layer dialogs on top of each other
  * You can define multiple scopes in which the dialogs appear

 

**How to use**

Add the decorator below the element to be used as the container. Set the **Target** property to the container.

```xml
<UserControl xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
             xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
             xmlns:av="http://schemas.codeplex.com/wpfcontrib/xaml/presentation"
             Name="RootContainer">
    <av:InlineModalDecorator Target="{x:Reference RootContainer}">
 
    </av:InlineModalDecorator>
</UserControl>  
```

Create a dialog and show it:

```csharp
var dialog = new InlineModalDialog
{
    Owner = this,
    Content = new MyDialogViewModel(),
};
dialog.Show();
```

The **Owner** can be any element contained within the **Target** specified in the decorator (or the target itself).

You may also use the new **ShowInline()** overloads in **TaskDialog**.

## 

## Limitations

* In the current implementation, you can't move or resize the dialogs (but they can be resized with the container using stretching and margins). This can be easily mitigated, and I may address it in a future release.
* The developer needs to be more aware of the dialogs' state, especially when these are dialogs that are shown when closing a window. For example, what happens if, while editing a document, the user has opened a settings dialog and clicks the window's close button? Should you ask whether to save the settings? Save the document? Ignore/disable it? It's up to you to decide what's the better UX.
