import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/theme/app_theme.dart';
import 'package:real_estate_app/screens/property_list_screen.dart';
import 'package:real_estate_app/screens/map_screen.dart';
import 'package:real_estate_app/screens/filter_screen.dart';
import 'package:real_estate_app/screens/add_property_screen.dart';
import 'package:real_estate_app/screens/favorites_screen.dart';
import 'package:real_estate_app/screens/search_screen.dart';
import 'package:real_estate_app/controllers/filter_controller.dart';
import 'package:real_estate_app/controllers/favorites_controller.dart';
import 'package:real_estate_app/controllers/search_controller.dart';

void main() {
  Get.put(FilterController());
  Get.put(FavoritesController());
  Get.put(PropertySearchController());
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
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              );
            },
          ),
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
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesScreen(),
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPropertyScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
