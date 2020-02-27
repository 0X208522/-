assume cs:code

code segment

start:	mov ax,0
		jmp short s 		;‘jmp short 标号’的功能为：（ip）=（ip）+8位位移，段内短转移
							;'jmp near ptr 标号’的功能为：（ip）=（ip）+16位位移，段内近转移
		add ax,1
		
	s:	inc ax
	
code ends

end start