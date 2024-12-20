import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/controllers/search_controller.dart';
import 'package:real_estate_app/widgets/property_card.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PropertySearchController controller = Get.find<PropertySearchController>();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Поиск недвижимости...',
            border: InputBorder.none,
            suffixIcon: Obx(() {
              if (controller.searchQuery.isNotEmpty) {
                return IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: controller.clearSearch,
                );
              }
              return const SizedBox.shrink();
            }),
          ),
          onChanged: controller.search,
        ),
      ),
      body: Obx(() {
        if (!controller.isSearching.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'Введите текст для поиска',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        if (controller.searchResults.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'Ничего не найдено',
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
          itemCount: controller.searchResults.length,
          itemBuilder: (context, index) {
            final property = controller.searchResults[index];
            return PropertyCard(property: property);
          },
        );
      }),
    );
  }
}
