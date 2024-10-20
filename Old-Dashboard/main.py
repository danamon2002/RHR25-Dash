#! /usr/bin/env python3
# Authors: Dana Maloney, William Ellis
# Version: 0.0.1
# Date:    1/30/2024
import sys
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtCore import QTimer, QObject, pyqtSignal

# Define QML app, and the QML render engine
app = QGuiApplication(sys.argv)

print("Application loaded")

engine = QQmlApplicationEngine()

print("Engine Initialized")

# If the app quits, shutdown engine object
#engine.quit.connect(app.quit)


# Load UI from file
engine.load('main.qml')

print("Loaded file \'main.qml\' from working dir.")

class ParameterUpdater(QObject):

	#oilChanged = pyqtSignal(str, arguments=['oil'])
	rpmChanged = pyqtSignal(str, arguments=['rpmValue'])
	#tempChanged = Signal(str)

	def __init__(self):
		super().__init__()
		#self.oil_value = "0"
		self.rpm_value = "1200"
		#self.temp_value = "0"

		self.timer = QTimer()
		self.timer.timeout.connect(self.update_parameters)
		self.timer.start(1000)  # Update every 1 second

	def update_parameters(self):
        # Example: Update parameters
		#self.oil_value = str(int(self.oil_value) + 1)
		self.rmp_value = str(int(self.rpm_value) + 10)
		#self.temp_value = str(int(self.temp_value) + 1)

        # Emit signals to notify QML of parameter changes
		#self.oilChanged.emit(self.oil_value)
		self.rpmChanged.emit(self.rpm_value)
		#self.tempChanged.emit(self.temp_value)


if __name__ == '__main__':

	# Create a parameter updater object
	parameterUpdater = ParameterUpdater()

	# Binding the updater function to the render engine
	engine.rootObjects()[0].setProperty('parameterUpdater', parameterUpdater)

	parameterUpdater.update_parameters()

	sys.exit(app.exec())
