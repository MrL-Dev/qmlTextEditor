import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.3

ApplicationWindow {
    id: root
    objectName: "root"
    visible: true
    width: 640
    height: 480
    title: qsTr("QML Text Editor")
    Material.accent: Material.Blue
    CustomTextEditor {
        id: editor
        objectName: "editor"
        anchors.fill: parent
    }
}
