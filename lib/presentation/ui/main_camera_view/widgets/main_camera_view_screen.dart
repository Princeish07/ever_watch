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
                      Container(padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),color: Colors.red[200]),child: Text("Add Music +",style: TextStyle(color: Colors.white),),)
                      ,
                      const Spacer(),
                      Row(
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
                      ),
                      const Spacer(),
                      Stack(               // Align elements inside Row

                        children: [
                          Align(alignment: Alignment.bottomLeft,child: IconButton(onPressed: (){}, icon: const Icon(Icons.filter,color: Colors.white,),color: Colors.red.withOpacity(0.5),)),
                          // Spacer(),

                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 45,
                                  backgroundColor: Colors.white,
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircleAvatar(backgroundColor: Colors.red,radius: 50,),
                                  )),
                            ),
                          ),
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
