assume cs:code

code segment

start:	mov ax,0
		mov bx,0
		jmp short s 		;jmp指令是根据标号的地址转移固定的距离，而不是具体的地址
		add ax,1			;说明了cpu在执行jmp指令时并不需要转移的目的地址
							;jmp short 标号包含的是转移的位移即距离
	s:	inc ax
	
code ends

end start