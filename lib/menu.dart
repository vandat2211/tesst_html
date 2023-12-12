import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import '/resources/app_colors.dart';
import '/utils/rive_utils.dart';
import '/components/animated_bar.dart';
import '/models/rive_asset.dart';
import 'home.dart';


class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _EntryPointState();
}

class _EntryPointState extends State<MenuScreen> {
  RiveAsset selectedBottomNav = bottomNavItems.first;
  int selectedIndex = 0;
  final List<Widget> pages = [
    const HomePage(),
    Container(color: Colors.orange), // Widget cho mục 2
    Container(color: Colors.blue),
    Container(color: Colors.grey),// Widget cho mục 3
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        extendBody: true,
        body: pages[selectedIndex],
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 24,vertical: 10),
            decoration: const BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.all(Radius.circular(24)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...List.generate(
                  bottomNavItems.length,
                      (index) => GestureDetector(
                    onTap: () {
                      bottomNavItems[index].input?.change(true);
                      if (bottomNavItems[index] != selectedBottomNav) {
                        setState(() {
                          selectedBottomNav = bottomNavItems[index];
                          selectedIndex = index;
                        });
                      }
                      // Time of animation running
                      Future.delayed(const Duration(seconds: 10), () {
                        bottomNavItems[index].input?.change(false);
                      });
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedBar(isActive: bottomNavItems[index] == selectedBottomNav),
                        SizedBox(
                          height: 36,
                          width: 36,
                          child: Opacity(
                            opacity: bottomNavItems[index] == selectedBottomNav ? 1 : 0.5,
                            child: RiveAnimation.asset(
                              bottomNavItems.first.src,
                              artboard: bottomNavItems[index].artBoard,
                              onInit: (artBoard) {
                                StateMachineController controller = RiveUtils.getRiveController(
                                  artBoard,
                                  stateMachineName: bottomNavItems[index].stateMachineName,
                                );
                                  bottomNavItems[index].input = controller.findSMI("active");

                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
