
;11.10		233 (244 / 354)

;(2)编程，用串传送指令，将F000H段中的最后16个字符复制到data段中

;要传送的字符串位于F000H段的最后16个单元中，那么它的最后一个字符的位置：F000:FFFF
;是显而易见的。可以将ds:di指向F000H段的最后一个单元，将es:di指向data段中的最后一个
;单元，然后逆向（即从高地址向低地址）传送16个字节即可.

assume cs:code,ds:data

data segment

	db 16 dup (0)
	
data ends

code segment

start:	mov ax,0foooh
		mov ds,ax
		mov si,0ffffh			;ds:si指向f000:ffff
		
		mov ax,data
		mov es,ax
		mov di,15				;es:di指向data:000F
		
		mov cx,16				;(cx)=16,rep 循环16次
		std						;设置df=1，逆向传送即（si）=（si）-1，（di）=（di）-1
		rep movsb
		
code ends

end start