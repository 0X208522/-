
;			13.3	对int、iret和栈的深入理解

;问题：用7ch中断例程完成loop指令的功能
;loop s的执行需要两个信息，循环次数和到s的位移，所以，7ch中断例程要完成loop指令的功能
;也需要这两个信息作为参数。我们用cx存放循环次数，用bx存放位移

;应用举例：在屏幕中间显示80个"!"

assume cs:code

code segment

start:	mov ax,0b800h
		mov es,ax
		mov di,160*12				;设置显存的中间位置
		
		mov bx,offset s-offset se	;设置从标号se到标号s的转移位移
		mov cx,80					;设置长度
		
	s:	mov byte ptr es:[di],'!'	;把'!'的ASCII码传送到显存中间位置处
		add di,2					;指向下一个显存地址
		int 7ch						;调用中断例程7ch
		
	se:	nop
	
	mov ax,4c00h
	int 21h
	
code ends

end start