# ICS3203-CAT2-Assembly-Wabuga Linet Wangui 151496

This repository contains assembly language programs developed for **ICS3203 CAT 2**, demonstrating key concepts such as **control flow**, **array manipulation**, **modular programming**, and **port-based simulation**. The following tasks are included in the submission, each addressing different aspects of assembly language programming. 

## How to Compile and Run the Programs on Ubuntu

To compile and execute assembly programs on an Ubuntu system, follow these steps:

### 1. Install Required Tools
Ensure that **NASM** (Netwide Assembler) and **ld** (GNU Linker) are installed. Use the following command to install them:
```bash
sudo apt update
sudo apt install nasm build-essential
```


### 2. Clone the Repository
Download the repository containing the assembly programs. If you don't have the repository URL yet, you can clone it from GitHub using:
```bash
git clone <repository_url>
```

### 3. Navigate to the Program Directory
Once the repository is cloned, navigate to the directory containing the assembly program:

```bash
cd <repository_folder>
```

### 4. Compile the Program
Use NASM to assemble the program into an object file. Replace `program_name.asm` with the actual assembly file name:

```bash
nasm -f elf64 program_name.asm -o program_name.o
```

### 5. Link the Object File
Use the `ld` (GNU Linker) to link the object file and create an executable:

```bash
ld program_name.o -o program_name
```

### 6. Run the Program
Now, you can run the compiled program with the following command:

```bash
./program_name
```
## Programs Overview

### Task 1: Control Flow and Conditional Logic 
#### Purpose
This program takes a user input number and classifies it as **POSITIVE**, **NEGATIVE**, or **ZERO** using **conditional** and **unconditional jumps**. 
The program demonstrates the use of control flow instructions such as `je` (jump if equal), `jg` (jump if greater), and `jmp` (unconditional jump) to handle branching logic for the classification of numbers.

#### Instructions:
1. The user is prompted to input a number.
2. Based on the input, the program classifies the number into one of the following categories:
   - **POSITIVE** if the number is greater than zero.
   - **NEGATIVE** if the number is less than zero.
   - **ZERO** if the number is exactly zero.
3. The program uses branching instructions (`je`, `jg`, `jmp`) to determine the appropriate action, demonstrating the handling of conditional jumps and efficient program flow.

#### Explanation of Jump Instructions and Program Flow

#### `jg` (Jump if Greater)
- **Purpose**: Checks if the input number is positive.
- **How it Works**: Compares the input to zero; if greater, jumps to the block for positive classification.
- **Role**: Skips unnecessary checks and directly processes the number as positive.

#### `je` (Jump if Equal)
- **Purpose**: Checks if the input number is zero.
- **How it Works**: Compares the input to zero; if equal, jumps to the block for zero classification.
- **Role**: Ensures accurate classification of zero while skipping positive and negative checks.

#### `jmp` (Unconditional Jump)
- **Purpose**: Skips over unnecessary code once a classification is complete.
- **How it Works**: Directly transfers control to the end of the program after a number is classified.
- **Role**: Improves efficiency by avoiding redundant checks after classification.

### Insights
- **Branching Logic**: The task demonstrated the use of conditional and unconditional jumps (je, jg, jmp), which are critical for implementing control flow in assembly. This showcases how decisions are made based on conditions like the comparison between a number and zero.
- **Flow Efficiency**: Using conditional jumps allowed for an efficient program flow, as unnecessary checks could be skipped based on the value of the number. This also allowed for clear and structured logic that mimics decision-making in higher-level languages.

### Challenges
- **Proper Jump Handling**:
Correctly understanding when and where to apply conditional jumps was a key challenge. It required ensuring that each jump correctly handled positive, negative, and zero conditions, especially considering edge cases (like zero itself).

- **Program Flow Complexity**:
While the program logic was straightforward, ensuring the jumps were handled in the right sequence was tricky. Without the abstractions of high-level programming, it was essential to keep track of the program flow manually to avoid errors.

---

### Task 2: Array Manipulation with Looping and Reversal
#### Purpose
This program accepts an array of integers as input, reverses the array **in place**, and outputs the reversed array. It demonstrates how to manipulate arrays using loops and how to perform the reversal operation directly in memory without using additional storage.

#### Instructions:
1. The program accepts an array of integers (e.g., five values) from the user.
2. Using a loop, it reverses the array elements in place.
3. After reversing the array, the program displays the reversed array.

#### Requirements:
- No additional memory should be used to store the reversed array. The reversal should be done directly in the array.
- Loops should be used for the reversal process.

