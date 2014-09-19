import pylab, time, datetime, numpy

def smoothTriangle(data,degree,dropVals=False):
        triangle=numpy.array(range(degree)+[degree]+range(degree)[::-1])+1
        smoothed=[]
        for i in range(degree,len(data)-degree*2):
                point=data[i:i+len(triangle)]*triangle
                smoothed.append(sum(point)/sum(triangle))
        if dropVals:
                print "smoothlen:",len(smoothed)
                return smoothed
        #smoothed=[smoothed[0]]*(degree+degree/2)+smoothed
        #while len(smoothed)<len(data):smoothed.append(smoothed[-1])
        while len(smoothed)<len(data):smoothed=[None]+smoothed+[None]
        if len(smoothed)>len(data):smoothed.pop(-1)
        return smoothed

print "reading"
f=open("pings.txt")
raw=eval("[%s]"%f.read())
f.close()

xs,ys,big=[],[],[]
for item in raw:
        t=datetime.datetime.fromtimestamp(item[0])
        maxping=20000
        if item[1]>maxping or item[1]==None:
                item[1]=maxping
                big.append(t)
        ys.append(float(item[1]))
        xs.append(t)

#print xs
#raw_input("WAIT")

print "plotting"
fig=pylab.figure(figsize=(10,7))
pylab.plot(xs,ys,'k.',alpha=.1)
pylab.plot(xs,ys,'k-',alpha=.1)
pylab.plot(xs,smoothTriangle(ys,15),'b-')
pylab.grid(alpha=.3)
pylab.axis([None,None,None,2000])
#pylab.semilogy()
#pylab.xlabel("time")
pylab.ylabel("latency (ping kernel.org, ms)")
pylab.title("D3-3 Network Responsiveness")
fig.autofmt_xdate()
#pylab.show()
pylab.savefig('out.png')
pylab.semilogy()
pylab.savefig('out2.png')
fig.autofmt_xdate()
print "done"

