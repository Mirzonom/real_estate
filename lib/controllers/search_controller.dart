import 'package:get/get.dart';
import 'package:real_estate_app/models/property.dart';
import 'package:real_estate_app/data/dummy_data.dart';

class PropertySearchController extends GetxController {
  final RxString searchQuery = ''.obs;
  final RxList<Property> searchResults = <Property>[].obs;
  final RxBool isSearching = false.obs;

  void search(String query) {
    searchQuery.value = query;
    isSearching.value = true;

    if (query.isEmpty) {
      searchResults.clear();
      isSearching.value = false;
      return;
    }

    final lowercaseQuery = query.toLowerCase();
    searchResults.value = dummyProperties.where((property) {
      return property.title.toLowerCase().contains(lowercaseQuery) ||
          property.description.toLowerCase().contains(lowercaseQuery) ||
          property.address.toLowerCase().contains(lowercaseQuery) ||
          property.city.toLowerCase().contains(lowercaseQuery) ||
          property.price.toString().contains(lowercaseQuery) ||
          (property.rentPrice?.toString().contains(lowercaseQuery) ?? false);
    }).toList();
  }

  void clearSearch() {
    searchQuery.value = '';
    searchResults.clear();
    isSearching.value = false;
  }
}
