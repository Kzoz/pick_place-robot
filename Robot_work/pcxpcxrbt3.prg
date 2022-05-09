Dly 1
Servo Off
Dim MDATA(6)
Dim MKANAWEIGHT(6)
M0 = 1
M1 = 1
MVal = 0
*LOOP
Open "COM1:" As #1
Input #1,C1$
MDIVIDEND = 2
#Include "LIB"
Modul = Modulo(MVal,MDIVIDEND)
If Modul = 0 Then
    MDATA(M0)= Val(C1$)
    M0 = M0+1
Else
    MKANAWEIGHT(M1)= Val(C1$)
    M1 = M1+1
EndIf
MVal = MVal+1
If M1 > 6 Then GoTo *NMOV
Print #1,C1$
Close #1
GoTo *LOOP
'
'
*NMOV
Dim Mworklist(6)
Mworklist(1) = MDATA(1)
Mworklist(2) = MDATA(2)
Mworklist(3) = MDATA(3)
Mworklist(4) = MDATA(4)
Mworklist(5) = MDATA(5)
Mworklist(6) = MDATA(6)
'
'
Dim PKANAP(5)
PKANAP(1) = PKANA1
PKANAP(2) = PKANA2
PKANAP(3) = PKANA3
PKANAP(4) = PKANA4
PKANAP(5) = PKANA5
'
'
Dim PKANAU(5)
PKANAU(1) = pKANA10
PKANAU(2) = PKANA20
PKANAU(3) = PKANA30
PKANAU(4) = PKANA40
PKANAU(5) = PKANA50
'
'-------------Initial Moves & Variable declaration--------------
Dly 0.4
Servo On
Dly 0.7
PPUT = (+621.63,-24.39,+395.56,-179.32,+1.99,-90.01)
Def Plt 1, P1,P2,P4,P3,5,2,11
Def Plt 2, P1,P2,P4,P3,5,2,11
M30 = 1
MCOUNT = 0
Mov PHOME
Dly 0.3
HClose 2
Dly 0.5
HOpen 2
Dly 0.3
M_Out(6001)= 0' Reset Hex Nut Counter
M_Out(6002) = 0'Reset Hex Nut time error
M_Out(6003) = 0' Release latches
M_Out(6004) = 0 'X104 Belt Conveyer move/stop
M_Out(6030) = 0 'to terminate trigger X136
M_DOut(6006) = Mworklist(6) ' for the number of hex nuts
M6 = Mworklist(6)
Dly 0.2
M_Out(6030) = 1 ' to trigger hex nut picking X136
Dly 0.2
M_Out(6030) = 0 ' to terminate trigger X136
'---------------------------------------------------------------
'
'-----------------------Pick Up Box-----------------------------
M_Out(6003) = 1 'X103 Lift Box
Mov PICK,-100
Wait M_In(6007) = 1
Mvs PICK
Dly 0.5
HClose 2
Dly 0.7
Mvs PICK, -226
Mvs P_Curr*(+347.00,+0.00,+0.00,+0.00,+0.00,+0.00)
Mov PLACE, -30
Mov PLACE
Dly 0.5
HOpen 2
Dly 0.7
M_Out(6003) = 0 'X103 Lift Box
Mov PLACE, -90
Mov PTRANSIT'
'---------------- --------------- --------------- -------------
'
'---------------------- Set Starting Weight --------------------
Print #1,"OK"'*
Input #1,C2$' receive INIT from PC
MTOTALWEIGHT = 0
MEXPECTED = (MDATA(1)*MKANAWEIGHT(1)+MDATA(2)*MKANAWEIGHT(2))
MEXPECTED = MEXPECTED+(MDATA(3)*MKANAWEIGHT(3)+MDATA(4)*MKANAWEIGHT(4))
MEXPECTED = MEXPECTED+(MDATA(5)*MKANAWEIGHT(5)+MDATA(6)*MKANAWEIGHT(6))
'--------------------------------------------------------------
'
'------------------------- Work Loop --------------------------
M100 = 1
For M10 = 1 To 5' 5 means the length of vector mworklist
    For M20 = 1 To Mworklist(M10)
        If M100 = 1 And Mworklist(1) > 0 Then
            GoSub *ROUTINE
        ElseIf M100 = 2 And Mworklist(2) > 0 Then
                GoSub *ROUTINE
        ElseIf M100 = 3 And Mworklist(3) > 0 Then
                GoSub *ROUTINE
        ElseIf M100 = 4 And Mworklist(4) > 0 Then
                GoSub *ROUTINE
        ElseIf M100 = 5 And Mworklist(5) > 0 Then
                GoSub *ROUTINE
        EndIf
    Next M20
    M100 = M100+1
