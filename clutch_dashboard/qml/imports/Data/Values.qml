/****************************************************************************
**
** Copyright (C) 2019 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Design Studio.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

pragma Singleton
import QtQuick 2.10

//import org.vks.GPObjects 1.0
//import org.vks.GPObjectType 1.0
import atv_dashboard

QtObject {
    id: values
    /* Iso Icons Boolean Values */
    property bool gplink: IconBlock.gp_link
    property bool water: IconBlock.water
    property bool holdon: IconBlock.holdon
    property bool rearGP_squeeze: IconBlock.rearGP_squeeze
    property bool frontGP_squeeze: IconBlock.frontGP_squeeze
    property bool faultF1: IconBlock.faultF1
    property bool faultF2: IconBlock.faultF2


    property int rear_left_Motor_state: Rear_left_GP.motor_state
    property int rear_right_Motor_state: Rear_right_GP.motor_state
    property int front_left_Motor_state: Front_left_GP.motor_state
    property int front_right_Motor_state: Front_right_GP.motor_state

    property int rear_left_GP_state: Rear_left_GP.gp_state
    property int rear_right_GP_state: Rear_right_GP.gp_state
    property int front_left_GP_state: Front_left_GP.gp_state
    property int front_right_GP_state: Front_right_GP.gp_state

    property int atv_angle: AnimationATV.angle
    property bool atv_running: AnimationATV.run

    /* State change bool */
    property bool booting: true
    readonly property real bootDuration: 5000

    property Timer bootTimer: Timer{
        running: true
        repeat: false
        onTriggered: values.booting = false
        interval: bootDuration
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
