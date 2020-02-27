
;		16_2	在其他段中使用数据标号

;一般来说，我们不在代码段中定义数据，而是将数据定义到其他段。在其他段，我们也可以使用数据
;来描述存储数据的单元的地址和长度。
;注意，在后面加有":"的地址标号，只能在代码段中使用，不能在其他段中使用

;下面的程序将data段中a标号处的8个数据累加，结果存储到b标号处的字中。

assume cs:code,ds:data

data segment

	a db 1,2,3,4,5,6,7,8
	b dw 0
	
data ends

code segment

start:	mov ax,data
		mov ds,ax
		
		mov si,0
		mov cx,8
		
	s:	mov al,a[si]	;a标号的数据放入al中
		mov ah,0		;置0防止ah中有数据影响ax的值
		add b,ax		;ax中的数据放入标号b处的字
		inc si
		loop s 
		
		mov ax,4c00h
		int 21h
		
code ends

end start

;注意，如果想在代码段中直接用数据标号访问数据，则需要用伪指令assume 将标号所在的段和
;一个段寄存器联系起来。否则，编译器在编译的时候，无法确定标号的段地址在哪一个寄存器中。
;当然，这种联系是编译器需要的，但绝对不是说，我们因为编译器的工作需要，用assume指令
;将寄存器和某个段相联系，段寄存器中就会真的存放该段的地址。我们在程序中还要使用指令对
;段寄存器进行设置

;比如，在上面的程序中，我们要在代码段code中用data段中的数据标号a、b访问数据，则必须
;用assume将一个寄存器和data段相联。在程序中，我们用ds寄存器和data段相联，则编译器
;对相关指令的编译如下：
;指令：mov al,a[si]		编译为：mov al,[si+0]
;指令：add b,ax 		编译为：add [8],ax

;因为这些实际编译出的指令，都默认所访问的段地址在ds中，而实际要访问的段为data，所以
;若要访问正确，在这些指令执行前，ds中必须为data段的段地址，则我们在程序中使用指令：
mov ax,data
mov ds,ax
;设置ds指向data段

;可以将标号当作数据来定义，此时，编译器将标号所表示的地址当作数据的值。比如：
data segment
	a db 1,2,3,4,5,6,7,8
	b dw 0
	c dw a,b 
data ends
;数据标号c处存储的两个字型数据为标号a、b的偏移地址。相当于：
data segment
	a db 1,2,3,4,5,6,7,8
	b dw 0
	c dw offset a,offset b
data ends

;再比如：
data segment
	a db 1,2,3,4,5,6,7,8
	b dw 0
	c dd a,b 
data ends
;数据标号c处存储的两个双字型数据为标号a的偏移地址和段地址、标号b的偏移地址和段地址。
;相当于：
data segment
	a db 1,2,3,4,5,6,7,8
	b dw 0
	c dw offset a,seg a,offset b,seg b 
data ends
;seg 操作符，功能为取得某一标号的段地址。