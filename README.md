# Bifrost Dart Client Sample
An example of a Flutter application which reads from a Bifrost gRPC Server.

## Setup
1. Install [Dart](https://dart.dev/get-dart) or [Flutter](https://docs.flutter.dev/get-started/install)
1. Launch Bifrost, and determine the IP/Port of the Node and/or Genus.  If using Flutter Web, you must use a proxy like grpcwebproxy or envoy.
1. Update `lib/native_grpc_channel.dart` or `lib/web_grpc_channel.dart` with the proper host/port.
1. Run `flutter run -d chrome` to launch the client in a browser.  Run `flutter run -d linux` to launch the client in Linux desktop.
