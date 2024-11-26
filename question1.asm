section .data
    prompt db "Enter a number: ", 0
    positive db "POSITIVE", 0
    negative db "NEGATIVE", 0
    zero db "ZERO", 0

section .bss
    num resb 4         ; Reserve space for an integer (32-bit)
    input resb 4       ; Reserve space for ASCII input (assuming single-digit for simplicity)

section .text
    global _start

_start:
    ; Display the prompt to the user
    mov eax, 4              ; syscall number for sys_write
    mov ebx, 1              ; file descriptor (stdout)
    mov ecx, prompt         ; pointer to the prompt message
    mov edx, 15             ; length of the prompt message
    int 0x80                ; invoke syscall to write prompt to stdout

    ; Read user input from stdin
    mov eax, 3              ; syscall number for sys_read
    mov ebx, 0              ; file descriptor (stdin)
    mov ecx, input          ; store ASCII input here
    mov edx, 4              ; read up to 4 bytes (including newline)
    int 0x80                ; invoke syscall to read user input

    ; Convert ASCII input to integer
    movzx eax, byte [input] ; Move the first byte from input into eax, zero-extended
    sub eax, '0'            ; Convert ASCII '0'-'9' to integer by subtracting ASCII code of '0'
    mov [num], eax          ; Store the integer result in `num`

    ; Check if zero
    cmp dword [num], 0
    je .is_zero             ; Jump if Equal (je) to `.is_zero` if num is 0
                            ; This jump is chosen to handle the exact match with 0, allowing
                            ; the program to skip further checks and proceed directly to the zero case.

    ; Check if positive
    cmp dword [num], 0
    jg .is_positive         ; Jump if Greater (jg) to `.is_positive` if num > 0
                            ; Using `jg` here lets us immediately classify the input as positive,
                            ; avoiding further comparisons, and directing the flow to handle positive cases.

.is_negative:
    ; Output "NEGATIVE" if none of the above conditions are true
    mov ecx, negative       ; Set `ecx` to the "NEGATIVE" message pointer
    jmp .print              ; Unconditional Jump (jmp) to the `.print` section
                            ; `jmp` ensures that, after classification, the program proceeds
                            ; to output without unnecessary checks or redirections.

.is_zero:
    ; Output "ZERO" for input equal to 0
    mov ecx, zero           ; Set `ecx` to the "ZERO" message pointer
    jmp .print              ; Unconditional Jump (jmp) to the `.print` section
                            ; `jmp` allows a direct path to the output section, streamlining
                            ; control flow after determining the input type.

.is_positive:
    ; Output "POSITIVE" for positive input
    mov ecx, positive       ; Set `ecx` to the "POSITIVE" message pointer

.print:
    ; Print the message stored in `ecx`
    mov eax, 4              ; syscall number for sys_write
    mov ebx, 1              ; file descriptor (stdout)
    mov edx, 8              ; length of message to display
    int 0x80                ; invoke syscall to output the message

    ; Exit the program
    mov eax, 1              ; syscall for exit
    xor ebx, ebx            ; set exit code to 0
    int 0x80                ; invoke syscall to exit program
