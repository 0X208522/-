;第八章，实验七：寻址方式在结构化访问中的应用
assume cs:code,ds:data,es:table

data segment

	db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
	db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
	db '1993','1994','1995' ;以上是表示21年的21个字符串   dx 0-53h
	
	dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
	dd 345980,590827,803530,1183000,1843000,2759000,3757000,4649000,5937000
	;以上是表示21年公司总收入的21个dword型数据   54h-0A7h
	
	dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
	dw 11452,14430,15257,17800
	;以上是表示21年公司雇员人数的21个word型数据   0A8-0D1
	
data ends

table segment
	
	db 21 dup ('year summ ne ??')				;每行 year summ ne ??为16个字节，共21行。
	
table ends

code segment
	
start:	mov ax,data
		mov ds,ax
		
		mov ax,table
		mov ss,ax
		
		mov bx,0
		mov si,0
		mov bp,0
		
		mov cx,21
		
	s0:	mov ax,[bx+si]			;s0是按列传送年份的循环
		mov [bp+0],ax			;0为栈段的第1个字节个字节
		add si,2
		mov ax,[bx+si]
		mov [bp+2],ax			;2为栈段的第3个字节
		add si,2
		add bp,10h				;10h即为16，一行16个字节
		loop s0
		
		mov cx,21
		mov bp,0
		mov si,0
		
	s1:	mov ax,[bx+si+84]		;按列传送总收入，84即为54h
		mov [bp+5],ax			;把数据段的数据放入栈段中
		add si,2
		mov ax,[bx+si+84]
		mov [bp+7],ax
		add si,2
		add bp,10h
		loop s1
		
	s2:	mov ax,[bx+si+168]		;按列传送雇员人数，168即为A8h
		mov [bp+10],ax
		add si,2
		add bp,10h
		loop s2
		
	s3:	mov ax,[bp+5]
		mov dx,[bp+7]
		div word ptr [bp+10]
		mov [bp+13],ax
		add bp,10h
		loop s3
		
		mov ax,4c00h
		int 21h
		
code ends

end start