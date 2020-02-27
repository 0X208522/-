
;		16	直接定址表

;这一章，我们讨论如何有效合理地组织数据，以及相关的编程技术

;		16_1	描述了单元长度的标号
;前面的课程中，我们一直在代码段中使用标号来标记指令、数据、段的起始地址。比如，下面的
;程序将code段中的a标号处的8个数据累加，结果存储到b标号处的字中。

assume cs:code

code segment 

	a: db 1,2,3,4,5,6,7,8
	b: dw 0
	
	
start:	mov si,offset a		;获取标号a的偏移地址，放入si
		mov bx,offset b		;获取标号b的偏移地址，放入bx
		
		mov cx,8		;传输长度
		
	s:	mov al,cs:[si]	;a中的数据放入al
		mov ah,0		;为防止ax中的ah有其他数据，所以先把ah置0
		add cs:[bx],ax	;把ax中的数据放入b中
		inc si			;指向下一个数据
		loop s 
		
		mov ax,4c00h
		int 21h
		
code ends

end start

;程序中，code、a、b、start、s都是标号。这些标号仅仅表示了内存单元的地址。但是，我们还
;可以使用一种标号，这种标号不但表示内存单元的地址，还表示了内存单元的长度，即表示在此
;标号处的单元，是一个字节单元，还是字单元，还是双字单元。上面的程序还可以写成：

assume cs:code

code segment

	a db 1,2,3,4,5,6,7,8
	b dw 0
	
start:	mov si,0
		mov cx,8
		
	s:	mov al,a[si]
		mov ah,0
		add b,ax
		inc si
		loop s 
		
		mov ax,4c00h
		int 21h
		
code ends

end start

;在code段中使用的标号a、b后面没有":",它们是同时描述内存地址和单元长度的标号。标号a
;描述了地址code:0,和从这个地址开始，以后的内存单元都是字节单元；而标号b描述了地址
;code:8，和从这个地址开始，以后的内存单元都是字单元。

;因为这种标号包含了对单元长度的描述，所以在指令中，它可以表示一个段中的内存单元。
;比如：对于程序中的"b dw 0":
;指令：mov ax,b 相当于：mov ax,cs:[8]
;指令：mov b,2	相当于：mov word ptr cs:[8],2
;指令：inc b	相当于：inc word ptr cs:[8]
;在这些指令中，标号b代表了一个内存单元，地址为code:8，长度为两个字节

;下面的指令会引起编译错误：
mov al,b 
;因为b代表的内存单元是字单元，而al是8位寄存器。
;如果我们将程序中的指令"add b,ax",写为"add b,al",将出现同样的编译错误
;对于程序中的"a db 1,2,3,4,5,6,7,8":
;指令：mov al,a[si]		 相当于：mov al,cs:0[si]
;指令：mov al,a[3]		 相当于：mov al,cs:0[3]
;指令：mov al,a[bx+si+3] 相当于：mov al,cs:0[bx+si+3]

;可见，使用这种包含单元长度的标号，可以使我们以简洁的形式访问内存中的数据。以后
;我们将这种标号称为数据标号，它标记了存储数据单元的地址和长度。它不同于仅仅表示
;地址的地址标号。
