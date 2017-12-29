import QtQuick 2.7
import QtQuick.Controls 2.0

Rectangle{
    width: 480
    height: 720
    property string hostIcon
    property alias hostName: hostName.text
    property string hostIp: hostIp.text
    property string hostMac: hostMac.text
    signal buttonClicked(string button)
    Column {
        id: grid
        anchors.fill: parent
        leftPadding: grid.width / 20
        rightPadding: grid.width / 20
        padding: itemHeight / 2
        property real itemHeight: height / 10

        Item{
            width : grid.width
            height:  grid.itemHeight*2
            Text {
                width : grid.width
                height:  grid.itemHeight
                text: qsTr("Icon:")
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: height *0.5
            }

            PathView {
                id: hostIconCollection
                anchors.fill: parent
                //pathItemCount: 5;
                property int pathMargin: hostIconCollection.height * 2 / 3
                preferredHighlightBegin: 0.45;
                preferredHighlightEnd: 0.55;
                highlightRangeMode: PathView.StrictlyEnforceRange;
                interactive: true

                model: ListModel{
                    ListElement{title:"Computer"; cover:"images/computer.png"}
                    ListElement{title:"Laptop"; cover:"images/laptop.png"}
                    ListElement{title:"Printer"; cover:"images/printer.png"}
                    ListElement{title:"Server"; cover:"images/server.png"}
                }
                delegate:
                    Rectangle {
                        height: hostIconCollection.height / 2;
                        width: height;
                        smooth: true;
                        scale: PathView.scale
                        color: "transparent"// Qt.rgba(Math.random(), Math.random(), Math.random(), 1);
                        border.width: 3;
                        border.color: PathView.isCurrentItem ? "green" : "transparent";
                        Image {
                            width: parent.height
                            height: parent.height
                            source: cover
                        }
                }
                path: Path {
                    startX: 0
                    startY: hostIconCollection.pathMargin

                    PathAttribute { name: "scale"; value: 0.6 }

                    PathLine { x: hostIconCollection.width/4;  y: hostIconCollection.pathMargin }
                    PathAttribute { name: "scale"; value: 0.8 }

                    PathLine { x: hostIconCollection.width*2/4; y: hostIconCollection.pathMargin }
                    PathAttribute { name: "scale"; value: 1.5 }

                    PathLine { x: hostIconCollection.width*3/4; y: hostIconCollection.pathMargin }
                    PathAttribute { name: "scale"; value: 0.8 }

                    PathLine { x: hostIconCollection.width*4/4; y: hostIconCollection.pathMargin }
                    PathAttribute { name: "scale"; value: 0.6 }
                }
            }

        }


        Text {
            width : grid.width
            height:  grid.itemHeight
            text: qsTr("Name:")
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: height *0.5

        }

        Rectangle{
            width : grid.width *0.9
            height:  grid.itemHeight
            radius: 5
            border.color: hostName.activeFocus ? "blue":"gray"
            color: "transparent"
            TextInput {
                id: hostName
//                 validator: userNameValidator
                padding: 5
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: height *0.5
                KeyNavigation.tab: hostIp
            }
        }

        Text {
            width : grid.width
            height:  grid.itemHeight
            text: qsTr("Ip:")
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: height *0.5
        }
        Rectangle{
            width : grid.width *0.9
            height:  grid.itemHeight
            radius: 5
            border.color: hostIp.activeFocus ? "blue":"gray"
            color: "transparent"

            TextInput {
                id: hostIp
                validator: ipAddressValidator;
                padding: 5
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: height *0.5
                wrapMode: TextEdit.NoWrap
                KeyNavigation.tab: hostMac
            }
        }


        Text {
            width : grid.width
            height:  grid.itemHeight
            text: qsTr("MAC:")
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: height *0.5
        }
        Rectangle{
            width : grid.width *0.9
            height:  grid.itemHeight
            radius: 5
            border.color: hostMac.activeFocus ? "blue":"gray"
            color: "transparent"

            TextInput {
                id: hostMac
                validator: macAddressValidator;
                padding: 5
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: height *0.5
                KeyNavigation.tab: okButton
            }
        }

    }

    Connections{
        target: hostIconCollection
        onCurrentIndexChanged:{
            var item = hostIconCollection.model.get(hostIconCollection.currentIndex)
            hostIcon = item.cover
        }
    }

    Button {
        id: okButton
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width : grid.width * 0.5
        height:  grid.itemHeight
        text: "Ok"
        font.pixelSize: height *0.5
        KeyNavigation.tab: cancleButton
        onClicked: {
            if(hostName.text.length > 0 && (hostIp.text.length >= 7 || hostMac.text.length == 17)){
                buttonClicked("Ok")
            }
        }

    }

    Button {
        id: cancleButton
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        width : grid.width * 0.5
        height:  grid.itemHeight
        text: "Cancle"
        font.pixelSize: height *0.5
        KeyNavigation.tab: hostIconCollection
        onClicked: {
            buttonClicked("Cancle")
        }
    }

}
