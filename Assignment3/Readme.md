# Instruction of my program to Assingment 3
This is a program about using SSP-RK method to numerical approximate the wave propagating in an abrupt bathymetry.
## Flow Chart
```mermaid
graph LR
   A[Main]-->B(Part 1: Generating data)
   A[Main]-->C(Part 2: Making plot)
   
   B --> D{bathymetrytype}
   D -->|flat| E[bathymetrytype.m]
   D -->|abrupt| E
   D -->|smoothed-abrupt| E

   C --> |generating figure store dictionary| F[/bathymetrytype/]
   F --> |flat| G[plotfe.m]
   F --> |abrupt| H[plota.m]
   F --> |smoothed-abrupt| I[/the requirement/]

   I --> |error analysis| J[plotsae.m]
   I --> |snapshot| K[plotsas.m]
   I --> |animation| L[plotsaa.m]

```
## Others
1. the data has generated. Could run the part 2 of Main.m directly.

