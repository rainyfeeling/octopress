---
layout: post
title: "shell Cheat Sheet"
date: 2017-12-17 12:38:35 +0800
comments: true
categories: shell
---

![shell_cheatsheet.png-218.6kB][1]

## 语句分隔符  `;`
* 如果一行只有一条命令，不需要分隔符
* 如果一行有多条命令，则每条命令后面需要加`;`

```

until TEST-COMMANDS; do CONSEQUENT-COMMANDS; done

```

* 如果多行的话，不需要分隔符，直接用`\n`

```

# 上面的单行命令变成了多行
until TEST-COMMANDS
do CONSEQUENT-COMMANDS
done

# if [] 是一条命令，then是第二条命令
if [ x"$STR" = "x" ]; then
	echo "STR is empty!"
fi

```

## 变量名

```

MY_VAL=josh
echo $MY_VAL            # 显示单独的变量,变量前加$
echo "var is: $MY_VAL"  # 显示变量和文本，要用双引号""
echo "${MY_VAL}_file"   # 显示变量和文本连接在一起，要加大括号{}

echo ${!MY_VAL}         # 如果MY_VAL的值是josh,则显示$josh的内容

VAL="$#"; echo ${!VAL}  # 显示最后一个变量的值

```

<!--more-->

## eval表示纯粹的字符串替换，然后执行

```

VAL="echo \$$#"
eval $VAL
# 先将$VAL表示出来, 假设$#等于4，$VAL即为"echo \$4"
# 然后执行，即显示最后一个变量的值

VAL="echo \$$#"
LAST=`eval $VAL` 		# LAST等于执行后的结果,即最后一个变量的值

```

## shell内部变量
* 参数
	* `$1`, `$2`... `$9`, 表示参数，只能显示1~9个
	*  `shift`命令可以让参数移一位。原来的第9个现在就是第10个参数了

```

shift
echo $9  # 第10个参数

```

* `$#` 表示参数的个数，如果为0，表示没有参数
* `$?` 表示上一条命令的返回值， 0表示成功，否则表示失败
* `$*` 表示一个字串，这个字串包含所有参数
* `$@` 跟上面一样，但是每一个参数是一个quoted string

## shell命令执行是否成功的判断
* 如果命令执行成功，则返回值`$?`为0。否则返回非零错误码`$?`。
* `cmd1 && cmd2`: 如果cmd1执行**成功**，则执行cmd2
* `cmd1 || cmd2`: 如果cmd1执行**出错**，则执行cmd2
* 跟c语言刚好相反

## shell条件判断运算符
### 逻辑真假值
* 在shell里面，如果**值为真，则值等于0**。如果值为假，则值等于大于0的数。
    * 与c语言里面**相反**, **相反**, **相反**

### test命令
* `-a`或者`&&`: 条件与
* `-o`或者`||`: 条件或
* `!`: 条件非

### if命令
* `if test ! 条件`
* `if [ 条件 ]`

### 字符串比较
* `=`: 是比较是否相等，两边一定要有 **空格**，否则就变成赋值了。
    * 记住不要用`==`，这个某些时候会出错，比如用dash的话
    * `=`也可能当作为数字的比较
* `z`: 字串长度是否为0
* `n`: 字串长度是否不为0

### 数字比较
`-eq, -ne, -lt, -gt`

### 文件判断
`-e, -f, -d` and etc.

### 举例

```

if [ $x -eq 2 ];   then xxx; fi # 数字比较
if [ $x -ne "2" ]; then xxx; fi # 数字比较
if [ $x != "2" ];  then xxx; fi # 字串比较
if [ $x = "2" ];   then xxx; fi # 字串比较
if [ -f $x ];      then xxx; fi # 文件存在就
if [ ! -f $x ];    then xxx; fi # 没有文件就
if [ $? = 0 ];     then xxx; fi # 上条命令执行成功就 


if [ ! -f $x ] && [ $1 != "abc" ]; then xxx; fi # 文件不存在,并且$1不等于abc

```

## shell变量作用域
* 当执行一个脚本时，会新生成一个shell进程去执行，而新生成的进程并不会知道调用者线程里定义的变量。
* 假如想让运行的脚本也知道当前的变量的话，就需要用`. xxx.sh`或者`source xxx.sh`。这样就不会打开新的shell进程。而是在当前进程里面执行新的脚本。

```

# 加了.号，表示不要新开shell进程。这样就能继承现有的变量
. ./my_shll.sh

source my_shell.sh

```