'
Next M10
'----------------- ------------------ ------------------------
'
'------------- PKANA6 HEX NUTS -----------------
If Mworklist(6) >=1 Then
    PTPUT = (+620.21,-28.56,+515.48,-179.32,+1.99,-90.01)
    Mov PTRANSIT3
    Mov PKANA60
    While (M_DIn(6006) < M6)'the sum allocated = the number of hex nuts counted D1006
        If M_In(6030) = 1 Then ' No more hex nuts in the tank Y36
            M_Out(6002) = 1 ' Reset Hex nut errors
            Dly 0.1
            M_Out(6002) = 0
            Print #1,"HNERROR"
            Input #1, C21$
            Error 9101'Hex nut Error (for now)
        EndIf
        If M_In(6017) = 1 Then' meaning hex nut count is done Y21/ to confirm D1006 or DIn(6006)
            Print #1, "KANA6"
            Input #1, C21$
            Break
        EndIf
    WEnd
    M_Out(6001) = 1
    Dly 0.1
    M_Out(6001)= 0
    HOpen 2
    Dly 0.7
    Mvs PKANA6
    Dly 0.3
    HClose 2
    Dly 0.5
    Mvs P_Curr*(+0.00,+0.00,-30.00,+0.00,+0.00,+0.00)
    Mvs P_Curr*(+0.00,+60.00,+0.00,+0.00,+0.00,+0.00)
    Mvs P_Curr*(+0.00,+0.00,-160.00,+0.00,+0.00,+0.00)
    Cnt 1
    PPUT = (+621.63,-24.39,+395.56,-179.32,+1.99,-90.01)
    Mov PPUT*(-80.00,+170.00,-160.00,+0.00,+0.00,+0.00)
    Mov PPUT*(-80.00,+190.00,-160.00,+0.00,+0.00,+0.00)
    Mov PPUT*(-40.00,+0.00,+0.00,-81.00,+0.00,-70.00)
    Dly 1
    Mov PPUT*(-50.00,+100.00,-160.00,+0.00,+0.00,+0.00)
    Cnt 0
    Mov PKANA6*(+0.00,+60.00,-160.00,+0.00,+0.00,+0.00)
    GoSub *WEIGHING
    MTOTALWEIGHT=Val(C3$)*1000
    Mvs P_Curr*(+0.00,+0.00,+130.00,+0.00,+0.00,+0.00)
    Mov PKANA6,-30
    Dly 0.2
    Mvs PKANA6
    Dly 0.3
    HOpen 2
    Dly 0.7
    Mvs P_Curr*(+0.00,+0.00,-180.00,+0.00,+0.00,+0.00)
EndIf
'---------------------Check Overall Weight------------------
While MEXPECTED-14 > MTOTALWEIGHT Or MTOTALWEIGHT > MEXPECTED+14
    Error 9102
    GoSub *WEIGHING
    MTOTALWEIGHT=Val(C3$)*1000
WEnd
'------------------------------------------------------------
'
'--------------Release Latches and Move Conveyer-------------
'
M_Out(6003) = 1 'X103 Lift Box
Dly 0.7
M_Out(6004) =1 'X104 Push Box Forward
Dly 6.6
M_Out(6003) = 0 'X104 Push Box Forward
Dly 0.9
M_Out(6004) = 0 'X103 Lift Box
Mov PHOME
Print #1,"END"
Close #1
End
'------------------------JOB COMPLETE-------------------------
'
'--------------------- ROUTINE SUBPROGRAM --------------------
*ROUTINE
Ovrd 100
If M100 = 1 Or M100 = 2 Then GoTo *SPECIALP
If M100 = 4 Or M100 = 5 Then Mov PTRANSIT3
'
Dly 0.5
Mov PKANAU(M100)
Dly 0.3
HOpen 2
Dly 0.7
If M100 = 3 Then Wait M_In(6019) = 1 'x3
If M100 = 4 Then Wait M_In(6020) = 1 'x4
If M100 = 5 Then Wait M_In(6022) = 1 'x6
Mov PKANAP(M100)
Dly 0.3
HClose 2
Dly 0.5
'
If M100 = 5 Then
    Mov P_Curr*(+17.00,+0.00,+0.00,+0.00,+0.00,+0.00)
    Cnt 1
    Mov P_Curr*(+0.00,+0.00,-110.00,+0.00,+0.00,+0.00)
    Mov PKANA51
    Cnt 0
