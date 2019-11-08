# IoT-Manager

[IoT Manager Broker Github Repo](https://github.com/JLiao98/IoT-Manager-Broker)

## Getting Started
- `git clone git@github.com:JLiao98/IoT-Manager.git`
- [Get flutter plugins & dark plugins](https://flutter.dev/docs/get-started/install)
- `cd iot-manager`
- Import the flutter project in Android Studio/Intellij/VSCode
- run `flutter doctor` to make sure you are properly setup 
- `flutter run` or run the application through the IDE  

## Try it out 
### Android 
- [Download the apk](fir.im/iotmanager)
- Click connect (don't input anything into the broker fields)
- Click on the **Subscriptions** tab
  - Input "action" in the topic
- If another client is connected, you can send commands be clicking on the **Messages** tab
  - Open the **Send** tab
  - For the message enter either "on" or "off" with topic "action"
  - leave the details under the messsage and topic the same
  - Click Send
- The other clients phone should have a nice surprise! 

### IOS (on MACOS)
- Plug in device to computer (must be running MACOS)
- Trust the device 
- run project on device plugged in
