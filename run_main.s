    # Autor - Yossi Maatook
.data
    d: .string "%d"
    s: .string "%s"

.text
    .global run_main
    .type run_main, @function

run_main:
    push    %rbp
    mov     %rsp,%rbp
    sub     $528, %rsp
    
    # reading first pstring
    leaq    d(%rip),%rdi        # read %d
    leaq    -256(%rbp),%rsi     # save size of pstring at start of it's addrres
    xor     %rax, %rax
    call    scanf
    
    leaq    s(%rip),%rdi        # read %s
    leaq    -255(%rbp),%rsi     # save after it's size in stack
    xor     %rax, %rax
    call    scanf
    
    leaq    -256(%rbp), %r10    # r10 point to the size
    movzbq   (%r10),%r10        # r10 has the size of string
    leaq    -255(%rbp), %r11    # r11 point to start of string
    leaq    1(%r11,%r10,1), %r10# r10 point to end of string
    movb    $0, (%r10)          # mark end of string with 0
    
    # reading second pstring
    leaq    d(%rip),%rdi        # read %d
    leaq    -512(%rbp),%rsi     # save size of pstring at start of it's addrres
    xor     %rax, %rax
    call    scanf
    
    leaq    -512(%rbp), %r10    # r10 point to the size
    movzbq   (%r10),%r10        # r10 has the size of string
    leaq    -511(%rbp), %r11    # r11 point to start of string
    leaq    1(%r11,%r10,1), %r10 # r10 point to end of string
    movb    $0, (%r10)            # mark end of string with 0
    
    leaq    s(%rip),%rdi        # read %s
    leaq    -511(%rbp),%rsi     # save after it's size in stack
    xor     %rax, %rax
    call    scanf
    
    # reading menu option
    leaq    d(%rip),%rdi        # read %d
    leaq    -528(%rbp),%rsi     # save menu option in -528(%rbp)
    xor     %rax, %rax
    call    scanf
    
    
    movq    -528(%rbp),%rdi     # first argument - menu option
    leaq    -256(%rbp),%rsi     # second argument - pointer to first pstring
    leaq    -512(%rbp),%rdx     # third argument - pointer to second pstring
    
    call    run_func
    
    mov     %rbp,%rsp
    pop     %rbp
    ret


    
    
