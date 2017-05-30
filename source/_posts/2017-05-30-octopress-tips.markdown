---
layout: post
title: "Octopress Tips"
date: 2017-05-30 10:34:53 +0800
comments: true
categories: octopress
---

## 提高网站访问速度
### 替换jquery的原始地址
因为原始地址是google的，所以中国这边完全访问不了，所以直接替换成比较快的镜像

打开octopress的根目录，编辑`source/_includes/head.html`，找到下面的代码行，将jquery的地址替换成code.jquery.com的地址:
```diff
-  <script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
+  <script src="//code.jquery.com/jquery-1.9.1.min.js"></script>
```

### 关闭tweet插件
编辑配置文件`_config.yml`，将twitter_tweet_button的配置改成`false`
