import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'package:iot_manager/ui/recvmsg.dart';
import 'package:iot_manager/ui/sendmsg.dart';
import 'dart:async';
import 'dart:math';
import 'package:lamp/lamp.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IoT Manager',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'IoT Manager'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  PageController _pageController;
  int _page = 0;

  String titleBar         = 'IoT-Manager';
  String broker           = 'tailor.cloudmqtt.com';
  int port                = 18184;
  String username         = 'kvuwrinm';
  String passwd           = 'TJaId_fJy2me';
  String clientIdentifier = 'lamhx_' + new Random().nextInt(100).toString();

  mqtt.MqttClient client;
  mqtt.MqttConnectionState connectionState;

  StreamSubscription subscription;

  TextEditingController brokerController = TextEditingController();
  TextEditingController portController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwdController = TextEditingController();
  TextEditingController identifierController = TextEditingController();

  TextEditingController topicController = TextEditingController();
  Set<String> topics = Set<String>();

  List<Message> messages = <Message>[];
  ScrollController messageController = ScrollController();

  @override
  Widget build(BuildContext context) {
    IconData connectionStateIcon;
    switch (client?.connectionState) {
      case mqtt.MqttConnectionState.connected:
        connectionStateIcon = Icons.cloud_done;
        break;
      case mqtt.MqttConnectionState.disconnected:
        connectionStateIcon = Icons.cloud_off;
        break;
      case mqtt.MqttConnectionState.connecting:
        connectionStateIcon = Icons.cloud_upload;
        break;
      case mqtt.MqttConnectionState.disconnecting:
        connectionStateIcon = Icons.cloud_download;
        break;
      case mqtt.MqttConnectionState.faulted:
        connectionStateIcon = Icons.error;
        break;
      default:
        connectionStateIcon = Icons.cloud_off;
    }
    void navigationTapped(int page) {
      _pageController.animateToPage(page,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }

    void onPageChanged(int page) {
      setState(() {
        this._page = page;
      });
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(titleBar),
              SizedBox(
                width: 8.0,
              ),
              Icon(connectionStateIcon),
            ],
          ),
        ),
