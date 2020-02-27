assume cs:codesg	;关联代码段codesg

codesg segment

		mov ax,0123h	;把16进制数0123h放进通用寄存器ax
		mov bx,0456h	;把0456h放进通用寄存器bx
		add ax,bx		;ax寄存器与bx寄存器中的值即0123h与0456h相加，把结果0579h放进ax中
		add ax,ax		;ax的值0579加两次得0AF2h，并放入ax
		
		mov ax,4c00h	
		int 21h			;调用21号中断例程
		
codesg ends
end