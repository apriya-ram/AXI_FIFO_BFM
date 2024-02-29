import sys
import os

f1=open("testcases.txt","w+")
n=len(sys.argv)
for i in range(1,n):
 # print(sys.argv[i])
# a=(sys.argv[1])
  if "fifo_bfm" in sys.argv[i]:
    testname=sys.argv[i].split("fifo_bfm")[1].split(".sv")[0]
    f1.write("fifo_bfm"+testname)
    #f1.write(sys.argv[i])
    f1.write("\n")
   #print(x)
f1.close()
#f1.seek(0)


f1=open("testcases.txt","r")
line=f1.read().splitlines()

for i in line:
  c = "make all test=\""+i+"\""
  os.system(c)
  



