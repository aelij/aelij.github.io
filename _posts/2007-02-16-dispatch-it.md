---
id: 166
title: Dispatch It
date: 2007-02-16T11:57:00+00:00
author: Eli Arbel
layout: post
redirect_from:
  - /blog/archive/2007/02/16/dispatch-it.aspx.html
guid: /blog/archive/2007/02/16/dispatch-it.aspx
permalink: /2007/02/16/dispatch-it/
dsq_thread_id:
  - "5736700243"
categories:
  - Uncategorized
tags:
  - CLR
  - WPF
---
In WPF, like most UI frameworks,&nbsp;UI elements&nbsp;can only be updated from the thread they were created on.&nbsp;If you do background work, and want to affect the UI from a different thread, you'll have to _dispatch_ it. The Dispatcher class has a CheckAccess() method (which is marked as&nbsp;EditorBrowsableState.Never, making it invisible to intellisense for some reason.)

<!--more-->

Here's how you would normally use it:

```csharp
delegate void CallMeDelegate(Button b);

void CallMe(Button b)
{
    if (!Dispatcher.CheckAccess())
    {
        Dispatcher.Invoke(DispatcherPriority.Normal, new CallMeDelegate(CallMe), b);
        return;
    }

    b.Foreground = Brushes.Red;
} 
```

<p>
  You have to create a delegate, check for access and dispach if necessary. However, there's a smarter way, if you allow for a bit of Reflection:
</p>

```csharp
void CallMe(Button b)
{
    if (UIHelper.EnsureAccess(MethodBase.GetCurrentMethod(), this, b))
    {
        b.Foreground = Brushes.Red;
    }
} 
```

<p>
  What <b>MethodBase.GetCurrentMethod()</b> does is actually give you a method descriptor of the calling method (quite useful for a few scenarios! Too bad they don't have a GetCallerMethod() as well&#8230;) The EnsureAccess() method then checks with the dispatcher if we're on the right thread, and if not, dynamically dispatches it.
</p>

<p>
  Last note: Dispatchers run a prioritized queue, so it can be handy to set the <b>DispatcherPriority</b> to something other than Normal. For example, if you set a Dependency Property's value, and want to do something after the UI was updated, try dispatching it with ContextIdle priority.
</p>

<p>
  For more information about Dispatchers, you should&nbsp;read Nick Kramer's <a href="http://blogs.msdn.com/nickkramer/archive/2006/03/17/553378.aspx">whitepaper</a>.
</p>

<p>
  <b>Update:</b> I also discovered the existence of the&nbsp;<a href="http://msdn2.microsoft.com/en-us/system.windows.threading.dispatchersynchronizationcontext.aspx">DispatcherSynchronizationContext</a>, which inherits from the good old SynchronizationContext of .NET 2.0. The original one uses ThreadPool to queue items, while the WPF one uses the Dispatcher mechanism, which is more suitable for WPF. Note that this way you cannot specify a priority. I still believe the way I described above is slightly better.
</p>

<p>
  <b>Another Update:</b> I've changed a few things in the implementation. Now it checks whether the object it receives is a DispatcherObject, and if so, uses its Dispatcher instead of the Application's. This is good for (the rare) cases where your UI itself runs in more than one thread.
</p>

<p>
  Attachment: <a href="https://arbel.net/attachments/UIHelper.rar">UIHelper.rar</a>
</p>