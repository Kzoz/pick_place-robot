from datetime import datetime
import os,serial

# The logEnd function procedes to logging into a text file the executed work
# It logs the date and time the work was done and returns a counter for the number of 
# works done it the execution of the program
def logEnd(filename,counter):
    now = datetime.now()            
    dt = now.strftime("%Y/%m/%d %H:%M:%S")
    print(dt,"---WORK {num} DONE!---".format(num = counter)) 
    if os.path.exists(filename):
        append_write = 'a' 
    else:
        append_write = 'w' 
    feedbck = open(filename,append_write)
    #if counter == 1:
    #    feedbck.write("------------NEW JOB-------------\n")
    feedbck.write(dt)
    feedbck.write("---WORK {num} DONE!---".format(num = counter)) 
    feedbck.write("\n")
    counter += 1
    return counter


# logStart basically fulfills the same work logEnds does. However, it comes at the beginning of the robot work
def logStart(filename, counter):
    now = datetime.now()            
    dt = now.strftime("%Y/%m/%d %H:%M:%S")
    if os.path.exists(filename):
        append_write = 'a' 
    else:
        append_write = 'w' 
    feedbck = open(filename,append_write)
    if counter == 1:
        feedbck.write("------------NEW JOB-------------\n")
    feedbck.write(dt)
    feedbck.write("---WORK {num} STARTED!---".format(num = counter)) 
    feedbck.write("\n")
    feedbck.close()

# the Function processData takes the input from PC0 and processes as follow:
#1. Format the data by removing \r\n and splitting the input into multiple values
#2. It verifies the header is in accordance to the system
#3. It verifies if the values, weights, kanamono names are correct and returns the format that will
# be sent to the robot.
def processData(sentData):
    def dataFormat(originalData):
        x=originalData.rstrip() 
        x = x.split(',') 
        x = tuple(x)
        return x
    def valueVerification(num):
        num = [int(i) for i in num]
        arr = list(range(1001,1007))
        weightDict = {1001:0,1002:0,1003:0,1004:0,1005:0,1006:0}
        for i in range(0,len(num),3):
            if (num[i] >= arr[0] and i <= arr[-1]) and num[i+2] >= 18: #here 18 means weight of Hex nut (smallest weight)
                weightDict[num[i]] = num[i+2]
        fullDict = {1001:0,1002:0,1003:0,1004:0,1005:0,1006:0}
        holder = dict(zip(num[::3],num[1::3]))
        fullDict.update(holder)
        WorkList = []
        for i in fullDict:
            WorkList.append(str(fullDict[i]))        
            WorkList.append(str(weightDict[i])) 
        return WorkList
    def verifyHeader(cmd):
        commands =['PIC','STS']
        if cmd not in commands:
            return False

    formattedData = list(dataFormat(sentData))
    verifyHeader(formattedData[0]) 
    workData = valueVerification(formattedData[1:]) 
    return workData

#The initializeScale function set the weight scale to 0 no matter its scurrent weight. 
# It is done by sending a ('Z\r\n') request to the weightscale
def initializeScale():
    hakari = serial.Serial(port='COM3',baudrate=9600,parity=serial.PARITY_EVEN,bytesize=7,stopbits=1,timeout=1)
    hakari.write('T\r\n'.encode('ascii'))
    hakari.close()


# The weighing function returns send request ('Q\r\n') to weightscale to obtain its current mass and retuns it
# The returned value is of float type
def weighing():
    hakari = serial.Serial(port='COM3',baudrate=9600,parity=serial.PARITY_EVEN,bytesize=7,stopbits=1,timeout=1)
    hakari.write('Q\r\n'.encode('ascii'))
    recv = hakari.readline()
    res=float(recv.decode('ascii')[4:12])
    hakari.close()
    return res
