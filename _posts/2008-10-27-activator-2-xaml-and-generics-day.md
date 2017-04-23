---
id: 179
title: 'Activator 2: XAML and Generics Day'
date: 2008-10-27T09:38:00+00:00
author: Eli Arbel
layout: post
redirect_from:
  - /blog/archive/2008/10/27/activator-2-xaml-and-generics-day.aspx.html
guid: /blog/archive/2008/10/27/activator-2-xaml-and-generics-day.aspx
permalink: /2008/10/27/activator-2-xaml-and-generics-day/
categories:
  - Uncategorized
tags:
  - Generics
  - WPF
  - XAML
---
First of all, you didn't miss part one. Just thought it was a funny [reference](http://en.wikipedia.org/wiki/Terminator_2).

<!--more-->

I'm currently working on a new release of [WPF Contrib](http://codeplex.com/wpfcontrib). In my TaskDialog class, I used a few classes I derived from ItemsControl (which I'm considering deleting in this version, but that's another debate). The reason I created them was so that you could add any item to the ItemsControl and it would be wrapped in some specific ContentControl, such as a Button. But if you added a Button, it would know that it doesn't need wrapping (this is what the IsItemItsOwnContainerOverride() and GetContainerForItemOverride() methods do).

I had three classes which were exactly the same, aside from the type of the ContentControl. Generics would very much fit here, but unfortunately, XAML has a [very limited](http://msdn.microsoft.com/en-us/library/ms750476.aspx) support for it (it seems the new .NET 4.0 XAML stack [will improve](http://channel9.msdn.com/pdc2008/TL36/) this, and much more). As an exercise I decided to try and extend XAML so it will support generics &#8211; on a basic level.

XAML can be extended using **MarkupExtension**s. These are classes that have a single method, ProvideValue(), that when XAML (or BAML) is loaded, create objects according to some custom logic. You're surely familiar with the TypeExtension (x:Type), which returns a System.Type from the specified qualified string. What I've done is create two new extensions:

* An alternative **TypeExtension** that supports type arguments. The following is equivalent to `typeof(List<List<KeyValuePair<string, int>>>)`:

```xaml
{t:Type gen:List, {t:Type gen:List, {t:Type gen:KeyValuePair, sys:String, sys:Int32}}}
```
  Note that you don't have to (but can) specify ``gen:List`1``. The number of type arguments will be inferred. The constructors support up to 4 type arguments. In the unlikely case that you need more than that, you can use the unabbreviated form and specify the arguments as sub-elements.

  * An **ActivatorExtension** that accepts a type (either generic or not) and a list of property-value pairs. For example, this will create an instance of ItemsControl<CheckBox> (a generic variation of ItemsControl I have in the demo), and assign some of its properties, including a binding:

```xaml
<t:ActivatorExtension x:Name="ic" Type="{t:Type t:ItemsControl, {t:Type CheckBox}}">
    <t:Setter Name="Name" Value="ic" />
    <t:Setter Name="Background" Value="{Binding ElementName=tb, Path=Text}" />
    <t:Setter Name="ItemsSource">
        <x:ArrayExtension Type="{x:Type sys:String}">
            <sys:String>one</sys:String>
            <sys:String>two</sys:String>
            <sys:String>three</sys:String>
            <sys:String>four</sys:String>
        </x:ArrayExtension>
    </t:Setter>
</t:ActivatorExtension>
```

There are, however, a few severe limitations:

  * The **Name** property has no effect, either on the extension or as a property. Not only does the XAML compiler not generate a member for it in the partial class, but the FrameworkElement.FindName() method also doesn't work. In templates, however, FindName() will return the _extension itself_, not the constructed object (if you add the x:Name attribute to it). This can be a big problem if you want to use an activated object as a template part.
  * Special treatment has been given for bindings to work in property values. Other expressions, such as DynamicResource or TemplateBinding, will not.
  * XamlWriter.Save() fails to save an object that contains an activator with a generic type (which makes sense since XAML does not support generics, and after it's loaded, the MarkupExtension is gone.)
  * The ActivatorExtension cannot be used as the root of a template (fails at compile time). This can be easily circumvented though, by surrounding it with a Decorator.

As I said in the beginning, this was just an experiment I wanted to share, and in no way should be viewed as a production-quality solution. I will, however, be adding the TypeExtension to the upcoming drop of WPF Contrib. It can be used to specify DataTemplate resource keys for generic types.

Attachment: [ActivatorDemo.zip](https://arbel.net/attachments/ActivatorDemo.zip)