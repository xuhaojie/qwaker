import QtQuick 2.6

Rectangle{
    id: win
    width:1080
    height:1920
    property Item currentPage: homePage
     property int animationDuration: 250
     Keys.onReleased:{
         if (event.key === Qt.Key_Escape) {
             Qt.quit();
         }
     }

     function fadeOut(obj, duration) {
         visibleChangeOut.target = obj;
         visibleChangeOut.duration = duration;
         opticyChangeOut.target = obj
         opticyChangeOut.duration = duration;
         yChangeOut.target = obj
         yChangeOut.duration = duration;
         scaleChangeOut.target = obj
         scaleChangeOut.duration = duration;

         visibleChangeOut.start();
         opticyChangeOut.start();
         yChangeOut.start()
         scaleChangeOut.start()
     }

     function fadeIn(obj, duration) {
         visibleChangeIn.target = obj
         visibleChangeIn.duration = duration;
         opticyChangeIn.target = obj
         opticyChangeIn.duration = duration;
         yChangeIn.target = obj
         yChangeIn.duration = duration;
         scaleChangeIn.target = obj
         scaleChangeIn.duration = duration;

         visibleChangeIn.start();
         opticyChangeIn.start();
         yChangeIn.start()
         scaleChangeIn.start()
     }
     function switchTo(obj) {
         if(win.currentPage !== obj)
         {
             fadeOut(win.currentPage, animationDuration);
             fadeIn(obj, animationDuration);
             win.currentPage = obj;
         }
     }

     NumberAnimation {
         id:visibleChangeIn
         from:0
         to: 1.0
         property: "visible"
     }
     NumberAnimation {
         id:opticyChangeIn
         from:0
         to: 1.0
         property: "opacity"
         easing.type: Easing.InOutQuad
     }
     NumberAnimation {
         id:yChangeIn
         from: -win.height
         to: 0
         property: "y"
         easing.type: Easing.InOutQuad
     }
     NumberAnimation {
         id:scaleChangeIn
         from:0
         to:1
         property: "scale"
         easing.type: Easing.InOutQuad
     }
     NumberAnimation {
         id:visibleChangeOut
         from:1.0
         to: 0
         property: "visible"
     }
     NumberAnimation {
         id:opticyChangeOut
         to: 0
         property: "opacity"
         easing.type: Easing.InOutQuad
     }
     NumberAnimation {
         id:yChangeOut
         to: win.height
         property: "y"
         easing.type: Easing.InOutQuad
     }
     NumberAnimation {
         id:scaleChangeOut
         to:0
         property: "scale"
         easing.type: Easing.InOutQuad
     }

    Item {
        id: viewArea
        anchors.fill: parent
        HomePage {
            id: homePage
            x:0
            y:0
            width: viewArea.width
            height: viewArea.height
            visible:true
        }

        HostPage {
            id: hostPage
            x:0
            y:0
            width: viewArea.width
            height: viewArea.height
            visible:false
        }

        SetupPage {
            id: setupPage
            x:0
            y:0
            width: viewArea.width
            height: viewArea.height
            visible:false
        }
    }

    MessageBox {
        id: removeConfirmBox
        title: "Are you sure?"
        buttonCaptions: ["Ok","Cancle"]
    }

    MessageBox {
        id: powerConfirmBox
        title: "Are you sure?"
        buttonCaptions: ["Ok","Cancle"]

    }
    RegExpValidator{id: userNameValidator; regExp:/^[a-zA-Z][a-zA-Z0-9_]{4,15}$/;}
    IntValidator{id: portValidator; bottom: 1; top: 65535;}
    RegExpValidator{id: ipAddressValidator;regExp:/^((25[0-5]|2[0-4]\d|((1\d{2})|([1-9]?\d)))\.){3}(25[0-5]|2[0-4]\d|((1\d{2})|([1-9]?\d)))$/;}
    RegExpValidator{id: macAddressValidator; regExp:/^([0-9a-fA-F]{2})(([:][0-9a-fA-F]{2}){5})$/;}
}






