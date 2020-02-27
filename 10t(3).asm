;实验10				(3) dtoc1子程序

;应用举例：将数据12666以十进制的形式在屏幕的8行3列，用绿色显示出来。

;在显示时调用子程序show_str。


assume cs:code,ds:data

data segment

	db 10 dup (0)
	
data ends

code segment

start:	mov ax,12666

		mov bx,data
		mov ds,bx
		mov si,0					;ds:si指向data首地址
		call dtocl					;调用子程序dtocl，把12666变成十进制
		
		mov dh,8					;行号（取值范围0~24）
		mov dl,3					;列号（取值范围0~79）
		mov cl,2					;颜色
		call show_str				;调用子程序show_str在8行3列实现绿色字符
		
		mov ax,4c00h
		int 21h
		
dtocl:	push ax
		push bx
		push cx
		push si
		push di
		;"""入栈保存数据"""
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		mov di,0
		
d10:	mov dx,0					;设置被除数高位为0
		mov bx,10					;除数为10
		div bx
		add dx,30h					;ax/10的余数+30h，转为字符，王爽211页(223 / 354)
		push dx						;字符入栈
		inc di						;记录字符个数
		mov cx,ax					;把商ax赋值给cx，判断cx是否为0
		jcxz d11					;当ax/10的商=0时，跳出循环的d10，转到d11执行
		jmp d10
		
d11:	mov cx,di					;把字符个数赋给cx

d12:	pop dx						;字符出栈
		mov [si],dl					;放入数据段中
		inc si						;ds:si指向下一单元
		loop d12
		
		mov dl,0
		mov [si],dl					;设置结尾符0
		pop si
		pop di
		pop dx
		pop cx
		pop bx
		pop ax
		ret
		
show_str:						;注释可参考10test.asm
		push ax
		push bx
		
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
		
show0:
		mov ch,[si]				;把数据段数据放入ch，看ch+cl=cx是否为0
		jcxz show1				;为0则跳到show1处执行，否则向下执行。
		mov es:[bx],ch			;把字符传到显存中去，8行3列的位置
		mov es:[bx].1,al		;设置颜色
		inc si					;ds:si指向下一个字符地址
		add bx,2				;es:bx指向下一个显存地址
		jmp show0
		
show1:							;出栈恢复数据
		pop bx			
		pop ax
		ret
		
code ends

end start
