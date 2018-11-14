import socket
import json
import collections
import random

def is_json(myjson):
  try:
    json_object = json.loads(myjson)
  except ValueError, e:
    return False
  return True
  
class socket_server:

  def __init__(self,port,host):
      self.sock=socket.socket()
      self.sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
      self.sock.bind((host,port))
      self.sock.listen(10)

server = socket_server(port=8888,host='127.0.0.1')
#    record the time when a measurement is received
timemea=0;
#    record the time when a overwriting command is executed
timerec=0;
i=1
while True:
    conn,addr=server.sock.accept()
    data = conn.recv(1024)
#    check if the message is in json format or not
    if not is_json(data):
        print "error: the message shall be in json format"
        continue
    dict=json.loads(data)
#    check if the message is from the sampler or the overwriting block
    if not hasattr(dict, 'keys'):
               msg={}
#    the following if-statement is to avoid receiving duplicated overwriting request, which may occur when using the JModeica                 
               if dict[-1]-timemea>=1 or varrecName!=dict[0]:
                    timemea=dict[-1]
                    temp={}
                    if i%3==0:
                        temp['enable']=True
                    elif i%3!=0 and i%5!=0:
                        temp['enable']=False
                    elif i%5==0:
                        temp['enable']=True
                        temp['derivative']=-1  
                    temp['nextSampleTime']=15+2*i
                    if dict[0].find('control_output')!=-1 or dict[0].find('control_setpoint')!=-1:
                         temp['value']=2*i/200.
                    else:
                         temp['value']=15+2*i
                    varrecName=dict[0]
                    i=i+1
               msg[varrecName]=temp
               msg=json.dumps(msg)
               print msg
               
               conn.send(msg+'\0')
    else: 
#    the following if-statement is to avoid receiving duplicated sampling result, which may occur when using the JModeica            	
               if dict[dict.keys()[0]]['time']-timerec>=1 or varmeaName!=dict.keys()[0]:
                    timerec=dict[dict.keys()[0]]['time']
                    varmeaName=dict.keys()[0]
                    print data
