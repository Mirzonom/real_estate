import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/controllers/property_form_controller.dart';
import 'package:real_estate_app/models/property.dart';
import 'package:real_estate_app/utils/constants.dart';
import 'dart:io';

class AddPropertyScreen extends StatelessWidget {
  AddPropertyScreen({super.key});

  final PropertyFormController controller = Get.put(PropertyFormController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить объект'),
        actions: [
          TextButton(
            onPressed: controller.submitForm,
            child: const Text('Сохранить'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(),
            const SizedBox(height: 24),
            _buildBasicInfoSection(),
            const SizedBox(height: 24),
            _buildLocationSection(),
            const SizedBox(height: 24),
            _buildBuildingDetailsSection(),
            const SizedBox(height: 24),
            _buildDealTypeSection(),
            const SizedBox(height: 24),
            _buildInstallmentSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Фотографии',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: Obx(() => ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  // Кнопка добавления изображения
                  InkWell(
                    onTap: controller.addImage,
                    child: Container(
                      width: 120,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.add_photo_alternate, size: 40),
                    ),
                  ),
                  // Список выбранных изображений
                  ...controller.images.asMap().entries.map((entry) {
                    return Stack(
                      children: [
                        Container(
                          width: 120,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: FileImage(File(entry.value)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 8,
                          top: 0,
                          child: IconButton(
                            icon: const Icon(Icons.remove_circle),
                            color: Colors.red,
                            onPressed: () => controller.removeImage(entry.key),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              )),
        ),
      ],
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Основная информация',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Название объекта',
            hintText: 'Например: Современная квартира в центре',
          ),
          onChanged: (value) => controller.title.value = value,
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Цена (TJS)',
            hintText: 'Введите цену',
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) =>
              controller.price.value = double.tryParse(value) ?? 0,
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Описание',
            hintText: 'Опишите объект',
          ),
          maxLines: 3,
          onChanged: (value) => controller.description.value = value,
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Расположение',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Obx(() => DropdownButtonFormField<String>(
              value: controller.city.value,
              decoration: const InputDecoration(
                labelText: 'Город',
              ),
              items: AppConstants.tajikistanCities
                  .map((city) => DropdownMenuItem(
                        value: city,
                        child: Text(city),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) controller.city.value = value;
              },
            )),
        const SizedBox(height: 8),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Адрес',
            hintText: 'Улица, номер дома',
          ),
          onChanged: (value) => controller.address.value = value,
        ),
      ],
    );
  }

  Widget _buildBuildingDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Характеристики здания',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Obx(() => DropdownButtonFormField<ConstructionStage>(
              value: controller.constructionStage.value,
              decoration: const InputDecoration(
                labelText: 'Стадия строительства',
              ),
              items: ConstructionStage.values
                  .map((stage) => DropdownMenuItem(
                        value: stage,
                        child: Text(AppConstants.constructionStages.keys.firstWhere(
                          (k) =>
                              AppConstants.constructionStages[k] ==
                              stage.toString().split('.').last,
                          orElse: () => stage.toString().split('.').last,
                        )),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) controller.constructionStage.value = value;
              },
            )),
        const SizedBox(height: 8),
        Obx(() => DropdownButtonFormField<BuildingMaterial>(
              value: controller.buildingMaterial.value,
              decoration: const InputDecoration(
                labelText: 'Материал здания',
              ),
              items: BuildingMaterial.values
                  .map((material) => DropdownMenuItem(
                        value: material,
                        child: Text(AppConstants.buildingMaterials.keys.firstWhere(
                          (k) =>
                              AppConstants.buildingMaterials[k] ==
                              material.toString().split('.').last,
                          orElse: () => material.toString().split('.').last,
                        )),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) controller.buildingMaterial.value = value;
              },
            )),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('Количество комнат:'),
            const SizedBox(width: 16),
            Obx(() => DropdownButton<int>(
                  value: controller.numberOfRooms.value,
                  items: List.generate(10, (index) => index + 1)
                      .map((rooms) => DropdownMenuItem(
                            value: rooms,
                            child: Text('$rooms'),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) controller.numberOfRooms.value = value;
                  },
                )),
          ],
        ),
      ],
    );
  }

  Widget _buildDealTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Тип сделки',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Obx(() => CheckboxListTile(
              title: const Text('Продажа'),
              value: controller.isForSale.value,
              onChanged: (value) {
                if (value != null) controller.isForSale.value = value;
              },
            )),
        Obx(() => CheckboxListTile(
              title: const Text('Аренда'),
              value: controller.isForRent.value,
              onChanged: (value) {
                if (value != null) controller.isForRent.value = value;
              },
            )),
        Obx(() {
          if (controller.isForRent.value) {
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Стоимость аренды (TJS/месяц)',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) =>
                    controller.rentPrice.value = double.tryParse(value) ?? 0,
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildInstallmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Рассрочка',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Obx(() => CheckboxListTile(
              title: const Text('Доступна рассрочка'),
              value: controller.isInstallmentAvailable.value,
              onChanged: (value) {
                if (value != null) {
                  controller.isInstallmentAvailable.value = value;
                }
              },
            )),
        Obx(() {
          if (controller.isInstallmentAvailable.value) {
            return Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Первоначальный взнос (%)',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) =>
                      controller.initialPayment.value = int.tryParse(value) ?? 0,
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Срок рассрочки (месяцев)',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) =>
                      controller.installmentMonths.value = int.tryParse(value) ?? 0,
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }
}
