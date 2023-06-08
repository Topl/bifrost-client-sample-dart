import 'package:grpc/grpc_connection_interface.dart';
import 'package:grpc/grpc_web.dart';

ClientChannelBase channel = GrpcWebClientChannel.xhr(
  Uri.parse("https://testnet.topl.co:443"),
);
