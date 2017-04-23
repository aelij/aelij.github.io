---
id: 182
title: Normality Restored
date: 2009-01-27T10:05:00+00:00
author: Eli Arbel
layout: post
redirect_from:
  - /blog/archive/2009/01/27/normality-restored.aspx.html
guid: /blog/archive/2009/01/27/normality-restored.aspx
permalink: /2009/01/27/normality-restored/
dsq_thread_id:
  - "5736700169"
categories:
  - Uncategorized
tags:
  - Blog
  - Google
---
The past 24 hours have been a blogger&rsquo;s nightmare for me. I wanted to upgrade my GoDaddy&rsquo;s hosting account to IIS 7. Unfortunately, they do not have any upgrade option, so you have to call their customer service, cancel your current hosting account, create a new one and build everything from scratch.

<!--more-->

What this means, of course, is that you have to backup your current website yourself. I created a backup of the SQL database, and used FileZilla to transfer all the files to my computer. Now, here&rsquo;s where my stupidity comes in: When FileZilla finished the transfer I assumed all was OK. I quickly browsed the root directory and saw that all the sub directories were there, but I forgot to verify the most important thing: the database backup. It seems the wretched FTP software reports errors into a tab at the bottom, that doesn&rsquo;t even get focus if there were any. Talk about trustful computing.

I realized my grave mistake only after the old account was gone, when I went to upload the website to its new location. I immediately called GoDaddy. It was a matter of minutes since the account was cancelled, yet they informed me that the restore fee would be **$150**! That&rsquo;s how much it costs me to host the entire site for&nbsp; **two years**! I told them I&rsquo;d get back to them.

What could I do? Well, it was Google who came to the rescue. Google indexes my blog. Google has cache! So I wrote a small program which fetched the cached pages (per post, since I wanted to restore the comments as well) and parsed them into a simple data structure, which I serialized into an XML file. That was the easy part. The hard part was using the cumbersome Community Server API to repost everything.

As a side note, GoDaddy does have one useful tool, which I only found later (and which might have saved me all this trouble): You can compress/uncompress files using their file manager. Had I compressed the entire site with the DB backups into a single file, I never would&rsquo;ve missed anything. And the transfer is much faster that way.

It&rsquo;s finally over and [normality](http://en.wikipedia.org/wiki/Infinite_Improbability_Drive) has been restored. The old posts&rsquo; unique IDs may have changed because of this debacle, so I&rsquo;m deeply sorry if some of them have been duplicated in your RSS reader. I have attached the code I used, should anyone ever need it (it&rsquo;s a bit messier than my usual standards). I also added the two config files you need in order to setup Community Server 2008.5 as a single user blog (spent a few hours digging that one up).

Morals of the story:

  * Never trust an FTP software for backup. Verify it again and again.
  * [TANSTAAFL](http://en.wikipedia.org/wiki/TANSTAAFL). GoDaddy is cheap, but I just discovered a major disadvantage.
  * You should backup your website regularly on your own. Don&rsquo;t rely only on your hosting provider.
  * Being the good Atheist that I am, I have accepted Google as my personal savior.
  * URLs are important. I worked extra hard so that all of the old URLs would remain the same.

Attachment: [RestoreBlog.zip](https://arbel.net/attachments/RestoreBlog.zip)