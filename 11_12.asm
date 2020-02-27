
;			11.12		标志寄存器在Debug中的表示

;下面列出Debug对我们已知的标志位的表示。

;标志					值为1的标志					值为0的标志
; of						OV							NV
; sf						NG							PL
; zf						ZR							NZ
; pf						PE							PO
; cf						CY							NC
; df						DN							UP


;	零标志位	方向标志位(未知)正负标志位	零标志位 (未知)奇偶标志位（1的个数）	进位标志位
;		OF			DF				SF			ZF				PF						CF
;		NV	  		UP 		EI		PL			NZ		NA		PO						NC	