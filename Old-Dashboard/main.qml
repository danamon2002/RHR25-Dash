/*
	Dashboard Display QML File
	UI file for dashboard Display Variables
	Authors: William Ellis, Dana Maloney, Ryan Politis, Justin Da Silva
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
	property double scaleFactor: 0.11
	property double rectWidth: parseFloat(rpmValue) * scaleFactor
	property double oilLightInd: parseFloat(oilValue) 				//Double to be checked 
	property double tempLightInd: parseFloat(tempValue)
	property double tachGreen: 1.6 - parseFloat(rpmValue) / 14000
	property double tachRed: parseFloat(rpmValue) / 14000

    property int maxWidth: 1600  // Maximum width to reach final illumination
    property int circleSpacing: 100

	Rectangle {	
		anchors.fill: parent
		color: "black" // fills the display so it isn't the hecking sun

		Row {
			id: shiftLights
        	spacing: 70
        	anchors.horizontalCenter: parent.horizontalCenter
        	anchors.top: parent.top
        	anchors.topMargin: 20

        	Repeater {
            	model: mainRect.markerPositions
        		Rectangle {
                	width: 20
                	height: 20
                	radius: 10
                	color: (index === 0 || index === 14) && mainRect.width >= circleSpacing ? "chartreuse" :
                       (index === 1 || index === 13) && mainRect.width >= 2 * circleSpacing ? "chartreuse" :
                       (index === 2 || index === 12) && mainRect.width >= 3 * circleSpacing ? "chartreuse" :
					   (index === 3 || index === 11) && mainRect.width >= 4 * circleSpacing ? "red" :
                       (index === 4 || index === 10) && mainRect.width >= 7 * circleSpacing ? "red" :
					   (index === 5 || index === 9) && mainRect.width >= 8 * circleSpacing ? "red" :
                       (index === 6 || index === 8) && mainRect.width >= 12 * circleSpacing ? "purple" :
					   (index === 7) && mainRect.width >= 16 * circleSpacing ? "purple" :
                       "gray"
            	}
        	}
    	}

		Rectangle {
			id: mainRect
			color: Qt.rgba(tachRed, tachGreen, 0, 1)
			width: rectWidth
			height: 100
			anchors.top: shiftLights.bottom
			anchors.topMargin: 20

        	// Specify the width values for the markers
        	property var markerPositions: [1000 * scaleFactor, 2000 * scaleFactor, 3000 * scaleFactor, 4000 * scaleFactor, 5000 * scaleFactor, 6000 * scaleFactor, 7000 * scaleFactor, 8000 * scaleFactor, 9000 * scaleFactor, 10000 * scaleFactor, 11000 * scaleFactor, 12000 * scaleFactor, 13000 * scaleFactor, 14000 * scaleFactor, 15000 * scaleFactor]

        	// Create markers at specified width values
        	Repeater {
            	model: mainRect.markerPositions
            	Rectangle {
                	width: 2
                	height: mainRect.height
                	color: "black"
                	x: modelData  // Position marker according to specified width values
					Text {
						text: " " + (modelData / scaleFactor) / 1000
					}
            	}
			}
		}

		
	

		
		RowLayout {
			anchors.fill: parent
			Layout.alignment: Qt.AlignVCenter
			ColumnLayout {
				Layout.alignment: Qt.AlignLeft
				Text {
					text: oilValue
					font.pixelSize: 64
					color: "white"

					Rectangle{								//Oil pressure warning 
						anchors.top: parent.bottom
						anchors.margins: 50
						x: 93
						Rectangle{
							width:  50
							height: 50
							radius: 40
							property bool oilWarning: (oilLightInd >= 35) && (oilLightInd <= 60)
							color: oilWarning ? normalColor : errorColor
    						property color normalColor: Qt.rgba(0,1,0,1)
							property color errorColor: Qt.rgba(1,0,0,1)
							SequentialAnimation on errorColor {			//Blink
								loops: Animation.Infinite
								running: !oilWarning
								ColorAnimation {from: "white"; to: "red"; duration: 300 }
								ColorAnimation { from: "red"; to: "white";  duration: 300 }
    							}
						}
					}
			     }
			}
			
		    ColumnLayout {
				Layout.alignment: Qt.AlignCenter
				Text {
					text: rpmValue
					font.pixelSize: 64
					color: "white"
				}
			}

			ColumnLayout {
				Layout.alignment: Qt.AlignRight
				Text {
					text: tempValue
					font.pixelSize: 64
					color: "white"

					Rectangle{							//Engine temp warning
						anchors.top: parent.bottom
						anchors.right: parent.right
						anchors.margins: 50
						Rectangle{
							x: -90
							width:  50
							height: 50
							radius: 40
							property bool tempWarning: (tempLightInd <= 100) && (tempLightInd >= 70)
							color: tempWarning ? normalColor : errorColor
    						property color normalColor: Qt.rgba(0,1,0,1)
							property color errorColor: Qt.rgba(1,0,0,1)
							SequentialAnimation on errorColor {
								id: anim
								loops: Animation.Infinite
								running: !tempWarning
								ColorAnimation {from: "white"; to: "red"; duration: 300 }
								ColorAnimation { from: "red"; to: "white";  duration: 300 }
    							}
						}
					}
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
			function onOilGreen(msg) {
				oilGreen = msg;
			}
		}
	}
}
