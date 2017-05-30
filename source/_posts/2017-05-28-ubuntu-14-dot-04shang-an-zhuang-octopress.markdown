---
layout: post
title: "Ubuntu 14.04上安装Octopress"
date: 2017-05-28 22:47:29 +0800
comments: true
categories: octopress
---

## 1. 介绍
octopress是基于Jekyll的静态博客系统。他有几个好处:

* 兼容github page, 不用再申请博客空间了。直接用github的repository就可以。博客的结尾是`用户名.github.io`

* 用户只需要编写markdown格式的文章，然后通过octopress生成网站内容
* 一条命令直接推送到github，简单方便。
* 通过git进行版本管理，不用担心内容丢失。

<!--more-->

### 基本知识

* `git` - 文件版本管理工具
   * `git remote`: 远程服务器的别名
   * 跟服务器的交互只有fetch, pull和push命令
   * 平时都是在本地分支上面, checkout命令才会改变本地工作目录的文件内容

`ruby`: 编程语言，octopress是用ruby开发的

`gem`: 是ruby的一个库或者是应用。可以用gem命令来安装管理。安装完之后在命令行就直接可以运行了

```sh
# 通过gem命令安装一个应用:bundle
$ gem install bundle  # 有时候需要sudo

# 安装完成后就可以直接执行bundle
$ bundle --version
Bundler version 1.15.0
```

`bundle`: 基于gem的更加强大的包管理工具，可以安装批量的gem, 解决gem之间的依赖关系，而且还可以指定要安装的gem版本

`Gemfile`: Gemfile里面包括批量的gem, 而且可以指定依赖关系和版本要求。
	`bundle install`读取当前目录的Gemfile来安装里面指定的gems

`rake`: 一个ruby应用，通过gem可以安装，是ruby in rail里的组件。可以理解成linux里面的make

`rakefile`: 很像makefile，指定rake执行的任务


### 参考
官方文档: http://octopress.org/docs/setup/
虽然文档已经有些老了，但是过程还是简单明了的。

## 2. 安装Octopress
### 环境
Ubuntu 14.04
```sh
➜  octopress lsb_release -a
No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 14.04.5 LTS
Release:        14.04
Codename:       trusty
```
ruby版本1.9.3
```
➜  octopress ruby --version
ruby 1.9.3p484 (2013-11-22 revision 43786) [x86_64-linux]
```
### 步骤
首先下载Octopress的源码
```
➜  git clone git://github.com/imathis/octopress.git
➜  cd octopress

# 列出目录下所有文件
➜  ls
CHANGELOG.markdown  config.rb  config.ru  _config.yml  Gemfile  plugins  Rakefile  README.markdown
```
目录下面有Gemfile，里面列出了Octopress需要安装的gem。需要用bundle安装
```
# 安装bundle, 如果已经安装了就可以略过这一步
➜  gem install bundle

# 根据Gemfile来安装相应的依赖。
➜  bundle install

# NOTE: 我遇到了有一个插件要求ruby 2.0.0，但是我的版本是1.9.3。但是重新运行了几次就成功了？！
```

## 3. 配置Octopress
运行rake命令安装默认的theme
```
# 生成sass目录和source目录
➜  rake install
```
设置github pages
```
➜  rake setup_github_pages
# 需要输入你的github.io的URL, 比如我的就是https://github.com/rainyfeeling/rainyfeeling.github.io

# 成功之后会在目录下面生成一个_deploy目录，这个文件夹就静态网站的所有内容。现在里面就一个简单字符串
```
编辑`_config.yml`来更改博客的基本信息，像标题等等

## 4. 写博客文章
新建标题文章, 注意在zsh里面，所以`[`, `]`字符前面要加转义符`\`
```sh
rake new_post\["Ubuntu 14.04上安装octopress"\]

# 在 _source/_posts目录下生成了一个 .markdown 文件
```
用markdown编辑器修改文章，直到文章差不多完成，这时可以开始生成网站内容
```
# Generates posts and pages into the public directory
rake generate

# 运行一个本地server，便于调试
rake preview    # Watches, and mounts a webserver at 
```

打开浏览器，在地址栏里面输入http://localhost:4000 就可以看到网站的内容了

检查文章，标题还有各种配置是否正确，如果不正确的话可以继续修改markdown文件，然后用`rake generate`重新生成网站。同时刷新一下`http://localhost:4000`就可以看到效果了。

## 5. 部署到github pages
只需要运行`rake deploy`，然后输入github repo的用户名和密码，就直接将生成的网站内容推送到github网站了。
