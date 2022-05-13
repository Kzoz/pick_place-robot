# Metal Fittings Picking System

**Detect presence, Pick, Weigh, Place, Convey and Arrange Metal Fittings(Kanamono)' System**<br>
Some part of the system won't be disclosed. 

## Contents

1. [Introduction](https://github.com/Kzoz/pick_place-robot/blob/b6b515bcfeed07584688a4f2fe7675130e581c27/docs/index.md#introduction)
2. [Objective](https://github.com/Kzoz/pick_place-robot/blob/b6b515bcfeed07584688a4f2fe7675130e581c27/docs/index.md#objective)
3. [Environment Setup](https://github.com/Kzoz/pick_place-robot/blob/b6b515bcfeed07584688a4f2fe7675130e581c27/docs/index.md#environment-setup)
4. [Physical Structure](https://github.com/Kzoz/pick_place-robot/blob/b6b515bcfeed07584688a4f2fe7675130e581c27/docs/index.md#physical-structure)
5. [Test and Review](https://github.com/Kzoz/pick_place-robot/blob/b6b515bcfeed07584688a4f2fe7675130e581c27/docs/index.md#test-and-review)

## Introduction

  In recent years, wooden house are mostly pre-fabricated in factories and assemble on-site.
Therefore, the pre-assembly stage remains a crucial to the success of each construction. One important part of this pre-assembly stage is the fixation of metal fittings(kanamono) in wood frames for future assembly. Each of these metal fittings is thoroughly chosen thinking about the length, width and emplacement of the wood frame as well as the structure of the house. Even though, the type and quantity of kanamono going into each woodframe is listed in advance, the tedious process of pick placing kanamono remains a difficult challenge for workers. This manual operation takes 3-4 hours a day and humans are prone to mistake. 
  Thus, in this project, we aim to build a physical structure and a system to completely automate the picking and placing metal fittings. For this purpose, we use a Mitsubishi Robot RV-5AS-D for grasping and stowing kanamono, a set of Keyence made sensors, air cylinders and a Mitsubishi PLC FX5U-32 for I/O control. Finally we build a computer program to manage the overall system.


## Objective

This Kanamono picking system aims to pick, verify and place metal fittings in boxes according to a work list sent to the robot. Then, using a conveyer system, the boxes are transported and arrange in shelves before being, later on, picked up by workers. <br>
Considering workers will have to store (refill) kanamono in the metal fittings structure and many metal fittings such as pins and pipes are very similar looking, the chances of mistakes is not null. Therefore, we also ensure to detect presence and type of kanamono with sensors. Not only for the robot's destination position, but also to send a *refill alert* to workers. Furthermore, we add an extra layer of verification by weighing the metal fittings.<br>

In this project, we aim to:
- Efficiently pick, weigh and place each target within 11 seconds
- Ensure each the correctness and correct grasping of each target by comparing its mass to the mass stored in our DB
- Efficiently convey each box to its appropriate destination
- Build a program to manage, control and monitor the entire system


## Environment Setup

Seeing as we mainly work with Mitsubishi's products in this project, we use softwares provided by Mitsubishi in order to program and monitor some of the devices. Moreover, we build our own softwares to better manage the system, monitor the devices, transfer data between devices and make the system easily controllable by workers.<br>

|       Device        |     Software     |     Prg Lang/Tool    |
|---------------------|------------------|----------------------|
|   Robot (RV-5AS-D)  |   RT Toolbox 3   |       MELFA Basic    |
|   PLC (FX5U-32MT)   |    GX Works 3    |       Ladder         |
|   HMI (GT2508-VTBD) |   GT Designer 3  |                      |
| Control/Monitor Sys |    by authors    |       C++/Python     |
|    A&D HV-15KGL     |    by authors    |        Python        |
|       Printer       |    by authors    |       C++/Python     |

1. Local Network

Mitsubishi products better connect with Mitsubishi's own communication protocols such as MELFSOFT or SLMP. 
As for the rest of devices, we made use of TCP based Telnet or RS-232C.<br>
Details are listed below:

![Connection Fig](https://github.com/Kzoz/pick_place-robot/blob/5d4bba74b6d87fe7b8f372e42ea815ca5c8812c5/docs/picking_system.jpeg)

|      Devices    |     Connection   |
|-----------------|------------------|
|     PLC % HMI   |      MELSOFT     |
|    Robot & PLC  |      CC-LINK     |
|    Robot & HMI  |        SMLP      |
|     PC & Robot  |       Telnet     |
|     PC & HMI    |      MELSOFT     |
|     PC & PLC    |      MELSOFT     |
| PC & WeightScale|       RS-232C    |
|   PC & Printer  |       RS-232C    |

2. Device Configuration

**[(Refer to README.txt)](https://github.com/Kzoz/pick_place-robot/blob/1c1ec4907c43758da2b93e9150891c6ac6a3e122/Robot_work/README.txt)**


## Physical Structure

## Test and Review


```markdown

(Empty for now) 
()

```

`print(n)`
