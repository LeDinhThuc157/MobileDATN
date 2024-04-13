import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:smart_home/mqtt/mqtt_client.dart';

class ButtonSFan extends StatefulWidget {
  int mode_fan;
  ButtonSFan({
    super.key,
    required this.mode_fan,
  });

  @override
  State<ButtonSFan> createState() => _ButtonSFanState();
}

class _ButtonSFanState extends State<ButtonSFan> {
  MqttServerClient client = MqttServerClient('white-dev.aithings.vn', "");

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          onPressed: () {
            if (widget.mode_fan > 0) {
              widget.mode_fan--;
            } else {
              widget.mode_fan = 5;
            }
            setState(() {
              sentMQTT();
              print("Muc: $widget.mode_fan");
            });
          },
          child: Transform.rotate(
            angle: pi,
            child: Image.asset(
              "assets/icons/arrow.png",
              height: 39,
              width: 39,
            ),
          ),
        ),
        Text("${widget.mode_fan}",
            style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold)),
        TextButton(
          onPressed: () {
            if (widget.mode_fan < 5) {
              widget.mode_fan++;
            } else {
              widget.mode_fan = 0;
            }
            setState(() {
              sentMQTT();
              print("Muc: ${widget.mode_fan}");
            });
          },
          child: Image.asset(
            "assets/icons/arrow.png",
            height: 39,
            width: 39,
          ),
        )
      ],
    );
  }

  Future<void> sentMQTT() async {
    MqttClient mqttClient = await MqttClient(client);
    mqttClient.Publish("c:f:s:${widget.mode_fan}");
  }
}
