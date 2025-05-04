# Instruction of my program to Assingment 5
This is a program involving MUSCL reconstruction and HLLC approximate Riemann solver
By input Test dat, compare the ouput data with Validation data. And input inference data.
## Flow Chart
```mermaid
graph LR
    A[Main]-->B(Part 1: MUSCL reconstruction)
    A[Main]-->C(Part 2: HLLC approximate Riemann solver)

    B --> B1[/bathymetrytype<Br>region<Br>spaceindex/]
    B1 --> B11[initial.m]

    C -->C1[g]
```
## Others
1. The code will generate the data throught process Part 1 and Part 2. 
