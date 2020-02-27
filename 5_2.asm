assume cs:mul_123x256

mul_123x256 segment

			mov ax,0
			mov cx,256
		s:  add ax,123
			loop s
			
			mov ax,4c00h
			int 21h
			
mul_123x256 ends

end

assume cs:mul_256x123

mul_256x123 segment

			mov ax,0
			mov cx,123
		s:  add ax,256
			loop s
			
			mov 4c00h
			int 21h
			
mul_256x123 ends

end