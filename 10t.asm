;test10     show_str子程序
;在屏幕的8行3列，用绿色显示data段中的字符串
assume cs:code,ds:data

data segment

	db 'welcome to masm!',0
	
data ends

code segment

start:	mov dh,8		;行号（取值范围0~24）
		mov dl,3		;列号（取值范围0~79）
		mov cl,2		;颜色
		
		mov ax,data
		mov ds,ax
		mov si,0		;ds:si指向字符串的首地址
		call show_str	;调用子程序show_str实现某功能
		
		mov ax,4c00h
		int 21h
		
show_str:
		push ax
		push bx
		push es
		push si
		
		mov ax,0b800h
		mov es,ax				;指向显存
		
		mov ax,160				;每行160个字节，dh为8行
								;160小于255，这里是8位乘法，结果放在ax中
		mul dh					;即得ax=ax*dh=160*dh
		mov bx,ax				;bx=160*dh
		
		mov ax,2				;每列为2个字节，dl为3列
		mul dl					;即得ax=dl*2
		add bx,ax				;所以mov bx,(160*dh+dl*2)设置es:bx指向显存首地址
								;即第8行第3列的位置
		mov al,cl				;把颜色cl赋值al
		mov cl,0
		
show0:	mov ch,[si]				;把数据段数据放入ch，看ch+cl=cx是否为0
		jcxz show1				;为0则跳到show1处执行，否则向下执行。
		mov es:[bx],ch			;把字符传到显存中去，8行3列的位置
		mov es:[bx].1,ax		;设置颜色
		inc si					;ds:si指向下一个字符地址
		add bx,2				;es:bx指向下一个显存地址
		jmp show0
		
show1:	pop si					;出栈恢复数据
		pop es
		pop bx
		pop ax
		ret
		
code ends

end start