### Insights:
- **In-place Array Reversal**: This task was a deep dive into memory manipulation and array management at a low level. Reversing the array in place without allocating extra memory showcased how efficient assembly can be for space-sensitive operations.
- **Pointer Management**: The program used registers (`esi` and `edi`) as pointers to traverse the array from both ends, demonstrating manual memory access and manipulation, which is crucial for efficient memory use in assembly programming.

### Challenges Encountered in Memory Handling for the Provided Code

1. **Memory Management**:
   - Allocating 20 bytes for the `array` assumes user input fits within this buffer. If more than 20 bytes are entered, it could cause a buffer overflow, risking data corruption or unexpected behavior.
   - Assembly does not automatically check for bounds, leaving it to the programmer to ensure safe memory usage.

2. **Pointer Management**:
   - The program uses `esi` and `edi` as pointers to traverse the array from opposite ends. Careful management is necessary to ensure they do not access memory outside the allocated range.
   - Logic is required to stop the reversal loop when `esi` meets or crosses `edi`, preventing out-of-bounds access.

3. **Direct Memory Access**:
   - Manipulating memory directly with registers like `esi` and `edi` is efficient but error-prone. Mismanagement of these registers can corrupt data or cause the program to crash.
   - Manual initialization and maintenance of pointers are necessary, which would be abstracted away in higher-level languages.

4. **Reversal Logic**:
   - The swapping process involves multiple steps: loading bytes into registers, swapping them, and writing back to memory. Errors at any stage can corrupt the array.
   - Proper sequencing is critical to ensure the input data is not lost or incorrectly reversed.

5. **Handling Edge Cases**:
   - The program assumes valid input (e.g., 5 numbers separated by spaces). If users provide fewer or invalid characters, the reversal process might yield unexpected results.
   - Spaces and newline characters are treated as part of the input, which can lead to incorrect output formatting unless handled explicitly.

6. **Performance Considerations**:
   - While memory operations are fast, the lack of abstractions increases the complexity and the chance of bugs. The manual approach demands precision in addressing and managing each byte.


---

### Task 3: Modular Program with Subroutines for Factorial Calculation 
#### Purpose
This program computes the **factorial** of a number, demonstrating the use of **modular programming** through subroutines (function-like code blocks). The program uses the stack to preserve registers, ensuring proper modularity and register management.

#### Instructions:
1. The program accepts a number from the user.
2. It computes the factorial of the number using a separate **subroutine** to perform the calculation.
3. The subroutine preserves and restores registers using the **stack**, demonstrating the concept of modular programming and register handling in assembly.
4. The final result (the factorial value) is placed in a general-purpose register.


#### Register Management and Stack Handling


1. **Register Usage**:
   - Registers like `eax`, `ebx`, `ecx`, and `ebp` are used for calculations, holding intermediate data, and managing stack frames.
   - Key registers are preserved during recursive calls to maintain their values.

2. **Stack Management**:
   - The stack is used to save and restore register values during function calls and recursion.
   - `push` saves a register's current value to the stack, and `pop` restores it after the function or recursion completes.

3. **Preservation in Recursive Functions**:
   - Before recursive calls (e.g., in `factorial`), registers like `ebx` (current value of `n`) and `ebp` (base pointer) are pushed onto the stack.
   - After recursion, these values are restored using `pop`, ensuring data integrity as the recursion unwinds.

4. **Handling Corruption**:
   - Explicit `push` and `pop` instructions prevent register overwriting or corruption during nested or recursive function calls.

### Insights:
- **Subroutine Usage**: The use of subroutines for calculating the factorial was an excellent exercise in understanding modular programming in assembly. By isolating the factorial logic into a subroutine, the task mirrored how functions or methods are used in higher-level programming languages.
- **Stack Management**: The use of the stack to save and restore registers demonstrated how important it is to preserve the program’s state in modular programming, especially in recursion or function calls.

### Challenges:
- **Recursive Stack Management**: One of the primary challenges was managing the stack for recursion. As factorial calculations are inherently recursive, ensuring that the program correctly pushed and popped register values onto the stack was critical. Any errors here could lead to incorrect results or program crashes.
- **Register Preservation**: Assembly requires manual preservation of registers, particularly in a recursive setting. Without a proper push and pop strategy, the registers would be overwritten, causing incorrect calculations. Ensuring that the state was preserved at every recursion level was complex and error-prone.
- **Handling Large Inputs**: Recursive factorial calculations can easily lead to stack overflows if the number is too large. Although the assignment didn’t specify constraints, handling large numbers would have been a challenge in a real-world scenario.

### **Conclusion**

