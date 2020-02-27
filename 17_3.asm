

;			17_3	字符串的输入

;用户通过键盘输入的通常不仅仅是单个字符而是字符串
;最基本的字符串输入程序，需要具备下面的功能：
;(1)在输入的同时需要显示这个字符串
;(2)一般在输入回车符后，字符串输入结束
;(3)能够删除已经输入的字符

;编写一个接收字符串输入的子程序，实现上面3个基本功能。因为在输入的过程中需要显示
;子程序的参数如下：
;(dh)、(dl)=字符串在屏幕上显示的行、列位置
;ds:si指向字符串的存储空间，字符串以0为结尾符

;下面我们进行分析：
;(1)字符的输入和删除
;每个新输入的字符都存储在前一个输入的字符之后，而删除是从最后面的字符进行的，我们看下
;面的过程。

;空字符串：
;输入"a":a
;输入"b":ab
;输入"c":abc
;输入"d":abcd
;删除一个字符：abc
;删除一个字符：ab
;删除一个字符：a
;删除一个字符： 

;可以看出在字符串输入的过程中，字符的输入和输出是按照栈的访问规则进行的，即后进先出
;这样，我们就可以用栈的方式来管理字符串的存储空间，也就是说，字符串的存储空间实际上
;是一个字符栈。字符栈中的所有字符，从栈底到栈顶，组成一个字符串。

;(2)在输入回车符后，字符串输入结束
;输入回车符后，可以在字符串中加入0，表示字符串结束

;(3)在输入的同时需要显示这个字符串
;每次有新的字符输入和删除一个字符的时候，都应该重新显示字符串，即从字符栈的栈底到栈顶
;显示所有的字符

;(4)程序的处理过程
;现在我们可以简单地确定程序的处理过程如下
;1.调用int 16h读取键盘输入
;2.如果是字符，进入字符栈，显示字符栈中的所有字符；继续执行
;3.如果是退格键，从字符栈中弹出一个字符，显示字符栈中的所有字符;继续执行
;4.如果是Enter键，向字符栈中压入0，返回。

;------------------------------------------------------------------------------------
assume cs:code

code segment

start:   	mov ax,2000h
			mov ds,ax
			mov si,0		;ds:si指向2000:0内存

			mov dl,0		;0行

			mov dh,0		;0列

			call getstr		;调用子程序

			mov ax,4c00h

			int 21h


;下面程序是完整的接收字符串输入的子程序：

;子程序：接收字符串输入。
getstr:		push ax
			
getstrs:	mov ah,0			;(ah)=功能号，0表示入栈，1表示出栈，2表示显示
			cmp al,20h			;al中返回的字符与20h比较
			jb nochar			;ASCII码小于20h，说明不是字符
			mov ah,0
			call charstack		;字符入栈
			mov ah,2
			call charstack		;显示栈中的字符
			jmp getstrs
			
nochar:		cmp ah,0eh			;退格键的扫描码
			je backspace
			cmp ah,1ch			;Enter键的扫描码
			je get
			jmp getstrs
			
backspace:	mov ah,1
			call charstack		;字符出栈
			mov ah,2
			call charstack		;显示栈中的字符
			jmp getstrs
			
get:		mov al,0
			mov ah,0
			call charstack		;0入栈
			mov ah,2
			call charstack		;显示栈中的字符
			pop ax
			ret
			
;从程序的处理过程中可以看出，字符栈的入栈、出栈和显示栈中的内容，是需要在多处使用的
;功能，我们应该将它们写为子程序。

;子程序：字符栈的入栈、出栈和显示
;参数说明：
;(ah)=功能号，0表示入栈，1表示出栈，2表示显示
;ds:si指向字符栈空间
;对于0号功能：(al)=入栈字符
;对于1号功能：(al)=返回的字符
;对于2号功能：(dh)、(dl)=字符串在屏幕上显示的行、列位置

charstack:		jmp short charstart

		table	dw charpush,charpop,charshow;
		top		dw 0			 ;栈顶(字符地址、个数记录器)
		
charstart:		push bx
				push dx
				push di
				push es
				
				cmp ah,2		;(ah)=功能号，0表示入栈，1表示出栈，2表示显示
								;判断ah中的功能号是否大于2

				ja sret			;功能号>2，结束
				mov bl,ah
				mov bh,0		;如果ah中为2，则bx中为0002h
				add bx,bx		;加两个bx是因为table中的数据是以字为单位，而功能号以
								;字节为单位，此时bx中为0004h?计算子程序在table中的偏移
				jmp word ptr table[bx]		;跳到对应功能号的子程序

;入栈的字符放入字符栈				
charpush:		mov bx,top				;标号top代表了一个内存单元，地址为xx:xx
										;长度为两个字节，在这个程序里top也影响
										;字符栈栈顶指针的移动，因把top放进bx中
										;代表了偏移
										
				mov [si][bx],al			;入栈的字符放入字符栈
				inc top					;top(同时描述标号地址及单元长度)代表栈顶指针
										;这里增加的是top单元里面的值，而不是增加地址
				jmp sret

;出栈返回的字符放入al				
charpop:		cmp top,0			;比较字符栈栈顶指针单元里的值
				je sret				;如果按下的是Enter键，压入字符栈栈顶中的值为0
									;则跳转到sret，退出；否则向下执行
									;栈顶为0(无字符)，结束

									
				dec top				;单元里的值减1，使栈顶指针移动到前一个单元地址
				mov bx,top			;然后值放入bx做偏移地址
				mov al,[si][bx]		;(键盘缓冲区的扫描码和ASCII码)偏移地址里面的值
									;放入al
				jmp sret
				
charshow:		mov bx,0b800h
				mov es,bx			;指向显存
				
				mov al,160			
				mov ah,0			
				mul dh				;dh*160
				mov di,ax			;结果放ax
				
				add dl,dl			;dl*2

				mov dh,0
				
				add di,dx			;di=dh*160+dl*2，es:di指向显存
				
				mov bx,0			;ds:[si+bx]指向字符串首地址
				
charshows:		cmp bx,top			;判断字符栈中字符是否全部显示完毕
				jne noempty			;top≠bx，有未显示字符，执行显示
				mov byte ptr es:[di],' '	;显示完毕，字符串末加空格
				jmp sret
				
noempty:		mov al,[si][bx]		;字符ASCII码赋值al
				mov es:[di],al		;显示字符
				mov byte ptr es:[di+2],' '	;字符串末加空格
				inc bx				;指向下一个字符
				add di,2			;指向下一显存单元
				jmp charshows
				
sret:			pop es
				pop di
				pop dx
				pop bx
				ret
		
;另一个要注意的问题是，显示栈中字符的时候，要注意清除屏幕上上一次显示的内容