* 如果一个脚本调用了`cd xxx`,当这个脚本退出的时候，当前目录却还是原来的目录。因为只是在哪个脚本里的当前目录变了，如果退出了，则那个脚本的线程已经退出了。

## 文件描述符 (相当于打开了一个文件句柄)
* 0, 1, 2
    * 0 -> stdin
    * 1 -> stdout
    * 2 -> stderr
* 参考: http://www.jb51.net/article/33484.htm

## exec命令
* `exec`命令不会生成一个新的进程，它会用他的binary将当前的shell进程给替换掉，然后运行完退出。变量会传到exec里面去
    * exec可以节省些资源
    * exec可以用来打开文件描述符

```

cd /dev/fd
exec 3< ~/temp.txt        # 新建一个file descriptor 3 (/dev/fd/3), 里面的内容是从~/temp.txt里读过来的。
cat 3                     # file descriptor 3里面的内容跟temp.txt是一样的。  
exec 4> thatfile          # 新建file descriptor 4，然后把4的内容写到thatfile。因为4现在是空的，所以thatfile也变成空文件了。
echo "josh" >&4           # 写一个字符串到4
cat thatfile              # 可以看到上面语句写的字符串也已经写到了thatfile
exec 8<> tother           # open "tother" for reading and writing on fd 8
exec 3<&-                 # close the read file descriptor 3
exec 4<&-

```

    
## vim
### vim里面更改只读文件

```

:w ! sudo tee %

```

### vim显示16进制

```

# vim -b 打开文件不会加回车

# 显示16进制
:% ! xxd

# 从16进制返回
:% ! xxd -r

```

## dd 用法

```

dd if=/dev/zero ibs=1k count=2 | tr "\000" "\377" > AllFF.bin

```

## tr用法
* `-c`: 取反
* `-d`: 删除
* `-t`: 替换

```

# 去掉空格
$ echo "fdsfsA5 45gbmcRR" | tr -d ' '

# 去掉f或者d
$ echo "fdsfsA5 45gbmcRR" | tr -d [fd]

# 只留下16进制字符 (去掉非16进制字符)
$ echo "fdsfsA545gbmcRR" | tr -d -c [:xdigit:]
$ fdfA545bc

# 去掉回车符, -r就是^M
cat filename |tr -d '\r' > newfile

# 去掉回车符2
sed -i 's/^M//g' filename   # 注意：^M的输入方式是 Ctrl + v ，然后Ctrl + M

# 去掉回车符3
vi filename

# 输入
:1,$ s/^M//g                # 注意：^M的输入方式是 Ctrl + v ，然后Ctrl + M

```


### echo用法
* `-n`: 不带回车
* `-e`: 可以用backslash做转义符
    *  `\x3f`: 16进制数
    *  `\056`: 8进制数

### 字符串操作

```

# 截取字符串的前两个 从1开始，取2个字符
echo abcdefg | awk '{print substr($0,1,2)}'

```

### 10进制，16进制转换
* awk

```

 echo 530 | awk '{printf("%04x", $1)}'
 
 # 将一个大数变成16进制，而且裁成两部分
 echo 530 | awk '{printf("%04x", $1)}' | sed 's/^../0x&,0x/'
 
 # sed 匹配行首，行末位置 ^, $
 # sed 匹配字符 ^.. 匹配行首的前两个字符。
 sed 's/^../&,/'   # 找到行首第二个字符，然后添加一个,号。其中&表示匹配的部分。

```

* bc

```

echo 'obase=16; 77' | bc 

```



### md5 16进制数
http://www.cnblogs.com/killkill/archive/2010/06/23/1763785.html

```

# -n 是不要加回车
echo -n -e "\xf1\x19\x07\x2b\x3e\x24\x2c\x2c\xbe\x96\x18\x71\x1f\x91\xa8\x69" > tt.bin
md5sum tt.bin
a8b5f2dcdccfe7c8ec18060c12820e98 *tt.bin

# 或者
$ echo -n -e "\xf1\x19\x07\x2b\x3e\x24\x2c\x2c\xbe\x96\x18\x71\x1f\x91\xa8\x69" | md5sum.exe
a8b5f2dcdccfe7c8ec18060c12820e98 *-

```

### hexdump和xxd的区别 (慎用hexdump，只用xxd)
通过以下例子可以知道`xxd` 和 `hexdump -C` 是一样的。

