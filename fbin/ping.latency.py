import socket, time, os, sys, re

def getping():
        pingaling = os.popen("ping -q -c2 kernel.org")
        sys.stdout.flush()
        while 1:
                line = pingaling.readline()
                if not line: break
                line=line.split("\n")
                for part in line:
                        if "rtt" in part:
                                part=part.split(" = ")[1]
                                part=part.split('/')[1]
                                print part+"ms"
                                return part

def add2log(stuff):
        f=open("pings.txt",'a')
        f.write(stuff+",")
        f.close()

while 1:
        print "pinging...",
        stuff="[%s,%s]"%(time.time(),getping())
        print stuff
        add2log(stuff)
        time.sleep(1)
