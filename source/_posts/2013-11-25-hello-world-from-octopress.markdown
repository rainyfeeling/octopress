---
layout: post
title: "Hello World from Octopress"
date: 2013-11-25 21:19:57 +0800
comments: true
categorie: 
---
花了一个晚上的时间，终于把这个博客给搭建起来了。效果还是挺满意的。这个计划N久了的事情终于开始了，看来有Macbook就要开始折腾了。

整个过程没有想像的难，像有句话说的:"只要开始动手，就已经成功一半"。
我是对照着Octopress的Getting start慢慢的看，然后一步一步的试，外加一点耐心。基本就搞定了。
整个过程中最慢的部分竟然是安装Octopress，此过程会安装很多ruby gem，经常会连接网站超时。
不过其他都还好。

Octopress是一个建立网站的框架。它可以完成配置，生成，预览网站。
部署的话需要一个外部的网站，比较简单就是像我一样，直接用github.io来部署。

总结一下，整个流程就是：

	1. 安装好Octopress (git, ruby, rake)
	2. 建立一个github.io的repository来存放网站
	3. 配置octopress，生成page, post.
	4. 用rake来生成，预览网页。
	5. 发布到github.io - 也就是push到github网站
	6. 把octopress的配置也commit到本地git


接下来的事情是要：

	* 安装代码显示的插件
	* 做几张好看的图片
	* 熟悉Markdown的语法格式
	* 多写写博客
