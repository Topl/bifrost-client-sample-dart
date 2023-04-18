# Bifrost Dart Client Sample
An example of a Dart application (server) which reads from a Bifrost gRPC Server.

## Setup
1. Install [Dart](https://dart.dev/get-dart) or [Flutter](https://docs.flutter.dev/get-started/install)
1. Clone [Topl/protobuf-specs](https://github.com/Topl/protobuf-specs) into this repo's parent directory.  Follow the local build instructions in the repository's README.  (NOTE: You may also need to install the [Dart protoc_plugin](https://pub.dev/packages/protoc_plugin)).
1. Update the relative imports of this repo's pubspec.yaml to point to the protobuf-specs Dart build directory (if necessary).
1. Launch Bifrost, and determine the IP/Port of the Node and/or Genus.
1. Update bin/server.dart with the IP/Port.
1. Run `dart run bin/server.dart` to launch the client.
