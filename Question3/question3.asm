section .data
    prompt db "Enter a number: ", 0
    result_msg db "Factorial: ", 0
    newline db 10, 0              ; Newline character for output formatting

section .bss
    num resb 3                   ; Buffer to store input number (allow 2 digits + null terminator)
    result resb 200              ; Buffer to store large result string (enough space for large factorials)

section .text
    global _start

; Entry point
_start:
    ; Display prompt
    mov eax, 4                   ; Syscall number for sys_write
    mov ebx, 1                   ; File descriptor (stdout)
    mov ecx, prompt              ; Address of the prompt
    mov edx, 15                  ; Length of the prompt
    int 0x80                     ; Make syscall

    ; Read user input
    mov eax, 3                   ; Syscall number for sys_read
    mov ebx, 0                   ; File descriptor (stdin)
    mov ecx, num                 ; Address to store input
    mov edx, 3                   ; Number of bytes to read (to allow for two digits + null terminator)
    int 0x80                     ; Make syscall

    ; Convert input (ASCII) to integer
    movzx eax, byte [num]        ; Load input into eax (zero-extend)
    sub eax, '0'                 ; Convert ASCII to integer
    mov edi, eax                 ; Move number to edi for factorial calculation

    ; Call factorial subroutine
    call factorial

    ; Convert factorial result to string for printing
    mov eax, edi                 ; Move factorial result to eax
    mov esi, result              ; Address of result buffer
    call int_to_string           ; Convert integer to string

    ; Display result message
    mov eax, 4                   ; Syscall number for sys_write
    mov ebx, 1                   ; File descriptor (stdout)
    mov ecx, result_msg          ; Address of the result message
    mov edx, 10                  ; Length of the result message
    int 0x80                     ; Make syscall

    ; Display result
    mov eax, 4                   ; Syscall number for sys_write
    mov ebx, 1                   ; File descriptor (stdout)
    mov ecx, result              ; Address of the result
    mov edx, 200                 ; Max length of result
    int 0x80                     ; Make syscall

    ; Print newline
    mov eax, 4                   ; Syscall number for sys_write
    mov ebx, 1                   ; File descriptor (stdout)
    mov ecx, newline             ; Address of newline character
    mov edx, 1                   ; Length of newline
    int 0x80                     ; Make syscall

    ; Exit program
    mov eax, 1                   ; Syscall number for sys_exit
    xor ebx, ebx                 ; Exit code 0
    int 0x80                     ; Make syscall

; Factorial subroutine
; Input: Number in edi
; Output: Result in edi
factorial:
    push ebp                    ; Save base pointer
    mov ebp, esp                ; Set up stack frame
    push ebx                    ; Preserve ebx (callee-saved register)

    ; Base case: if number <= 1, return 1
    cmp edi, 1
    jle base_case

    ; Recursive case: factorial(n) = n * factorial(n-1)
    mov ebx, edi                ; Save n in ebx
    sub edi, 1                  ; Compute n-1
    call factorial              ; Recursive call
    imul edi, ebx               ; Multiply n * factorial(n-1)
    jmp end_factorial

base_case:
    mov edi, 1                  ; Return 1 for base case

end_factorial:
    pop ebx                     ; Restore ebx
    pop ebp                     ; Restore base pointer
    ret                         ; Return to caller

; Integer to string conversion subroutine
; Input: Integer in eax
; Output: String at address in esi
int_to_string:
    mov ecx, 10                 ; Base 10
    xor edx, edx                ; Clear edx (remainder)
    mov ebx, esi                ; Save starting address of buffer
convert_digits:
    xor edx, edx                ; Clear edx
    div ecx                     ; Divide eax by 10
    add dl, '0'                 ; Convert remainder to ASCII
    mov [esi], dl               ; Store ASCII character in buffer
    inc esi                     ; Move buffer pointer
    test eax, eax               ; Check if eax is 0
    jnz convert_digits          ; If not, continue dividing
    mov byte [esi], 0           ; Null-terminate the string

    ; Reverse the digits
    dec esi                     ; Adjust pointer to last digit
    mov edi, ebx                ; Starting address of the buffer
reverse_string:
    cmp edi, esi                ; Check if pointers have crossed
    jge done_reverse            ; If yes, we're done
    mov al, [edi]               ; Load current character
    mov bl, [esi]               ; Load end character
    mov [edi], bl               ; Swap characters
    mov [esi], al               ; Swap characters
    inc edi                     ; Move start pointer forward
    dec esi                     ; Move end pointer backward
    jmp reverse_string
done_reverse:
    ret

