;转移地址在内存中的jmp指令有两种格式：
;(1)	jmp word ptr 内存单元地址（段内转移）
;功能：从内存单元地址处开始存放着一个字，是转移的目的的偏移地址。如下：
mov ax,0123h
mov ds:[0],ax
jmp word ptr ds:[0]
;执行后，（ip）=0123h

;又如下面指令
mov ax,0123h
mov [bx],ax
jmp word ptr [bx]
;执行后，（ip）=0123h


;(2)	jmp dword ptr 内存单元地址（段间转移）
;功能：从内存单元地址处开始存放着两个字。
;高地址处的字是转移的目的地址的段地址，低地址处是转移的目的偏移地址。
;(CS)=(内存单元地址+2)
;(IP)=(内存单元地址)，如下：
mov ax,0123h
mov ds:[0],ax
mov word ptr ds:[2],0
jmp dword ptr ds:[0]
;执行后，（CS）=0，（IP）=0123h，CS:IP指向0000：0123h，CS

;又如下面指令：
mov ax,0123h
mov [bx],ax
mov word ptr [bx+2],0
jmp dword ptr [bx]
;执行后，（CS）=0，（IP）=0123h，CS：IP指向0000：0123h