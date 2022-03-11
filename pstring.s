    # Autor - Yossi Maatook
.data
    d: .string "%d"
    s: .string "%s"
    format_error_input: .string "invalid input!\n"
.text

.global pstrlen
.type pstrlen, @function
# rdi = pstring pointer
pstrlen:
    push    %rbp
    mov     %rsp, %rbp
    
    movzbq  (%rdi),%rax                 # rax = recived pstring length
    
    mov     %rbp,%rsp
    pop     %rbp
    ret


.global swapCase
.type swapCase, @function
# rdi = pstring pointer
swapCase:
    push    %rbp
    mov     %rsp, %rbp
   
    movzbq  (%rdi), %rbx               # rbx = pstring length
    mov     %rdi, %rax                 # rax = pstring address


.swapCase_while_l1:
    cmp     $0, %rbx                   # compare length to 0
    jg      .swapCase_while_l2         # if length > 0, iterate on string and switch case every char
    
    mov     %rbp,%rsp                  # else, return
    pop     %rbp
    ret

.swapCase_while_l2:
    leaq    1(%rdi), %rdi              # point to next char on string
    
    movzbq  (%rdi),%r10                # get current char
    cmpb    $64, %r10b       
    ja      .bigger_64                 # if current char ascii value is bigger 64, keep checking
    
                                       # else, its not a letter in the ABC and continue to next char:
                                
    dec     %rbx                       # pstring length--
    jmp     .swapCase_while_l1
    
.bigger_64:
    cmpb    $90, %r10b          
    ja      .bigger_90                 # if current char's ascii value is bigger than 91
    add     $32, (%rdi)                # else:  64 < ascii value < 91 so add 32 and upper case it. 
    jmp     .advance                   # go to next char
    
.bigger_90:
    cmpb    $96, %r10b
    ja      .bigger_96                 # if current char's ascii value is bigger than 96
    jmp     .advance                   # else, advance to next char

.bigger_96:
    cmpb    $123, %r10b
    jb      .low_case                  # if current char's:  96 < ascii value < 123, lower case it. 
    jmp     .advance                   # else, advance to next char

.low_case:
    subb     $32, (%rdi)               # subtract 32 from upper case letter to make it lower case
    
.advance:
    dec     %rbx                       # pstring length--
    jmp     .swapCase_while_l1         # go to next char
    
    

.global replaceChar
.type replaceChar, @function
# rdi = pstring pointer, rsi = old char, rdx = new char
replaceChar:
    push    %rbp
    mov     %rsp, %rbp
    mov     %rdi, %rax
   
    movzbq  (%rdi), %rcx               # rcx = pstring length
    
.replaceChar_condition:
    cmp     $0,%rcx
    jg      .replaceChar_while         # in case havent reached end of string
    
    mov     %rbp,%rsp                  # else, return
    pop     %rbp
    ret

.replaceChar_while:
    inc     %rdi                       # go to next char
    movzbq  (%rdi), %r10               # r10 = current char
    dec     %rcx                       # pstring length--
    cmp     %r10b, %sil                # compare current char to "old char"
    jne   .replaceChar_condition       # if diffrent, go to next char
    mov     %dl, (%rdi)                # else, replace current with old char
    jmp   .replaceChar_condition       # go to next char



.global pstrijcpy
.type pstrijcpy, @function
# rdi = p1, rsi = p2, rdx = i, rcx = j
pstrijcpy:
    push    %rbp
    mov     %rsp, %rbp

    call    is_valid                   # check if args are valid
    cmp     $1,%rax
    je      .cpy                       # if valid, go to cpy and execute the fucntion
    
    mov     $-2,%rax                   # else, return -2
    mov     %rbp,%rsp
    pop     %rbp
    ret
    
.cpy:
    leaq    (%rdi,%rdx),%rdi           # rdi points to p1[i]           
    leaq    (%rsi,%rdx),%rsi           # rsi points to p2[i]
    sub      %rdx, %rcx                # rcx = j - i
    
.pstrijcmp.while:
    inc     %rdi                       # advacne to next char
    inc     %rsi
    movzbq (%rsi), %r10                # r10 = p1[i] char
    movb    %r10b, (%rdi)              # p2[i] = p1[i]
    dec     %rcx                       # rcx--
    cmp     $0, %rcx                   # compare 0 to remainning length
    jge     .pstrijcmp.while           # in case havent reached the string endding, go to next char
    
    mov     %rbp,%rsp
    pop     %rbp
    ret
    

.global pstrijcmp
.type pstrijcmp, @function
# rdi = p1, rsi = p2, rdx = i, rcx = j
pstrijcmp:
    push    %rbp
    mov     %rsp, %rbp
   
    call    is_valid                   # check if args are valid
    cmp     $1,%rax                    
    je      .cmp                       # if valid, go to cpy and execute the fucntion
    
    mov     $-2,%rax                   # else, return -2
    mov     %rbp,%rsp
    pop     %rbp
    ret
    
.cmp:
    leaq    1(%rdi,%rdx),%rdi       # rdi points to p1[i]           
    leaq    1(%rsi,%rdx),%rsi       # rsi points to p2[i]
    sub     %rdx, %rcx              # rcx = j - i

.pstrijcmp.compare:
    movzbq  (%rdi), %r10            # r10 = p1[i] char
    movzbq  (%rsi), %r11            # r11 = p2[i] char
    cmpb    %r11b, %r10b
    je      .pstrijcmp_condition    # in case p1[i]=p2[i], go to next char
    ja      .return_p1_bigger       # elif p1[i]>p2[i], p1 is bigger
    mov     $-1, %rax               # else, p2 is bigger
    
    mov     %rbp,%rsp
    pop     %rbp
    ret
    
.return_p1_bigger:
    mov     $1, %rax                # return 1 - p1 is bigger
    
    mov     %rbp,%rsp
    pop     %rbp
    ret

.pstrijcmp_condition:
    inc     %rsi                    # go to next char on p2
    inc     %rdi                    # go to next char on p1
    dec     %rcx                    # rcx--
    cmp     $0, %rcx                # compare 0 to remainning length
    jge     .pstrijcmp.compare      # in case havent reached the string endding, go to next char
    
    mov     $0, %rax                # else, strings are equal
    
    mov     %rbp,%rsp
    pop     %rbp
    ret
  
  
.global is_valid
.type is_valid, @function
# rdi = p1, rsi = p2, rdx = i, rcx = j
# checks if recived args are valid - if i and j are in the p1 and p2 bounds and i<j.
# returns 1 if valid and -2 otherwise. 
is_valid:
    push    %rbp
    mov     %rsp, %rbp
    
    movzbq  (%rsi), %r10            # r10 = p1 length
    cmpb    %r10b,%dl        
    jge     .invalid_input          # in case i is out of p1 bound
    cmpb    %r10b,%cl
    jge     .invalid_input          # in case j is out of p1 bound

    movzbq  (%rdi), %r10            # r10 = p1 length
    cmpb    %r10b,%dl
    jge     .invalid_input          # in case i is out of p2 bound
    cmpb    %r10b,%cl
    jge     .invalid_input          # in case j is out of p2 bound
    
    cmp     %rdx, %rcx              
    jl      .invalid_input          # in case i > j
    
    mov     $1, %rax                # return args are valid
    mov     %rbp,%rsp
    pop     %rbp
    ret

  
.invalid_input:
    leaq    format_error_input(%rip),%rdi       
    xor     %rax,%rax
    call    printf
    mov     $-2,%rax                # return invalid
    
    mov     %rbp,%rsp
    pop     %rbp
    ret
