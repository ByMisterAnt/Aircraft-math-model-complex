import socket
from struct import unpack
from time import sleep


UDP_IP = ''
UDP_PORT = 5005
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind((UDP_IP, UDP_PORT))

def UDP_control():
    try:
        data, addr = sock.recvfrom(1024)
        x_control, y_control = unpack('dd', data)
    except:
        print('error')
        sleep(0.5)
    return x_control, y_control

while True:
    x, y = UDP_control()
    print(x*0.1, y*0.1)
