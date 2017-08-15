org 100h    
 .data  
     base DB 40, ?, 40 DUP ('-'),'$'     
     l1 db 40, ?, '|', 38 DUP(' '),'|$'  
     l2 db 40, ?, '|', 38 DUP(' '),'|$'
     l3 db 40, ?, '|', 38 DUP(' '),'|$'
     l4 db 40, ?, '|', 38 DUP(' '),'|$'
     l5 db 40, ?, '|', 38 DUP(' '),'|$'
     l6 db 40, ?, '|', 38 DUP(' '),'|$'
     l7 db 40, ?, '|', 38 DUP(' '),'|$'
     l8 db 40, ?, '|', 38 DUP(' '),'|$'   
              
LF equ 0Ah ;line feed
CR equ 0Dh ;carriage return

.code

print macro msg
    LEA DX, [msg]
    MOV AH,09h
    INT 21h
endm 
                       
;mosntro 2ah
;tiro 07h
;carinha 10h              
              
main proc near
  
 LINE DW 04h 
 TIROS DW 0h
 INI_M_TIRO DW 643h
 aux_zera DW 643h

 mov cx, 0h      
 
 ;mov bx, 132h ; = na memoria 07 132h
 ;mov [bx], '-'
 call zeraTabela
 jmp PEGA_TECLA
main endp  
         
zeraTabela proc
 cmp cx, 0x64
 je  PEGA_TECLA
 mov bx, aux_zera 
 
 mov [bx], 0h
 inc aux_zera
 inc cx
 jmp zeraTabela
zeraTabela endp          
          
PEGA_TECLA:  

 call tela
 MOV AH, 01
 INT 21H
 ;CMP     AL, "'"
 ;JE      quit    
 
 
 CMP     AL, 77h
 JE      up   
 
 CMP     AL, 73h
 JE      down 
 
 CMP     AL, 20h
 JE      tiro   ;2ah
 
 JMP     PEGA_TECLA 

;;
;;EM TESTE
;;
;;

tiro proc near  
 inc TIROS      
 
 ;se tiro esta na linha 1
 cmp LINE, 01h
 je tiro_l1 
 
 cmp LINE, 02h
 je tiro_l2 
 
 cmp LINE, 03h
 je tiro_l3; 392 428
 
 cmp LINE, 04h
 je tiro_l4; 435 471 
 
 cmp LINE, 05h
 je tiro_l5; 478 514 

 cmp LINE, 06h
 je tiro_l6; 521 557

 cmp LINE, 07h
 je tiro_l7; 564 600

 cmp LINE, 08h
 je tiro_l8; 607 643
    
tiro endp                

tiro_l1 proc 
 ;bx guarda posicao inicial do tiro
 mov cx, 0132h;306   
 ;cx guarda posicao final do tiro
 mov dx, 0342h;156h;342
 jmp arm_memory
tiro_l1 endp           

tiro_l2 proc 
 mov cx, 015Dh ;349   
 mov dx, 0181h ;385
 jmp arm_memory
tiro_l2 endp

tiro_l3 proc 
 mov cx, 0188h ;392  
 mov dx, 01ACh ;428
 jmp arm_memory
tiro_l3 endp

tiro_l4 proc 
 mov cx, 01B3h ;435   
 mov dx, 01D7h ;471
 jmp arm_memory
tiro_l4 endp

tiro_l5 proc 
 mov cx, 01DEh ;478   
 mov dx, 0202h ;514
 jmp arm_memory
tiro_l5 endp

tiro_l6 proc 
 mov cx, 0209h ;521   
 mov dx, 022Dh ;557
 jmp arm_memory
tiro_l6 endp

tiro_l7 proc 
 mov cx, 0234h ;564   
 mov dx, 0258h ;600
 jmp arm_memory
tiro_l7 endp

tiro_l8 proc 
 mov cx, 025Fh ;607   
 mov dx, 0283h ;643
 jmp arm_memory
tiro_l8 endp

arm_memory proc;armazena tiro na tabela 
 add INI_M_TIRO, 6h
 
 mov bx, INI_M_TIRO 
 cmp [bx], 1
 je arm_memory;encontra espaco desativado
 
 mov [bx], 1 ;tiro ativado
 mov [bx + 2], cx;cx;pos ini
 mov [bx + 4], dx;;dx;pos fim     
 ;atualiza inicio_memoria  
 
 mov INI_M_TIRO, 643h
 mov cx, TIROS
 jmp arm_matriz 
           
arm_memory endp