Manual stack management ensures correct preservation and restoration of register values, critical for maintaining program correctness in recursion and complex function calls.


---

### Task 4: Data Monitoring and Control Using Port-Based Simulation 
#### Purpose
This program simulates a control system that monitors a "sensor value" and takes actions such as turning on a motor, triggering an alarm, or stopping the motor based on the sensor input. The program manipulates memory locations or ports to reflect the state of the motor and alarm.

#### Instructions:
1. The program reads a “sensor value” from a specified memory location or input port (simulating a water level sensor).
2. Based on the sensor input, it performs the following actions:
   - **Turning on a motor** (by setting a bit in a specific memory location).
   - **Triggering an alarm** if the water level is too high.
   - **Stopping the motor** if the water level is at a moderate level.
3. The program uses specific memory locations or ports to store and manipulate the motor and alarm statuses.


#### Overview
The program simulates a water level sensor using user input to determine the motor and alarm status. The input represents a sensor value (an integer between 0 and 99), which dictates actions based on the following conditions:

1. **Low Water Level (Input < 20):**
   - Motor is turned on.
   - Alarm is turned off.
   - Outputs: `"Motor ON: Water level low"`.

2. **Moderate Water Level (20 ≤ Input ≤ 59):**
   - Motor is turned off.
   - Alarm is turned off.
   - Outputs: `"Motor OFF: Water level moderate"`.

3. **High Water Level (Input > 59):**
   - Motor is turned off.
   - Alarm is turned on.
   - Outputs: `"ALARM ON: Water level high!"`.

If the input is invalid (non-numeric or outside the range of 0–99), the program prints a newline and terminates.

#### Memory and Ports
- **Sensor Value (`sensor_value`):** Holds the current input value from the user.
- **Motor Status (`motor_status`):** Indicates whether the motor is ON or OFF.
- **Alarm Status (`alarm_status`):** Indicates whether the alarm is ON or OFF.

The motor and alarm statuses are updated based on the detected water level and stored in these memory locations, reflecting their current state.


#### Action Determination Based on Input
1. **Input Validation:**
   - The program checks if the input is numeric and within the valid range (0–99). Invalid inputs result in program termination.

2. **Level Detection:**
   - The program uses conditional checks (`if` statements or equivalent assembly instructions) to determine the range in which the sensor value falls:
     - **Low Level:** Input is less than 20.
     - **Moderate Level:** Input is between 20 and 59.
     - **High Level:** Input is greater than 59.

3. **Action Execution:**
   - Based on the detected range:
     - **Low Level:**
       - `motor_status` is set to ON.
       - `alarm_status` is set to OFF.
       - The message `"Motor ON: Water level low"` is written to the console.
     - **Moderate Level:**
       - `motor_status` is set to OFF.
       - `alarm_status` is set to OFF.
       - The message `"Motor OFF: Water level moderate"` is written to the console.
     - **High Level:**
       - `motor_status` is set to OFF.
       - `alarm_status` is set to ON.
       - The message `"ALARM ON: Water level high!"` is written to the console.

4. **Memory Updates:**
   - The `sensor_value` memory location is updated with the user's input.
   - The `motor_status` and `alarm_status` locations are updated accordingly to reflect the current state.
### Insights:
- **Simulating Control Systems**: This task demonstrated the ability to simulate a simple control system using assembly language. It involved interacting with "ports" or memory locations to simulate real-world devices (like a motor or alarm system), showcasing the power of assembly in embedded systems programming.
- **Memory and I/O Interaction**: By manipulating the sensor value, motor status, and alarm status in memory, this task provided insight into how low-level programming interacts directly with hardware or simulated devices, bridging the gap between software and hardware.

### Challenges:
- **Port Simulation**: Since assembly is typically used for direct hardware manipulation, simulating ports and memory locations in a high-level OS environment was a conceptual challenge. The task required creating a virtual environment that could mimic the expected behavior of hardware components.
- **Validating Input**: Ensuring that user input was correctly validated and handled was a key challenge. Invalid input could lead to unexpected results or program failure, so robust input checking (especially for numeric ranges) was necessary.
- **Condition Handling**: Mapping specific sensor input ranges (e.g., low, moderate, high water levels) to actions (motor on/off, alarm on/off) required careful conditional checks. Additionally, it was important to ensure that memory values were correctly updated and reflected the state of the system in real-time.

### Summary
This program leverages input validation and conditional logic to classify water levels into predefined categories. It updates memory locations (`motor_status` and `alarm_status`) to represent the current state of the motor and alarm. Console messages are generated dynamically based on the water level detected, ensuring the user is informed of the system's actions.

---

#### Happy Coding!