//        floatingActionButton: _page == 2
//            ? Builder(builder: (BuildContext context) {
//          return FloatingActionButton(
//            child: Icon(Icons.add),
//            onPressed: () {
//              Navigator.push(
//                  context,
//                  MaterialPageRoute<String>(
//                    builder: (BuildContext context) =>
//                        SendMessageDialog(client: client),
//                    fullscreenDialog: true,
//                  ));
//            },
//          );
//        })
//            : null,
        bottomNavigationBar: BottomNavigationBar(
          onTap: navigationTapped,
          currentIndex: _page,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.cloud),
              title: Text('Broker'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.playlist_add),
              title: Text('Subscriptions'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              title: Text('Messages'),
            ),
          ],
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: onPageChanged,
          children: <Widget>[
            _buildBrokerPage(connectionStateIcon),
            _buildSubscriptionsPage(),
            _buildMessagesPage(),
          ],
        ),
      ),
    );
  }

  Column _buildBrokerPage(IconData connectionStateIcon) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox( //Input Broker
              width: 200.0,
              child: TextField(
                controller: brokerController,
                decoration: InputDecoration(hintText: broker),

              ),
            ),
            SizedBox( //Input Port
              width: 200.0,
              child: TextField(
                controller: portController,
                decoration: InputDecoration(hintText: port.toString()),
              ),
            ),
            SizedBox( //Username
              width: 200.0,
              child: TextField(
                controller: usernameController,
                decoration: InputDecoration(hintText: username),
              ),
            ),
            SizedBox( //Passwd
              width: 200.0,
              child: TextField(
                controller: passwdController,
                decoration: InputDecoration(hintText: passwd),
              ),
            ),
            SizedBox( //Passwd
              width: 200.0,
              child: TextField(
                controller: identifierController,
                decoration: InputDecoration(hintText: clientIdentifier),
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              broker + ':' + port.toString(),
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(width: 8.0),
            Icon(connectionStateIcon),
          ],
        ),
        SizedBox(height: 8.0),
        RaisedButton(
          child: Text(client?.connectionState == mqtt.MqttConnectionState.connected
              ? 'Disconnect'
              : 'Connect'),
          onPressed: () {
            if(brokerController.value.text.isNotEmpty) {
              broker = brokerController.value.text;
            }

            port = int.tryParse(portController.value.text);
            if(port == null) {
              port = 18184;
            }
            if(usernameController.value.text.isNotEmpty) {
              username = usernameController.value.text;
            }
            if(passwdController.value.text.isNotEmpty) {
              passwd = passwdController.value.text;
            }

            clientIdentifier = identifierController.value.text;
            if(clientIdentifier.isEmpty) {
              var random = new Random();
              clientIdentifier = 'lamhx_' + random.nextInt(100).toString();
            }

            if (client?.connectionState == mqtt.MqttConnectionState.connected) {
              _disconnect();
            } else {
              _connect();
            }
          },
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      child: new TabBar(
        tabs: <Widget>[
          new Tab(
            text: "Recv",
          ),
          new Tab(
            text: "Send",
          ),
        ],
        labelColor: Colors.black,
        indicatorColor: Colors.deepOrangeAccent,
      ),
    );
  }

  Widget _buildMessagesPage() {
    return new DefaultTabController(
      length: 2,
      child:new Column(
        children: <Widget>[
        _buildTabBar(),
        new Expanded(child: new TabBarView(
          children: <Widget>[
            _buildRecv(),
            SendMessageDialog(client: client),
          ],
        )),
      ]),
    );
  }

  Widget _buildRecv(){
    return new Column(
      children: <Widget>[

        new Expanded(child: ListView(
          controller: messageController,
          children: _buildMessageList(),
        )),
        new Padding(padding: const EdgeInsets.all(8.0),
          child: RaisedButton(
            child: Text ('Clear'),
            onPressed: (){
              setState(() {
                messages.clear();
              });
            },
          ),
        ),
      ],
    );



  }
  String dropdownValue = "action";

  Column _buildSubscriptionsPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              child: DropdownButton<String>(
                value: dropdownValue,

                iconSize:24,
                elevation:16,
                  style: TextStyle(
                      color: Colors.black87,
                  ),
                  underline: Container(
                    height: 2,
                    color: Colors.black38,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                items: <String>['action', 'receive notification', 'turn on flashlight', 'turn off heater']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                })
                    .toList(),
              ),
            ),
            SizedBox(width: 8.0),
            RaisedButton(
              child: Text('add topic'),
              onPressed: () {
                _subscribeToTopic(dropdownValue);
              },
            ),
          ],
        ),
        SizedBox(height: 16.0),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          alignment: WrapAlignment.start,
          children: _buildTopicList(),
        )
      ],
    );
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  List<Widget> _buildMessageList() {
    return messages
        .map((Message message) => Card(
      color: Colors.white70,
      child: ListTile(
        trailing: CircleAvatar(
            radius: 14.0,
            backgroundColor: Theme.of(context).accentColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'QoS',
                  style: TextStyle(fontSize: 8.0),
                ),
                Text(
                  message.qos.index.toString(),
                  style: TextStyle(fontSize: 8.0),
                ),
              ],
            )),
        title: Text(message.topic),
        subtitle: Text(message.message),
        dense: true,
      ),
    ))
        .toList()
        .reversed
        .toList();
  }

  List<Widget> _buildTopicList() {
    // Sort topics
    final List<String> sortedTopics = topics.toList()
      ..sort((String a, String b) {
        return compareNatural(a, b);
      });
    return sortedTopics
        .map((String topic) => Chip(
      label: Text(topic),
      onDeleted: () {
        _unsubscribeFromTopic(topic);
      },
    ))
        .toList();
  }

  void _connect() async {
    /// First create a client, the client is constructed with a broker name, client identifier
    /// and port if needed. The client identifier (short ClientId) is an identifier of each MQTT
    /// client connecting to a MQTT broker. As the word identifier already suggests, it should be unique per broker.
    /// The broker uses it for identifying the client and the current state of the client. If you don’t need a state
    /// to be hold by the broker, in MQTT 3.1.1 you can set an empty ClientId, which results in a connection without any state.
    /// A condition is that clean session connect flag is true, otherwise the connection will be rejected.
    /// The client identifier can be a maximum length of 23 characters. If a port is not specified the standard port
    /// of 1883 is used.
    /// If you want to use websockets rather than TCP see below.
    ///
    client = mqtt.MqttClient(broker, '');
    client.port = port;

    /// A websocket URL must start with ws:// or wss:// or Dart will throw an exception, consult your websocket MQTT broker
    /// for details.
    /// To use websockets add the following lines -:
    /// client.useWebSocket = true;
    /// client.port = 80;  ( or whatever your WS port is)
    /// Note do not set the secure flag if you are using wss, the secure flags is for TCP sockets only.

    /// Set logging on if needed, defaults to off
    client.logging(on: true);

    /// If you intend to use a keep alive value in your connect message that is not the default(60s)
    /// you must set it here
    client.keepAlivePeriod = 30;

    /// Add the unsolicited disconnection callback
    client.onDisconnected = _onDisconnected;

    /// Create a connection message to use or use the default one. The default one sets the
    /// client identifier, any supplied username/password, the default keepalive interval(60s)
    /// and clean session, an example of a specific one below.
    final mqtt.MqttConnectMessage connMess = mqtt.MqttConnectMessage()
        .withClientIdentifier(clientIdentifier)
    // Must agree with the keep alive set above or not set
        .startClean() // Non persistent session for testing
        .keepAliveFor(30)
    // If you set this you must set a will message
        .withWillTopic('test/test')
        .withWillMessage('lamhx message test')
        .withWillQos(mqtt.MqttQos.atMostOnce);
    print('MQTT client connecting....');
    client.connectionMessage = connMess;

    /// Connect the client, any errors here are communicated by raising of the appropriate exception. Note
    /// in some circumstances the broker will just disconnect us, see the spec about this, we however will
    /// never send malformed messages.

    try {
      await client.connect(username, passwd);
    } catch (e) {
      print(e);
      _disconnect();
    }

    /// Check if we are connected
    if (client.connectionState == mqtt.MqttConnectionState.connected) {
      print('MQTT client connected');
      setState(() {
        connectionState = client.connectionState;
      });
    } else {
      print('ERROR: MQTT client connection failed - '
          'disconnecting, state is ${client.connectionState}');
      _disconnect();
    }

    /// The client has a change notifier object(see the Observable class) which we then listen to to get
    /// notifications of published updates to each subscribed topic.
    subscription = client.updates.listen(_onMessage);
  }

  void _disconnect() {
    client.disconnect();
    _onDisconnected();
  }

  void _onDisconnected() {
    setState(() {
      topics.clear();
      connectionState = client.connectionState;
      client = null;
      subscription.cancel();
      subscription = null;
    });
    print('MQTT client disconnected');
  }

  void _onMessage(List<mqtt.MqttReceivedMessage> event) {
    print(event.length);
    final mqtt.MqttPublishMessage recMess =
    event[0].payload as mqtt.MqttPublishMessage;
    final String message =
    mqtt.MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    if(event[0].topic == 'action'){
      if(message == 'on'){
        Lamp.turnOn();
      }else if (message == 'off'){
        Lamp.turnOff();
      }
    }




    /// The above may seem a little convoluted for users only interested in the
    /// payload, some users however may be interested in the received publish message,
    /// lets not constrain ourselves yet until the package has been in the wild
    /// for a while.
    /// The payload is a byte buffer, this will be specific to the topic
    print('MQTT message: topic is <${event[0].topic}>, '
        'payload is <-- ${message} -->');
    print(client.connectionState);
    setState(() {
      messages.add(Message(
        topic: event[0].topic,
        message: message,
        qos: recMess.payload.header.qos,
      ));
      try {
        messageController.animateTo(
          0.0,
          duration: Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      } catch (_) {
        // ScrollController not attached to any scroll views.
      }
    });
  }

  void _subscribeToTopic(String topic) {
    if (connectionState == mqtt.MqttConnectionState.connected) {
      setState(() {
        if (topics.add(topic.trim())) {
          print('Subscribing to ${topic.trim()}');
          client.subscribe(topic, mqtt.MqttQos.exactlyOnce);
        }
      });
    }
  }

  void _unsubscribeFromTopic(String topic) {
    if (connectionState == mqtt.MqttConnectionState.connected) {
      setState(() {
        if (topics.remove(topic.trim())) {
          print('Unsubscribing from ${topic.trim()}');
          client.unsubscribe(topic);
        }
      });
    }
  }
}
