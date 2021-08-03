from kivy.app import App
from kivy.garden.joystick import Joystick
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.label import Label
from kivy.uix.button import Button
from kivy.uix.slider import Slider

from threading import Thread
from time import sleep

#для отправки по udp
import socket
import struct
UDP_IP = '127.0.0.0'#"192.168.1.67"
UDP_PORT = 5005
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
#объявляем глобальную переменную
x=0
y=0
thrust=0

class JoystickApp(App):
  def OnSliderValueChange(self, instance,value):
    self.label.text = "192.168." + str(int(self.slider.value)) + "." + str(int(self.slider1.value))
    global UDP_IP
    UDP_IP = "127.0."+ str(int(self.slider.value)) + "." + str(int(self.slider1.value))

  def ChangeThrust(self, instance,value):
      global thrust
      thrust = self.slider_thrust.value
  def build(self):
    self.root = BoxLayout()#orientation = "vertical")
    self.root.padding = 1
    self.boxlayout = BoxLayout(orientation = "vertical")
    self.slider = Slider(value_track=True, value_track_color=[1, 0, 0, 1], min = 0, max = 255)
    self.slider1 = Slider(value_track=True, value_track_color=[1, 0, 0, 1], min = 0, max = 255)
    self.slider.bind(value=self.OnSliderValueChange)
    self.slider1.bind(value=self.OnSliderValueChange)
    self.label = Label(text = "192.168." + str(int(self.slider.value)) + "." + str(int(self.slider1.value)))
    self.button = Button(text="РАСЧЁТ", background_color = (0.2,1,0,1), on_press = self.createJoystick)
    self.boxlayout.add_widget(self.label)
    self.boxlayout.add_widget(self.slider)
    self.boxlayout.add_widget(self.slider1)
    self.boxlayout.add_widget(self.button)
    self.root.add_widget(self.boxlayout)

  def createJoystick(self, instance):
    self.root.remove_widget(self.boxlayout)
    self.minibox = BoxLayout(size_hint=[0.3, 1])

    self.slider_thrust = Slider(value_track=True, value_track_color=[1, 0, 0, 1], min = 0, max = 1, orientation='vertical')
    self.slider_thrust.bind(value=self.ChangeThrust)
    self.minibox.add_widget(self.slider_thrust)
    self.root.add_widget(self.minibox)

    self.joystick = Joystick()
    self.joystick.bind(pad=self.update_coordinates)
    self.root.add_widget(self.joystick)


  def update_coordinates(self, joystick, pad):
    global x, y
    x = str(pad[0])[0:5]
    y = str(pad[1])[0:5]
    radians = str(joystick.radians)[0:5]
    magnitude = str(joystick.magnitude)[0:5]
    angle = str(joystick.angle)[0:5]

The_app = JoystickApp()

#вывод х в цикле частоту вывода можно менять или сделать отправку udp пакетов
def printer():
    while True:
        try:
            print(x, y, thrust, UDP_IP)
            sleep(0.7)
            sock.sendto(struct.pack('ddd', float(x), float(y), float(thrust)), (UDP_IP, UDP_PORT))
        except:
            print("Wait")


if __name__ == '__main__':
    my_thread = Thread(target=The_app.run, args=())
    my_thread1 = Thread(target=printer, args=())
    my_thread.start()
    my_thread1.start()
    my_thread.join()
    my_thread1.join()
