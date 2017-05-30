---
layout: post
title: "Tmux高级部分"
date: 2017-05-30 17:53:07 +0800
comments: true
categories: tmux
---

## 0. 准备
为了更好的理解session和window，我们再次回顾一下前面一篇文章里面的基本用法

* 首先，确认你没有打开任何tmux窗口。如果打开了，请在打开的tmux打开的所有窗口里面执行`exit`命令，保证我们退出了所有tmux窗口。
* 接下来按快捷键`CTRL+ALT+t`打开一个terminal，然后执行`tmux`创建一个session
* 按`CTRL+b, %`在当前窗口水平分屏，创建一个新的pane
* 按`CTRL+b, "`在当前窗口垂直分屏，创建一个新的pane
* 按`CTRL+b, c(reate)`创建新的窗口

## 1. session
这时我们运行下面的命令来列出当前的session信息

```sh
# 列出所有的session
$ tmux ls
0: 2 windows (created Tue May 30 17:23:49 2017) [80x23] (attached)
```

* 我们分析一下输出信息:
   * 一行就是现在有一个session
   * 在`:`前面的字串是这个session的名字。也就是`0`
   * 这个session有2个窗口
   * 后面有这个session创建的时间，和窗口的大小
   * `(attached)` : 表示这个session现在运行在前台。是可以看得到的。

<!--more-->

接下来，我们运行一条脚本，每一秒钟打印一个信息，而且不会停止。(只有按`CTRL+c`才能停止这条脚本)
```
$ while true; do echo `date`; sleep 1; done
2017年 05月 30日 星期二 18:03:09 CST
2017年 05月 30日 星期二 18:03:10 CST
2017年 05月 30日 星期二 18:03:11 CST
2017年 05月 30日 星期二 18:03:12 CST
2017年 05月 30日 星期二 18:03:13 CST
2017年 05月 30日 星期二 18:03:14 CST
2017年 05月 30日 星期二 18:03:15 CST
2017年 05月 30日 星期二 18:03:16 CST
2017年 05月 30日 星期二 18:03:17 CST
... ...
```

现在按下快捷键`CTRL+b, d`来做detach的动作。也就是让tmux的session运行在后台状态。

按完发现命令行的log如下:
```sh
$ tmux
[detached]

```
而且tmux的状态栏也不见了。再运行session查看命令:
```sh
$ tmux ls
0: 2 windows (created Tue May 30 17:23:49 2017) [80x23]
```
后面的`(attached)`不见了。这个就是说明当前有一个session, 名字是`0`，包含2个窗口。而且现在运行在后台。

接下来，我们运行attach命令，将这个session带到前台, 这里我们用到了`-t`参数，表target的意思。

```
# tmux attach到名字为0的session
tmux attach -t 0
```

运行完命令发现tmux又回来了，而且可以发现这条打印时间的命令一直在后台运行，detach不会影响它的执行。
```
$ while true; do echo `date`; sleep 1; done
2017年 05月 30日 星期二 18:03:09 CST
2017年 05月 30日 星期二 18:08:10 CST
2017年 05月 30日 星期二 18:08:11 CST
2017年 05月 30日 星期二 18:08:12 CST
2017年 05月 30日 星期二 18:08:13 CST
2017年 05月 30日 星期二 18:08:14 CST
2017年 05月 30日 星期二 18:08:15 CST
2017年 05月 30日 星期二 18:08:16 CST
2017年 05月 30日 星期二 18:08:17 CST
2017年 05月 30日 星期二 18:08:18 CST
2017年 05月 30日 星期二 18:08:19 CST
2017年 05月 30日 星期二 18:08:20 CST
2017年 05月 30日 星期二 18:08:21 CST
2017年 05月 30日 星期二 18:08:22 CST
2017年 05月 30日 星期二 18:08:23 CST
2017年 05月 30日 星期二 18:08:24 CST
2017年 05月 30日 星期二 18:08:25 CST
2017年 05月 30日 星期二 18:08:26 CST
2017年 05月 30日 星期二 18:08:27 CST
2017年 05月 30日 星期二 18:08:28 CST
2017年 05月 30日 星期二 18:08:29 CST
2017年 05月 30日 星期二 18:08:30 CST
```

好，现在可以按`CTRL+c`来停止打印时间的脚本。

## 2. window (窗口)

运行下面的tmux命令列出所有的窗口信息
```sh
$ tmux list-windows 
0: ~- (3 panes) [80x23] [layout 837a,80x23,0,0{40x23,0,0,0,39x23,41,0[39x11,41,0,1,39x11,41,12,2]}] @0
1: tmux* (1 panes) [80x23] [layout ae60,80x23,0,0,3] @1 (active)
```

我们分析一下输出信息:

* 一行就是现在有一个窗口, 窗口里面可以有多个pane。当前session有两个窗口，其中一个窗口有3个pane。另外一个窗口只有1个pane
* 在`:`前面的数字是这个窗口的id。可以通过按`CTRL+b, 数字`开切换当前窗口
* `(active)` : 表示当前窗口是1

