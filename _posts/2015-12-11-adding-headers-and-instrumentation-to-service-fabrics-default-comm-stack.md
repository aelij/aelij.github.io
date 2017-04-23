---
id: 481
title: 'Adding headers and instrumentation to Service Fabric default comm. stack'
date: 2015-12-11T10:31:46+00:00
author: Eli Arbel
layout: post
guid: https://arbel.net/?p=481
permalink: /2015/12/11/adding-headers-and-instrumentation-to-service-fabrics-default-comm-stack/
image: /wp-content/uploads/2015/12/partycluster-background1.png
categories:
  - Uncategorized
tags:
  - Service Fabric
---
**Update**

With Service Fabric SDK v2 this became much simpler. Check out this [SO answer](http://stackoverflow.com/a/34221661/276083) of mine for details.

<!--more-->

* * *

Service Fabric's default communication stack for Reliable Services provides a simple way to enable communications without worrying about protocols, discovery, and much more as we shall see. To use the stack, we need to create a `ServiceRemotingListener`, which implements `ICommunicationListener`, as well as create a service interface:

```csharp
interface IMyService : IService
{
    Task<MyData> DoIt();
}

class MyService : StatelessService, IMyService
{
    protected override IEnumerable CreateServiceInstanceListeners()
    {
        return new[] { new ServiceInstanceListener(parameters => new ServiceRemotingListener(parameters, this)) };
    }

    public Task<MyData> DoIt()  
    {
        return Task.FromResult(new MyData());
    }
}
```

Then, to use the service, we can create a proxy using `ServiceProxy`:

```csharp
var myService = ServiceProxy.Create<IMyService>();
await myService.DoIt();
```

However, what the stack doesn't _trivially_ provide are hooks for adding headers and instrumentation for the service operations. Headers are essential in modern SO architectures. They can allow ambient information such as identity to pass along messages. Instrumentation allows you to add code when a service operation starts and ends. This could be used for logging, error handling, authorization and more. In this post I will share a solution for adding both of these.

## Get the code

This sample is no longer relevant with SDK v2 and has been removed

<del><a href="https://github.com/aelij/samples-servicefabric-instrumentation">https://github.com/aelij/samples-servicefabric-instrumentation</a></del>

## How it works

In the latest preview, two additions were made to the service API that enable this &#8211; both `ServiceRemotingListener` and `ServiceProxy` now accept a factory that allows us to construct the &#8220;inner&#8221; communication listener and client. What does this mean? Both the listener and the proxy are higher level abstractions, and they use inner classes to provide the actual communication layer. By default, Service Fabric uses WCF. All of this implementation is internal, so in the sample code you'll see a replica of that internal code with the added hooks.

The heart of the solution relies on the `WcfRemotingService` class, which is the implementation of the WCF service. This class receives generic messages, in the form of a byte array, later to be decoded and dispatched into our implementation (e.g. the `MyService` class above). So, essentially, we can add any code before and after the execution of the method.

Service Fabric uses the class `ServiceRemotingMessageHeaders` to send metadata about which interface and method were called. This data is encoded into integer hashes of the names. The sample code also shows how to decode this data for logging purposes. This could be very useful for other uses, such as extracting attributes from the methods, and applying policy according to them. In addition, we can add our own headers. In the sample, I've added the `ClaimsIdentity` of the client to the headers. I'm using a neat .NET 4.6 class called `AsyncLocal<T>` to allow the context to flow between awaits (note that 4.6 is not installed on Service Fabric clusters by default, and requires additional setup).

The other part of the solution is the client side, in the `WcfServiceRemotingClient` class. That is where we add the headers before sending requests to the server.

## How to use it

In the sample code above, simply replace `new ServiceRemotingListener` with `ServiceRemotingListenerEx.Create` and `ServiceProxy` with `ServiceProxyEx`. This will enable the custom listener and client.