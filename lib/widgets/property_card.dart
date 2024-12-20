import 'package:flutter/material.dart';
import 'package:real_estate_app/models/property.dart';
import 'package:real_estate_app/screens/property_detail_screen.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class PropertyCard extends StatelessWidget {
  final Property property;

  const PropertyCard({
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

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PropertyDetailScreen(property: property),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: property.images.isNotEmpty
                  ? Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: property.images.first.startsWith('http')
                              ? NetworkImage(property.images.first) as ImageProvider
                              : FileImage(File(property.images.first)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.home, size: 50),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title,
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  if (property.isForSale)
                    Text(
                      currencyFormatter.format(property.price),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (property.isForRent && property.rentPrice != null)
                    Text(
                      '${currencyFormatter.format(property.rentPrice)} / месяц',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildFeatureChip(
                        context,
                        '${property.numberOfRooms} комн.',
                      ),
                      const SizedBox(width: 8),
                      if (property.isInstallmentAvailable)
                        _buildFeatureChip(
                          context,
                          'Рассрочка',
                          color: Colors.green,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureChip(BuildContext context, String label, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: color ?? Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
