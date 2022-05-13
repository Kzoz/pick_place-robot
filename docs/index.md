## Metal Fittings(Kanamono) Picking System

**Detect presence, Pick, Weigh, Place, Convey and Arrange Metal Fittings' System**<br>
Some part of the system won't be disclosed. 

### Contents

1. Introduction 
2. Objective
3. Environment Setup
4. Physical Structure
5. Programs
6. Test and Review

### Introduction

  In recent years, wooden house are mostly pre-fabricated in factories and assemble on-site.
Therefore, the pre-assembly stage remains a crucial to the success of each construction. One important part of this pre-assembly stage is the fixation of metal fittings(kanamono) in wood frames for future assembly. Each of these metal fittings is thoroughly chosen thinking about the length, width and emplacement of the wood frame as well as the structure of the house. Even though, the type and quantity of kanamono going into each woodframe is listed in advance, the tedious process of pick placing kanamono remains a difficult challenge for workers. This manual operation takes 3-4 hours a day and humans are prone to mistake. 
  Thus, in this project, we aim to build a physical structure and a system to completely automate the picking and placing metal fittings. For this purpose, we use a Mitsubishi Robot RV-5AS-D for grasping and stowing kanamono, a set of Keyence made sensors, air cylinders and a Mitsubishi PLC FX5U-32 for I/O control. Finally we build a computer program to manage the overall system.


### Objective

This Kanamono picking system aims to pick, verify and place metal fittings in boxes according to a work list sent to the robot. Then, using a conveyer system, the boxes are transported and arrange in shelves before being, later on, picked up by workers. <br>
Considering workers will have to store (refill) kanamono in the metal fittings structure and many metal fittings such as pins and pipes are very similar looking, the chances of mistakes is not null. Therefore, we also ensure to detect presence and type of kanamono with sensors. Not only for the robot's destination position, but also to send a *refill alert* to workers. Furthermore, we add an extra layer of verification by weighing the metal fittings.<br>

In this project, we aim to:
- Efficiently pick, weigh and place each target within 11 seconds
- Ensure each the correctness and correct grasping of each target by comparing its mass to the mass stored in our DB
- Efficiently convey each box to its appropriate destination
- Build a program to manage, control and monitor the entire system


### Environment Setup

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

In this project, we mainly serial and ethernet connections to interconnect devices.
Details are listed below:

|      Devices    |    Connection   |
|-----------------|-----------------|
|     PLC % HMI   |     MELSOFT     |
|    Robot & PLC  |     CC-LINK     |
|    Robot & HMI  |       SMLP      |
|     PC & Robot  |      TCP/IP     |
|     PC & HMI    |      TCP/IP     |
|     PC & PLC    |      TCP/IP     |
| PC & WeightScale|      RS-232C    |
|   PC & Printer  |      RS-232C    |

2. Device Configuration

**(Refer ro README.txt)**


### Physical Structure

### Test and Review

## Welcome to GitHub Pages

You can use the [editor on GitHub](https://github.com/Kzoz/picking-robot/edit/main/docs/index.md) to maintain and preview the content for your website in Markdown files.

Whenever you commit to this repository, GitHub Pages will run [Jekyll](https://jekyllrb.com/) to rebuild the pages in your site, from the content in your Markdown files.

### Markdown

Markdown is a lightweight and easy-to-use syntax for styling your writing. It includes conventions for

```markdown
Syntax highlighted code block

# Header 1
## Header 2
### Header 3

- Bulleted
- List

1. Numbered
2. List

**Bold** and _Italic_ and `Code` text

[Link](url) and ![Image](src)
```

For more details see [Basic writing and formatting syntax](https://docs.github.com/en/github/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax).

### Jekyll Themes

Your Pages site will use the layout and styles from the Jekyll theme you have selected in your [repository settings](https://github.com/Kzoz/picking-robot/settings/pages). The name of this theme is saved in the Jekyll `_config.yml` configuration file.

### Support or Contact

Having trouble with Pages? Check out our [documentation](https://docs.github.com/categories/github-pages-basics/) or [contact support](https://support.github.com/contact) and we’ll help you sort it out.
