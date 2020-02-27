assume cs:codesg,ds:datasg

datasg segment

	db 'BaSiC'
	db 'MinIX'
	
datasg ends

codesg segment

start:	mov ax,datasg
		mov ds,ax
		mov bx,0
		
		mov cx,5
		
	s:	mov al,[bx]		;定位第一个字符串中的字符,也可以写成0[bx]
		and al,11011111b
		mov [bx],al
		
		mov al,[5+bx]	;定位第二个字符串中的字符，也可以写成5[bx]
		or al,00100000b
		mov [5+bx],al
		inc bx
		loop s
		
			
		mov 4c00h
		int 21h
			
codesg ends

end start

;与C语言比较如下：
;char a[5]="BaSiC"
;char b[5]="MinIX"
;main（）
;{
;	int i;
;	i = 0;
;	do
;		{
;			a[i] = a[i]&0xDF;
;			B[I] = b[i]|0x20;
;			i++;
;		}
;	while(i < 5);
;}