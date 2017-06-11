---
layout: post
title: "Octopress Tips"
date: 2017-05-30 10:34:53 +0800
comments: true
categories: octopress
---

## 写博客的基本流程

首先运行octopress里面的`rake preview`和`rake watch`。查看log运行正常，下面的log就表示运行正常:
```sh
➜  octopress rake watch
Starting to watch source with Jekyll and Compass.

>>> Compass is watching for changes. Press Ctrl-C to Stop.

Configuration file: /home/josh/work/blogger/octopress/_config.yml
            Source: source
       Destination: public
      Generating... 
                    done.
 Auto-regeneration: enabled for 'source'
    write public/stylesheets/screen.css
      Regenerating: 1 file(s) changed at 2017-06-11 10:20:43 ...done in 0.44646012 seconds.
```

然后用浏览器打开`localhost:4000`，按`F5`刷新查看效果

现在可以用文本编辑器打开source目录下面的markdown文章开始编辑

编辑文章存盘的时候，一定要确认`rake watch`那边的log里出现
```
Regenerating: 1 file(s) changed at 2017-06-11 10:20:43 ...done in 0.44646012 seconds.
```
如果没有出现上面的log则表示octopress发现你的文章里面有错误，所以没有生成出新的博客。比如下面的例子表示出错:

```
   Error: Pygments can't parse unknown language: </p>.
   Error: Run jekyll build --trace for more information.

```
这个时候你需要重新编辑你的文章，修复错误。


## 用jquery的镜像地址来提高网站访问速度
因为原始地址是google的，所以中国这边完全访问不了，所以直接替换成比较快的镜像

打开octopress的根目录，编辑`source/_includes/head.html`，找到下面的代码行，将jquery的地址替换成code.jquery.com的地址:
```diff
-  <script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
+  <script src="//code.jquery.com/jquery-1.9.1.min.js"></script>
```

## 关闭tweet插件
编辑配置文件`_config.yml`，将twitter_tweet_button的配置改成`false`

## 关于markdown格式的文档: 
* https://help.github.com/articles/basic-writing-and-formatting-syntax/
* https://guides.github.com/features/mastering-markdown/
