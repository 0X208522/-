
;		15_5		安装新的int9中断例程

;任务：安装一个新的int9中断例程
;功能：在DOS下，按F1键后改变当前屏幕的显示颜色，其他的键照常处理

;(1)改变屏幕的显示颜色
;改变从b8000h开始的4000个字节中的所有奇地址单元中的内容，当前屏幕的显示颜色即发生改变。
;程序如下：
	mov ax,0b800h
	mov es,ax
	mov bx,1
	mov cx,2000
	
s:	inc byte ptr es:[bx]
	add bx,2
	loop s 
	
;(2)其他键照常处理
;可以调用原int9中断处理程序，来处理其他键盘输入

;(3)原int9中断例程的安装
;我们可将新的int9中断例程安装在0:204处。
;完整程序如下：
assume cs:code

stack segment

	db 128 dup (0)
	
stack ends

code segment

start:	mov ax,stack
		mov ss,ax
		mov sp,128			;栈顶指针ss:sp指向栈顶
		
		push cs				;cs的值入栈
		pop ds				;把栈中cs的值赋给ds，使数据段与代码段处于同一段中
		
		mov ax,0
		mov es,ax
		
		mov si,offset int9	;设置ds:si指向源地址
		mov di,204h			;设置es:di指向目的地址
		mov cx,offset int9end-offset int9	;设置cx为传输长度
		cld					;设置传输方向为正
		rep movsb
		
		push es:[9*4]		;把原9号中断程序的偏移地址IP入栈
		pop es:[200h]		;然后出栈IP放到0:200h单元处
		push es:[9*4+2]		;把原9号中断程序的段地址CS入栈
		pop es:[202h]		;然后出栈CS放到0:202h单元处
		
		cli					;设置IF＝0屏蔽其他中断
		mov word ptr es:[9*4],204h		;把新的int9号中断例程的IP添加到中断向量表
		mov word ptr es:[9*4+2],0		;把新的int9号中断例程的CS添加到中断向量表
		sti					;设置IF＝1不屏蔽中断
		
		mov ax,4c00h
		int 21h
		
		
int9:	push ax
		push bx
		push cx
		push es
		
		in al,60h				;从端口60h读出键盘的输入
		
		pushf					;标志寄存器入栈
		call dword ptr cs:[200h];跳到原中断例程的入口地址执行原int9号中断例程
		;CS、IP入栈。(IP)=((cs)*16+200h)、(CS)=((cs)*16+202h)
		
		cmp al,3bh				;al与F1的扫描码比较，F1的扫描码为3bh
		jne int9ret				;不相等就跳转到int9ret处执行，相等就向下执行
		
		mov ax,0b800h
		mov es,ax
		mov bx,1
		mov cx,2000
		
	s:	inc byte ptr es:[bx]	;显存的所有奇地址加1，设置颜色属性
		add bx,2				;指向下一个奇地址
		loop s 
		
int9ret:
		pop es
		pop cx
		pop bx
		pop ax
		iret
		
int9end:
		nop
		
code ends

end start

;这一章通过对键盘输入的处理，讲解了CPU对外设输入的通常处理方法即：
;(1)外设的输入送入端口
;(2)向CPU发出外中断（可屏蔽中断）信息
;(3)CPU检测到可屏蔽中断信息，如果IF=1，CPU在执行完当前指令后响应中断，执行相应的中断
;例程
;(4)可在中断例程中实现对外设输入的处理

;端口和中断机制，是CPU进行I/O的基础。