;实验10			(4) dtoc2子程序
 
;应用举例：将数据2494967295以十进制的形式在屏幕的8行3列，用绿色显示出来。

assume cs:code,ds:data

data segment

     db 10 dup (0)

data ends

code segment

start:   mov ax,0ffffh

     mov dx,0ffffh

     mov bx,data

     mov ds,bx

     mov si,0 ;ds:si指向字符串首地址

     call dtoc2

 

     mov dh,8

     mov dl,3

     mov cl,2

     call show_str

 

     mov ax,4c00h

     int 21h

 

;名称：dtoc2

;功能：将dword型数据转变为表示十进制的字符串，字符串以0为结尾符。

;参数：(ax)=dword型数据的低16位；

;      (dx)=dword型数据的高16位；

;      ds:si指向字符串首地址。

;返回：无。

dtoc2:

     push ax

     push bx

     push cx

     push dx

     push si

     push di

     mov di,0

d20: mov cx,10     ;除数为10

     call divdw

     add cx,30h    ;余数+30h，转为字符

     push cx       ;字符入栈

     inc di        ;记录字符个数

     mov cx,ax 

     jcxz d21      ;低位商=0时，转到d21检测高位商

     jmp d20

d21: mov cx,dx

     jcxz d22      ;高低位商全=0时，转到d22执行

     jmp d20

d22: mov cx,di

d23: pop ax        ;字符出栈

     mov [si],al

     inc si        ;ds:si指向下一单元

     loop d23

     mov al,0

     mov [si],al   ;设置结尾符0

     pop di

     pop si

     pop dx

     pop cx

     pop bx

     pop ax

     ret

 

;名称：show_str

;功能：在指定的位置，用指定的颜色，显示一个用0结束的字符串。

;参数：(dh)=行号(取值范围0~24)；

;      (dl)=列号(取值范围0~79)；

;      (cl)=颜色；

;      ds:si指向字符串的首地址。

;返回：无。

show_str:

     push ax

     push bx

     mov ax,0b800h

     mov es,ax

     mov ax,160

     mul dh

     mov bx,ax ;bx=160*dh

     mov ax,2

     mul dl        ;ax=dl*2

     add bx,ax     ;mov bx,(160*dh+dl*2)设置es:bx指向显存首地址

     mov al,cl     ;把颜色cl赋值al

     mov cl,0

show0:

     mov ch,[si]

     jcxz show1    ;(ds:si)=0时，转到show1执行    

     mov es:[bx],ch

     mov es:[bx].1,al

     inc si        ;ds:si指向下一个字符地址

     add bx,2      ;es:bx指向下一个显存地址

     jmp show0

show1:

     pop bx

     pop ax

     ret

 

;名称：divdw

;功能：进行不会产生溢出的除法运算，被除数为dword型，除数为word型，结果为dword型。

;参数：(ax)=dword型数据的低16位；

;      (dx)=dword型数据的高16位；

;      (cx)=除数。

;返回：(dx)=结果的高16位；

;      (ax)=结果的低16位；

;      (cx)=余数。

divdw:

     push si

     push bx

     push ax

     mov ax,dx

     mov dx,0

     div cx        ;被除数的高位/cx

     mov si,ax

     pop ax 

     div cx        ;(被除数高位的商+低位)/cx

     mov cx,dx     ;余数入cx

     mov dx,si     ;高位的商入dx

     pop bx

     pop si

     ret

code ends

end start
