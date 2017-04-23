---
id: 251
title: The Case of the Elusive TransportManager
date: 2012-06-28T10:33:55+00:00
author: Eli Arbel
layout: post
guid: http://arbel.net/?p=251
permalink: /2012/06/28/the-story-of-the-elusive-transportmanager/
image: /wp-content/uploads/2012/06/Detective.png
categories:
  - Uncategorized
tags:
  - AppFabric
  - WCF
---
Hosting WCF services in AppFabric has its benefits, but it can cause a lot of pain as well. I was trying to resolve the following error which kept appearing at one of my customers:

> There is no compatible TransportManager found for URI &#8216;net.pipe://<some address>'. This may be because that you have used an absolute address which points outside of the virtual application, or the binding settings of the endpoint do not match those that have been set by other services or endpoints. Note that all bindings for the same protocol should have same settings in the same application.

Google yielded very little results on this. I knew for a fact the _address_ was in the virtual application, so that only left the _binding settings_. It seems once a transport manager is created for a certain protocol, you **cannot** create another one that differs in these parameters (found [here](http://msdn.microsoft.com/en-us/library/ms733109.aspx)):

  * ConnectionBufferSize
  * ChannelInitializationTimeout
  * MaxPendingConnections
  * MaxOutputDelay
  * MaxPendingAccepts
  * ConnectionPoolSettings.IdleTimeout
  * ConnectionPoolSettings.MaxOutboundConnectionsPerEndpoint

(Note these are properties of ConnectionOrientedTransportBindingElement; some of them are mapped to properties of NetNamedPipeBinding and NetTcpBinding).

Now, that specific system had an initialization mechanism which created all bindings _in code_. And there was only one method which created a NetNamedPipeBinding, so this had to be coming from somewhere else. **The** [**MaxConnections**](http://msdn.microsoft.com/en-us/library/system.servicemodel.netnamedpipebinding.maxconnections.aspx) **property in this binding was set to a non-default value (100; the default is 10).**

So, the first thing I tried was to set the default binding in the Web.config file to match what was in that method. No luck.

After some digging in Reflector, I realized I had to somehow track down the suspected TransportManager. I had to resort to using _windbg_. I'm going to give you the solution right now, but if you're interested in _how_ I found it, keep reading.

## The Solution

Turns out the culprit was **AppFabric's Service Management Service**. When you install AppFabric, it adds an entry to the root Web.config file that activates this service (applied to all "web" applications). It seems there's a problem with the way it initializes its endpoint (quite possibly a bug) which prevents it from reading the default binding configuration. There are a few possible fixes:

  * Set its endpoint configuration in your Web.config to match your other bindings
  * Disable the service
  * Remove the service altogether

You can find out how to accomplish all of these [here](http://msdn.microsoft.com/en-us/library/ff383422).

## How I Tracked It Down

With a few helpful [SOS](http://msdn.microsoft.com/en-us/library/bb190764) commands (the output is shortened for brevity):

First, get all types on the heap that have "TransportManager" in them:

```
!dumpheap -type TransportManager

                          MT      Count      TotalSize Class Name
						  000007feca5d9558              1                  176 System.ServiceModel.Activation.HostedTcpTransportManager
						  000007feca5d94a8              1                  176 System.ServiceModel.Activation.HostedNamedPipeTransportManager
						  000007feead19ac8              8                  320 System.Collections.Generic.List`1[[System.ServiceModel.Channels.TransportManager, System.ServiceModel]]
```

Get the specific object:

```
!dumpheap -type HostedNamedPipeTransportManager

                Address                            MT        Size
				00000001c000e068 000007feca5d94a8          176        

!do 00000001c000e068

Name:              System.ServiceModel.Activation.HostedNamedPipeTransportManager
 Fields:
 MT      Field    Offset                                Type VT        Attr                      Value Name
 000007fef7adcc28  40003b5            1c                System.Int32  1 instance                        8192 connectionBufferSize
 000007fef7af96f0  40003b6            40          System.TimeSpan     1 instance 00000001c000e0a8 channelInitializationTimeout
 000007fef7adcc28  40003b7            30                System.Int32  1 instance                            10 maxPendingConnections
 000007fef7af96f0  40003b8            48          System.TimeSpan     1 instance 00000001c000e0b0 maxOutputDelay
 000007fef7adcc28  40003b9            34                System.Int32  1 instance                              1 maxPendingAccepts</span>
```

Then I realized what I really needed was the binding element:

```
!dumpheap -type NamedPipeTransportBindingElement

 Heap 0
 Address                            MT        Size
 0000000100bee908 000007feead35550            96
 total 0 objects
 &#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;
 Heap 1
 Address                            MT        Size
 000000014031e130 000007feead35550            96
 00000001403f66b8 000007feead35550            96
 00000001403f69d0 000007feead35550            96
 00000001403f7b40 000007feead35550            96
 00000001403f7e58 000007feead35550            96
 00000001403f87b8 000007feead35550            96
 00000001403f8cd0 000007feead35550            96
 00000001403f95c8 000007feead35550            96
 00000001403f9930 000007feead35550            96      

 Heap 3
 Address                            MT        Size
 000007feead35550            96
 total 0 objects
```

There were lots of them, but I decided to examine the last one (because it was the oldest) and find out where it's rooted (i.e. which objects have references to it):

```
!do 00000001c0055d78
 Name:              System.ServiceModel.Channels.NamedPipeTransportBindingElement
 Fields:
 MT      Field    Offset                                Type VT        Attr                      Value Name
 000007fef7adcc28  40008c5            28                System.Int32  1 instance                    10 maxPendingConnections

!gcroot 00000001c0055d78

DOMAIN(000000000368B3B0):HANDLE(Strong):b812f0:Root:  000000010005c840(System.Runtime.Remoting.ServerIdentity)->
 000000010002cbe0(System.Runtime.Remoting.Contexts.Context)->
 000000010002c8e0(System.AppDomain)->
 00000001406f2e88(System.EventHandler)->
 0000000140093f78(System.Object[])->
 000000017fff4bf0(System.EventHandler)->
 000000017fff49a0(System.Web.Hosting.HostingEnvironment)->
 000000017fff4b38(System.Collections.Hashtable)->
 000000017fff4b90(System.Collections.Hashtable+bucket[])->
 0000000180080060(System.ServiceModel.ServiceHostingEnvironment+HostingManager)->
 00000001800800f8(System.Collections.Hashtable)->
 0000000180080150(System.Collections.Hashtable+bucket[])->
 00000001bfff0160(System.ServiceModel.ServiceHostingEnvironment+ServiceActivationInfo)->
 00000001c005c430(System.ServiceModel.ServiceHost)->
 00000001c005e7d0(System.ServiceModel.Description.ServiceDescription)->
 00000001c005e890(System.ServiceModel.Description.ServiceEndpointCollection)->
 00000001c005e8b0(System.Collections.Generic.List`1[[System.ServiceModel.Description.ServiceEndpoint, System.ServiceModel]])->
 00000001c006ce58(System.Object[])->
 00000001c00591f0(Microsoft.ApplicationServer.Hosting.Management.ServiceManagementEndpoint)->
```

And that's it.