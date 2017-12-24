#!perl -w
undef $/;   # 一次读取所有文件内容

$input = <>;

# 找到```，并且后面没有空行。在后面加空行。
$input =~ s/```(?!\n(\n)+)/```\n/mg;

# 将多个回车变成2个回车。
$input =~ s/((\n)+)```/\n\n```/mg;
print $input;
