The complex is intended for educational and research purposes. It consists of a nonlinear mathematical model of the aircraft in Matlab/Simulink,
a joystick for convenient pitch and roll control in Python3, Kivy and FlightGear visualization tools.

There are two types of control implemented in the model:
-using sliders in Matlab/Simulink itself
-via the network using the phone app

The input of the model includes control signals for pitch, roll, yaw and two motors, as well as a vector of the state space
(speeds in the Connected SC, angles, angular velocities in the Connected SC) via feedback. The output of the model is a vector
of the state space (velocities in the Connected SC, angles, angular velocities in the Connected SC). It is passed to the block for rendering in FlightGear.
As well as on graphs, together with control actions. Data is transmitted over the network to FlightGear for real-time rendering.


How to assemble.


Availability of Matlab/Simulink
The joystick application is assembled for the phone using buildozer.
Before assembling, change the ip address in main.py to the address of a pc with Matlab or use a ready-made assembly from the site http://f0541798.xsph.ru/source/soft/
FlightGear for rendering, in planer.bat set your path to the FlightGear\data folder, if desired, you can install another aircraft model and
change the value of --aircraft=c172p to another one.


How to launch it.

Open the release folder in Matlab, run the init.m file, open the Sodel_my_6dof_euler.slx file.
To draw in FlightGear, run planer.bat
To control the joystick, launch the app on your phone and change the drop input in the model.
Click on start simulation (F9) in Simulink


Комплекс предназначен для учебных и исследовательских целей. Состоит из нелинейной математической модели ЛА в Matlab/Simulink,
джойстика для удобного управления по тангажу и крену на Python3, Kivyи средства визуализации FlightGear.

В модели реализовано два типа управления:
-с помощью слайдеров в самом Matlab/Simulink
-через сеть с помощью приложения для телефона

На вход модели идут сигналы управления по тангажу, крену, рысканью и двум двигателям, также вектор пространства состояний 
(скорости в Связанной СК, углы, угловые скорости в Связанной СК) через обратную связь. На выходе модели вектор пространства
состояний (скорости в Связанной СК, углы, угловые скорости в Связанной СК). Он передаётся в блок для отрисовки в FlightGear.
А также на графики, совместно с управляющими воздействиями. По сети передаются данные в FlightGear для отрисовки в реальном времени.


Как собрать.

Наличие Matlab/Simulink
Сборка приложения джойстика под телефон осуществляется с помощью buildozer.
Перед сборкой поменять ip адрес в main.py на адрес пк с Matlab или использовать готовую сборку с сайта http://f0541798.xsph.ru/source/soft/
FlightGear для отрисовки, в planer.bat установить свой путь до папки FlightGear\data, при желании можно установить другую модель самолёта и
поменять значение --aircraft=c172p на другое.


Как запустить.

Открыть папку release в Matlab, запустить файл init.m, открыть файл Sodel_my_6dof_euler.slx.
Для отрисовки в FlightGear запустить planer.bat
Для управления джойстиком запустить приложение на телефоне и в модели поменять вход упавления.
Нажать на запуск моделирования (F9) в Simulink
