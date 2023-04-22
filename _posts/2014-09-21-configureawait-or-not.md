---
id: 390
title: To ConfigureAwait or not to ConfigureAwait?
date: 2014-09-21T14:04:42+00:00
author: Eli Arbel
layout: post
permalink: /2014/09/21/configureawait-or-not/
image: /wp-content/uploads/2014/09/ConfigureAwaitReSharper.png
categories:
  - Uncategorized
tags:
  - Async
  - 'C#'
  - ReSharper
---
When **await**ing tasks in C#, you have the option to configure how the continuation behaves - whether it uses the Synchronization Context or not.

<!--more-->

This can be pretty important, especially when awaiting tasks in code that was initialized from a UI thread, which has a Synchronization Context. Poorly written code can easily result in a deadlock, not to mention a serious perf hit. For example:

```csharp
  
class MyWindow : Window
{
    private void MyButton_Click(object sender, EventArgs e)
    {
        DoSomething().Wait();
    }

    private async Task DoSomething()
    {
        await Task.Run(() => { });
    }
}
```  

This is obviously bad, calling Wait() on the UI thread. But it's easy to imagine more subtle ways this could happen inside library code. That's why the best practice is to **always** use **ConfigureAwait(continueOnCapturedContext: false)** in library code. I really wish they'd split that into two separate methods. I also wish they'd made the default to be **false**.

I've recently come to the conclusion that it's best to always specify ConfigureAwait **everywhere** lest you forget. So I wrote up a small ReSharper plugin (my first) that checks for it and also provides a quick-fix (ReSharper provides an awesome extensibility model):

<img class="wp-image-393 size-full" src="https://arbel.net/wp-content/uploads/2014/09/ConfigureAwaitReSharper.png" alt="ConfigureAwait Checker for ReSharper" width="396" height="157" srcset="https://arbel.net/wp-content/uploads/2014/09/ConfigureAwaitReSharper.png 396w, https://arbel.net/wp-content/uploads/2014/09/ConfigureAwaitReSharper-300x118.png 300w" sizes="(max-width: 396px) 100vw, 396px" />

Download it from the ReSharper extensions gallery: <http://resharper-plugins.jetbrains.com/packages/ConfigureAwaitChecker>.

**Update:** Now supporting ReSharper 9 (different package): <https://resharper-plugins.jetbrains.com/packages/ConfigureAwaitChecker.v9>