
;		13.2p(2)	

assume cs:code

code segment

start:		mov ax,cs
			mov ds,ax
			mov si,offset capital
			
			mov ax,0
			mov es,ax
			mov di,200h
			
			mov cx,offset capitalend-offset capital
			cld
			rep movsb
			
			mov ax,0
			mov es,ax
			mov word ptr es:[7ch*4],200h
			mov word ptr es:[7ch*4+2],0
			
			mov ax,4c00h
			int 21h
			
			
capital:	push cx				;入栈，避免寄存器的冲突
			push si
			
change:		mov cl,[si]			;把数据段字符的ASCII码放入cl中
			mov ch,0			;设置ch为0，这里主要看的是cl的值
								;如果cl的值为0，ch+cl=cx=0
			jcxz ok				;如果cx为0则跳转到标号ok处执行指令
			and byte ptr [si],11011111b		;如果不为0则把字符串转化为大写字母
			inc si				;指向下一个字符
			jmp short change	;再跳回change标号处继续执行循环直到cx=0
			
		ok:	pop si				;出栈，恢复数据
			pop cx
			iret				;返回上一个调用程序
			
capitalend:	nop

code ends

end start