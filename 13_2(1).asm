;			13.2	编写供应用程序调用的中断例程

;问题1，编写、安装中断程序7ch的中断例程

;功能：求一word型数据的平方
;参数：（ax）=要计算的数据
;返回值：dx、ax中存放结果的高16位和低16位
;应用举例：求2*3456^2

assume cs:code

code segment

start:	mov ax,3456
		int 7ch				;调用中断7ch，计算ax中的数据的平方
		add ax,ax			;中断程序需要用另外的代码添加到中断向量表中才能调用
							;即中断例程7ch的安装程序（在13_2(2).asm中）
		adc dx,dx			;带进位加法指令，这条语句相当于
							;（dx）=（dx）+（dx）+CF(标志寄存器)
		
		mov ax,4c00h
		int 21h
		

		
code ends

end start