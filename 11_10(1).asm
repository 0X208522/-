
;11.10		232 (244 / 354)

;(1)编程，用串传送指令，将data段中的第一个字符串复制到它后面的空间中
assume cs:code,ds:data

data segment

	db 'Welcome to masm!'
	db 16 dup (0)
	
data ends

code segment

start:	mov ax,data
		mov ds,ax
		mov si,0			;ds:si指向data:0
		
		mov es,ax
		mov di,16			;es:di指向data:0010
		
		mov cx,16			;(cx)=16,rep循环16次
		cld					;设置df=0，正向传送即（si）=（si）+1，（di）=（di）+1
		rep movsb			;ds:si的数据传送至es:di
		
code ends

end start
		