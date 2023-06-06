import 'package:grpc/grpc.dart';
import 'package:grpc/grpc_connection_interface.dart';

ClientChannelBase channel = ClientChannel(
  "tetra.testnet.torus.topl.tech",
  port: 443,
  options: const ChannelOptions(credentials: ChannelCredentials.secure()),
);