updateTiro proc;incrementar caminho do tiro  

 cmp cx, 0h
 je PEGA_TECLA
 add INI_M_TIRO, 6h  
 
 mov bx, INI_M_TIRO
 cmp [bx], 0
 je updateTiro
 dec cx
 
 ;na tela
 mov bx, [bx+2]
 mov [bx+1], '-'
 mov [bx], ' ' 
 
 ;na memoria  
 mov bx, INI_M_TIRO
 mov dx, [INI_M_TIRO+2]
 inc dx 
 mov [bx + 2], dx

 
 cmp cx, 0h
 je PEGA_TECLA
 jmp updateTiro
 
updateTiro endp                 
              
arm_matriz proc;armazena tabela na matriz
 cmp cx, 0h
 je PEGA_TECLA
 add INI_M_TIRO, 6h
 
 mov bx, INI_M_TIRO
 cmp [bx], 0
 je arm_matriz;mostra so ativados      
 
 mov bx, [bx+2]
 mov [bx], '-'
 
 dec cx
 cmp cx, 0h
 je PEGA_TECLA
 jmp arm_matriz

arm_matriz endp

    
                           
              
  
           
;;
;; FUNCIONANDO
;;
;;
   
up proc near
 cmp LINE,01h
 je PEGA_TECLA    
 jmp verLine 
up endp


down proc near
 cmp LINE, 08h
 je PEGA_TECLA
 jmp verLine
down endp


verLine proc near
 
 cmp LINE, 01h
 je stack_p1
 
 cmp LINE, 02h
 je stack_p2  
 
 cmp LINE, 03h
 je stack_p3
 
 cmp LINE, 04h
 je stack_p4 
 
 cmp LINE, 05h
 je stack_p5 

 cmp LINE, 06h
 je stack_p6

 cmp LINE, 07h
 je stack_p7

 cmp LINE, 08h
 je stack_p8
 
 
verLine endp
         
         
stack_p1 proc near
 
 push 000    ; cima -   
 push 348    ; baixo l2
 push 305    ; atual l1
 cmp  AL, 73h 
 je atualizaDw
stack_p1 endp
             
      
stack_p2 proc near
    
 push 305   ; cima  l1
 push 391   ; baixo l3
 push 348   ; atual l2
 cmp  AL, 77h
 je atualizaUp
 jmp atualizaDw
 
stack_p2 endp             

stack_p3 proc near

 push 348   ; cima  l2
 push 434   ; baixo l4
 push 391   ; atual l3
 cmp  AL, 77h
 je atualizaUp
 jmp atualizaDw
 
stack_p3 endp

stack_p4 proc near
 
 push 391   ; cima  l3
 push 477   ; baixo l5
 push 434   ; atual l4
 cmp  AL, 77h
 je atualizaUp
 jmp atualizaDw
 
stack_p4 endp

stack_p5 proc near 

 push 434   ; cima  l4
 push 520   ; baixo l6
 push 477   ; atual l5
 cmp  AL, 77h
 je atualizaUp
 jmp atualizaDw
 
stack_p5 endp

stack_p6 proc near 

 push 477   ; cima  l5
 push 563   ; baixo l7
 push 520   ; atual l6
 cmp  AL, 77h
 je atualizaUp
 jmp atualizaDw
 
stack_p6 endp  

stack_p7 proc near 

 push 520   ; cima  l6
 push 606   ; baixo l8
 push 563   ; atual l7
 cmp  AL, 77h
 je atualizaUp
 jmp atualizaDw
 
stack_p7 endp
  
stack_p8 proc near 

 push 563   ; cima  l7
 push 000   ; baixo 
 push 606   ; atual l8
 cmp  AL, 77h
 je atualizaUp
 jmp PEGA_TECLA
 
stack_p8 endp
             
atualizaUp proc near

 pop bx  ; linha atual
 mov [bx], ' '
 pop bx  ; linha de baixo
 pop bx  ; linha de cima
 mov [bx], 10h
 dec LINE
 jmp PEGA_TECLA
 
atualizaUp endp  

      
atualizaDw proc near

 pop bx  ; linha atual
 mov [bx], ' '
 pop bx  ; linha de baixo
 mov [bx], 10h
 pop bx  ; linha de cima
 
 inc LINE
 jmp PEGA_TECLA
 
atualizaDw endp
     
           
           
tela proc near  
    call pula
    print [base+2]    
    call pula
    print [l1+2]
    call pula
    print [l2+2]
    call pula
    print [l3+2]
    call pula
    print [l4+2]
    call pula
    print [l5+2] 
    call pula
    print [l6+2]    
    call pula
    print [l7+2]    
    call pula
    print [l8+2]    
    call pula
    print [base+2]    
    call pula
    
    mov INI_M_TIRO, 643h
    mov cx, TIROS
    cmp TIROS, 0
    jne updateTiro

    ret
    
tela endp

pula proc 
    MOV AH, 0006H ;pula linha e volta o carro
    MOV DL, LF
    INT 21H
    MOV AH, 0006H
    MOV DL, CR
    INT 21H
    ret
pula endp