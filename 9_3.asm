;'jmp far ptr 标号'实现的是段间转移，又称为远转移，功能如下：
;（cs）=标号所在段的段地址；（ip）=标号在段中的偏移地址。
;far ptr 指明了指令用标号的段地址和偏移地址修改cs和ip。
assume cs:code

code segment

start:	mov ax,0		;‘jmp 寄存器’ 即是把寄存器中的内容赋值给ip
		mov bx,0
		jmp far ptr s 
		db 256 dup (0)
		
	s:	add ax,1
		inc ax
		
code ends

end start