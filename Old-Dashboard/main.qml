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
	property double scaleFactor: 0.099
	property double rectWidth: parseFloat(rpmValue) * scaleFactor
	property double oilLightInd: parseFloat(oilValue) 				//Double to be checked 
	property double tempLightInd: parseFloat(tempValue)
	property double tachGreen: 1.6 - parseFloat(rpmValue) / 14000
	property double tachRed: parseFloat(rpmValue) / 14000

	Rectangle {
		anchors.fill: parent
		color: "black" // fills the display so it isn't the hecking sun

		// Shift light row
		Row {
			id: shiftLights
        	spacing: 70
        	anchors.horizontalCenter: parent.horizontalCenter
        	anchors.top: parent.top
        	anchors.topMargin: 20

        	Repeater {
            	model: 15
        		Rectangle {
                	width: 20
                	height: 20
                	radius: 10
                	color: (index === 0 || index === 14) && rectWidth >= 2000 * scaleFactor ? "chartreuse" :
                       (index === 1 || index === 13) && rectWidth >= 3000 * scaleFactor ? "chartreuse" :
                       (index === 2 || index === 12) && rectWidth >= 5000 * scaleFactor ? "chartreuse" :
					   (index === 3 || index === 11) && rectWidth >= 7000 * scaleFactor ? "red" :
                       (index === 4 || index === 10) && rectWidth >= 9000 * scaleFactor ? "red" :
					   (index === 5 || index === 9) && rectWidth >= 11000 * scaleFactor ? "red" :
                       (index === 6 || index === 8) && rectWidth >= 13000 * scaleFactor ? "orchid" :
					   (index === 7) && rectWidth >= 15000 * scaleFactor ? "orchid" :
                       "gray"
            	}
        	}
    	}

		// Tach column
		ColumnLayout {
			anchors.top: shiftLights.bottom
			anchors.topMargin: 20
			Row {
				id: tachLabels
				Layout.alignment: Qt.AlignTop
				Repeater {
				model: mainRect.labeledMarkers
					Rectangle {
						x: modelData  // Position marker according to specified width values
						Text {
							text: (modelData / scaleFactor) / 1000
							color: (index === 14 || index === 15 || index === 16) ? "red" :
							"white"
						}
					}
				}
			}

			// Tach line
			Row {
				id: tachLine
				Layout.alignment: Qt.AlignTop
				Layout.topMargin: 20
				Rectangle {
					width: 15000 * scaleFactor
					height: 2
					color: "white"
				}
				Rectangle {
					width: 2000 * scaleFactor
					height: 2
					color: "red"
				}
			}

			// RPM
			Rectangle {
				id: mainRect
				color: Qt.rgba(tachRed, tachGreen, 0, 1)
				width: Math.min(rectWidth, 17000 * scaleFactor)
				height: 100
				Layout.alignment: Qt.AlignTop

				// Specify the width values for all markers
				property var markerPositions: Array.from({length: 34}, (v, i) => (i + 1) * 500 * scaleFactor)
				// Filter labeled markers
				property var labeledMarkers: markerPositions.filter((value, index) => (index + 1) % 2 === 0)

				// Create markers at specified width values
				Repeater {
					model: mainRect.markerPositions
					Rectangle {
						width: 5
						height: mainRect.height
						color: "black"
						x: modelData  // Position marker according to specified width values
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
		}
	}
}
