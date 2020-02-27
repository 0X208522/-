assume cs:abc

abc segment

	mov ax,0
	mov ds,ax
	mov ds:[26h],ax
	
	mov ax,4c00h
	int 21h
	
abc ends

end