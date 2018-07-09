import socket

class socket_server:

    def __init__(self):     
          self.sock=socket.socket()
          port=8888
          host='127.0.0.1'  
          self.sock.bind((host,port))
          self.sock.listen(10)

server=socket_server()
### data received from Modelica

while 1:
       conn,addr=server.sock.accept()		 
       print('I just got a connection from ', addr)
       data = conn.recv(1024)

### inputs for Modelica models
       inputs=''
       inputs=inputs+str(data[:-1])
       conn.send(inputs)

