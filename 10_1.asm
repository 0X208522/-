;call和ret指令都是转移指令，它们都修改IP，或同时修改CS和IP。
;它们经常被共同用来实现子程序的设计。

;ret指令用栈中的数据，修改ip的内容，从而实现近转移
;retf指令用栈中的数据，修改CS和IP的内容，从而实现远转移

;CPU执行ret指令时,操作如下：
;(1)(IP)=(ss)*16+(SP)
;(2)(SP)=(SP)+2
;相当于pop IP,用'栈'中的数据，修改ip的内容，从而实现近转移


;CPU执行retf指令时,操作如下：
;(1)(IP)=(ss)*16+(sp)
;(2)(sp)=(sp)+2
;(3)(CS)=(ss)*16+(sp)
;(4)(sp)=(sp)+2
;相当于pop IP,用'栈'中的数据，修改CS和IP的内容，从而实现远转移
;pop CS
assume cs:code

stack segment				;定义栈段

	db 16 dup (0)
	
stack ends

code segment

		mov ax,4c00h		;这两句是返回语句
		int 21h
		
start:	mov ax,stack
		mov ss,ax		;使ss指向栈段
		mov sp,16		;使栈顶指针ss:sp指向栈底
		mov ax,0
		push ax			;把ax的值0推入栈中
		mov bx,0
		ret 			;相当于pop IP,即把刚刚推入栈中的数据（ax）赋值给IP
						;因ax=0，所以ip=0
						;ret指令执行后，(ip)=0,CS:IP指向代码段的第一条指令
						;代码的第一条指令即前面说的那两条返回语句，此时程序可以正常退出
code ends

end start				;start是程序的入口 