import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/controllers/filter_controller.dart';
import 'package:real_estate_app/models/property.dart';
import 'package:real_estate_app/utils/constants.dart';

class FilterScreen extends StatelessWidget {
  FilterScreen({super.key});

  final FilterController controller = Get.put(FilterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Фильтры'),
        actions: [
          TextButton(
            onPressed: () {
              controller.resetFilters();
            },
            child: const Text('Сбросить'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Город'),
            _buildCityDropdown(),
            const SizedBox(height: 24),

            _buildSectionTitle('Цена'),
            _buildPriceRangeSlider(),
            const SizedBox(height: 24),

            _buildSectionTitle('Количество комнат'),
            _buildRoomSelection(),
            const SizedBox(height: 24),

            _buildSectionTitle('Класс жилья'),
            _buildPropertyClassSelection(),
            const SizedBox(height: 24),

            _buildSectionTitle('Материал здания'),
            _buildBuildingMaterialSelection(),
            const SizedBox(height: 24),

            _buildSectionTitle('Парковка'),
            _buildParkingTypeSelection(),
            const SizedBox(height: 24),

            _buildSectionTitle('Тип сделки'),
            _buildDealTypeSelection(),
            const SizedBox(height: 24),

            _buildInstallmentOption(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCityDropdown() {
    return Obx(() => DropdownButton<String>(
          isExpanded: true,
          value: controller.selectedCity.value,
          items: AppConstants.tajikistanCities.map((String city) {
            return DropdownMenuItem<String>(
              value: city,
              child: Text(city),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              controller.selectedCity.value = newValue;
            }
          },
        ));
  }

  Widget _buildPriceRangeSlider() {
    return Obx(() => Column(
          children: [
            RangeSlider(
              values: RangeValues(
                controller.minPrice.value.toDouble(),
                controller.maxPrice.value.toDouble(),
              ),
              min: 0,
              max: 10000000,
              divisions: 100,
              labels: RangeLabels(
                '${controller.minPrice.value} TJS',
                '${controller.maxPrice.value} TJS',
              ),
              onChanged: (RangeValues values) {
                controller.minPrice.value = values.start.toInt();
                controller.maxPrice.value = values.end.toInt();
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${controller.minPrice.value} TJS'),
                Text('${controller.maxPrice.value} TJS'),
              ],
            ),
          ],
        ));
  }

  Widget _buildRoomSelection() {
    return Obx(() => Wrap(
          spacing: 8,
          children: List.generate(10, (index) {
            final roomCount = index + 1;
            final isSelected = controller.selectedRooms.contains(roomCount);
            return FilterChip(
              label: Text('$roomCount комн.'),
              selected: isSelected,
              onSelected: (bool selected) {
                if (selected) {
                  controller.selectedRooms.add(roomCount);
                } else {
                  controller.selectedRooms.remove(roomCount);
                }
              },
            );
          }),
        ));
  }

  Widget _buildPropertyClassSelection() {
    return Obx(() => Wrap(
          spacing: 8,
          children: PropertyClass.values.map((propertyClass) {
            final isSelected = controller.selectedClasses.contains(propertyClass);
            return FilterChip(
              label: Text(AppConstants.propertyClasses.keys.firstWhere(
                (k) => AppConstants.propertyClasses[k] == propertyClass.toString().split('.').last,
                orElse: () => propertyClass.toString().split('.').last,
              )),
              selected: isSelected,
              onSelected: (bool selected) {
                if (selected) {
                  controller.selectedClasses.add(propertyClass);
                } else {
                  controller.selectedClasses.remove(propertyClass);
                }
              },
            );
          }).toList(),
        ));
  }

  Widget _buildBuildingMaterialSelection() {
    return Obx(() => Wrap(
          spacing: 8,
          children: BuildingMaterial.values.map((material) {
            final isSelected = controller.selectedMaterials.contains(material);
            return FilterChip(
              label: Text(AppConstants.buildingMaterials.keys.firstWhere(
                (k) => AppConstants.buildingMaterials[k] == material.toString().split('.').last,
                orElse: () => material.toString().split('.').last,
              )),
              selected: isSelected,
              onSelected: (bool selected) {
                if (selected) {
                  controller.selectedMaterials.add(material);
                } else {
                  controller.selectedMaterials.remove(material);
                }
              },
            );
          }).toList(),
        ));
  }

  Widget _buildParkingTypeSelection() {
    return Obx(() => Wrap(
          spacing: 8,
          children: ParkingType.values.map((parkingType) {
            final isSelected = controller.selectedParkingTypes.contains(parkingType);
            return FilterChip(
              label: Text(AppConstants.parkingTypes.keys.firstWhere(
                (k) => AppConstants.parkingTypes[k] == parkingType.toString().split('.').last,
                orElse: () => parkingType.toString().split('.').last,
              )),
              selected: isSelected,
              onSelected: (bool selected) {
                if (selected) {
                  controller.selectedParkingTypes.add(parkingType);
                } else {
                  controller.selectedParkingTypes.remove(parkingType);
                }
              },
            );
          }).toList(),
        ));
  }

  Widget _buildDealTypeSelection() {
    return Obx(() => Column(
          children: [
            SwitchListTile(
              title: const Text('Продажа'),
              value: controller.isForSale.value,
              onChanged: (bool value) {
                controller.isForSale.value = value;
              },
            ),
            SwitchListTile(
              title: const Text('Аренда'),
              value: controller.isForRent.value,
              onChanged: (bool value) {
                controller.isForRent.value = value;
              },
            ),
          ],
        ));
  }

  Widget _buildInstallmentOption() {
    return Obx(() => SwitchListTile(
          title: const Text('Доступна рассрочка'),
          value: controller.hasInstallment.value,
          onChanged: (bool value) {
            controller.hasInstallment.value = value;
          },
        ));
  }
}
