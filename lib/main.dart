import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/theme/app_theme.dart';
import 'package:real_estate_app/screens/property_list_screen.dart';
import 'package:real_estate_app/screens/map_screen.dart';
import 'package:real_estate_app/screens/filter_screen.dart';
import 'package:real_estate_app/controllers/filter_controller.dart';

void main() {
  Get.put(FilterController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Real Estate App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Недвижимость'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MapScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FilterScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: const PropertyListScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Добавление новой недвижимости
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
