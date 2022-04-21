1 Servo On
2 Ovrd 80
3 M30 = 14
4 Def Plt 1, P11,P12,P13,P14,3,M30,11
5 Def Plt 2, P21,P22,P23,P24,2,7,11
6 M1 = 1
7 M20 = 1
8 Mov P0
9 HOpen 1
10 For M2=1 To M30
11     For M3=1 To 3
12         If M3 = 2 Then
13             P100 = Plt 1, M1
14             P200 = Plt 2, M20
15             M20 = M20+1
16             GoSub *MOVES
17         EndIf
18         M1 = M1+1
19     Next M3
20 Next M2
21 If M1>=42 Then Mov P0, -300
22 Hlt
23 End
24 '
25 '
26 '
27 *MOVES
28 Mov P100
29 Dly 3
30 Mvs P100, -70
31 GoSub *PICK 'Jump to pick subprogram
32 Mov P100, -150
33 Mvs P100
34 Dly 0.3
35 HOpen 1
36 Dly 1
37 Mvs ,-100
38 Return
39 '
40 '
41 '
42 *PICK
43 Mov P200, -100 Type 1,0
44 Mvs P200
45 Dly 0.3
46 HClose 1
47 Dly 0.5
48 Mvs P200, -150
49 Return
P11=(+460.43,-591.23,+269.78,-179.68,+0.20,-174.83)(7,0)
P12=(+536.41,-594.74,+270.38,-179.46,+0.50,+178.25)(7,0)
P13=(+458.28,+592.95,+268.15,+179.81,+0.16,-178.82)(7,0)
P14=(+539.36,+589.18,+267.36,+178.39,+1.42,+178.67)(7,0)
P21=(+667.59,-92.61,+326.57,-179.75,-0.05,-86.72)(7,0)
P22=(+730.67,-93.29,+334.19,+179.53,+0.09,-86.10)(7,0)
P23=(+665.33,+108.46,+325.43,-179.85,+0.03,-93.18)(7,0)
P24=(+730.37,+97.77,+334.19,+179.66,-0.07,-92.88)(7,0)
P0=(+609.16,+0.00,+257.41,-180.00,-3.20,-180.00)(7,0)
P100=(+498.87,-410.84,+269.62,-179.68,+0.20,-174.83)(7,0)
P200=(+730.62,-61.45,+334.19,-179.75,-0.05,-86.72)(7,0)
P5=(+730.24,-0.00,+270.56,-180.00,-0.81,+180.00)(7,0)
