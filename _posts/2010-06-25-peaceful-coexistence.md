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

<div style="padding-bottom: 0px; margin: 0px; padding-left: 0px; padding-right: 0px; display: inline; float: none; padding-top: 0px" id="scid:9ce6104f-a9aa-4a17-a79f-3a39532ebf7c:9deedec7-4ab5-4ffe-ad31-1339c44d6e11" class="wlWriterEditableSmartContent">
  <div style="border: #000080 1px solid; color: #000; font-family: 'Courier New', Courier, Monospace; font-size: 10pt">
    <div style="background: #fff; max-height: 300px; overflow: auto">
      <ol style="background: #ffffff; margin: 0; padding: 0 0 0 5px;">
        <li>
          [<span style="color:#2b91af">Guid</span>(<span style="color:#a31515">&#8220;45421E7C-EA8E-4987-A669-5334795D1627&#8221;</span>)]
        </li>
        <li style="background: #f3f3f3">
          <span style="color:#0000ff">public</span> <span style="color:#0000ff">interface</span> <span style="color:#2b91af">IMyControl</span>
        </li>
        <li>
          {
        </li>
        <li style="background: #f3f3f3">
          &nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#2b91af">IntPtr</span> Handle { <span style="color:#0000ff">get</span>; }
        </li>
        <li>
          }
        </li>
      </ol>
    </div>
  </div>
</div>

Now, we implement the interface using the FrameworkElementAdapters class:

<div style="padding-bottom: 0px; margin: 0px; padding-left: 0px; padding-right: 0px; display: inline; float: none; padding-top: 0px" id="scid:9ce6104f-a9aa-4a17-a79f-3a39532ebf7c:8c65ce44-3119-40ef-8ae9-54b38bf1ff9d" class="wlWriterEditableSmartContent">
  <div style="border: #000080 1px solid; color: #000; font-family: 'Courier New', Courier, Monospace; font-size: 10pt">
    <div style="background: #ddd; max-height: 300px; overflow: auto">
      <ol style="background: #ffffff; margin: 0 0 0 2.5em; padding: 0 0 0 5px;">
        <li>
          [<span style="color:#2b91af">Guid</span>(<span style="color:#a31515">&#8220;4F03582A-8ECA-4A27-9E4E-00AB54078592&#8221;</span>)]
        </li>
        <li style="background: #f3f3f3">
          &nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#0000ff">public</span> <span style="color:#0000ff">class</span> <span style="color:#2b91af">MyControl</span> : <span style="color:#2b91af">IMyControl</span>
        </li>
        <li>
          &nbsp;&nbsp;&nbsp;&nbsp;{
        </li>
        <li style="background: #f3f3f3">
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#0000ff">private</span> <span style="color:#2b91af">UserControl1</span> _instance;
        </li>
        <li>
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#0000ff">private</span> <span style="color:#2b91af">INativeHandleContract</span> _contract;
        </li>
        <li style="background: #f3f3f3">
          &nbsp;
        </li>
        <li>
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#0000ff">public</span> MyControl()
        </li>
        <li style="background: #f3f3f3">
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{
        </li>
        <li>
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;_instance = <span style="color:#0000ff">new</span> <span style="color:#2b91af">UserControl1</span>();
        </li>
        <li style="background: #f3f3f3">
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;_contract = <span style="color:#2b91af">FrameworkElementAdapters</span>.ViewToContractAdapter(_instance);
        </li>
        <li>
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Handle = _contract.GetHandle();
        </li>
        <li style="background: #f3f3f3">
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}
        </li>
        <li>
          &nbsp;
        </li>
        <li style="background: #f3f3f3">
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#0000ff">public</span> <span style="color:#2b91af">IntPtr</span> Handle { <span style="color:#0000ff">get</span>; <span style="color:#0000ff">private</span> <span style="color:#0000ff">set</span>; }
        </li>
        <li>
          &nbsp;&nbsp;&nbsp;&nbsp;}
        </li>
      </ol>
    </div>
  </div>
</div>

We must also tag the assembly (or the required types) with the [ComVisible(true)] attribute.

Now, for the host, we simply reference the assembly containing the user control and instantiate the COM object. We also need to provide a simple implementation of INativeHandleContract (see the sample code).

<div style="padding-bottom: 0px; margin: 0px; padding-left: 0px; padding-right: 0px; display: inline; float: none; padding-top: 0px" id="scid:9ce6104f-a9aa-4a17-a79f-3a39532ebf7c:7bfe535a-a393-4700-8e6a-f6709ebe0afb" class="wlWriterEditableSmartContent">
  <div style="border: #000080 1px solid; color: #000; font-family: 'Courier New', Courier, Monospace; font-size: 10pt">
    <div style="background: #ddd; max-height: 300px; overflow: auto">
      <ol style="background: #ffffff; margin: 0 0 0 2em; padding: 0 0 0 5px;">
        <li>
          _control = (WpfSxsControls.<span style="color:#2b91af">IMyControl</span>)<span style="color:#2b91af">Activator</span>.CreateInstance(
        </li>
        <li style="background: #f3f3f3">
          &nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#2b91af">Type</span>.GetTypeFromCLSID(<span style="color:#0000ff">new</span> <span style="color:#2b91af">Guid</span>(<span style="color:#a31515">&#8220;{4F03582A-8ECA-4A27-9E4E-00AB54078592}&#8221;</span>)));
        </li>
        <li>
          Content = <span style="color:#2b91af">FrameworkElementAdapters</span>.ContractToViewAdapter(
        </li>
        <li style="background: #f3f3f3">
          &nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#0000ff">new</span> <span style="color:#2b91af">NativeHandleContract</span>(_control.Handle));
        </li>
      </ol>
    </div>
  </div>
</div>

Lastly, there&rsquo;s the issue of COM registration. You can either register the COM object in the registry, which can cause deployment problems (mainly during uninstall). To do it quickly from VS, simply check the following box in the Build tab of the control assembly&rsquo;s project properties:

 <img style="border-bottom: 0px; border-left: 0px; display: inline; border-top: 0px; border-right: 0px" title="image" alt="image" src="https://arbel.net/attachments/images/image_5F00_thumb_5F00_31039729.png" border="0" height="74" width="244" />

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