Else
    Mov P_Curr*(+0.00,-30.00,-13.00,+0.00,+0.00,+0.00)
    Mov P_Curr*(+0.00,+0.00,-70.00,+0.00,+0.00,+0.00)
EndIf
Cnt 1
Mov PTRANSIT
Mov PPUT,-100
Cnt 0
'
'
*COMEBACK
'-------------------- For Kanamono E1 -------------------
If M100 = 1 Then
    If M30 > 10 Then
        GoSub *OVERTENKANA
        GoTo *PALETSTS4
    EndIf
    P100 = Plt 1, M30
    If M30 >= 6 Then
        Mov P100*(-13.30,-20.00,+0.00,+0.00,+0.00,+180.00)
    Else
        Mov P100
    EndIf
    Dly 0.4
    Mov P_Curr*(+0.00,+0.00,+93.80,+0.00,+0.00,+0.00)
    Dly 0.3
    If M30 >= 6 Then Mov P_Curr*(+0.00,-45.00,+0.00,+0.00,+0.00,+0.00)
    HOpen 2
    Dly 0.7
    Mov P_Curr*(+0.00,+0.00,-200.00,+0.00,+0.00,+0.00)
    GoTo *PALETSTS1
EndIf
'
'----------------------  For Kanamono E2  ---------------------
If M100 = 2 Then
    If M30 > 10 Then
        GoSub *OVERTENKANA
        GoTo *PALETSTS3
    EndIf
    P200 = Plt 2, M30
    If M30 >= 6 Then
        Mov P200*(-20.00,-40.00,-161.90,+0.00,-1.00,+180.00)
        Dly 0.4
        Mvs P_Curr*(-2.00,+0.00,+199.00,+0.00,+0.00,+0.00)
    Else
        Mov P200*(+22.00,-60.00,-155.30,-10.00,-4.00,+2.00)
        Dly 0.4
        Mvs P_Curr*(+6.00,+0.00,+199.00,+0.00,+0.00,+0.00)
        Dly 1
    EndIf
    If M30 >= 6 Then Mov P_Curr*(+2.00,-60.00,+0.00,+0.00,+0.00,+0.00)
    If M30 = 5 Then
        HOpen 2
        Dly 0.3
        Mvs P_Curr*(+0.00,+0.00,-50.00,+0.00,+0.00,+0.00)
        Mvs P_Curr*(-7.00,-57.00,+0.00,+0.00,+0.00,+0.00)
        Mvs P_Curr*(+0.00,+0.00,+50.00,+0.00,+0.00,+0.00)
        Mvs P_Curr*(+9.00,-21.00,+0.00,+0.00,+0.00,+0.00)
    Else
        Dly 0.7
        HOpen 2
        Dly 1
    EndIf
    Mov P_Curr*(+0.00,+25.00,-199.00,+0.00,+0.00,+0.00)
    GoTo *PALETSTS2
EndIf
'-----------------------------------------------------------------
'- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Ovrd 20
If M30 > 6 Then PPUT = (+661.63,-24.39,+395.56,-179.32,+1.99,-90.01)
Mvs PPUT
Dly 0.3
HOpen 2
Dly 0.7
Mov P_Curr*(+0.00,+0.00,-100.00,+0.00,+0.00,+0.00)'Z from -100 to -30
MCOUNT = MCOUNT+1
If MCOUNT = 5 And M30 > 10 Then
    PPUT = (+621.63,-24.39,+395.56,-179.32,+1.99,-90.01)
