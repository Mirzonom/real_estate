import 'package:get/get.dart';
import 'package:real_estate_app/models/property.dart';

class FavoritesController extends GetxController {
  final RxList<Property> favorites = <Property>[].obs;

  void toggleFavorite(Property property) {
    if (isFavorite(property)) {
      favorites.remove(property);
    } else {
      favorites.add(property);
    }
  }

  bool isFavorite(Property property) {
    return favorites.any((p) => p.id == property.id);
  }
}
