## ZHWKLIB USAGE

### General

-  手动调用段间过程方式调用库内函数：
  - 按参数列表从右往左压栈
  - `call far ptr func_name`
  - 注意将参数退栈 (使用宏 `clstk`)
- 使用 `zhwklib.inc` 宏库进行库内函数调用：
  - `@macro_name <arg1>,<arg2> ...` 注意每个参数两侧均有尖括号
  - 宏内已经完成参数压栈退栈
- 具体使用方式可以参考已有实现

### Strings

- 采用C风格字符串，以空字符作为结尾（与DOS风格不同）

#### Data References Address

- 所有引用数据的地址皆为段内地址，因此必须位于数据段中。

### Returning Values

- 一般放置在 `ax` 中

### Function List

#### qmemset

- 参数列表
  - 目标地址 word
  - 写入长度 word
  - 写入内容 byte
- 无返回值
- 宏名 `memset`

#### qmemcpy

- 参数列表
  - 目标地址 word
  - 源地址 word
  - 复制长度 word
- 无返回值
- 宏名 `memcpy`

#### qstrlen

- 参数列表
  - 字符串地址 word


- 返回值 长度
- 宏名 `strlen`

#### qstrcmp

- 参数列表
  - 字符串地址 word
  - 字符串地址 word
- 返回值 第一个不同字符的差值
- 宏名 `strcmp`

#### qstrfcmp

> `f` means `full`

- 参数列表
  - 字符串地址 word
  - 字符串地址 word
- 返回值 第一个不同字符差值 或 字符串长度差值
- 宏名 `strfcmp` 

#### qstrprint

- 参数列表
  - 字符串地址 word
- 无返回值，输出该字符串到屏幕
- 宏名 `strprint`

#### qprintword

- 参数列表
  - 需要打印的数字 word
- 无返回值，将该数字转换为字符串并输出到屏幕
- 宏名 `printword`

#### qgets

- 参数列表
  - 缓冲区地址 word
    - 注意：不需要按照DOS缓冲区格式，只需要是一块内存即可
- 无返回值，将最多99个字符从输入读取并写入到缓冲区，最末补上一个空字符
- 宏名 `gets`

#### exit

- 调用时强制退出程序
- 宏名 `ex`

#### newline

- 换行
- 宏名 `newln`

#### qimult

- 参数列表
  - 操作数 word
  - 操作数 word
  - 存放结果 word
    - 执行完毕后，会将栈上最后一个参数（即：存放结果）覆盖为有符号相乘结果，此时使用pop即可将其放入某个寄存器中
- 无返回值，执行有符号乘法
- 宏名 `multiply` , 不需要提供存放结果参数，自动将前两个参数退栈

#### qidivid

- 参数列表
  - 被除数 word
  - 除数 word
  - 商 word
  - 余数 word
    - 和 `qimult` 行为类似
- 无返回值，执行有符号除法
- 宏名 `divide`， 不需要提供后两个参数，自动将前两个参数退栈

#### qstrtoword

- 参数列表
  - 字符串地址 word
  - 存放结果 word
    - 和 `qimult` 行为类似，将字符串转换为数字
- 返回值 0代表正常转换，1代表存在非法字符
- 宏名 `strtoword`，不需要提供存放结果参数，自动将第一个参数退栈

### Extra Macro

#### clstk

- 参数列表
  - 字节数 立即数
- 将栈顶指针增加指定字节数

