;下面程序中，retf指令执行后，CS:IP指向代码段的第一条指令

assume cs:code

stack segment

	db 16 dup (0)
	
stack ends

code segment

		mov ax,4c00h
		int 21h
	
start:	mov ax,stack
		mov ss,x
		mov sp,16
		mov ax,0
		push cs			;把cs寄存器中的值入栈
		push ax			;把ax的值入栈
		mov bx,0
		retf			;先pop ip（ax），后pop cs，因先入栈的后出栈
		
code ends

end start
		