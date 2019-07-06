import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.3

Item {
    id: root
    property string fontFamily: "Consolas"
    property var fontPointSize: 15
    property alias readOnly: edit.readOnly
    property alias text: edit.text
    property alias selectionColor: edit.selectionColor
    property alias textDocument: edit.textDocument
    function append(txt) {
        edit.append(txt)
    }
    Flickable {
        id: flick
        focus: false
        anchors {
            fill: parent
        }
        contentWidth: edit.paintedWidth
        contentHeight: edit.paintedHeight + 5
        clip: true
        boundsBehavior:Flickable.StopAtBounds
        function ensureVisible(r) {
           if (contentX >= r.x)
               contentX = r.x;
           else if (contentX+width <= r.x+r.width)
               contentX = r.x+r.width-width;
           if (contentY >= r.y)
               contentY = r.y;
           else if (contentY+height <= r.y+r.height)
               contentY = r.y+r.height-height + 10;
        }
        Rectangle {
            id: textBg
            z: 0
            anchors.left: edit.left
            anchors.leftMargin: 5
            color: "#333"
            opacity: 0.2
            radius: 4
            Behavior on width {
               NumberAnimation { duration: 1000; easing.type: Easing.OutElastic }
            }
            Behavior on height {
               NumberAnimation { duration: 1000; easing.type: Easing.OutElastic }
            }
        }
        Column{
            id:lineNumberLabel
            anchors {
                left: parent.left
            }
            Repeater {
               model: edit.lineCount;
               Rectangle {
                   width: lineNumberWidth(edit.lineCount)
                   height: panding.contentHeight
                   color: "#333"
                   Text {
                       id:showLineNumber
                       anchors{
                           bottom:parent.bottom
                           bottomMargin: 1
                           horizontalCenter: parent.horizontalCenter
                       }
                       text:index + 1
                       color: "gray"
                       font.pointSize: fontPointSize
                       font.family: fontFamily
                   }
               }
            }
        }
        TextEdit{
            id: panding
            font.pointSize: fontPointSize
            visible: false
            font.family: fontFamily
            text: " "
        }
        TextEdit {
            property bool ctrlPressed: false
            anchors {
                left:lineNumberLabel.right
                leftMargin: -4
            }
            id: edit
            readOnly: root.readOnly
            selectByMouse: true
            tabStopDistance: 20
            activeFocusOnPress: true
            focus: true
            clip: true
            selectionColor: Material.accent
            wrapMode: TextEdit.WordWrap
            leftPadding: 5
            topPadding: 0.5
            font.pointSize: fontPointSize
            font.family: fontFamily
            width: flick.width - 10
            height: edit.contentHeight > flick.height ?
                        edit.contentHeight : flick.height
            anchors.margins: 10
            cursorVisible: true
            cursorDelegate: cursorDelegate
            onPaintedWidthChanged: {
                textBg.width = edit.paintedWidth + 10
            }
            onPaintedHeightChanged: {
                textBg.height = edit.paintedHeight + 1
            }
            onCursorRectangleChanged: flick.ensureVisible(cursorRectangle)
            MouseArea {
                anchors {
                    fill: parent
                }
                propagateComposedEvents: true
                onClicked: mouse.accepted = false;
                onPressed: mouse.accepted = false;
                onReleased: mouse.accepted = false;
                onDoubleClicked: mouse.accepted = false;
                onPositionChanged: mouse.accepted = false;
                onPressAndHold: mouse.accepted = false;
                cursorShape: Qt.IBeamCursor
                onWheel: {
                    var datl = wheel.angleDelta.y / 120
                    if (datl>0 && edit.ctrlPressed) {
                        fontPointSize += 1
                    } else if (datl<0 && edit.ctrlPressed) {
                        fontPointSize -= 1
                    }
                    wheel.accepted = false
                }
            }
            Keys.onPressed: {
                if(event.modifiers === Qt.ControlModifier) {
                    ctrlPressed = true
                }
                event.accepted = false
            }
            Keys.onReleased: {
                if(!(event.modifiers&Qt.ControlModifier)) {
                    ctrlPressed = false
                }
                event.accepted = false
            }
        }
        ScrollIndicator.horizontal: ScrollIndicator { }
        ScrollIndicator.vertical: ScrollIndicator { }
    }
    Component {
        id: cursorDelegate
        Rectangle {
            id: cursor
            color: Material.accent
            width: 2;
            height: 5
            SequentialAnimation {
                running: true;
                loops: ColorAnimation.Infinite
                NumberAnimation {
                    easing {
                        type: Easing.InQuint
                    }
                    property: "opacity"
                    target: cursor; from: 1.0; to: 0.0; duration: 800;
                }
                NumberAnimation {
                    easing {
                        type: Easing.InQuint
                    }
                    property: "opacity"
                    target: cursor;
                    from: 0.0;
                    to: 1.0;
                    duration: 800;
                }
            }
            Behavior on x {
                SpringAnimation { spring: 3; damping: 0.2  }
            }
            Behavior on y {
                SpringAnimation { spring: 3; damping: 0.2 }
            }
        }
    }
    function lineNumberWidth(lineCount) {
        var width = 1;
        var space = 0;
        while(lineCount >= 10) {
           lineCount /= 10;
           ++width;
        }
        return space = width * fontPointSize
    }
}

