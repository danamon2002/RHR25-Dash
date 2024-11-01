#! /usr/bin/env python3
# Authors: Dana Maloney, William Ellis, Ryan Politis
# Version: 0.0.3
# Date:    11/1/2024

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

	oilChanged = pyqtSignal(str, arguments=['oilValue'])
	rpmChanged = pyqtSignal(str, arguments=['rpmValue'])
	tempChanged = pyqtSignal(str, arguments=['tempValue'])

	def __init__(self):
		super().__init__()
		self.oil_value = "0"
		self.rpm_value = "1500"
		self.temp_value = "0"

		self.timer = QTimer()
		self.timer.timeout.connect(self.update_parameters)
		self.timer.start(100)  # Update every x second

	def update_parameters(self):
        # Example: Update parameters
		self.oil_value = str(round(float(self.oil_value) + 1.2, 1))
		self.rpm_value = str(int(self.rpm_value) + 200)
		self.temp_value = str(round(float(self.temp_value) + 1.41, 1))

        # Emit signals to notify QML of parameter changes
		self.oilChanged.emit(self.oil_value + "PSI")
		self.rpmChanged.emit(self.rpm_value + "RPM")
		self.tempChanged.emit(self.temp_value + "℃")

if __name__ == '__main__':

	# Create a parameter updater object
	parameterUpdater = ParameterUpdater()

	# Binding the updater function to the render engine
	engine.rootObjects()[0].setProperty('parameterUpdater', parameterUpdater)

	parameterUpdater.update_parameters()

	sys.exit(app.exec())