## 3. 一些结论
* tmux session可以包含一系列窗口，窗口可以包含多个pane
   * `tmux ls`: 可以列出当前所有的session的信息，包括前台的(attached)和后台的(detached)
* 首先创建session，然后才能创建窗口
* 运行`tmux`命令就是创建一个session，同时这个session只有一个窗口
* 在tmux的当前session里，可以按`CTRL+b, d`来做detach，使其运行在后台
* session在后台也还是运行状态
* tmux 可以用attach命令将某个session运行在前台
   * `tmux attach -t <session name>`
* 只能有一个前台session
* 因为session里面是运行着的任务，所以在系统重启之后，这些运行着的任务会全部清除

## 4. tmux脚本化
通过tmux的命令可以做一些订制和自动化。比如:

* 可以让tmux创建一个session，里面可以创建几个运行的任务。
* 可以让tmux自动创建几个窗口，每个窗口都在不同的路径下

### a) 关于session的命令行参数
* `new-session`: 创建新的session
	* `-s 名字`: 指定创建session的名字
	* `-d`: 表示创建一个在后台的session。只能用`tmux ls`才能看得到。
	* `"shell命令"`: 可以在后面跟一系列的shell命令,要用单引号或者双引号括起来。
	* 实例:

```sh
# 创建一个新的session，名字叫做octopress。
# 同时在这个session里面执行命令: cd ~/work/blogger/octopress; rake preview
tmux new-session -s octopress 'cd ~/work/blogger/octopress; rake preview'
```

* `attach`: 把后台的session运行到前台
	* `-t 名字`: 指定target session的名字
	* 实例:

```sh
# 这条命令跟上面基本一样，只是多了-d参数，表示创建的session是在后台，只能用tmux ls才能看到
tmux new-session -s octopress -d 'cd ~/work/blogger/octopress; rake preview'

# 将上面的创建的后台session变成前台
tmux attach -t octopress
```

### b) 关于窗口的命令行参数 (窗口的命令必须在tmux的session当中才能开始运行)
* `new-window`: 创建新的窗口
	* `-c 目录名`: 表示到某个目录下。举例: `tmux new-window -c ~/work`表示打开一个新窗口，并且新窗口的目录为`~/work`。然后切换当前窗口到新建窗口。
	* `-d`: 表示执行命令后，不要改变当前窗口。举例: `tmux new-window -c ~/work -d` 基本跟上面的命令一样，唯一的区别是，不要切换当前窗口到新窗口。
	* `"shell命令"`: 在窗口里执行的命令, 要用单引号或者双引号括起来。
		* 注意: 如果命令是当场返回的话，则窗口在命令返回时就会退出。所以看起来没有效果。
	* 实例:

```sh
# 创建一个tmux session
tmux

# 在当前session里面创建一个新窗口，路径是~/work/blogger/octopress，同时执行yes命令
tmux new-window -c ~/work/blogger/octopress 'yes'

# 在当前session里面创建一个新窗口, 运行yes命令，同时不要切换到那个窗口
tmux new-window -d -c ~/work/blogger/octopress 'yes'
```

* `split-window`: 在当前窗口里创建一个pane

* tmux的窗口和session命令可以连着用，但是中间要用`\;`隔开。实例:

```sh
# 创建一个名字叫做octopress的新session。在默认窗口里执行rake preview命令。同时在创建一个pane。里面执行rake watch命令。最后在新建一个新窗口
tmux new-session -s octopress 'cd ~/work/blogger/octopress; rake preview' \; split-window 'cd ~/work/blogger/octopress;rake watch' \; new-window

# 创建两个新窗口打开不同的路径
tmux new-window -c ~/work \; new-window -c ~/work/blogger

```

## 5. 脚本实例
### 我自己的octopress博客的自动化tmux脚本
```sh
#!/bin/bash

OCTOPRESS_PATH="/home/josh/work/blogger/octopress"

# create a tmux session, which running the octopress with preview and watch
tmux new-session -s octopress -d "cd ${OCTOPRESS_PATH}; rake preview" \;\
     split-window             -d "cd ${OCTOPRESS_PATH}; rake watch" \;	\
     new-window -c ${OCTOPRESS_PATH}/_deploy \;				\
     new-window -c ${OCTOPRESS_PATH}

# open local server
opera http://localhost:4000 &

# open sublime edit the posts
subl $OCTOPRESS_PATH/source/_posts/2017*.markdown

tmux attach -t octopress
```

### 有人写了一个tmux session的保存和读取的脚本。大家可以参考一下
* [此脚本](https://github.com/mislav/dotfiles/blob/d2af5900fce38238d1202aa43e7332b20add6205/bin/tmux-session)可以在系统重启之后，restore整个session。但是仔细看代码可以发现，restore的session只是把每个窗口所在的目录记录下来而已。