; Documentation
; -------------------------------------------
; Explanation of Register Management and Stack Handling
; -------------------------------------------

; 1. **Register Usage**:
;    - Registers such as `eax`, `ebx`, `ecx`, `edx`, `edi`, and `esi` are used throughout the program to store intermediate values, perform calculations, and hold addresses for memory access.
;    - In particular, `eax` is commonly used for syscall numbers (e.g., sys_write, sys_read) and intermediate data (e.g., the factorial result). `ebx` is often used to hold the file descriptor for I/O syscalls (stdout, stdin), while `ecx` and `edx` are used to hold addresses and lengths of data.
;    - `edi` and `esi` are used for pointer manipulation, with `edi` typically holding the value passed into functions (e.g., the user input number for factorial calculation), and `esi` being used for buffers or other memory-related tasks (e.g., storing the address of the result buffer when converting numbers to strings).

; 2. **Stack Management**:
;    - The stack plays a crucial role in preserving the values of registers across function calls, particularly in recursive functions (like `factorial`) where the state of the registers needs to be maintained.
;    - In assembly, the stack is manually managed using `push` and `pop` instructions. This ensures that the values of registers are saved before entering a function (or before a recursive call) and restored before returning from the function.
;    - The `push` instruction saves the value of a register to the stack, and the `pop` instruction restores the value from the stack. This is particularly important for registers that are used across multiple function calls, such as `ebx` (callee-saved register) and `ebp` (base pointer used for managing stack frames).
;    - The stack is manipulated explicitly in the `factorial` function where `ebp` and `ebx` are pushed onto the stack at the start of the function to preserve their values across recursive calls. These values are restored before returning from the function.

; 3. **Preserving and Restoring Registers**:
;    - The primary purpose of stack management in this context is to **preserve** register values that would otherwise be overwritten during function calls or recursive invocations.
;    - For instance, before making a recursive call to calculate the factorial of a smaller number (`n-1`), the value in `ebx` (which stores the current value of `n`) is pushed onto the stack. This ensures that the value of `ebx` is not lost when the recursive function is called. Once the recursive call returns, the value in `ebx` is restored using the `pop` instruction.
;    - Similarly, the base pointer (`ebp`) is pushed onto the stack to save the stack frame before any other data is pushed. This allows the function to maintain stack consistency when entering and exiting nested function calls.

; 4. **Recursive Calls and Register Preservation**:
;    - In recursive functions, like `factorial`, it is essential to preserve register values between recursive calls, as the registers are overwritten with each new call. This could potentially lead to losing important values if not managed correctly.
;    - The `push` and `pop` instructions allow the program to maintain the correct values in registers across multiple recursive calls. Each recursive call in `factorial` pushes `ebx` and `ebp` onto the stack to preserve their values, then restores them as the function unwinds.
;    - The recursive process ensures that each call works on a separate set of values, and when the base case is reached, the function starts returning, with each call restoring the correct register values using the `pop` instructions before returning to the previous call level.

; 5. **Handling Register Corruption**:
;    - Without careful register preservation and stack management, register values can become corrupted during function calls, especially in recursive scenarios. This could lead to incorrect calculations, memory access violations, or other runtime errors.
;    - By explicitly saving and restoring registers using the stack (`push` and `pop`), the program ensures that the values in `ebx`, `ebp`, and other registers remain intact throughout the execution, even in cases of deep recursion or multiple function calls.

; 6. **Edge Cases and Register Management**:
;    - Special cases such as very large numbers (in factorial calculations), deep recursion, or unexpected values could result in stack overflow or register corruption if not handled carefully.
;    - The program is designed to minimize such risks by using the stack to preserve register values and restore them at the correct times. However, handling excessively large inputs or very deep recursion would require additional checks to avoid stack overflow or excessive memory use.

; 7. **Efficiency and Manual Management**:
;    - While the manual management of registers and stack space provides fine-grained control over the program's behavior, it also increases the complexity of the code.
;    - The lack of high-level abstractions means that every function call and recursion must be carefully designed to preserve the state of the registers. In higher-level languages, this process is typically handled automatically, but in assembly, the programmer must ensure that the state is explicitly managed.

; 8. **Conclusion**:
;    - In this assembly code, the stack is used to manage the preservation and restoration of registers, particularly in recursive functions like `factorial`. Through careful `push` and `pop` operations, the program ensures that register values are preserved across function calls, preventing corruption or loss of data during recursion.
;    - This technique is crucial for ensuring the correctness of the program and avoiding issues like register overwriting or stack corruption. It also provides an opportunity for optimization by minimizing the overhead of function calls and maintaining efficient control over memory and register usage.