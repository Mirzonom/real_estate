import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:real_estate_app/controllers/favorites_controller.dart';
import 'package:real_estate_app/models/property.dart';
import 'package:real_estate_app/utils/constants.dart';
import 'package:real_estate_app/screens/map_screen.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:get/get.dart';

class PropertyDetailScreen extends StatelessWidget {
  final Property property;

  const PropertyDetailScreen({
    super.key,
    required this.property,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'ru_RU',
      symbol: 'TJS',
      decimalDigits: 0,
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageSlideshow(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPriceSection(currencyFormatter),
                      const SizedBox(height: 16),
                      _buildLocationSection(context),
                      const SizedBox(height: 24),
                      _buildDetailsSection(),
                      const SizedBox(height: 24),
                      _buildDescriptionSection(),
                      if (property.isInstallmentAvailable) ...[
                        const SizedBox(height: 24),
                        _buildInstallmentSection(),
                      ],
                      const SizedBox(height: 32),
                      _buildContactButtons(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final FavoritesController favoritesController =
        Get.find<FavoritesController>();

    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      pinned: true,
      title: Text(property.title),
      actions: [
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () {
            // TODO: Реализовать функцию поделиться
          },
        ),
        Obx(() => IconButton(
              icon: Icon(
                favoritesController.isFavorite(property)
                    ? Icons.favorite
                    : Icons.favorite_border,
              ),
              onPressed: () => favoritesController.toggleFavorite(property),
            )),
      ],
    );
  }

  Widget _buildImageSlideshow() {
    if (property.images.isEmpty) {
      return Container(
        height: 300,
        color: Colors.grey[300],
        child: const Icon(Icons.home, size: 100, color: Colors.grey),
      );
    }

    return SizedBox(
      height: 300,
      child: ImageSlideshow(
        width: double.infinity,
        height: 300,
        initialPage: 0,
        indicatorColor: Colors.blue,
        indicatorBackgroundColor: Colors.grey,
        autoPlayInterval: 0,
        isLoop: true,
        children: property.images.map((imageUrl) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageUrl.startsWith('http')
                    ? NetworkImage(imageUrl) as ImageProvider
                    : FileImage(File(imageUrl)),
                fit: BoxFit.cover,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPriceSection(NumberFormat formatter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (property.isForSale)
          Text(
            formatter.format(property.price),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (property.isForRent && property.rentPrice != null)
          Text(
            '${formatter.format(property.rentPrice)} / месяц',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }

  Widget _buildLocationSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Расположение',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.location_on, size: 16),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                '${property.city}, ${property.address}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MapScreen(),
                  ),
                );
              },
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(property.latitude, property.longitude),
                  zoom: 15,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.real_estate_app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(property.latitude, property.longitude),
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.location_on,
                          color: Theme.of(context).primaryColor,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Характеристики',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildDetailRow('Количество комнат', '${property.numberOfRooms}'),
        _buildDetailRow(
          'Стадия строительства',
          AppConstants.constructionStages.keys.firstWhere(
            (k) =>
                AppConstants.constructionStages[k] ==
                property.constructionStage.toString().split('.').last,
          ),
        ),
        _buildDetailRow(
          'Материал здания',
          AppConstants.buildingMaterials.keys.firstWhere(
            (k) =>
                AppConstants.buildingMaterials[k] ==
                property.buildingMaterial.toString().split('.').last,
          ),
        ),
        _buildDetailRow(
          'Класс жилья',
          AppConstants.propertyClasses.keys.firstWhere(
            (k) =>
                AppConstants.propertyClasses[k] ==
                property.propertyClass.toString().split('.').last,
          ),
        ),
        _buildDetailRow(
          'Парковка',
          AppConstants.parkingTypes.keys.firstWhere(
            (k) =>
                AppConstants.parkingTypes[k] ==
                property.parkingType.toString().split('.').last,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Описание',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(property.description),
      ],
    );
  }

  Widget _buildInstallmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Условия рассрочки',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        if (property.installmentTerms != null) ...[
          _buildDetailRow(
            'Первоначальный взнос',
            '${property.installmentTerms!['initialPayment']}%',
          ),
          _buildDetailRow(
            'Срок рассрочки',
            '${property.installmentTerms!['months']} месяцев',
          ),
        ],
      ],
    );
  }

  Widget _buildContactButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.phone),
            label: const Text('Позвонить'),
            onPressed: () {
              // TODO: Реализовать функцию звонка
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.message),
            label: const Text('Написать'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            onPressed: () {
              // TODO: Реализовать функцию отправки сообщения
            },
          ),
        ),
      ],
    );
  }
}
