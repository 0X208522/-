
;			14_4(1)	CMOS RAM中存储的时间信息

;编程，在屏幕中间显示当前的月份
;分析，这个程序主要做以下两部分工作。

;(1)从CMOS	RAM的8号单元读出当前月份的BCD码。
;要读取CMOS	RAM的信息，首先要向地址端口70h写入要访问的单元的地址：
mov al,8
out 70h,al
;然后从数据端口71h中取得指定单元中的数据：
in al,71h

;(2)将用BCD码表示的月份以十进制的形式显示到屏幕上。
;我们可以看出，BCD码值=十进制数码值，则BCD码值+30h=十进制数对应的ASCII码。

;从CMOS RAM的8号单元读出的一个字节中，包含了用两个BCD码表示的两位十进制数，高4位的BCD表示
;十位，低4位的BCD码表示个位。比如，00010100b表示14

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;我们需要进行以下两步工作：
;1.将从CMOS RAM的8号单元中读出的一个字节，分为两个表示BCD码值的数据。
mov ah,al				;al中为从CMOS RAM的8号单元中读出的数据
mov cl,4
shr ah,cl				;ah中为月份的十位数码值
and al,00001111b		;al中为月份的个位数码值

;2.显示(ah)+30h和(al)+30h对应的ASCII码字符。

assume cs：code

code segment

start:	mov al,8
		out 70h,al			;向70h地址端口写入要读取的8号单元
		in al,71h			;读取数据端口71h的数据进al
		
		mov ah,al			;al中为从CMOS RAM的8号单元中读出的数据
		mov cl,4
		shr ah,cl			;右移4次之后ah中为月份的十位数码值，个位的被丢掉了
		and al,00001111b	;把8号单元中的原始数据高位置0，只留下个位的BDC码
							;al中为月份的个位数码值
							
		add ah,30h			;显示月份的十位数码转化为对应的ASCII码
		add al,30h			;显示月份的个位数码转化为对应的ASCII码
		
		mov bx,0b800h			;显存地址
		mov es,bx
		
		mov byte ptr es:[160*12+40*2],ah		;显示月份的十位数码
		mov byte ptr es:[160*12+40*2+2],al		;接着显示月份的个位数码
		
		mov ax,4c00h
		int 21h
		
code ends

end start