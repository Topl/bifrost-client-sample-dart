import 'dart:convert';

import 'package:grpc/grpc.dart';
import 'package:topl_protobuf/genus/genus_models.pb.dart';
import 'package:topl_protobuf/genus/genus_rpc.pbgrpc.dart';
import 'package:topl_protobuf/node/services/bifrost_rpc.pbgrpc.dart';

Future<void> main() async {
  final nodeRpc = NodeRpcClient(ClientChannel(
    'localhost',
    port: 9084,
    options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
  ));
  final genusBlockRpc = GenusFullBlockServiceClient(ClientChannel(
    'localhost',
    port: 9084,
    options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
  ));

  // Talking directly to Node
  await nodeRpc
      .synchronizationTraversal(SynchronizationTraversalReq())
      .where((r) => r.hasApplied())
      .asyncMap((r) async {
    final id = r.applied;
    final header =
        (await nodeRpc.fetchBlockHeader(FetchBlockHeaderReq(blockId: id)))
            .header;
    final body =
        (await nodeRpc.fetchBlockBody(FetchBlockBodyReq(blockId: id))).body;
    final transactions = await Future.wait(body.transactionIds.map(
        (txId) async => (await nodeRpc
                .fetchTransaction(FetchTransactionReq(transactionId: txId)))
            .transaction));
    print(json.encode(header.toProto3Json()));
    for (final transaction in transactions) {
      print(json.encode(transaction.toProto3Json()));
    }
  }).drain();

  // Interact with Genus
  // await Stream.periodic(Duration(milliseconds: 500))
  //     .asyncMap((event) => genusBlockRpc
  //         .getBlockByDepth(GetBlockByDepthRequest(depth: ChainDistance())))
  //     .map((r) => r.block)
  //     .forEach((block) {
  //   print(json.encode(block.header.toProto3Json()));
  //   for (final transaction in block.fullBody.transactions) {
  //     print(json.encode(transaction.toProto3Json()));
  //   }
  // });
}
