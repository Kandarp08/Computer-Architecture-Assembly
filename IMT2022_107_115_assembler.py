# Converts a decimal number 'n; into a binary string of length 'size'
def decimalToBinary(n, size) :

    if n == 0 :
        return "0" * size

    binary = "" # Binary string

    # Convert decimal to binary
    while n != 0 :

        binary = str(n % 2) + binary # Add remainder to the string
        n = n // 2

    return (size - len(binary)) * "0" + binary # Return string of length 'size'

# Maps each register to it's corresponding decimal number
regToDecimal = {"$0": 0, "$at": 1, "$v0": 2, "$v1": 3, "$a0": 4, "$a1": 5, "$a2": 6, "$a3": 7, "$t0": 8, "$t1": 9,
               "$t2": 10, "$t3": 11, "$t4": 12, "$t5": 13, "$t6": 14, "$t7": 15, "$s0": 16, "$s1": 17, "$s2": 18, 
               "$s3": 19, "$s4": 20, "$s5": 21, "$s6": 22, "$s7": 23, "$t8": 24, "$t9": 25,"$k0": 26, "$k1": 27, 
               "$gp": 28, "$sp": 29, "$fp": 30, "$ra": 31}

# Maps each instruction to it's corresponding opcode (decimal)
instructionToOpcode = {"add": 0, "beq": 4, "j": 2, "addi": 8, "lw": 35, "sw": 43, "sll": 0, "slt": 0}

# For R-type instructions, this dictionary gives the corresponding funct field
rFormatFunct = {"add": 32, "sub": 34, "sll": 0, "slt": 42}

# Maps each label to the corresponding BTA in decimal
labelToDecimal = {"copyElementsEnd": 6, "outerLoopEnd": 24, "innerLoopEnd": 11, "if_condn": 2}

# Maps each label to the corresponding JTA in decimal
jumpToDecimal = {"copyElements": 4194392, "innerLoop": 4194448, "after_if_condn": 4194476, "outerLoop": 4194424}

assemblyCode = open("inpfile.txt", "r") # Input file (assembly language)
binaryCode = open("outfile.txt", "w") # Output file (binary)

# Read each line of assembly code
for instruction in assemblyCode :

    splittedInstruction = instruction.split() # Split instruction using the delimiter " "
    
    # Empty line
    if len(splittedInstruction) == 0 :
        continue

    instructionName = splittedInstruction[0] # Name of instruction

    try :
        opcode = decimalToBinary(instructionToOpcode[instructionName], 6) # Find opcode of instruction

    # Label is found instead of instruction
    except KeyError :
        continue

    # R-type instruction (except sll)
    if opcode == "000000" and instructionName != "sll" :

        splittedInstruction[1] = splittedInstruction[1][0: -1] # Remove trailing ',' from end of register name
        splittedInstruction[2] = splittedInstruction[2][0: -1] # Remove trailing ',' from end of register name

        rs = decimalToBinary(regToDecimal[splittedInstruction[2]], 5) # Source register 1 (binary)
        rt = decimalToBinary(regToDecimal[splittedInstruction[3]], 5) # Source register 2 (binary)
        rd = decimalToBinary(regToDecimal[splittedInstruction[1]], 5) # Destination register (binary)
        shamt = "0" * 5                                               # Shift amount
        funct = decimalToBinary(rFormatFunct[instructionName], 6)     # Funct field
    
        binaryInstruction = opcode + rs + rt + rd + shamt + funct # 32-bit binary instruction
        binaryCode.write(binaryInstruction) # Write into the file

    # Shift left logical instruction
    elif instructionName == "sll" :
        
        splittedInstruction[1] = splittedInstruction[1][0: -1] # Remove trailing ',' from end of register name
        splittedInstruction[2] = splittedInstruction[2][0: -1] # Remove trailing ',' from end of register name

        rs = "0" * 5                                                  # rs = "00000" for sll
        rt = decimalToBinary(regToDecimal[splittedInstruction[2]], 5) # Source register (binary)
        rd = decimalToBinary(regToDecimal[splittedInstruction[1]], 5) # Destination register (binary)
        shamt = decimalToBinary(int(splittedInstruction[3]), 5)       # Shift amount (binary)
        funct = "0" * 6                                               # Funct field

        binaryInstruction = opcode + rs + rt + rd + shamt + funct # 32-bit binary instruction
        binaryCode.write(binaryInstruction) # Write into the file

    # Load word or Store word instruction
    elif opcode == "100011" or opcode == "101011" :

        ind = splittedInstruction[2].index("(") # Index of '(' 
        
        immediateValue = decimalToBinary(int(splittedInstruction[2][0: ind]), 16)    # Immediate value (binary)
        rs = decimalToBinary(regToDecimal[splittedInstruction[2][(ind + 1): -1]], 5) # Register 1 (binary)
        rt = decimalToBinary(regToDecimal[splittedInstruction[1][0: -1]], 5)         # Register 2 (binary)

        binaryInstruction = opcode + rs + rt + immediateValue # 32-bit binary instruction
        binaryCode.write(binaryInstruction) # Write into the file

    # Add immediate instruction
    elif opcode == "001000" :

        splittedInstruction[1] = splittedInstruction[1][0: -1] # Remove trailing ',' from register name
        splittedInstruction[2] = splittedInstruction[2][0: -1] # Remove trialing ',' from register name

        immediateValue = decimalToBinary(int(splittedInstruction[3]), 16) # Immediate value (binary)
        rs = decimalToBinary(regToDecimal[splittedInstruction[2]], 5)     # Source register (binary)
        rt = decimalToBinary(regToDecimal[splittedInstruction[1]], 5)     # Destination register (binary)

        binaryInstruction = opcode + rs + rt + immediateValue # 32-bit binary instruction
        binaryCode.write(binaryInstruction) # Write into the file

    # Branch if equal instruction
    elif opcode == "000100" :

        splittedInstruction[1] = splittedInstruction[1][0: -1] # Remove trailing ',' from register name
        splittedInstruction[2] = splittedInstruction[2][0: -1] # Remove trialing ',' from register name

        immediateValue = decimalToBinary(labelToDecimal[splittedInstruction[3]], 16) # Immediate value (binary)
        rs = decimalToBinary(regToDecimal[splittedInstruction[1]], 5)                # Source register 1 (binary)
        rt = decimalToBinary(regToDecimal[splittedInstruction[2]], 5)                # Source register 2 (binary)

        binaryInstruction = opcode + rs + rt + immediateValue # 32-bit binary instruction
        binaryCode.write(binaryInstruction) # Write into the file

    # Unconditional jump instruction
    elif opcode == "000010" :

        immediateValue = decimalToBinary(jumpToDecimal[splittedInstruction[1]], 32) # Immediate value (binary)
        immediateValue = immediateValue[4:-2] # Convert 32-bit address to 26-bits
        
        binaryInstruction = opcode + immediateValue # 32-bit binary instruction
        binaryCode.write(binaryInstruction) # Write into the file

    if not (splittedInstruction[0] == "j" and splittedInstruction[1] == "outerLoop") :
        binaryCode.write("\n")

assemblyCode.close()
binaryCode.close()