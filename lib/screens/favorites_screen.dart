import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/controllers/favorites_controller.dart';
import 'package:real_estate_app/widgets/property_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoritesController controller = Get.find<FavoritesController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранное'),
      ),
      body: Obx(() {
        if (controller.favorites.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'У вас пока нет избранных объектов',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.favorites.length,
          itemBuilder: (context, index) {
            final property = controller.favorites[index];
            return PropertyCard(property: property);
          },
        );
      }),
    );
  }
}
