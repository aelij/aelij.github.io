---
id: 189
title: Peaceful Coexistence
date: 2010-06-25T18:21:00+00:00
author: Eli Arbel
layout: post
redirect_from:
  - /blog/archive/2010/06/25/peaceful-coexistence.aspx.html
guid: /blog/archive/2010/06/25/peaceful-coexistence.aspx
permalink: /2010/06/25/peaceful-coexistence/
categories:
  - Uncategorized
tags:
  - .NET 4
  - CLR
  - WPF
---
One of the new features in .NET 4.0 is **Side-By-Side In-Process** (SxS InProc) execution of older CLRs (e.g. .NET 2.0). Previously, SxS was supported only in different processes. If you look it up, you&rsquo;ll find [these](http://blogs.msdn.com/clrteam/archive/2009/06/03/in-process-side-by-side-part1.aspx) [two](http://blogs.msdn.com/clrteam/archive/2009/06/07/in-process-side-by-side-part-2-common-in-proc-sxs-scenarios.aspx) (yet to be updated) blog posts by the CLR team, an MSDN Magazine [article](http://msdn.microsoft.com/en-us/magazine/ee819091.aspx) as well as [one](http://msdn.microsoft.com/en-us/library/ee518876.aspx) in the MSDN Library. You can get a good review of supported scenarios and some code, but what they all sorely lack is a working sample. (**Update:** There&rsquo;s a new detailed [article](http://blogs.msdn.com/clrteam/archive/2010/06/23/in-proc-sxs-and-migration-quick-start.aspx) from the CLR team.)

The common scenario for SxS would be a host (such as Outlook) that loads .NET add-ins which are configured to run in different versions of the CLR. In this case, it is sufficient to provide an app.config that would tell the host which .NET version you need. The default COM activation behavior in .NET 4 is to use the CLR version the component was compiled with.

The scenario I&rsquo;ve been trying to solve isn&rsquo;t mentioned in any of these articles; I would like to host a WPF 3.5 control in a WPF 4 application. Why? Because I&rsquo;m using a crucial 3rd party control that unfortunately doesn&rsquo;t work with .NET 4.

I remembered that there was already a way to host WPF controls from different AppDomains, by using the .NET Add-In framework (System.AddIn). This [article](http://blogs.msdn.com/clraddins/archive/2007/08/06/appdomain-isolated-wpf-add-ins-jesse-kaplan.aspx) from the CLR Add-In team blog has a nice [sample](http://clraddins.codeplex.com/releases/view/9454) that shows how it&rsquo;s done.

So, we will utilize the FrameworkElementAdapters class to help us convert a FrameworkElement to a Win32 handle, pass it from the CLR v2 component via COM and then convert it back to a FrameworkElement in CLR v4. Sounds complicated? Maybe. But it will take only a handful of code lines to accomplish.

### Creating the Control

First, we create a WPF user control. Then, we create a COM interface that contains the handle and any other properties we may want to use on &ldquo;the other side&rdquo;.

```csharp
[Guid(“45421E7C-EA8E-4987-A669-5334795D1627”)]
public interface IMyControl
{
    IntPtr Handle { get; }
}
```

Now, we implement the interface using the FrameworkElementAdapters class:

```csharp
[Guid("4F03582A-8ECA-4A27-9E4E-00AB54078592")]
public class MyControl : IMyControl
{
    private UserControl1 _instance;
    private INativeHandleContract _contract;

    public MyControl()
    {
        _instance = new UserControl1();
        _contract = FrameworkElementAdapters.ViewToContractAdapter(_instance);
        Handle = _contract.GetHandle();
    }

    public IntPtr Handle { get; private set; }
}
```

        
We must also tag the assembly (or the required types) with the [ComVisible(true)] attribute.

Now, for the host, we simply reference the assembly containing the user control and instantiate the COM object. We also need to provide a simple implementation of INativeHandleContract (see the sample code).

```csharp
_control = (WpfSxsControls.IMyControl)Activator.CreateInstance(
    Type.GetTypeFromCLSID(new Guid("{4F03582A-8ECA-4A27-9E4E-00AB54078592}")));
Content = FrameworkElementAdapters.ContractToViewAdapter(
    new NativeHandleContract(_control.Handle));
```

Lastly, there&rsquo;s the issue of COM registration. You can either register the COM object in the registry, which can cause deployment problems (mainly during uninstall). To do it quickly from VS, simply check the following box in the Build tab of the control assembly&rsquo;s project properties:

!(Properties)[https://arbel.net/attachments/Images/image_5F00_thumb_5F00_31039729.png" border="0" height="74" width="244"]

**Or** you can use [Registration-Free COM](http://msdn.microsoft.com/en-us/library/ms973913.aspx). The provided sample code uses the latter method.

### Caveats

  * You&rsquo;re using COM, which means everything you&rsquo;re exposing from your control needs to be COM-patible.
  * You&rsquo;re using COM, which means passing delegates (and that includes registering to .NET events) becomes a lot less trivial.
  * Debugging can be a serious issue; it seems VS is not capable of attaching to the other (older) CLR.
  * Some work needs to be done to handle focus changes.

You can ameliorate some of these issues by using COM only to activate the older CLR and then use some IPC technology (e.g. WCF, Remoting) to communicate with your control. I strongly recommend this approach if you have a complex object model.

### Running the Sample

Just compile and run. The C++ project in the solution is used only to generate a Win32 Resource file which embeds the manifest that is required for reg-free COM. You can see that it is working if the title of the windows shows CLR v4 and above the first text box there&rsquo;s a text indicating it&rsquo;s coming from CLR v2.

Attachment: [WpfSxs.zip](https://arbel.net/attachments/WpfSxs.zip)