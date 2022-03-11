    # Autor - Yossi Maatook

.data
    d: .string "%d"
    s: .string "%s"
    c: .string "%c"
    format_50_60:       .string "first pstring length: %d, second pstring length: %d\n"
    format_52:          .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
    format_53_54:       .string "length: %d, string: %s\n"
    format_55:          .string "compare result: %d\n"
    format_def:         .string "invalid option!\n"
    
    .align 8
    .L_SWITCH:
   .quad .L50_60
   .quad .L_DEF
   .quad .L52
   .quad .L55_53
   .quad .L54
   .quad .L55_53

.text
    
 .global run_func
 .type run_func, @function
 # rdi = operation, rsi = *p1, rdx = *p2   
run_func:
    leaq    -50(%rdi),%rdi                # normalize arg: rdi = rdi - 50
    cmpq    $0,%rdi
    jl      .L_DEF                        # if rdi < 50, go to defult
    cmpq    $10,%rdi
    je      .L50_60                       # if rdi = 60, go to 50_60 case
    cmpq    $5,%rdi
    jg      .L_DEF                        # if rdi > 55, go to defult
    cmpq    $1,%rdi
    je      .L_DEF                        # if rdi = 51, go to defult
    jmp     *.L_SWITCH(,%rdi,8)           # go the wanted case according to jump table
    
    
.L_DEF:                     
    leaq    format_def(%rip),%rdi         # wanted string to be printed
    xor     %rax,%rax
    call    printf
    ret
     

.L50_60: 
    mov     %rdx,%rdi                     # rdi = p2
    call    pstrlen                       # get p2 length
    mov     %rax,%rdx                     # rdx = p2 length
    
    mov     %rsi,%rdi                     # rdi = p1
    call    pstrlen                       # get p1 length
    mov     %rax,%rsi                     # rsi = p1 length

    leaq    format_50_60(%rip),%rdi       # wanted string to be printed
    xor     %rax,%rax
    call    printf
    ret
    
.L52:
    push    %rbp
    mov     %rsp,%rbp
    sub     $32, %rsp
    mov     %rsi,-16(%rbp)                # -16(%rbp) points to p1
    mov     %rdx,-8(%rbp)                 # -8(%rbp) points to p2
    
    leaq    s(%rip),%rdi                  # reading format
    leaq    -24(%rbp),%rsi                # set scanf to save input in -24(%rbp)
    xor     %rax,%rax
    call    scanf                         # -24(%rbp) = old char
    
    leaq    s(%rip),%rdi                  # reading format is char
    leaq    -32(%rbp),%rsi                # set scanf to save input in -32(%rbp)
    xor     %rax,%rax
    call    scanf                         # -32(%rbp) = new char
    
    
    mov     -16(%rbp),%rdi                # rdi points to p1  
    mov     -24(%rbp),%rsi                # rsi = old char
    mov     -32(%rbp),%rdx                # rdx = new char
    call    replaceChar                   # replace old char with new char in p1
              
    mov     -8(%rbp),%rdi                 # rdi = p2
    call    replaceChar                   # replace old char with new char in p2
    
    
    mov     -32(%rbp),%rdx                # rdx = old char
    mov     -16(%rbp),%rcx                # rcx = p1
    leaq    1(%rcx),%rcx                  # rcx points to the string part of p1
    mov     %rax,%r8                      # r8 = p2
    leaq    1(%r8),%r8                    # r8 points to the string part of p2

    
    leaq    format_52(%rip),%rdi          # wanted string to be printed
    xor     %rax,%rax
    call    printf                        # print wanted string
    
    mov     %rbp,%rsp
    pop     %rbp
    ret
        
.L53:
    call    pstrijcpy
    mov     -16(%rbp),%rdx                # rdx = p1
    movzbq  (%rdx),%rsi                   # rsi = p1 length
    inc     %rdx                          # rdx = p1's string
          
    leaq    format_53_54(%rip),%rdi       # wanted string to be printed
    xor     %rax,%rax
    call    printf
    
    mov     -8(%rbp),%rdx                 # rdx = p2
    movzbq  (%rdx),%rsi                   # rsi = p2 length
    inc     %rdx                          # rdx = p2's string
    
    leaq    format_53_54(%rip),%rdi       # wanted string to be printed
    xor     %rax,%rax
    call    printf
    
    mov     %rbp,%rsp
    pop     %rbp
    ret

.L54:
    push    %rdx
    movq    %rsi, %rdi                    # rdi = p1
    call    swapCase                      # swap case on p1
    movq    %rax, %rdx                    # rdx = p1 struct
    leaq    1(%rdx),%rdx                  # rdx = p1 swaped case string
    movzbq  (%rsi), %rsi                  # rsi = p1 length
    
    leaq    format_53_54(%rip),%rdi       # wanted string to be printed
    xor     %rax,%rax
    call    printf                        # print p1
    
    pop     %rdx
    movzbq  (%rdx), %rsi                  # rsi = p1 length
    movq    %rdx, %rdi                    # rdi = p2
    call    swapCase                      # swap case on p1
    leaq    1(%rdx),%rdx                  # rdx = p1 swaped case string
    
     
    leaq    format_53_54(%rip),%rdi       # wanted string to be printed
    xor     %rax,%rax
    call    printf                        # print p2
    ret
    
.L55_53:
    push    %rbp
    mov     %rsp,%rbp
    sub     $48, %rsp
    
    mov     %rdi, -48(%rbp)               # -48(%rbp)= operation
    mov     %rsi, -16(%rbp)               # -16(%rbp) points to p1
    mov     %rdx, -8(%rbp)                # -8(%rbp) points to p2
    
    movq     $0,-24(%rbp)                 # reset garbage value in -24(%rbp)
    leaq    d(%rip),%rdi                  # reading format
    leaq    -24(%rbp),%rsi                # set scanf to save input in -24(%rbp)
    xor     %rax,%rax
    call    scanf                         # -24(%rbp) = i
    
    movq     $0,-32(%rbp)                 # # reset garbage value in -32(%rbp)
    leaq    d(%rip),%rdi                  # reading format
    leaq    -32(%rbp),%rsi                # set scanf to save input in -32(%rbp)
    xor     %rax,%rax
    call    scanf                         # -32(%rbp) = j
    
    mov     -16(%rbp),%rdi                # rdi = p1
    mov     -8(%rbp),%rsi                 # rsi = p2
    mov     -24(%rbp),%rdx                # rdx = i
    mov     -32(%rbp),%rcx                # rcx = j

    cmp     $3,-48(%rbp)                   
    je      .L53                          # if operation = 53 go to its label

    call    pstrijcmp                     # else, operation = 55
    
    mov     %rax, %rsi                    # rsi = compare value between p1 and p2
    leaq    format_55(%rip),%rdi          # wanted string to be printed
    xor     %rax,%rax
    call    printf
    
.retrun_label:
    mov     %rbp,%rsp
    pop     %rbp
    ret
