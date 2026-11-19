import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/favorite_controller.dart';
import '../main.dart';
import 'home_page.dart';
import 'favorite_page.dart';
import 'profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _index = 0;

  final _pages = const [HomePage(), FavoritePage(), ProfilePage()];

  // Controller sudah pasti ada karena AppBinding dijalankan sebelum halaman ini.
  final FavoriteController _favCtrl = Get.find<FavoriteController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: _index,
          onTap: (i) => setState(() => _index = i),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              label: 'Favorite',
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.favorite),
                  if (_favCtrl.count.value > 0)
                    Positioned(
                      top: -6,
                      right: -8,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: kAccent,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          _favCtrl.count.value > 99
                              ? '99+'
                              : '${_favCtrl.count.value}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
