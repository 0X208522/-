;实验11（letterc子程序）小写改成大写

;编写一个子程序，将包含任意字符，以0结尾的字符串的小写字母转变成大写字母

;程序二：参考书中P143页内容，有更好的办法，无需用到寄存器。

;可以用and直接修改内存，将ASCII码的第5位置为0，变为大写字母。
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
			
letterc:	push si
	let:	cmp byte ptr [si],0
			je let0
			cmp byte ptr [si],61h
			jb let1
			cmp byte ptr [si],86h
			ja let1
			and byte ptr [si],11011111b			;ASCII码的第5位置为0，转为大写
			
	let1:	inc si
			jmp let
			
	let0:	pop si
			ret
			
code ends

end begin