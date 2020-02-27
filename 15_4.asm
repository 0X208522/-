
;		15_4	编写int 9中断例程

;从上面的内容中，可以看出键盘输入的处理过程：
;1.键盘产生扫描码
;2.扫描码送入60h端口
;3.引发9号中断
;4.CPU执行int 9中断例程处理键盘输入
;上面的过程中，第1、2、3步都是由硬件系统完成的。我们能够改变的只有int 9中断处理程序
;我们可以重新编写int 9中断例程，按照自己的1意图来处理键盘的输入。但是，在课程中，我
;们不准备完整地编写一个键盘中断的处理程序，因为要涉及一些硬件细节，而这些内容脱离了
;我们的内容主线。

;因为BIOS提供的int 9中断例程已经对这些硬件细节进行了处理。我们只要在自己编写的中断例程
;中调用BIOS的int 9中断例程就可以了。

;编程：在屏幕中间依次显示“a”~“z”，并可以让人看清。在显示的过程中，按下Esc键后，改变显示
;的颜色

;下面程序依次显示“a”~“z”
assume cs:code

stack segment

	db 128 dup (0)
	
stack ends

code segment

start:	mov ax,stack
		mov ss,ax
		mov sp,128
		
		mov ax,0b800h
		mov es,ax
		mov ah,'a'
		
	s:	mov es:[160*12+40*2],ah
		call delay			;调用子程序，使显示的字符延迟一段时间再显示下一个
		inc ah
		cmp ah,'z'
		jna s
		
		mov ax,4c00h
		int 21h
		
delay:	push ax
		push dx
		mov dx,1000h		;循环10000000h次，可以根据自己的机器速度调整循环次数
		mov ax,0
		
	s1:	sub ax,1			;ax借位1，所以CF=1
		sbb dx,0			;(dx)=(dx)-0-(CF)
		cmp ax,0			;判断低16位是否为0
		jne s1				;不是则继续到s1处循环
		cmp dx,0			;判断高16位是否为0
		jne s1				;不是则继续到s1处循环
		pop dx
		pop ax
		ret
		
code ends

end start