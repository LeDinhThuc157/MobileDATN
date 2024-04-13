import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:smart_home/mqtt/mqtt_client.dart';

class ButtonSwitch extends StatefulWidget {
  bool on_off;
  final String image;
  final String name;
  ButtonSwitch(
      {super.key,
      required this.on_off,
      required this.image,
      required this.name});

  @override
  State<ButtonSwitch> createState() => _ButtonSwitchState();
}

class _ButtonSwitchState extends State<ButtonSwitch> {
  MqttServerClient client = MqttServerClient('white-dev.aithings.vn', "");

  @override
  Widget build(BuildContext context) {
    return TextButton(
          onPressed: () {
            setState(() {
              widget.on_off ? widget.on_off = false : widget.on_off = true;
              print("Check: ${widget.on_off}");
              sentMQTT();
            });
          },
          child: Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
      color: widget.on_off ? Color.fromARGB(255, 186, 248, 188) : Color.fromARGB(255, 246, 178, 173),
      borderRadius: BorderRadius.all(Radius.circular(10),),
      // border: Border.all(color: Colors.red, width: 2),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
            widget.image,
            color: widget.on_off ? Colors.green : Colors.red,
            scale: 1,
            height: 39,
            width: 39,
          ),
        Text(
          widget.name,
          style: TextStyle(color: Colors.black, fontSize: 14),
        )
      ],
    )),
  );
  }

  Future<void> sentMQTT() async {
    MqttClient mqttClient = await MqttClient(client);
    switch (widget.name) {
      case "Light":
        {
          widget.on_off
              ? mqttClient.Publish("c:l:s:1")
              : mqttClient.Publish("c:l:s:0");
          break;
        }
      case "Door":
        {
          widget.on_off
              ? mqttClient.Publish("c:d:s:1")
              : mqttClient.Publish("c:d:s:0");
          break;
        }
      case "Auto Light":
        {
          widget.on_off
              ? mqttClient.Publish("c:l:m:1")
              : mqttClient.Publish("c:l:m:0");
        }
      case "Auto Door":
        {
          widget.on_off
              ? mqttClient.Publish("c:d:m:1")
              : mqttClient.Publish("c:d:m:0");
        }
      case "Siren":
        {
          widget.on_off
              ? mqttClient.Publish("c:b:s:1")
              : mqttClient.Publish("c:b:s:0");
        }
    }
  }
}
