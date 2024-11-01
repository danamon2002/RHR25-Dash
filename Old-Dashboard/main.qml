/*
	Dashboard Display QML File
	UI file for dashboard Display Variables
	Authors: William Ellis, Dana Maloney, Ryan Politis
*/
// Import necessary modules from QtQuick
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.2

ApplicationWindow{
	// Application window settings
	visible: true
	width: 1920
	height: 480
	title: "dashboard_app"
	property QtObject parameterUpdater
	property string rpmValue: "0" 
	property string oilValue: "0"
	property string tempValue: "0"
	property double rectWidth: parseFloat(rpmValue) * 0.11
	//property double tachGreen: qml.pow(-2, (-0.0001 * parseFloat(rpmValue) - 14 ) + 1)
	property double tachGreen: 1.6 - parseFloat(rpmValue) / 14000
	property double tachRed: parseFloat(rpmValue) / 14000

	Rectangle {	
		anchors.fill: parent
		color: "black" // fills the display so it isn't the hecking sun

		Rectangle {
			color: Qt.rgba(tachRed, tachGreen, 0, 1)
			width: rectWidth
			height: 100
		}

		RowLayout {
			anchors.fill: parent
			Layout.alignment: Qt.AlignVCenter
			ColumnLayout {
				Layout.alignment: Qt.AlignLeft
				Text {
					text: oilValue
					font.pixelSize: 64
					color: "red"
				}
			}
		    ColumnLayout {
				Layout.alignment: Qt.AlignCenter
				Text {
					text: rpmValue
					font.pixelSize: 64
					color: "chartreuse"
				}
			}
			ColumnLayout {
				Layout.alignment: Qt.AlignRight
				Text {
					text: tempValue
					font.pixelSize: 64
					color: "cyan"
				}
			}
		}
	
		Connections {	// Updater object exposes variables to python function
			
			target: parameterUpdater
			
			function onRpmChanged(msg) { 
				rpmValue = msg;
			}
			function onOilChanged(msg) { 
				oilValue = msg;
			}
			function onTempChanged(msg) { 
				tempValue = msg;
			}
		}
	}
}
