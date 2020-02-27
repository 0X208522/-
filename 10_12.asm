
;				10.12  """寄存器冲突问题"""

;设计一个子程序，功能：将一个全死字母，以0为结尾的字符串，转化为大写。
assume cs:code
data segment 

	db 'word',0
	db 'unix',0
	db 'wind',0
	db 'good',0
	
data ends

code segment

	start:	mov ax,data
			mov ds,ax
			mov bx,0
			
			mov cx,4			;作为外层循环s的次数，因为有4行字符串
								;也作为capital的循环次数,因为每行有4个字符
								;但此处cx有冲突，主程序要使用cx记录循环次数
								;可是子程序也使用了cx，在执行子程序的时侯
								;cx中保存的循环数值被改变，使得主程序的循环出错
								
		s:	mov si,bx
			call capital
			add bx,5			;指向下一行
			loop s 
			
			mov ax,4c00h
			int 21h
			
capital:	mov cl,[si]				;把数据段的数据依次放入cl中
			mov ch,0				;得以判断cx是否为0
			jcxz ok					;如果cx=0，跳到ok处执行；不为0，继续向下执行
			and byte ptr [si],11011111b		;把数据转为大写
			inc si
			jmp short capital
			
		ok:	ret
		
;修正冲突的代码如下：
;capital:	push cx					;保存主程序的循环cx，推入栈中，防止主程序cx的值被
;									;子程序修改
;			push si					;保存主程序的偏移地址si

;change:	mov cl,[si]				;把数据段的数据依次放入cl中
;			mov ch,0				;得以判断cx是否为0
;			jcxz ok					;如果cx=0，跳到ok处执行；不为0，继续向下执行
;			and byte ptr [si],11011111b		;把数据转为大写
;			inc si
;			jmp short change
			
;		ok:	pop si 					;用之前保存在栈中的值恢复为主程序的值
;			pop cx
;			ret
		
code ends

end start
