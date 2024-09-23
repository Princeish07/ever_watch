import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../main.dart';

class MainCameraView extends StatefulWidget {
  const MainCameraView({super.key});

  @override
  State<MainCameraView> createState() => _MainCameraViewState();
}

class _MainCameraViewState extends State<MainCameraView> {
  late CameraController controller;
  @override
  void initState() {
    super.initState();

    controller = CameraController(cameras[0], ResolutionPreset.max);

    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
          // Handle access errors here.
            break;
          default:
          // Handle other errors here.
            break;
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Expanded(
            child: Stack(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height,
                    child: CameraPreview(controller)),
                Container(
                  child: Column(
                    children: [
                      Container(padding: EdgeInsets.all(20),decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),color: Colors.red.withOpacity(0.5)),child: Text("Add Music"),)
                      ,Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Spacer(),
                          Column(
                            children: [
                                IconButton(onPressed: (){}, icon: const Icon(Icons.filter,color: Colors.white,),color: Colors.red.withOpacity(0.5),),
                              IconButton(onPressed: (){}, icon: const Icon(Icons.ac_unit_outlined,color: Colors.white,),color: Colors.red.withOpacity(0.5),)

                            ],
                          )
                  
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
