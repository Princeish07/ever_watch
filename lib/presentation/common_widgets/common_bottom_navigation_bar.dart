import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'custom_icon.dart';

class CommonBottomNavigationBar extends StatefulWidget {
  void Function(int)? onTap;
   CommonBottomNavigationBar({super.key,this.onTap});

  @override
  State<CommonBottomNavigationBar> createState() => _CommonBottomNavigationBarState();
}

class _CommonBottomNavigationBarState extends State<CommonBottomNavigationBar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (index){
        setState(() {
          _currentIndex = index;
        });
        widget.onTap!(index);
      },

      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.mainBgColor,
      selectedItemColor:AppColors().mainButtonColor
    ,
      unselectedItemColor: Colors.white,
      currentIndex: _currentIndex,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home,size: 30,color: Colors.white,),label: "Home",backgroundColor: Colors.white),
        BottomNavigationBarItem(icon: Icon(Icons.search,size: 30,color: Colors.white,),label: "Search"),
        BottomNavigationBarItem(icon: CustomIcon(),label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.message,size: 30,color: Colors.white,),label: "Messages",backgroundColor: Colors.white),
        BottomNavigationBarItem(icon: Icon(Icons.person,size: 30,color: Colors.white,),label: "Profile")

      ],
    );
  }
}