```

➜  whitedwarf:rsa_pub_format_test  echo -n -e "\xf1\x19" | xxd 
0000000: f119                                     ..

# 和xxd一样
➜  whitedwarf:rsa_pub_format_test  echo -n -e "\xf1\x19" | hexdump -C
00000000  f1 19                                             |..|
00000002

# 和xxd不一样，倒过来了
➜  whitedwarf:rsa_pub_format_test  echo -n -e "\xf1\x19" | hexdump 
0000000 19f1                                   
0000002

```

### xxd的用法
`-r`: 可以将16进制数变成字符串
`-i`: 可以生成c语言格式的字串

```

# 将字符串转成16进制数
$ echo -n "Josh what's" | xxd -i
0x4a, 0x6f, 0x73, 0x68, 0x20, 0x77, 0x68, 0x61, 0x74, 0x27, 0x73

# 再通过tr去掉空格
$ echo -n "Josh what's" | xxd -i | tr -d ' '
0x4a,0x6f,0x73,0x68,0x20,0x77,0x68,0x61,0x74,0x27,0x73

```

## 用quilt来生成patch, 这个可以用来往一些patch系统(比如Buildroot)里面加东西
Basic patch process

* Browse to the directory the patch should be relative from, and create patches directory: mkdir patches
* Create a new patch: `quilt new 999-WGPro-010-tcp-syslog-fixes.patch`
* Add the file to be patched: `quilt add log/logread.c`
* Make edits to the file, then refresh the patch: `quilt refresh`
* View the patch diff: `quilt diff`
    * For OpenWRT, the patches directory has to be copied from the build directory into the package directory where the Makefile lives. If
* there is already a patches directory, then copy the patch files into the existing directory to avoid overwriting the existing patches

## Display process information:

```

ps axjf	# display prcess tree
ps –ejH	# ditto

```

## kill杀死进程

```

kill -9 <pid>

```

## grep搜索字符串

```

# 在所有文件里搜索QT5字串,包括子目录. 但是没有包括隐藏目录?!
grep -r <搜索文本> <什么文件>
grep -nR QT5 *
grep -r "fs" *

grep -v -- <不需要包括的字符>

#如果grep认为文件不是文本文件，可以指定类型
grep --binary-files=text

```

## git grep 搜索宏定义，然后查找哪些是没有用过的

```

# 1. 将所有搜到的宏定义存到macros文件
git grep -h "#define" | awk -F: '{print $2}'| sed 's/^[/ \t\n]*//g' | awk '{print $2}' | sed 's/(.*$//g'  > macros

# NOTES:
# git grep -h "#define" | awk -F: '{print $2}'： 查找宏定义，然后去除grep的信息(文件名和line number)

#  sed 's/^[/ \t\n]*//g' | awk '{print $2}'
# 去掉行首的空白符，制表符，回车符，和注释

#  sed 's/(.*$//g' 
# 去掉(到行末的内容

# 2. cat macros | xargs -n1 ./find_usage_cnt.sh >> macro_usage.txt

-----find_usage_cnt.sh
COUNT=`git grep $1 | wc -l`
echo -e "$1\t: ${COUNT}"

# 3. grep -w 1 macro_usage.txt > macro_not_used

```

## find查找文件名或目录

```

find . -name "*.sh"

# 查找比file.txt更新的所有文件
find . -type f -newer file.txt -print

# 在当前目录下查找名字为sama5d2_xplained的目录,不包括子目录
find . -maxdepth 1 -type d -name '*sama5d2_xplained*'

```

## 批量更改名字(sed)

```

for files in `find . -name "CSRMesh*" -type d`;do;git mv $files `echo "$files" | sed 's/CSRMesh/CSRmesh/'`;done


#！/bin/bash
for files in `find . -name "boot.bin"`
do 
        # echo $files
        # echo "$files" | sed 's/boot/boot-sd/'
        mv $files `echo "$files" | sed 's/boot/boot-sd/'`
done

```

## xargs
### xargs: 在所有.h文件里搜索"fs"

```

find . -name "*.h" | xargs grep "fs" 

```

### xargs: 将xargs里面的数组一个一个的取出来执行

```

find . -name "*.h" | xargs -I {} cat {}

find . -name "*.h" | xargs -n 1 echo

# 上面的加入文件名含有空格，则会出问题，这个时候用下面的命令就没问题
find . -name "switcher.bin" | xargs -n 1 -I {} ./test.sh {}

# 一次删除所有branch
git br | xargs -I {} git branch -d {}

```

### xargs: 将xargs里面的数组一个一个的取出来做复杂运算

```

find . -name "Config.in*" | xargs -n 1 ./change.sh

```

### 另外一种查找文件，然后执行的方法

