from kivy.app import App
from kivy.garden.joystick import Joystick
from kivy.uix.boxlayout import BoxLayout

from threading import Thread
from time import sleep

#для отправки по udp
import socket
import struct
UDP_IP = '127.0.0.1'#"192.168.1.67"
UDP_PORT = 5005
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
#объявляем глобальную переменную
x=0
y=0

class JoystickApp(App):
  def build(self):
    self.root = BoxLayout()
    self.root.padding = 25
    joystick = Joystick()
    joystick.bind(pad=self.update_coordinates)
    self.root.add_widget(joystick)

  def update_coordinates(self, joystick, pad):
    global x, y
    x = str(pad[0])[0:5]
    y = str(pad[1])[0:5]
    #print(self.x, self.y)
    radians = str(joystick.radians)[0:5]
    magnitude = str(joystick.magnitude)[0:5]
    angle = str(joystick.angle)[0:5]

The_app = JoystickApp()

#вывод х в цикле частоту вывода можно менять или сделать отправку udp пакетов
def printer():
    while True:
        print(x, y)
        sleep(0.4)
        sock.sendto(struct.pack('dd', float(x), float(y)), (UDP_IP, UDP_PORT))

if __name__ == '__main__':
    for i in range(2):

        if i <= 0:
            my_thread = Thread(target=The_app.run, args=())

        elif i >= 1:
            my_thread = Thread(target=printer, args=())

        my_thread.start()
    my_thread.join()







"""

#UDP_IP = "192.168.1.67"
UDP_IP = ''
UDP_PORT = 5005
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind((UDP_IP, UDP_PORT))

while True:
	try:
		data, addr = sock.recvfrom(1024)
		print(data.decode('utf-8'))
	except:
		print("gg")
		t.sleep(0.5)


#sock.sendto(MESSAGE, (UDP_IP, UDP_PORT))
"""
