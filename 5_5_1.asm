;类型匹配超界问题
;(dx)=(dx)+内存中的8位数据，此问题是两个运算对象类型不匹配
;(dl)=(dl)+内存中的8位数据，此问题是结果可能超界

;解决办法：用一个16位寄存器作为中介。将内存单元中的8位数据赋值到一个16位寄存器ax中
;再将ax中的数据加到dx上，从而使两个运算对象的类型匹配并且结果不会超界

assume cs:code

code segment

		mov ax,0ffffh
		mov ds,ax
		mov bx,0
		
		mov dx,0
		
		mov cx,12
		
	s:	mov al,[bx]
		mov ah,0
		add dx,ax
		inc bx
		loop s
		
		mov ax,4c00h
		int 21h
		
code ends

end