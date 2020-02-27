;实验12 编写0号中断处理程序

;编写0号中断处理程序，使得在除法溢出发生时，在屏幕中间显示字符串“divide error!”，
;然后返回DOS

assume cs:code

code segment

start:		mov ax,cs
			mov ds,ax			;offset do0是获取do0标号的地址
			mov si,offset do0	;设置ds:si指向源地址
			
			mov ax,0
			mov es,ax			;es:di指向目的地址0000:0200h处
			mov di,200h			;设置中断处理程序代码的传送地址
			
			mov cx,0ffset do0end-offset do0		;设置传输长度，这里用一个do0end
												;减去do0从而得到do0中断程序代码
												;的长度，而不必手数
			
			cld					;设置标志寄存器df=0，使传送正方向
			rep movsb
			
			mov ax,0
			mov es,ax
			mov word ptr es:[0*4],200h		
			mov word ptr es:[0*4+2],0	;设置中断向量表，添加do0中断程序的入口地址
			
			mov ax,4c00h
			int 21h
			
			
	do0:	jmp short do0start		;do0是在内存0000:0200h单元处的中断程序，另一个程序
			db 'divide error!'	;13个字节
			
do0start:	mov ax,cs				;所以此时的cs是do0的，而不是属于12test.asm的
			mov ds,ax				;所以设置ds与cs挂钩
			mov si,202h				;设置ds:si指向字符串
			
			mov ax,0b800h
			mov es,ax
			mov di,12*160+34*2		;设置es:di指向显存空间的中间位置
			
			mov cx,13				;设置cx为字符串长度
			
		s:	mov al,[si]				;字符的ASCII码送入al
			mov es:[di],al			;把al中的ASCII码song送入显存
			inc si					;指向下一个字符
			add di,2				;指向下一个显存单元
			loop s 
			
			mov 4c00h
			int 21h
			
do0end:		nop

code ends

end start