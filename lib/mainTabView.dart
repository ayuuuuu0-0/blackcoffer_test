import 'package:blackcoffer_test/HomeScreen/homeScreen.dart';
import 'package:blackcoffer_test/VideoScreen/videoScreen.dart';
import 'package:blackcoffer_test/library.dart';
import 'package:blackcoffer_test/tabBar.dart';
import 'package:flutter/material.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  int selectTab = 0;
  final PageStorageBucket pageBucket = PageStorageBucket();
  Widget currentTab = const HomeScreen();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: PageStorage(bucket: pageBucket, child: currentTab),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: SizedBox(
          width: 70,
          height: 70,
          child: InkWell(
            onTap: () {
              selectTab = 1; // Set a unique number for the CameraScreen
              currentTab = VideoScreen(); // Set the currentTab to CameraScreen
              if (mounted) {
                setState(() {});
              }
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  color: currentTab is VideoScreen
                      ? Color(0xFFFF7373)
                      : Color.fromARGB(255, 243, 228, 242),
                  borderRadius: BorderRadius.circular(35),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 2,
                    )
                  ]),
              child: Icon(
                Icons.camera_alt,
                color:
                    currentTab is VideoScreen ? Colors.white : Colors.black54,
                size: 35,
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 10,
          clipBehavior: Clip.antiAlias,
          shape: CircularNotchedRectangle(),
          //  child:
          //   Container(
          // decoration: BoxDecoration(color: Colors.white, boxShadow: const [
          //   BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, -2))
          // ]),
          // height: kToolbarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TabButton(
                  icon: "assets/explore.png",
                  selectIcon: "assets/explore_active.png",
                  isActive: selectTab == 0,
                  onTap: () {
                    selectTab = 0;
                    currentTab = HomeScreen();
                    if (mounted) {
                      setState(() {});
                    }
                  }),
              const SizedBox(
                width: 40,
              ),
              TabButton(
                  icon: "assets/library.png",
                  selectIcon: "assets/library_active.png",
                  isActive: selectTab == 2,
                  onTap: () {
                    selectTab = 2;
                    currentTab = const Library();
                    if (mounted) {
                      setState(() {});
                    }
                  }),
            ],
          ),
        ));
    //);
  }
}