```

find . -name install.sh | while read installer ; do sh -c "${installer}" ; done

```

### 获得git里面所有modified文件列表

```

git status -s | grep M | awk '{print $2}' 

# 对这些文件做 dos2unix
git status -s | grep M | awk '{print $2}' | xargs -n1 dos2unix

```

```

# change.sh: run git mv to rename the files
#!/bin/bash

NEW_NAME=`echo $1 | sed s/Config.in/Kconfig/`
#echo $NEW_NAME

git mv $1 $NEW_NAME

```

### egrep 抽取字符串

```

# 得到所有href="xxx"的字串
egrep -o "href=[^>]*" dl.html

```

## tail 显示dmesg

```

tail -f /var/log/syslog
tail -f /var/log/{messages,kernel,dmesg,syslog}

```

## {} 用来生成组合

```

echo {a,b}{a,b}
aa ab ba bb

cp file{,.bak}
cp file file.bak

```

## random随机数打印

```

printf "%04x\n" $RANDOM
echo "obase=16;$RANDOM" | bc

```

## rsync拷贝文件,除了某个目录

```

# -a: archive mode, 包括-r etc.
# -v: verbose
rsync -av test support-issue --exclude "output/"

```

## for循环

```

# 循环一个字符串数组
PROJECT_LIST="linux4sam_wiki at91_sd_boot"
for PROJECT in $PROJECT_LIST
do
	touch /home/git/repositories/${PROJECT}.git/git-daemon-export-ok
done

# 数字循环
for num in `seq 0 6`;do;echo file${num};done

```

### 批量文件copy/改名

```

for file in `ls sama5d3*revc_pda7*dts`; do; cp $file `echo $file | sed 's/pda7/pda4/'`; done

#！/bin/bash
for files in `find . -name "u-boot.bin"`
do 
        # echo $files
        # echo "$files" | sed 's/boot/boot-sd/'

        git mv $files `echo "$files" | sed 's/boot/boot-sd/'`
done

```

#### 将空格文件夹改名字
* 在空格文件夹的同级目录上建立一个shell脚本: test.sh

```

## tesh.sh
#!/bin/bash
_renamed=`echo $1 | sed 's/\ /_/'`
mv "$1" $_renamed

```

* 把上面的文件加上执行权限

```

chmod +x test.sh

```

* 然后执行命令

```

find . -maxdepth 1 -type d -name '* *'|  xargs -n 1 -I {} ./tesh.sh {}

```

## !! 上一条命令

```

sudo !!

```

## cd - 上一个目录

```

cd -

```

## ssh

```

# 连上melon并执行一条命令
ssh melon cat ~/work/env.sh

```

### ssh用法
http://linux.icydog.net/ssh/piping.php
ssh -vvv

## sudoer with no password

```

user=josh
sudo adduser $user sudo
sudo adduser $user dialout

echo "$user ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$user
sudo chmod 440 /etc/sudoers.d/$user

```

## 文件/目录属性设置
文件/目录一般会有三列，分别为owner(u), group(g), others(o)。在chmod里面用u, g, o来表示。

比如要让一个目录所有人都能读的话，就可以把rx属性加给others

```

# -R 表示包含所有子目录
chmod -R o+rx xxx_path/

```

## cut用法
grep 字符, 只把文件名打印出来:

```

# cut: 
# -f 和 -d要一起用
#  -f num :第几个字段
#  -d:  以:为分隔符
#  -d\  以空格为分隔符
# uniq: 去掉同名

git grep video= | cut -d: -f 1 | uniq

echo "$BOARD_DIRS" | cut -d\ -f 1

```

## nm 列出.so .a文件里面的所有函数


## dpkg查找pakage安装的文件

```

# dpkg查找pakage安装的文件
dpkg -L <包名>

# dpkg通过文件查找对应得安装包
dpkg -S <文件path>

```

## 管道命令重定向
http://www.cyberciti.biz/faq/linux-redirect-error-output-to-file/

```

stdin (0)
stdout (1)
stderr (2)

command1 > out.txt 2> err.txt
command2 -f -z -y > out.txt 2> err.txt

command1 > everything.txt 2>&1
command1 -arg > everything.txt 2>&1

```

## crontab命令

```

crontab -l
crontab -e
# 分 时 日 月 周
  10 5  *  *  0 /home/fred/foo.ksh  # 每周日5点10分
# 分       时 日 月 周
  [1-10]/3 23 1  8  *   xxx.sh      # 8月1日, 23点的1, 4, 7, 10分执行

```

