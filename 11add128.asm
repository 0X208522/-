;下面编写一个子程序，对两个128位数据进行相加。
;名称：add128
;功能：两个128位数据进行相加
;参数：ds:si指向存储第一个数的内存空间，因数据为128位，所以需要8个字单元，
;由低地址单元到高地址单元依次存放128位数据由低到高的各个字。运算结果存储在
;第一个数的存储空间
;ds:di指向存储第二个数的内存空间

add128:	push ax
		push cx
		push si
		push di
		
		sub ax,ax			;将CF设置为0
		
		mov cx,8
		
	s:	mov ax,[si]
		adc ax,[di]
		mov [si],ax
		inc si				;inc和loop不影响CF位，但add si,2;add di,2
		inc si				;add指令会影响CF位，所以不能用add代替inc
		inc di
		inc di
		loop s 
		
		pop di 
		pop si
		pop cx
		pop ax
		ret