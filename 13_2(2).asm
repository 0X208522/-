
;			13.2(2)		编写供应用程序调用的中断例程7ch

;编写工作：
;(1)编写实现求平方功能的程序
;(2)安装程序，将其安装在0:200处
;(3)设置中断向量表，将程序的入口地址保存在7ch表项中，使其成为中断7ch的中断例程
;安装程序如下：

assume cs:code

code segment

start:	mov ax,cs
		mov ds,ax					;源地址
		mov si,offset sqr			;使ds:si指向标号sqr所在处
		
		mov ax,0
		mov es,ax					;目的地址即sqr标号处的代码要复制到的地方
		mov di,200h					;使es:di指向0:200内存单元处
		
		mov cx,offset sqrend-offset sqr		;计算从sqend到sqr间的代码长度，再赋值给cx
		cld							;设置传送方向为正即df=0，si、di递增1
		rep movsb					;循环次数以cx为主
		;上面的代码是为了把sqr处的代码放到中断向量表中
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		mov ax,0
		mov es,ax
		mov word ptr es:[7ch*4],200h
		mov word ptr es:[7ch*4+2],0				;此处的代码则是为了把中断处理程序的入口
												;地址添加到中断向量表中
		
		mov ax,4c00h
		int 21h
		
sqr:	mul ax							;计算的代码主要是这句代码，上面的是安装中断
										;处理程序
		iret
		
sqrend:	nop

code ends

end start

;int指令和iret指令的配合使用与call指令和ret指令的配合使用具有相似的思路