下面设置一条命令，每天早上5点会fetch git repo

```

0 5 * * * ~/work/at91/kernel/fetch_all.sh >> ~/work/at91/kernel/runlog.txt 2>&1

```

fetch_all.sh的脚步内容

```

#!/bin/sh
TOP_DIR="~/work/at91/kernel"
PATH=$PATH:/home/josh/bin
cd ~/work/at91/kernel/linuxs
echo "start fetching at" `date`
git fetch at91
git fetch linus
git fetch mtd
git fetch stable
echo "Done"
echo ""
cd - > /dev/null 2>&1

```

* 可以在/var/log/syslog里面看到cron命令是否执行
* cron job是没有output的，所以它会将output作为邮件发出来，可以在/var/spool/mail/josh里面看到。如果没有装mail工具的话，会报错

```

(CRON) info (No MTA installed, discarding output

```

这样的话，可以按照postfix

```

sudo apt-get install postfix

```

* 启动cron服务的命令

```

// @ubuntu 14.04
sudo service cron restart

```


## 日期和时间戳转换函数

```

➜  whitedwarf:zigbee-3.0 git:(develop) ✗ date
2017年 01月 10日 星期二 15:35:25 CST
➜  whitedwarf:zigbee-3.0 git:(develop) ✗ date +%s
1484033731
➜  whitedwarf:zigbee-3.0 git:(develop) ✗ date -d "2000-01-01 0:0:0" +%s
946656000
➜  whitedwarf:zigbee-3.0 git:(develop) ✗ date -d "1970-01-01 0:0:0" +%s                  
-28800
➜  whitedwarf:zigbee-3.0 git:(develop) ✗ date -d "1970-01-01 0:0:0 utc" +%s
0
➜  whitedwarf:zigbee-3.0 git:(develop) ✗ date -d "1970-01-01 0:0:0" +%s    
➜  whitedwarf:zigbee-3.0 git:(develop) ✗ date -d "2000-01-01 0:0:0 utc" +%s
946684800
➜  whitedwarf:zigbee-3.0 git:(develop) ✗ date -d "@429496729"              
1983年 08月 12日 星期五 08:38:49 CST
➜  whitedwarf:zigbee-3.0 git:(develop) ✗ date -d "@0"        
1970年 01月 01日 星期四 08:00:00 CST
➜  whitedwarf:zigbee-3.0 git:(develop) ✗ date -d "@4294967296"
2106年 02月 07日 星期日 14:28:16 CST
➜  whitedwarf:zigbee-3.0 git:(develop) ✗ 

```

## 日期格式

```

$ date "+%Y/%m/%d %H:%M:%S"
2017/07/11 12:38:47

$ date -u "+%Y/%m/%d %H:%M:%S UTC"
2017/07/11 04:39:35 UTC

```

## shell脚本控制命令行颜色
https://zybuluo.com/mdeditor#88762

## 源文件代码行数的计算

```

cloc --no3 --by-file-by-lang

```

## 正则表达式

### 正则表达式里面的特殊字符(元字符)
* 参考: http://dragon.cnblogs.com/archive/2006/05/08/394078.html

```

[ ] \ ^ $ . | ? * + ( )

```

* `.` : 表示一个字符
* `*` : 表示重复0次或者多次
* `+` : 表示重复1次或者多次
* `?` : 表示重复0次或者1次
* `.*` : 表示任意多个字符
* `^` : 表示从行首开始
* `$` : 表示从到行末
* `[ab]` : 字符集，表示匹配`[]`里面多个字符的一个。也就是说`a`或者`b`。
    * 在字符集`[]`里面, 只有4个字符有特殊意义: `] ^ \ -`
        * 这时`-`可以作为连字符，表示范围，比如[1-9]表示1~9的任意数字。
        * 这时`[^`可以表示字符集取反。这样字符集将匹配任何不在`[]`里面的字符。
            * 举例: `q[^u]`表示匹配一个q，并且后面跟着一个不是`u`的字段
        * `\` 表示转义.


### 正则表达式转义字符 `\`

### 正则表达式的简写
`\d`: 代表[0-9]
`\w`: 代表单词字符
`\s`: 代表空格是Tab字符

### 测试正则表达式:

```

# 删除(到行尾的所有内容， $表示到行末，^表示从行首开始。
echo "josh(fdfd)" | sed 's/(.*$//'

```


  [1]: http://static.zybuluo.com/rainyfeeling/4dnn7fmb2gsbp5iworqazwgt/shell_cheatsheet.png
