import QtQuick 2.8
import QtQuick.Timeline 1.0
import QtQuick.Studio.Components 1.0
import QtQuick.Studio.Effects 1.0

import QtQuick.Controls
import QtQuick3D
import atv_dashboard
import Quick3DAssets.Sherp2 1.0
import Data 1.0 as Data
import "functions.js" as FR

Item {

   id: mainform
    width: 1280
    height: 720


    Image {
        id: cluster_ArtAsset
        x: 0
        y: 0
        source: "Cluster_Art.png"
    }

    Backgrounds_195_610 {
        x: 0
        y: 0
    }


    Item {
        id: isoIconsEffect
        x: -73
        y: 551
        width: 1033
        height: 142
        layer.enabled: true
        layer.effect: DirectionalBlurEffect {
            length: isoIconsEffect.directionalBlurLength
        }
        property real directionalBlurLength: 0

        Iso_195_156 {
            id: isoIcons
            x: 131
            y: 19
        }
    }

    View3D {
        id: view3D
        anchors.fill: parent
        anchors.rightMargin: -719
        anchors.bottomMargin: 27
        anchors.leftMargin: -15
        anchors.topMargin: -27

        environment: sceneEnvironment

        SceneEnvironment {
            id: sceneEnvironment
            antialiasingMode: SceneEnvironment.MSAA
            antialiasingQuality: SceneEnvironment.High
        }

        Node {
            id: scene
            DirectionalLight {
                id: directionalLight
            }

            PerspectiveCamera {
                id: camera
                z: 200
                fieldOfView: 30
            }

            Sherp2 {
                id: sherp
                property real x_startangle: 0.0
                property real y_startangle: 0.0
                property real z_startangle: 0.0
                eulerRotation.x: 0 - x_startangle + backend.x_angle
                eulerRotation.y: 25 - y_startangle + backend.y_angle
                eulerRotation.z: 180 - z_startangle
            }
        }


        Arrows {
            id: arrows
            x: 842
            y: 560

        }



    }

    FlipableItem {
           id: flipable
           x: 14
           y: 9
           width: 800
           height: 487
           opacity: 0.31
           flipAngle: 180

           Gp {
               id: image1
               x: 175
               y: 10
               width: 404
               height: 449
           }


           Image {
               id: image
               x: 157
               y: 177
               source: "carLogo.png"
           }
       }

       Timeline {
           id: bootTImeline
           animations: [
               TimelineAnimation {
                   id: timelineAnimation
                   property: "currentFrame"
                   duration: 5000
                   running: false
                   loops: 1
                   to: 5000
                   from: 0
               }
           ]
           startFrame: 0
           endFrame: 5000
           enabled: true

           KeyframeGroup {
               target: flipable
               property: "flipAngle"
               Keyframe {
                   value: 180
                   frame: 0
               }

               Keyframe {
                   value: 180
                   frame: 2389
               }

               Keyframe {
                   easing.bezierCurve: [0.90, 0.03, 0.69, 0.22, 1, 1]
                   value: 1.1
                   frame: 4117
               }
           }

           KeyframeGroup {
               target: flipable
               property: "opacity"
               Keyframe {
                   value: 0
                   frame: 0
               }

               Keyframe {
                   easing.bezierCurve: [0.17, 0.84, 0.44, 1.00, 1, 1]
                   value: 1
                   frame: 1015
               }
           }


           KeyframeGroup {
               target: sherp
               property: "x_startangle"
               Keyframe {
                   value: 0
                   frame: 2000
               }

               Keyframe {
                   easing.bezierCurve: [0.17, 0.70, 0.44, 1.00, 1, 1]
                   value: 30
                   frame: 4000
               }
           }


           KeyframeGroup {
               target: sherp
               property: "y_startangle"
               Keyframe {
                   value: 0
                   frame: 0
               }

               Keyframe {
                 //  easing.bezierCurve: [0.17, 0.70, 0.44, 1.00, 1, 1]
                   value: 205
                   frame: 3000
               }
           }



           KeyframeGroup {
               target: isoIconsEffect
               property: "scale"

               Keyframe {
                   value: 0.01
                   frame: 0
               }

               Keyframe {
                   value: 0.01
                   frame: 2977
               }

               Keyframe {
                   easing.bezierCurve: [0.07, 0.82, 0.17, 1.00, 1, 1]
                   value: 1
                   frame: 3473
               }
           }

           KeyframeGroup {
               target: isoIconsEffect
               property: "opacity"

               Keyframe {
                   value: 0
                   frame: 800
               }

               Keyframe {
                   easing.bezierCurve: [0.07, 0.82, 0.17, 1.00, 1, 1]
                   value: 1
                   frame: 3362
               }

               Keyframe {
                   value: 0
                   frame: 0
               }
           }

           KeyframeGroup {
               target: isoIconsEffect
               property: "directionalBlurLength"

               Keyframe {
                   value: 64
                   frame: 0
               }

               Keyframe {
                   value: 64
                   frame: 2977
               }

               Keyframe {
                   easing.bezierCurve: [0.07, 0.82, 0.17, 1.00, 1, 1]
                   value: 0
                   frame: 3473
               }
           }

           KeyframeGroup {
               target: arrows
               property: "opacity"

               Keyframe {
                   value: 0
                   frame: 2977
               }

               Keyframe {
                   easing.bezierCurve: [0.07, 0.82, 0.17, 1.00, 1, 1]
                   value: 1
                   frame: 3362
               }

               Keyframe {
                   value: 0
                   frame: 0
               }
           }
       }

       Timeline {
           id: timeline
           animations: [
               TimelineAnimation {
                   id: timelineAnimation1
                   duration: 1000
                   running: true
                   loops: 1
                   to: 1000
                   from: 0
               }
           ]
           enabled: false
           endFrame: 1000
           startFrame: 0
       }

       states: [
           State {
               name: "bootState"
               when: Data.Values.booting

               PropertyChanges {
                   target: bootTImeline
                   enabled: true
               }

               PropertyChanges {
                   target: timelineAnimation
                   running: true
               }
           },
           State {
               name: "running"
               when: !Data.Values.booting

               PropertyChanges {
                   target: bootTImeline
                   currentFrame: 5000
                   enabled: true
               }
           }
        ]



       Item {
           id: __materialLibrary__
       }
}









