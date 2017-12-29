import QtQuick 2.6
import QtQuick.Controls 2.0
import  "xxtea.js" as Tea
Rectangle{
    width: 800
    height: 480
    property alias protocol: routerProtocol.editText
    property alias address: routerAddress.text
    property alias port: routerPort.text
    property alias userName: routerUserName.text
    property alias password: routerPassword.text
    property string enc_kay: "www.autopard.com"
    signal buttonClicked(string button)
    Component.onCompleted: {
        protocol = appSetting.get("Protocol");
        routerProtocol.currentIndex = routerProtocol.find(protocol)

        address  = appSetting.get("Address");

        port = appSetting.get("Port");

        userName = appSetting.get("UserName");

        var enc_password = appSetting.get("Password");

        password = Tea.xxtea_decrypt(enc_password, enc_kay)

        var url = protocol + "://" + address + ":" + port;
        RouterMaster.SetupUrl(url);
        RouterMaster.Login(setupPage.userName, setupPage.password);

    }
    Column {
        id: grid
        anchors.fill: parent
        leftPadding: grid.width / 20
        rightPadding: grid.width / 20
        padding: itemHeight /10
        property real itemHeight: height / 12

        Text {
            width : grid.width
            height:  grid.itemHeight
            text: qsTr("Protocol:")
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: height *0.5
        }

        Rectangle{
            width : grid.width *0.9
            height:  grid.itemHeight
            radius: 5
            border.color: routerProtocol.activeFocus ? "blue":"gray"
            color: "transparent"
            ComboBox {
                id: routerProtocol
                anchors.fill: parent
                focus:true
                model: [ "http", "https" ]
                font.pixelSize: height *0.5
                KeyNavigation.tab: routerAddress
            }
        }

        Text {
            width : grid.width
            height:  grid.itemHeight
            text: qsTr("Address:")
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: height *0.5
        }
        Rectangle{
            width : grid.width *0.9
            height:  grid.itemHeight
            radius: 10
            border.color: routerAddress.activeFocus ? "blue":"gray"
            color: "transparent"
            TextInput {
                id: routerAddress
                validator: ipAddressValidator
                padding: 5
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: height *0.5
                wrapMode: TextEdit.NoWrap
                KeyNavigation.tab: routerPort
            }
        }


        Text {
            width : grid.width
            height:  grid.itemHeight
            text: qsTr("Port:")
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: height *0.5
        }
        Rectangle{
            width : grid.width *0.9
            height:  grid.itemHeight
            radius: 10
            border.color: routerPort.activeFocus ? "blue":"gray"
            color: "transparent"

            TextInput {
                id: routerPort
                validator: portValidator
                padding: 5
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: height *0.5
                KeyNavigation.tab: routerUserName
            }
        }

        Text {
            width : grid.width
            height:  grid.itemHeight
            text: qsTr("UserName:")
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: height *0.5
        }
        Rectangle{
            width : grid.width *0.9
            height:  grid.itemHeight
            radius: 10
            border.color: routerUserName.activeFocus ? "blue":"gray"
            color: "transparent"

            TextInput {
                id: routerUserName
                padding: 5
                validator: userNameValidator;
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: height *0.5
                KeyNavigation.tab: routerPassword
            }
        }

        Text {
            width : grid.width
            height:  grid.itemHeight
            text: qsTr("Password:")
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: height *0.5
        }
        Rectangle{
            width : grid.width *0.9
            height:  grid.itemHeight
            radius: 10
            border.color: routerPassword.activeFocus ? "blue":"gray"
            color: "transparent"

            TextInput {
                id: routerPassword
                padding: 5
                anchors.fill: parent
                inputMethodHints:Qt.ImhHiddenText
                verticalAlignment: Text.AlignVCenter
                //textFormat: TextEdit.PlainText
                echoMode: TextInput.Password
                font.pixelSize: height *0.5
                KeyNavigation.tab: okButton
            }
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
            if(address.length > 0 && port.length >0 && userName.length > 0 && password.length > 0){
                appSetting.set("Protocol", protocol);
                appSetting.set("Address", address);
                appSetting.set("Port", port);
                appSetting.set("UserName", userName);

                var enc_password = Tea.xxtea_encrypt(password, enc_kay)

                appSetting.set("Password", enc_password);
                appSetting.save();
                var url = protocol + "://" + address + ":" + port
                RouterMaster.SetupUrl(url)
                RouterMaster.Login(setupPage.userName, setupPage.password)
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
        KeyNavigation.tab: routerProtocol
        onClicked: {
            buttonClicked("Cancle")
        }
    }
}
