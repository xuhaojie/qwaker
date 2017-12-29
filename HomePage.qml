import QtQuick 2.6

Rectangle{
    id: home
    anchors.fill: parent
    property Item currentPage: homePage
    property int animationDuration: 250

    ListView {
        id: listview
        focus: true
        clip: true
        width: parent.width
        height: parent.height - setupButton.height
        model: hostModel
        delegate: Rectangle {
            id: delegate
            width: listview.width
            height: home.height / 10
            Image {
                id: hostIcon
                anchors.left: parent.left
                height: delegate.height
                width: height
                source: (icon != undefined && icon.length > 0) ? icon: "images/computer.png"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        var host = {
                            "icon": icon,
                            "name" : name,
                            "ip" :  ip,
                            "mac" : mac
                        };
                        powerConfirmBox.prompt = "Power on " + name + " ?"
                        powerConfirmBox.doModal();
                        powerConfirmBox.userParam = host
                    }
                }
            }

            Item{
                anchors.left: hostIcon.right
                anchors.right: removeBtn.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                Text {
                    id: hostName
                    anchors.left: parent.left
                    height: delegate.height
                    width: parent.width * 0.5
                    text: name
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: height *0.5
                    color: "black"
                }

                Text {
                    anchors.left: hostName.right
                    anchors.right: parent.right
                    anchors.top: parent.top
                    height: delegate.height /2
                    text: "ip: " + ip
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: height *0.5
                    color: "gray"

                }
                Text {
                    anchors.left: hostName.right
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: delegate.height /2
                    text: "mac: " + mac
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: height *0.5
                    color: "gray"
                }
            }

            Image  {
                id: removeBtn
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                height: delegate.height*0.5
                width: height
                source: "images/remove.jpg"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {

                        removeConfirmBox.prompt = "Delete item " + name + " ?"
                        removeConfirmBox.doModal();
                        removeConfirmBox.userParam = index
                    }

                }
            }

        }
    }

    Connections {
        target: removeConfirmBox
        onItemClicked:{
            console.debug(removeConfirmBox.userParam)
            if(index == 0) hostModel.remove(removeConfirmBox.userParam);
        }
    }

    Connections {
        target: powerConfirmBox
        onItemClicked:{
            var host = powerConfirmBox.userParam;
            console.debug("Wake up " + host.name+ " ip:" + host.ip + " mac:" + host.mac);
            if(index == 0){
                var ip = host.ip
                if( ip.length > 0)
                    RouterMaster.WakeUp(ip);
                var mac = host.mac
                if(mac.legnth > 0)
                    RouterMaster.WakeUp(mac);
            }
            //RouterMaster.Logout()
        }
    }

    Image  {
        id: addButton
        height : home.height / 10
        width : height
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        source: "images/add.jpg"
        MouseArea {
            anchors.fill: parent
            onClicked: {
                switchTo(hostPage);
            }
            Connections {
                target: hostPage
                onButtonClicked: {
                    switchTo(homePage)
                    if("Ok" === button){
                        var host = {
                            "icon" : hostPage.hostIcon,
                            "name" : hostPage.hostName,
                            "ip" :  hostPage.hostIp,
                            "mac" : hostPage.hostMac
                        };

                        hostModel.append(host);
                        listview.positionViewAtEnd()
                        hostModel.save();
                    }
                }
            }
        }
    }

    Image  {
        id: setupButton
        height : home.height / 10
        width : height
        anchors.bottom: parent.bottom
        anchors.left: parent.left

        source: "images/setup.png"
        MouseArea {
            anchors.fill: parent
            onClicked: {
                switchTo(setupPage);
            }
            Connections {
                target: setupPage
                onButtonClicked: {
                    switchTo(homePage)
                }
            }
        }
    }
}

