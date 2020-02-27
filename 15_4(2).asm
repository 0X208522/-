
;		15_4(2)	编写int 9中断例程

assume cs:code

stack segment

	db 128 dup (0)
	
stack ends

data segment

	dw 0,0
	
data ends

code segment

start:		mov ax,stack
			mov ss,ax
			mov sp,128				;栈顶指针ss:sp指向栈底
			
			mov ax,data
			mov ds,ax				;指向数据段
			
			mov ax,0
			mov es,ax				;指向段地址为0的内存单元
			
			push es:[9*4]			;把原来的int9的偏移地址IP放入栈中
			pop ds:[0]				;然后出栈保存到数据段ds:[0]号单元中
			push es:[9*4+2]			;把原来的int9的段地址CS放入栈中
			pop ds:[2]				;然后出栈保存到数据段ds:[2]号单元中
			
			mov word ptr es:[9*4],offset int9		;获取新编写的int9的偏移地址
													;放入中断向量表9项单元中
			mov es:[9*4+2],cs		;把新编写的int9的段地址放入中断向量表9项单元中
			
			mov ax,0b800h			;指向显存段地址
			mov es,ax
			mov ah,'a'				;把字符a的ASCIII码放进ah
			
		s:	mov es:[160*12+40*2],ah	;再把字符放入显存
			call delay				;调用子程序delay
			inc ah					;指向下一个字符
			cmp ah,'z'				;与z的ASCII码比较
			jna s 					;不高于则跳转到标号s处继续执行循环
			
			mov ax,0
			mov es,ax
			
			push ds:[0]
			pop es:[9*4]
			push ds:[2]
			pop es:[9*4+2]			;将中断向量表中int9中断例程的入口恢复为原来的地址
			
			mov ax,4c00h
			int 21h
			
	delay:	push ax			;delay的功能是延迟没一个字符显示时间
			push dx
			mov dx,1000h	;dx+ax循环10000000h次
			mov ax,0
			
		s1:	sub ax,1		;ax借位1，所以CF=1
			sbb dx,0		;借位减法：(dx)=(dx)-0-(CF)
			cmp ax,0		;判断低16位是否为0
			jne s1			;不是则继续到s1处循环
			cmp dx,0		;判断高16位是否为0
			jne s1			;不是则继续到s1处循环
			pop dx
			pop ax
			ret
		;------------以下为新的int9中断例程-----------	
			
	int9:	push ax
			push bx
			push es
			
			in al,60h			;从端口60h读出键盘的输入
		;------------可以精简的程序段-----------------------------------------
		;其实在我们的int 9中断例程中，模拟int指令调用原int 9中断例程的程序段是可以精简
		;的，因为在进入中断例程后，IF和TF都已置0，没有必要再进行设置了,可以精简为：
		;pushf
		;call dword ptr ds:[0]
		
		
			pushf				;标志寄存器入栈
			pushf
			pop bx
			and bh,11111100b	;IF和TF为标志寄存器的第9位和第8位
								
			push bx
			popf						;这里置IF=0,TF=0
			call dword ptr ds:[0]		;对int指令进行模拟，调用原来的int9中断例程
										;CS、IP入栈;(IP)=ds:[0],(CS)=ds:[2]
		;------------可以精简的程序段--------------------------------------------
			cmp al,1				;判断键盘的输入是否为Esc键的通码01
			jne int9ret				;不是就转到int9ret执行，是就向下执行
			
			mov ax,0b800h
			mov es,ax
			inc byte ptr es:[160*12+40*2+1]		;将属性值加1，改变颜色
			
int9ret:	pop es
			pop bx
			pop ax
			iret
			
code ends

end start

;在主程序中，如果在设置执行设置int 9中断例程的段地址和偏移地址的指令之间发生了键盘中段，则CPU将转去一个错误的地址执行，将发生错误。

;找出这样的程序段，改写他们，排除潜在的问题。

 

;在中断向量表中设置新的int 9中断例程的入口地址

     cli           ;设置IF＝0屏蔽中断

     mov word ptr es:[9*4],offset int9

     mov es:[9*4+2],cs

     sti           ;设置IF＝1不屏蔽中断
