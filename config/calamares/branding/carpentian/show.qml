import QtQuick 2.0;
import calamares.slideshow 1.0;

Presentation
{
    id: presentation
    Timer {
        interval: 12000
        running: true
        repeat: true
        onTriggered: presentation.goToNextSlide()
    }
    Slide {
        Image {
            anchors.centerIn: parent
            id: image1
            width: 480
            height: 360
            fillMode: Image.PreserveAspectFit
            smooth: true
            source: "welcome.png"
        }
    }
    Slide {
        Text {
            anchors.centerIn: parent
            text: "Carpentian — the potato-powered OS.\nInstalling to disk…"
            font.pixelSize: 22
            color: "#c8c8c8"
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
