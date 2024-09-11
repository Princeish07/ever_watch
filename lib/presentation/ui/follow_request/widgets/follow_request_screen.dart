import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ever_watch/presentation/ui/follow_request/widgets/follow_request_item.dart';
import 'package:ever_watch/presentation/ui/follow_request/provider/follow_request_provider.dart';
class FollowRequestScreen extends ConsumerStatefulWidget {
  const FollowRequestScreen({super.key});

  @override
  ConsumerState<FollowRequestScreen> createState() => _FollowRequestScreenState();
}

class _FollowRequestScreenState extends ConsumerState<FollowRequestScreen> {

  @override
 void initState(){
    ref.read(followRequestProvider.notifier).fetchFollowRequestList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,title: Text("Pending Requests"),),
      body: Container(
        child: ListView.builder(itemBuilder: (context,index){
          return Container(padding: EdgeInsets.all(5),
          color: Colors.black12,
          child: FollowRequestItem(),);
        }),
      ),
    );
  }
}
