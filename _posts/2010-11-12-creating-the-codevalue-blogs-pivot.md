---
id: 193
title: Creating the CodeValue Blogs Pivot
date: 2010-11-12T12:23:00+00:00
author: Eli Arbel
layout: post
redirect_from:
  - /blog/archive/2010/11/12/creating-the-codevalue-blogs-pivot.aspx.html
guid: /blog/archive/2010/11/12/creating-the-codevalue-blogs-pivot.aspx
permalink: /2010/11/12/creating-the-codevalue-blogs-pivot/
categories:
  - Uncategorized
tags:
  - CodeValue
  - Deep Zoom
  - Pivot
---
[Pivot](http://www.microsoft.com/silverlight/pivotviewer/) is a Microsoft Silverlight control which can visualize collections of data, filter and sort them in a very appealing manner. To see what I mean, check out the [CodeValue](http://codevalue.net/) Blogs Pivot:

> [http://codevalue.net/blogspivot/](http://codevalue.net/blogspivot/ "http://codevalue.net/blogspivot/")

This allows you to browse through our blogs, and to filter them by tags, dates and authors.

&#160;

Pivot uses a proprietary XML format, called [CXML](http://www.silverlight.net/learn/pivotviewer/collection-xml-schema/). An item in the collection is comprised of an image, a URI and any other metadata you choose to add. I've created a small utility which takes an RSS feed, transforms it into CXML, creates snapshots of all site images and adds metadata (author, date and tags).

In addition, because Pivot presents many large images, you can optionally (highly recommended!) configure the collection to use [Deep Zoom](http://www.microsoft.com/silverlight/deep-zoom/) (which breaks down your images to pyramids, much like how Google Maps works). To do that, you can use [Pauthor](http://pauthor.codeplex.com/), a free utility that can be found on CodePlex. The attached code contains a batch file with a sample that shows how to use it.

Lastly, since Deep Zoom uses many files (for example, 140 Pivot items might generate ~7500 Deep Zoom files - depending on image sizes), uploading them individually can be a real pain. Fortunately, many website hosts support uploading archives (such as ZIP files) and unarchiving them on the server.

&#160;

**Some interesting facts about the code:**

  * I used **Parallel.ForEach()** to parallelize the creation of items. Note that I'm assuming LINQ to XML is okay for cross-threaded _reading_ (which is not documented, and I wouldn't use in production code), but for writing (a single point in the end) I added a lock.
  * The **UriImageCreator** class relies on the Windows Forms WebBrowser control, but uses WPF's Dispatcher to handle the message loop. This is because Dispatcher makes it easier to marshal calls into the message loop. I've borrowed some of this code from Pauthor (which uses it for its HTML template feature), and made it thread-safe. Note it is using a single thread to load the WebBrowser controls (so we only have one message loop), but websites will be loaded asynchronously because of how the WebBrowser control works.
  * I used **NDesk.Options** to parse command-line arguments. It provides a very neat interface with object initializers and lambda expressions.

Attachment: [Rss2Cxml.zip](https://arbel.net/attachments/Rss2Cxml.zip)