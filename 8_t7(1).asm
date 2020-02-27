assume cs:code,ds:data,es:table

data segment

    db '1975','1976','1977','1978','1979','1980','1981','1982','1983'

    db '1984','1985','1986','1987','1988','1989','1990','1991','1992'

    db '1993','1994','1995' ;以上是表示21年的21个字符串   dx 0-53h
        

    dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514

    dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
	 ;以上是表示21年公司总收入的21个dword型数据   54h-0A7h

    dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226

    dw 11452,14430,15257,17800 ;以上是表示21年公司雇员人数的21个word型数据   0A8-0D1

data ends

table segment

    db 21 dup ('year summ ne ?? ')

table ends

code segment 

start:  mov ax,data 

        mov ds,ax 
		

        mov ax,table 

        mov es,ax 
		

        mov bx,0 

        mov si,0 

        mov di,0 

        mov cx,21 
		

s:      mov ax,[bx]

        mov es:[si],ax   ;因为年份是4个字节，所以需要分两次才能传送完全年份的值

        mov ax,[bx].2

        mov es:[si].2,ax   ;年份完全传送完成
        

 

        mov ax,[bx].84			;传送总收入

        mov es:[si].5,ax

        mov dx,[bx].86

        mov es:[si].7,dx    ;操作方式同年份，因为占两个字型数据。
							;同时由于是dword数据，所以低位存储ax，高位存储dx
 

        div word ptr ds:[di].168

        mov es:[si].13,ax

        

        mov ax,[di].168     ;此处不能用bx，因为bx是4个字节的跳动，
							;用BX到0A8开始就会出错，所以用di,因为di自加2
        mov es:[si].10,ax

 

        add di,2

        add bx,4

        add si,16

        loop s 

 

        mov ax,4c00h 

        int 21h 

code ends 

end start 

