;实验11（letterc子程序）小写改成大写

;编写一个子程序，将包含任意字符，以0结尾的字符串的小写字母转变成大写字母。

;程序一：此题为小写改成大写，根据书P141页介绍，小写字母'a'-'z'对应ASCII码为61h-86h
;只要[61,86]这段区间里的ASCII减去20h，就改成了大写字母。
assume cs:code

data segment

	db "Seginner's ALL-purpose Symbolic Instruction Code.",'0'
	
data ends

code segment

begin:		mov ax,data
			mov ds,ax
			mov si,0				;ds:si指向data段第一个字节
		
			call letterc 			;调用子程序实现小写变大写
		
			mov ax,4c00h
			int 21h
		
letterc:	push ax
			push si
	let:	cmp byte ptr [si],0				;和0比较
			je let0							;如果等于0则跳转到let0，结束
			cmp byte ptr [si],61h			;和61h比较
			jb let1							;如果低于61h则转到let1,继续循环
			cmp byte ptr [si],86h			;和86h比较
			ja let1							;如果高于86h则转到let1，继续循环
			mov al,[si]						;把data段字符的ASCII码放入al
			sub al,20h						;转化为大写字母
			mov [si],al						;把转化后的大写字母放回data段原位置中
			
	let1:	inc si							;指向下一个字符
			jmp let
			
	let0:	pop si
			pop ax
			ret
			
code ends

end begin
