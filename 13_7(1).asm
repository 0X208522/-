
;		13_7(1)		
;编程：在屏幕的5行12列显示字符串"Welcome to masm!".

assume cs:code

data segment

	db 'Welcome to masm','$'
	
data ends

code segment

start:		mov ah,2		;调用中断例程第10h号的2号子程序，功能为设置光标位置
			mov bh,0		;设置第0页	
			mov dh,5		;第5行
			mov dl,12		;第12列
			int 10h
			
			mov ax,data
			mov ds,ax
			mov dx,0		;ds:dx指向字符串的首地址data:0(不用bx是因为前面bh被占用)
			mov ah,9		;21h号中断例程的9号子程序，功能为在光标位置显示字符
			int 21h			;调用第21h号中断例程
			
			mov ax,4c00h
			int 21h
			
code ends

end start

;上述程序在屏幕的5行12列显示字符串“Welcome to masm!”,直到遇见“$”
;($本身并不显示，只起到边界的作用)。

;如果字符串比较长，遇到行尾，程序会自动转到下一行开头处继续显示;如果到了最后一行
;还能自动上卷一行。

;DOS为程序员提供了许多可以调用的子程序，都包含在int 21h号中断例程中。