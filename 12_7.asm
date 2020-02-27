
;			12.7	编程处理0号中断

;(1)编写可以显示"overflow!"的中断处理程序：do0
;(2)将do0送入内存0000：0200c处
;(3)将do0的入口地址0000：0200存储在中断向量表0号表项中。

assume cs:code

code segment

start:		mov ax,cs
			mov ds,ax							;源地址
			mov si,offset do0					;使ds:si指向代码段的do0处的地址
												;即do0中断程序代码所在位置
			
			mov ax,0
			mov es,ax							;目的地址
			mov di,200h							;使es:di指向0000：0200h内存单元
												;do0中断程序的代码要复制的目的地址
			
			mov cx,offset do0end-offset do0		;计算do0程序代码的长度
			cld									;设置标志寄存器df=0，使传输代码的
												;为正
			rep movsb							
;			设置中断向量表		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

			mov ax,0						;将do0的入口地址0:200，写入中断向量表中
			mov es,ax
			mov word ptr es:[0*4]，200h		;0号表项的地址为0:0,其中0:0放偏移地址
			mov word ptr es:[0*4+2],0		;0:2字单元放段地址
			
			mov ax,4c00h
			int 21h
		
do0:		jmp short do0start
			db "overflow!"
		
do0start:	mov ax,cs							;此处是内存中中断程序发生除法溢出
												;时要执行的代码（另一个程序）
			mov ds,ax							;所以设置ds指向cs是正确的
			mov si,202h							;设置ds:si指向字符串
			
			mov ax,0b800h
			mov es,ax
			mov di,12*160+36*2					;设置es:di指向显存空间的中间位置
			
			mov cx,9							;设置cx为字符串的长度，循环9次
			
		s:	mov al,[si]							;把ds:si处字符的ASCII码放到al中
			mov es:[di],al						;再把al中字符的ASCII码放到显存空间
			inc si								;指向下一个字符
			add di,2							;指向下一个显存单元，加2是因为用两
												;个字节存放要显示的字符及其属性
			loop s
			
			mov ax,4c00h
			int 21h
			
do0end:		nop

code ends

end start