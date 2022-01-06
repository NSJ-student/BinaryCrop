import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.5
import Qt.labs.platform 1.1
import QtQuick.Dialogs 1.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.0

Window {
    id: window
    width: 450
    height: 200
    visible: true
    title: qsTr("Binary Crop")

    signal fileSelected(string path);
    signal saveBinary(string path, string offset, string length);

    function qmlLog(data){
        txtStatusLog.text = data;
        console.log(data)
    }


    StatusBar {
        id: ueStatusBar
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        transformOrigin: Item.Bottom

        RowLayout
        {
            spacing: 8

            Text {
                id: txtStatusLog
            }
        }
    }

    FileDialog {
        id: fileOpenDialog
        title: "Please choose a file"
        nameFilters: ["Bin files (*.bin)"]
        selectExisting: true
        onAccepted: {
            console.log("You chose: " + fileOpenDialog.fileUrl)
            fileSelected(fileOpenDialog.fileUrl);
            txtSourceFilePath.text = fileOpenDialog.fileUrl;
        }
        onRejected: {
            console.log("Canceled")
        }
    }


    FileDialog {
        id: fileSaveDialog
        title: "save file"
        nameFilters: ["Bin files (*.bin)"]
        selectExisting: false
        onAccepted: {
            console.log("You chose: " + fileSaveDialog.fileUrl)
            saveBinary(fileSaveDialog.fileUrl, tiBinOffset.text, tiBinLength.text);
            txtSaveFilePath.text = fileSaveDialog.fileUrl;
        }
        onRejected: {
            console.log("Canceled")
        }
    }

    Row {
        id: row
        x: 29
        width: 400
        height: 34
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 15

        Text {
            id: text1
            text: qsTr("Source: ")
            width: 50
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            font.pixelSize: 12
            anchors.leftMargin: 0
        }

        TextField {
            id: txtSourceFilePath
            text: qsTr("")
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.right: btnBinaryOpen.left
            font.pixelSize: 12
            verticalAlignment: Text.AlignVCenter
            anchors.rightMargin: 20
            anchors.leftMargin: 55
            anchors.verticalCenterOffset: 0

        }

        Button {
            id: btnBinaryOpen
            text: qsTr("Open")
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.verticalCenterOffset: 0

            onClicked: {
                console.log("open")
                fileOpenDialog.open();
            }
        }
    }

    Row {
        id: row1
        x: 29
        width: 400
        height: 34
        anchors.top: row.bottom
        anchors.topMargin: 15
        anchors.horizontalCenter: parent.horizontalCenter
        Text {
            id: text2
            text: qsTr("Dest: ")
            width: 50
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            font.pixelSize: 12
            anchors.leftMargin: 0
        }

        TextField {
            id: txtSaveFilePath
            text: qsTr("")
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.right: btnBinarySave.left
            font.pixelSize: 12
            verticalAlignment: Text.AlignVCenter
            anchors.rightMargin: 20
            anchors.verticalCenterOffset: 0
            anchors.leftMargin: 55
        }

        Button {
            id: btnBinarySave
            text: qsTr("Save")
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.verticalCenterOffset: 0

            onClicked: {
                if (txtSourceFilePath.text != "")
                {
                    fileSaveDialog.open();
                    console.log("save")
                }
            }
        }
    }

    Row {
        id: row2
        x: 29
        width: 400
        height: 34
        anchors.top: row1.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 15
        Text {
            id: text3
            text: qsTr("Offset(hex): ")
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            font.pixelSize: 12
            anchors.leftMargin: 0
        }
        Text {
            id: text5
            text: qsTr("0x")
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: text3.right
            font.pixelSize: 12
            anchors.leftMargin: 0
        }

        TextInput {
            id: tiBinOffset
            width: 80
            height: 20
            text: qsTr("0")
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: text5.right
            font.pixelSize: 12
            verticalAlignment: Text.AlignVCenter
            anchors.leftMargin: 0
        }
        Text {
            id: text4
            text: qsTr("WLength(dec): ")
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: tiBinOffset.right
            font.pixelSize: 12
            anchors.leftMargin: 15
        }

        TextInput {
            id: tiBinLength
            width: 80
            height: 20
            text: qsTr("0")
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: text4.right
            font.pixelSize: 12
            verticalAlignment: Text.AlignVCenter
            anchors.leftMargin: 5
        }
    }

}
