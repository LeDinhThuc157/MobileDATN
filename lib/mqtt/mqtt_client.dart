import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttClient{
  MqttServerClient? client;
  MqttClient(this.client);
  Future<void> Publish(String data) async {
    // client?.port = 1883;
    // client?.useWebSocket = true;
    client?.logging(on: false);

    // Đăng nhập với tên người dùng và mật khẩu
    client?.setProtocolV311();

    /// If you intend to use a keep alive you must set it here otherwise keep alive will be disabled.
    client?.keepAlivePeriod = 20;

    /// The connection timeout period can be set if needed, the default is 5 seconds.
    client?.connectTimeoutPeriod = 2000; // milliseconds
    final connMess = MqttConnectMessage()
        .withClientIdentifier('')
        .withWillTopic('doan2/aithing/control') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    print('EXAMPLE::Mosquitto client connecting....');
    client?.connectionMessage = connMess;
    try {
      print('Conecting....');
      await client?.connect();
    } catch (e) {
      print('Exception: $e');
      client?.disconnect();
    }
    const pubTopic = 'doan2/aithing/control';
    final builder = MqttClientPayloadBuilder();
    builder.addString(data);
    client?.publishMessage(pubTopic, MqttQos.atLeastOnce, builder.payload!);
    client?.disconnect();
    print('Disconnect! Sent to complete....');
  }
}

// 20240406112405	tem:30.1	hum:60.5	mq2:3273	dr1:1	dm1:1	ds1:1	dr2:1	dm2:1	ds2:1	fn1:1	fs1:1	fn2:1	fs2:0	ld1:1	lm1:1	ls1:1	ld2:1	lm2:1	ls2:1	bs:0

