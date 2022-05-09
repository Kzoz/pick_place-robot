#Version 5
#Changes from version 4:
#  creation of a 'library' utilities.py that holds most of the inner functions
# added a weightscale to the same system and the functions initializeScale() and weighing() respectively
# reinitalize the scale and send the current weight to PC1 that will transfer it to RBT.
# split the process() function into to 2 functions sendToRbot() and monitorRobot() to better manage the system
# modification of the status() to be compatible with the PC0's data transfer and retrieval.


import socket,time,utilities
from datetime import datetime
from threading import Thread

#Output the robot work in new file
now = datetime.now()
seq = str(now.strftime("%Y%m%d"))
txtname = "kiroku/robot_kiroku"+seq+".txt"  #create output filename
counter,work,conn = 1,0,''

#Robot Socket Connection
rHOST = '192.168.3.5' 
rPORT = 10006
sok = socket.socket(socket.AF_INET, socket.SOCK_STREAM)


#Client Side
def sendToRobot(lst):
    global sok
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sok:
        sok.connect((rHOST, rPORT)) #connect to Robot
        for x in lst: 
            sok.sendall(b''+(x).encode('ascii'))
            time.sleep(0.02)    
            data = sok.recv(1024)
            if data == bytes(b'OK\r'):
                print('All data have been successfully sent to Robot')
        utilities.logStart(txtname,counter)
        monitorRobot()
    sok.close()

def monitorRobot():
    global work
    global counter
    work,counter = work,counter
    utilities.initializeScale() #set the scale to 0
    sok.sendall(b'INIT')
    time.sleep(0.02) 
    while True:
        data = sok.recv(1024)
        if data == bytes(b'WEIGHT\r'):
            currentWeight = str(utilities.weighing())
            sok.sendall(b''+(currentWeight).encode('ascii'))
            time.sleep(0.02) 
        if data == bytes(b'HNERROR\r'): #HN for Hex Nut
            while data == bytes(b'HNERROR\r'):
                work = 21
                time.sleep(0.02)
                sok.sendall(b'RECHECK')
                time.sleep(0.02)
                data = sok.recv(1024)
                if data !=  bytes(b'HNERROR\r'):
                    break      
        if data == bytes(b'KANA6\r'):# Kana6 was picked successfully.
            print(data)
            time.sleep(0.02)
            sok.sendall(b'CONTINUE')
            #work = 1
        if data == bytes(b'END\r'):
            counter = utilities.logEnd(txtname,counter)
            break
    print('Received from Robot:', repr(data),"\n")
    work = 0
   
    
#Check Robot Status   
def status():
    global conn # make conn global to keep using it in status()
    global work 
    if work == 0:
        conn.sendall(b'STS,0\r\n') # ready to receive new data
        return
    while work != 0: # meaning robot is executing tasks
        if work == 0:
            conn.sendall(b'STS,1\r\n')
            break
        data = conn.recv(1024)
        if work == 21:
            conn.sendall(b'STS,2_1\r\n')#Hex nut time-out error
        elif work == 1:
            conn.sendall(b'STS,1\r\n') #busy! 
        elif not data:
            break

        

#Server Side
def recvData():
    HOST = '127.0.0.1'
    PORT = 1024
    global conn
    global work
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.bind((HOST, PORT))
        s.listen()
        conn, addr = s.accept()
        with conn:
            print('Connected by', addr)
            while True:
                data = conn.recv(1024)
                if not data:
                    s.close()
                    recvData()
                while data == (b'STS\r\n'): #(b'STS\\r\\n')
                    status()
                    data = conn.recv(1024)
                    if data != (b'STS\r\n'):
                        break   
                if not data:
                    s.close()
                    recvData()
                x = data.decode('ascii')
                if x!= '':
                    worklist = utilities.processData(x)
                    if worklist == False:
                        conn.sendall(b'STS,2_2\r\n') # An error within recv data
                        s.close()
                        recvData()
                conn.sendall(b'PIC,0\r\n')
                work = 1
                print("Received new data: ",(data.decode('ascii')).rstrip())
                print("\n---STARTING WORK!---")
                #multi-thread for communicating with rbt and answering requests from PC 0
                t1 = Thread(target=sendToRobot, args=(worklist,))
                t2 = Thread(target=status, args=())#, daemon=True)
                t2.start()
                t1.start()
                t1.join()
                t2.join()
                conn.sendall(b'STS,1\r\n')

utilities.initializeScale()
recvData()