ElseIf MCOUNT = 5 And M30 <= 10 Then
    PPUT = (+661.63,-24.39,+395.56,-179.32,+1.99,-90.01)
ElseIf MCOUNT = 10 Then
    MCOUNT = 0
    PPUT = (+621.63,-24.39,+395.56,-179.32,+1.99,-90.01)
Else
    PPUT = PPUT*(-11.00,+0.00,+0.00,+0.00,+0.00,+0.00)
EndIf
'
*JUMP
If M100 >3 Then Mov PTRANSIT
Dly 1
*REWEIGH
GoSub *WEIGHING
Mass = Val(C3$)*1000' Mass is the the current value displayed on the weight scale
If (Mass-MTOTALWEIGHT) <= 16 Then
    Mworklist(M100) = Mworklist(M100)+1 '16 is minimum weight
ElseIf MKANAWEIGHT(M100)*0.97 > Mass - MTOTALWEIGHT Or Mass - MTOTALWEIGHT > (MKANAWEIGHT(M100)*1.03) Then
    Error 9102
    GoTo *REWEIGH
EndIf
MTOTALWEIGHT=Mass
'
'
Return
'--------------  END OF ROUTINE SUBPROGRAM -----------------
'----------------- Kanamono E1 & E2 SUBPROGRAM -------------
*SPECIALP
Mov PKANAU(M100)
Dly 0.3
HOpen 2
Dly 0.7
If M100 = 2 Then Wait M_In(6023) = 1 ' x7 for Kanamono E2
If M100 = 1 Then Wait M_In(6016) = 1 'x0 for kanamono E1
Mvs PKANAP(M100)
Dly 0.5
HClose 2
Dly 0.5
PTPUT = PPUT*(+0.00,+0.00,-120.00,+0.00,+0.00,+0.00)
Cnt 1
Mvs PKANAU(M100)
If M100 = 2 Then
    Mov PTPUT*(+0.00,+0.00,-100.00,+0.00,+0.00,+0.00)
Else
    Mov PTPUT
EndIf
Cnt 0
GoTo *COMEBACK
'
'------------------E1 & E2 Special Positions ---------------------
*OVERTENKANA
Cnt 1
If M30 = 11 Then '
    Mov PLARGEKANA1,-170
    Mvs PLARGEKANA1
    If M100 = 1 Then Mov PSMALLKANA1
    Dly 0.3
    HOpen 2
    Dly 0.7
    Mvs PLARGEKANA1,-170
ElseIf M30 = 12 Then
    Mov PLARGEKANA2,-170
    Mvs PLARGEKANA2
    If M100 = 1 Then Mov PSMALLKANA2
    Dly 0.2
    Mov P_Curr*(+0.00,-75.00,+0.00,+0.00,+0.00,+0.00)
    Dly 0.3
    HOpen 2
    Dly 0.7
    Mvs PLARGEKANA2,-170
ElseIf M30 = 13 Then
    Mov PLARGEKANA3,-170
    Mvs PLARGEKANA3
    If M100 = 1 Then Mov PSMALLKANA3
    Dly 0.3
    HOpen 2
    Dly 0.7
    Mvs PLARGEKANA3,-170
ElseIf M30 = 14 Then
    Mov PLARGEKANA4,-300
    Mvs PLARGEKANA4
    If M100 = 1 Then Mov PSMALLKANA4
    Dly 0.2
    Mov P_Curr*(+0.00,-50.00,+0.00,+0.00,+0.00,+0.00)
    Dly 0.3
    HOpen 2
    Dly 0.7
    Mvs PLARGEKANA4,-170
Else
    M30 = 0
EndIf
Cnt 0
Return
'----------------- PART OF E1 & E2 SUBPROGRAM--------------------
*PALETSTS4
*PALETSTS3
*PALETSTS1
*PALETSTS2
If M30 >= 14 Then Mov PTRANSIT
M30 = M30+1
GoTo *JUMP
'-----------------------------------------------------------------
*WEIGHING
Print #1,"WEIGHT"
Dly 0.02
Input #1, C3$
Return
'----------------------------ERROR--------------------------------
*ERRROR
Error 9101 'is defined in the settings.