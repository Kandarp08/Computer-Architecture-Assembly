correctBinary = open("MARS_binary.txt", "r") # Binary code as given by MARS
output = open("outfile.txt", "r")            # Binary code as given by Python code

countLine = 1 # Current line number
flag = True # To check for errors

# Compare each line
for (marsInst, pythonInst) in zip(correctBinary, output) :

    # Mismatch found
    if marsInst != pythonInst :

        print(f"Mismatch found on line {countLine}: ")
        print("MARS binary: " + marsInst)
        print("Python binary: " + pythonInst + "\n")

        flag = False # Error found

    countLine += 1 # Increment count

# No errors found
if flag :
    print("No errors found")

correctBinary.close()
output.close()
