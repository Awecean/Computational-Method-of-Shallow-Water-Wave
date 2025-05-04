# Instruction of my program to Assingment 5
This is a program involving MUSCL reconstruction and HLLC approximate Riemann solver
By input Test dat, compare the ouput data with Validation data. And input inference data.
## Flow Chart
```mermaid
graph LR
    A[Main]-->B(Part 1: Generating Initial data)
    A[Main]-->C(Part 2: Simulating)
    A[Main]-->D(Part 3: Plot)

    B --> B1[/bathymetrytype<Br>region<Br>spaceindex/]
    B1 --> B11[initial.m]

    C -->C1[/bathymetrytype<Br>region<Br>spaceindex/]
    C1 -->C11[simulate.m]

    D -->D1[/flat<Br> full domain/]
    D1-->D11[pconvergence.m]
    D1-->D12[pradialsymmetry.m]
    D1-->D13[figureeta.m]
    D1-->D14[animationeta.m]

    D-->D2[/othercase/]

    D2-->D21[figureeta.m]
```
## Others
1. The code will generate the data throught process Part 1 and Part 2. 
