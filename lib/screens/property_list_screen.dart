import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/models/property.dart';
import 'package:real_estate_app/widgets/property_card.dart';
import 'package:real_estate_app/data/dummy_data.dart';
import 'package:real_estate_app/controllers/filter_controller.dart';

class PropertyListScreen extends StatelessWidget {
  const PropertyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FilterController filterController = Get.find<FilterController>();

    return Obx(() {
      final filteredProperties = filterController.filterProperties(dummyProperties);
      
      if (filteredProperties.isEmpty) {
        return const Center(
          child: Text(
            'Нет объектов, соответствующих выбранным фильтрам',
            textAlign: TextAlign.center,
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredProperties.length,
        itemBuilder: (context, index) {
          final property = filteredProperties[index];
          return PropertyCard(property: property);
        },
      );
    });
  }
}
