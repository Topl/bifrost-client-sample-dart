import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:topl_common/proto/node/models/block.pb.dart';
import 'package:topl_common/proto/node/services/bifrost_rpc.pbgrpc.dart';
import 'native_grpc_channel.dart'
    if (dart.library.html) 'web_grpc_channel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bifrost Client',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlockchainPage(),
    );
  }
}

class BlockchainPage extends StatefulWidget {
  const BlockchainPage({super.key});

  @override
  _BlockchainPageState createState() => _BlockchainPageState();
}

class _BlockchainPageState extends State<BlockchainPage> {
  NodeRpcClient nodeRpcClient = NodeRpcClient(channel);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: StreamBuilder(
            stream: _accumulateBlocksStream,
            builder: (context, snapshot) => _blocksView(snapshot.data ?? []),
          ),
        ),
      );

  Widget get loading => const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );

  Stream<List<FullBlock>> get _accumulateBlocksStream => nodeRpcClient
          .synchronizationTraversal(SynchronizationTraversalReq())
          .where((t) => t.hasApplied())
          .map((t) => t.applied)
          .asyncMap((blockId) async {
        final header = (await nodeRpcClient
                .fetchBlockHeader(FetchBlockHeaderReq(blockId: blockId)))
            .header;
        final body = (await nodeRpcClient
                .fetchBlockBody(FetchBlockBodyReq(blockId: blockId)))
            .body;
        final transactions = await Future.wait(body.transactionIds.map(
            (id) async => (await nodeRpcClient
                    .fetchTransaction(FetchTransactionReq(transactionId: id)))
                .transaction));
        return FullBlock(
            header: header,
            fullBody: FullBlockBody(transactions: transactions));
      }).transform(StreamTransformer.fromBind((inStream) {
        final List<FullBlock> state = [];
        return inStream.map((block) {
          state.insert(0, block);
          return List.of(state);
        });
      }));

  Widget _blocksView(List<FullBlock> blocks) => SizedBox(
        width: 500,
        child: ListView.separated(
          itemCount: blocks.length,
          itemBuilder: (context, index) => Card(
            color: const Color.fromARGB(210, 255, 255, 255),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // TODO: Base58
                  Text(base64Encode(blocks[index].header.headerId.value)),
                  Text("Height: ${blocks[index].header.height}"),
                  Text("Slot: ${blocks[index].header.slot}"),
                  Text("Timestamp: ${blocks[index].header.timestamp}"),
                  Text(
                      "Transactions: ${blocks[index].fullBody.transactions.length}"),
                ],
              ),
            ),
          ),
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        ),
      );
}
