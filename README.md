<h1 align="center">Welcome to IoT-Manager 👋</h1>
<p>
  <img alt="Version" src="https://img.shields.io/badge/version-1.0.0-blue.svg?cacheSeconds=2592000" />
  <a href="https://github.com/JLiao98/IoT-Manager/README.md" target="_blank">
    <img alt="Documentation" src="https://img.shields.io/badge/documentation-yes-brightgreen.svg" />
  </a>
</p>

> IoT Manager

### 🏠 [Homepage](https://github.com/JLiao98/IoT-Manager)

### ⛺️ [IoT Manager - Broker Server](https://github.com/JLiao98/IoT-Manager-Broker)

## Install

Clone the repo & prepare the app for development:

- `git clone git@github.com:JLiao98/IoT-Manager.git`
- [Get flutter plugins & Dart plugins](https://flutter.dev/docs/get-started/install)
- Import the flutter project in Android Studio/Intellij/VSCode
- `flutter doctor` to make sure you are properly setup
- `flutter pub get` to install dependencies

Before you get to run the app, ensure that `.env` file exists in the root of the project. To see the structure of the `.env` file, check out [.env.example](/.env.example).

## Usage/Running the Application

After dependencies are installed, the app can be started using:

```sh
flutter run
```

## Try it out!

### Android

- [Download the apk](https://fir.im/iotmanager)
- Install the apk on your phone
- Launch the app 🎉

### iOS

- Plug in an iOS device to a macOS computer
- Trust the device
- Run the project on the phone
- Open the application once it's installed on your iOS device 🎉

### In the App

- Click connect (don't input anything into the broker fields)
- Click on the **Subscriptions** tab
  - Input "action" in the topic
- If another client is connected, you can send commands be clicking on the **Messages** tab
  - Open the **Send** tab
  - For the message enter either "on" or "off" with topic "action"
  - leave the details under the messsage and topic the same
  - Click Send
- The other clients phone should have a nice surprise!

---

## Authors

👤 **Jian Liao**

- Github: [@JLiao98](https://github.com/JLiao98)

👤 **Rakheem Dewji**

- Github: [@raksdewji](https://github.com/raksdewji)

👤 **Artem Golovin**

- Github: [@awave1](https://github.com/awave1)

👤 **Juan Luis de Reiset**

- Github: [@JuadeReiset](https://github.com/JuandeReiset)

👤 **Igor Pieters**

- Github: [@ipieters](https://github.com/ipieters)

## 🤝 Contributing

Contributions, issues and feature requests are welcome!<br />Feel free to check [issues page](https://github.com/JLiao98/IoT-Manager/issues).

## Show your support

Give a ⭐️ if this project helped you!
