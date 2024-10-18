/*
	Dashboard Display QML File
	UI file for dashboard Display Variables
	Authors: William Ellis, Dana Maloney
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
	Rectangle {	
		anchors.fill: parent
		color: "black" // fills the display so it isn't the hecking sun

		RowLayout {
		
			anchors.fill: parent
			Layout.alignment: Qt.AlignVCenter
		    ColumnLayout {
				Layout.alignment: Qt.AlignCenter
				Text {
					text: rpmValue
					font.pixelSize: 64
					color: "chartreuse"
				}
			}
		}
	
		Connections {	// Updater object exposes variables to python function
			
			target: parameterUpdater
			
			function onRpmChanged(msg) { 
				rpmValue = msg;
			}
		}
	}
}
