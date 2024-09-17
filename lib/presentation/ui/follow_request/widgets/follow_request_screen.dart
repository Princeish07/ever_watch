import 'package:ever_watch/data/model/user_model.dart';
import 'package:ever_watch/presentation/common_widgets/common_loader.dart';
import 'package:ever_watch/presentation/common_widgets/error_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ever_watch/presentation/ui/follow_request/widgets/follow_request_item.dart';
import 'package:ever_watch/presentation/ui/follow_request/provider/follow_request_provider.dart';

import '../../../../core/other/resource.dart';
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
    var state = ref.watch(followRequestProvider);
    return Scaffold(
      appBar: AppBar(centerTitle: true,title: const Text("Pending Requests"),),
      body: Stack(
        children: [
          if(state.followRequestList?.status==Status.SUCCESS) ...[
            if(state.followRequestList?.data?.isNotEmpty==true) ...[
          ListView.builder(itemCount: state.followRequestList?.data?.length,itemBuilder: (context,index){
            return Container(padding: EdgeInsets.all(5),
            color: Colors.black12,
            child: FollowRequestItem(userModel: state.followRequestList?.data?[index] ?? UserModel(),),);
          }),
    ]else ...[
      ErrorMessage(errorMessage: "No request found",)
            ]
    ]else ...[
      const CommonLoader()
          ]
        ],
      ),
    );
  }
}
