---
id: 172
title: 'C# Partial Specialization With Extension Methods'
date: 2007-11-22T06:46:00+00:00
author: Eli Arbel
layout: post
redirect_from:
  - /blog/archive/2007/11/21/c-partial-specialization-with-extension-methods.aspx.html
guid: /blog/archive/2007/11/21/c-partial-specialization-with-extension-methods.aspx
permalink: /2007/11/22/c-partial-specialization-with-extension-methods/
dsq_thread_id:
  - "5736700149"
categories:
  - Uncategorized
tags:
  - 'C#'
  - Programming Languages
---
One of the things C# generics lacks ([compared](http://msdn2.microsoft.com/en-us/library/c6cyy67b.aspx) to C++ templates) is [specialization](http://msdn2.microsoft.com/en-us/library/c401y1kb.aspx) (neither explicit nor partial). This can be very useful in some cases where you want to perform something differently for a specific `T` in a `Class<T>`.

With C# 3.0, there is a relatively easy way to achieve this, albeit not optimal, for reasons I'll specify later on. Take a look at the following piece of code:

```csharp
public class SomeClass
{
    private readonly List items = new List();

    internal void AddInternal(T item)
    {
        items.Add(item);
    }
}

[EditorBrowsable(EditorBrowsableState.Never)]
public static class SomeClassExtensions
{
    public static void Add(this SomeClass c, T item)
    {
        c.AddInternal(item);
    }

    public static void Add(this SomeClass<int> c, int item)
    {
        if (item <= 0)
        {
            throw new ArgumentOutOfRangeException("item", "Value must be a positive integer.");
        }

        c.AddInternal(item);
    }
}  
```

Instead of placing the **Add** method in `SomeClass<T>`, we put it in a static class that has [extension methods](http://msdn2.microsoft.com/en-us/library/ms364047.aspx#cs3spec_topic3). This allows the compiler to select the appropriate method according to the type parameter. (Side note: I've specified the EditorBrowsable attribute so that the class with the extensions would not appear in VS intellisense.)

The biggest caveat about this is that extension methods do no have access to private members, so the only option is to make the members **internal**, which, in many cases, leads to a bad design. If only extension method classes could be written as inner classes...

Also, extension methods, being static, could not be virtualized. You can, however, make the internal method `protected internal virtual`.