# Instruction of my program to Assingment 5
This is a program involving MUSCL reconstruction and HLLC approximate Riemann solver
By input Test data, compare the ouput data with Validation data. And input inference data.
## Flow Chart
```mermaid
graph LR
    A[Main]-->B(Part 1: MUSCL reconstruction)
    A[Main]-->C(Part 2: HLLC approximate Riemann solver)

    B --> B1[Test data]
    B --> B2[Inference data]

    C -->C1[Test data]
    C -->C2[Inference data]
```
## Others
1. The code will generate the data throught process Part 1 and Part 2. 
