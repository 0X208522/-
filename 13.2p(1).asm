
;		13.2p(1)   (安装程序在13.2p(2)  )

;问题二：编写、安装中断7ch的中断例程
;功能：将一个全是字母，以0结尾的字符串，转化为大写
;参数：ds:si指向字符串的首地址

assume cs:code

data segment

	db 'conversation',0
	
data ends

code segment

start:	mov ax,data
		mov ds,ax
		mov si,0			;使ds:si指向数据段的字符串
		
		int 7ch				;调用中断例程7ch
		
		mov ax,4c00h
		int 21h
		
code ends

end start