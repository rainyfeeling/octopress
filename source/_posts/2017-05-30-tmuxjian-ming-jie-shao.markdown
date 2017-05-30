---
layout: post
title: "Tmux简明介绍"
date: 2017-05-30 14:42:20 +0800
comments: true
categories: tmux
---

## tmux介绍
tmux是一个多窗口终端工具，可以同时在多个终端(窗口)来回切换。而且还可以管理各个窗口，在窗口里面分屏等等。

tmux里面的基本概念有: session, window和panel

比如执行tmux命令，就产生产一个新的session。如果这时再执行创建窗口操作`CTRL+B, C`, 就会创建一个新window，这个window是属于当前session的。
再执行分屏操作`CTRL+B, %`就新建了一个panel。

所以基本就是一个session可以包含很多window(窗口),  一个window(窗口)又可以包含多个panel。

<!--more-->

### 快捷键说明
* `CTRL+B`表示按住`CTRL`键不动，然后按`B`
* `CTRL+B, C`表示按住`CTRL`键不动，然后按`B`, 然后松开`CTRL`和`B`键。再按下`C`键
* `CTRL+B, O(ther)`表示`CTRL+B, O`。加单词在这里是怕用户把字母`O`看成是数字`0`

### 环境
Ubuntu 14.04

tmux用的是默认配置, 没有做任何修改。也就说tmux的快捷键是`CTRL+B`

## 基本用法
在Ubuntu下面可以用快捷键`CTRL+ALT+T`打开一个terminal

如果没有安装tmux的话可以运行`sudo apt-get install tmux`来进行安装。

运行`tmux`命令, 可以看到最底下已经有一条绿色的状态栏，表示终端现在正在一个tmux的session里面。

### 创建窗口和panel
* 按`CTRL+B, %`在当前窗口水平分屏，创建一个新的panel
* 按`CTRL+B, "`在当前窗口垂直分屏，创建一个新的panel
* 按`CTRL+B, C(reate)`创建新的窗口

现在你的终端应该长的下图一样:
![tmux_example.png](/images/tmux_example.png)

* 图片说明:
   * `[0]` 表示session的名称是`0`
   * `0:~` 表示窗口编号是`0`, 名称是`~`，其实就是当前目录
   * `1:~*`表示窗口编号是`1`, 名称是`~`。也就是当前目录名。`*`表示这个窗口是当前窗口

### 窗口切换
* `CTRL+B, 数字`，数字是窗口的编号，从0开始往后累加。
* `CTRL+B, L(ast)`，表示切换到上一个(last)窗口。

### panel的切换
* `CTRL+B, O(ther)`, 这里只能是一个panel，一个panel的切换
* `CTRL+B, 箭头`，这时可以上下左右的切换。

### 退出窗口或者panel
在tmux的窗口或者命令行，输入`exit`命令就可以退出当前窗口或者panel。

### 历史记录浏览
如果在窗口或者panel里，想往上翻页查询历史记录，那应该怎么办呢？

* 这时我们需要进入复制模式
   * 按`CTRL+B, [`进入复制模式。可以看到右上角显示一个黄色高亮块，表示当前正在复制模式。
   * 按`PAGE-UP` `PAGE-DOWN`和上下左右箭头进行浏览
   * 按两次`ESC`键退出复制模式, 恢复正常模式。(默认使用Emacs的按键方案)
      * 如果使用vi按键方案，在复制模式下，只要按回车键就可以退出复制模式。(下面讲解怎么配置成vi按键方案)
<p />


* 如果你习惯用vi的话，我们可以把复制模式里面的按键配置成vi样式
   * 打开`~/.tmux.conf`文件，如果没有的话就直接创建。
   * 加入代码
   ```
   set-window-option -g mode-keys vi
   ```
   * 配置完成之后，需要退出tmux
   * 这样配置以后, 退出复制模式的快捷键变成了回车键。
   * 而且你可以在复制模式用`h`, `i`, `j`, `k`进行翻页，还可以用`G`, `gg`等等进行浏览。

至此，你已经学会基本的tmux功能，这样可以帮助你在命令行下面更加高效。