
;			16_4	程序入口地址的直接定址表

;我们可以在直接定地址表中存储子程序的地址，从而方便地实现不同子程序的调用。我们看下面
;的问题。

;实现一个子程序setscreen,为显示输出提供如下功能。
;(1)清屏
;(2)设置前景色
;(3)设置背景色
;(4)向上滚动一行

;入口参数说明如下：
;(1)用ah寄存器传递功能号：0表示清屏，1表示设置前景色，2表示设置背景色，3表示向上滚动一行
;(2)对于1、2号功能，用al传送颜色值，al={0,1,2,3,4,5,6,7}

;下面我们讨论一下各种功能如何实现
;(1)清屏：将显存中当前屏幕中的字符设为空格符
;(2)设置前景色：设置显存中当前屏幕中处于奇地址的属性字节的第0、1、2位
;(3)设置背景色：设置显存中当前屏幕中处于奇地址的属性字节的第4、5、6位
;(4)向上滚动一行：依次将第n+1行的内容复制到第n行处：最后一行为空。

;------------------------------------------------------------------------------------

;我们将这4个功能分别写为4个子程序，请读者根据编程思想，自行读懂下面的程序。

sub1:	push bx
		push cx
		push es
		mov bx,0b800h
		mov es,bx		;指向显存
		mov cx,2000		;一屏有4000个字节，2000个字符
		
sub1s:	mov byte ptr es:[bx],' '	;显存处于偶地址的字节存放字符的ASCII码
									;用空格符清屏
		add bx,2		;指向下一个偶地址单元
		loop sub1s		;重复循环2000次
		pop es
		pop cx
		pop bx
		ret
		
sub2:	push bx
		push cx
		push es
		
		mov bx,0b800h
		mov es,bx			;指向显存
		mov bx,1
		mov cx,2000
		
sub2s:	and byte ptr es:[bx],11111000b		;先把0、1、2位置0，防止其他数据影响
											;设置前景色：设置显存中当前屏幕中处于
											;奇地址的属性字节的第0、1、2位
											
		or es:[bx],al		;al中为颜色值
		add bx,2			;指向下一个奇地址单元
		loop sub2s			;重复循环2000次
		
		pop es
		pop cx
		pop bx
		ret
		
sub3:	push bx
		push cx
		push es
		
		mov cl,4			;移动次数大于1，用cl存放数值
		shl al,cl			;al中的值左移4次,目的是设置4、5、6位的颜色
							;因为之前al设置的颜色数值在0、1、2位，所以
							;左右4位是为了把设置颜色的数值移动到4、5、6位
		
		mov bx,0b800h
		mov es,bx			;指向显存
		
		mov bx,1
		mov cx,2000
		
sub3s:	and byte ptr es:[bx],10001111b		;先把4、5、6位置0，防止其他数据影响
											;设置背景色：设置显存中当前屏幕中处于
											;奇地址的属性字节的第4、5、6位
											
		or es:[bx],al		;al中为颜色值
		add bx,2			;指向下一个奇地址单元
		loop sub3s
		
		pop es
		pop cx
		pop bx
		ret
		
sub4:	push cx
		push si
		push di
		push es
		push ds
		
		mov si,0b800h		
		mov es,si			;指向显存
		
		mov si,160			;ds:si指向第n+1行
		mov di,0			;es:di指向第n行
		cld 
		mov cx,24			;共复制24行
		
sub4s:	push cx
		mov cx,160			;一行160个字节，复制一行
		rep movsb			;复制
		
		pop cx				;恢复cx指向另一行
		loop sub4s
		
		mov cx,80			;最后一行不用颜色属性的字节，只需字符的字节，所以
							;一行80
		mov si,0			;这里的si代表行内偏移地址
		
sub4s1:	mov byte ptr [160*24+si],' '	;最后一行清空，这里的si代表行内偏移地址
		add si,2						;指向行内下一个偶地址单元
		loop sub4s1
		
		pop ds
		pop es
		pop di
		pop si
		pop cx
		ret
		
;-------------------------------------------------------------------------------------

;我们可以将这些功能子程序的入口地址存储在一个表中，它们在表中的位置和功能号相对应。
;对应关系为：功能号*2=对应的功能子程序在地址表中的偏移。程序如下：

setscreen:	jmp short set
	
	table dw sub1,sub2,sub3,sub4		;每个两字节
	
set:	push bx
		cmp ah,3			;判断功能号是否大于3
		ja sret				;不大于则跳转到sret
		mov bl,ah
		mov bh,0
		add bx,bx			;根据ah中的功能号计算对应子程序在table表中的偏移
		
		call word ptr table[bx]		;调用对应的功能子程序
		
sret:	pop bx
		ret
		
;当然，我们也可以将子程序setscreen如下实现。

setscreen:	cmp ah,0
			je do1
			cmp ah,1
			je do2
			cmp ah,2
			je do3
			cmp ah,3
			je do4
			jmp short sret
			
	do1:	call sub1
			jmp short sret
			
	do2:	call sub2
			jmp short sret
			
	do3:	call sub3
			jmp short sret
			
	do4:	call sub4
	
	sret:	ret
	
;显然，用通过比较功能号进行转移的方法，程序结构比较混乱，不利于功能的扩充。比如说
;在setscreen中再加入一个功能，则需要修改程序的逻辑，加入新的比较、转移指令。
;用根据功能号查找地址表的方法，程序的结构清晰清楚，便于扩充。如果加入一个新的功能
;子程序，那么只需要在地址表中加入它的入口地址就可以了。