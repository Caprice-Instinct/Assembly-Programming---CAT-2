section .data
    prompt db "Enter 5 numbers: ", 0      ; Prompt message asking user for input
    result_msg db "Reversed array: ", 0    ; Message to display after reversing the array
    newline db 10, 0                       ; Newline character for output formatting

section .bss
    array resb 20                          ; Reserve 20 bytes of memory to store input (5 numbers + spaces)

section .text
    global _start

_start:
    ; Display prompt to the user
    mov eax, 4                             ; Syscall number for sys_write (to display the prompt)
    mov ebx, 1                             ; File descriptor (stdout)
    mov ecx, prompt                        ; Address of the prompt message
    mov edx, 16                            ; Length of the prompt message
    int 0x80                               ; Make syscall to display the prompt

    ; Read user input (5 numbers with spaces)
    mov eax, 3                             ; Syscall number for sys_read (to read user input)
    mov ebx, 0                             ; File descriptor (stdin)
    mov ecx, array                         ; Address of the array where input will be stored
    mov edx, 20                            ; Max bytes to read (20 bytes for 5 numbers and spaces)
    int 0x80                               ; Make syscall to read input into the array

    ; Reverse the array in place
    lea esi, [array]                       ; Load the address of the start of the array into esi
    lea edi, [array + 19]                  ; Load the address of the end of the array into edi (20 bytes - 1)
    sub edi, 1                             ; Point to the last character (ignoring newline or additional space at the end)

reverse_loop:
    ; Check if the pointers have crossed (end of the array reached)
    cmp esi, edi                           ; Compare the start pointer (esi) with the end pointer (edi)
    jge done_reversing                     ; If pointers have crossed or met, we are done reversing

    ; Load characters from both ends of the array
    mov al, byte [esi]                     ; Load the byte at the start (esi) into al
    mov bl, byte [edi]                     ; Load the byte at the end (edi) into bl

    ; Swap the characters
    mov byte [esi], bl                     ; Store the byte from the end (bl) at the start (esi)
    mov byte [edi], al                     ; Store the byte from the start (al) at the end (edi)

    ; Move the pointers towards each other
    inc esi                                ; Increment esi to move towards the middle (move right)
    dec edi                                ; Decrement edi to move towards the middle (move left)

    jmp reverse_loop                       ; Repeat the loop to continue reversing

done_reversing:
    ; Output the result message
    mov eax, 4                             ; Syscall number for sys_write (to display the result message)
    mov ebx, 1                             ; File descriptor (stdout)
    mov ecx, result_msg                    ; Address of the result message
    mov edx, 16                            ; Length of the result message
    int 0x80                               ; Make syscall to display the result message

    ; Output the reversed array
    mov eax, 4                             ; Syscall number for sys_write (to display the reversed array)
    mov ebx, 1                             ; File descriptor (stdout)
    lea ecx, [array]                       ; Address of the reversed array
    mov edx, 20                            ; Length of the array to output (20 bytes)
    int 0x80                               ; Make syscall to display the reversed array

    ; Print newline for better formatting
    mov eax, 4                             ; Syscall number for sys_write (to display a newline character)
    mov ebx, 1                             ; File descriptor (stdout)
    mov ecx, newline                       ; Address of the newline character
    mov edx, 1                             ; Length of the newline character (1 byte)
    int 0x80                               ; Make syscall to print newline

    ; Exit program
    mov eax, 1                             ; Syscall number for sys_exit (to exit the program)
    xor ebx, ebx                           ; Exit code 0 (no error)
    int 0x80                               ; Make syscall to exit the program

; Documentation
; -------------------------------------------
; Explanation of Challenges with Handling Memory Directly
; -------------------------------------------

; 1. **Memory Management**:
;    - The primary challenge in handling memory directly is managing the space allocated for storing the user input. In this code, the `array` is reserved with 20 bytes, which is enough to store the input (5 numbers and 4 spaces or newline characters).
;    - If the user enters more than 20 bytes, it would lead to a buffer overflow, overwriting adjacent memory. Ensuring that the buffer is large enough to accommodate the expected input is critical, and handling any overflow requires additional checks (e.g., validating the length of input).
;    - In assembly, there are no automatic bounds checks, so the programmer must be careful to manage the available memory properly.

; 2. **Pointer Management**:
;    - The program uses two pointers (`esi` and `edi`) to traverse the array from opposite ends, performing swaps. Direct memory access through registers allows for efficient manipulation but requires careful pointer handling.
;    - One challenge is ensuring that the pointers do not go out of bounds. If either `esi` or `edi` crosses the other, it could result in reading or writing data outside the allocated memory, potentially leading to corruption or program crashes.
;    - The loop stops once `esi` and `edi` meet or cross, which is a simple check (`cmp esi, edi`) to prevent further out-of-bounds access. However, the programmer must account for the memory layout and ensure that the start and end pointers are correctly initialized and moved.

; 3. **Direct Access and Performance**:
;    - Direct memory access is very fast and efficient, as there is no overhead of function calls or bounds checking. However, this also means the programmer must manually manage every aspect of the memory usage.
;    - In high-level programming languages, functions like string reversal are built-in and abstract away the complexities of pointer management. In assembly, everything must be explicitly controlled, including the initialization of pointers, the loop conditions, and the bounds of the array.
;    - Additionally, since the input is directly written to the `array` from the user input buffer, careful handling is required to ensure that spaces or other non-digit characters are correctly processed and not treated as part of the numerical input.

; 4. **Array Reversal Logic**:
;    - The array reversal logic involves swapping bytes directly in memory. This requires loading a byte from one location, storing it in a register, and then writing it to another memory location. Any mistake in the memory locations or swap operations can result in corrupted data.
;    - The challenge is ensuring that memory writes happen correctly, especially since assembly does not provide abstractions for working with strings or arrays directly. If any pointer mismanagement occurs, it can result in memory being overwritten, losing part of the input or causing segmentation faults.

; 5. **Edge Cases**:
;    - Special cases such as input length mismatches, unexpected characters, or buffer overflows require manual handling. These would typically be handled by higher-level languages, but here, the programmer must carefully ensure the expected input format and manage the length of data being read and reversed.
;    - While this specific example works with 20 bytes, other cases (e.g., handling empty input, extremely large input, or incorrect formatting) would require additional checks to prevent issues.