import 'package:get/get.dart';
import 'package:real_estate_app/models/property.dart';
import 'package:real_estate_app/utils/constants.dart';

class FilterController extends GetxController {
  final RxString selectedCity = 'Весь Таджикистан'.obs;
  final RxInt minPrice = 0.obs;
  final RxInt maxPrice = 10000000.obs;
  final RxList<int> selectedRooms = <int>[].obs;
  final RxList<PropertyClass> selectedClasses = <PropertyClass>[].obs;
  final RxList<BuildingMaterial> selectedMaterials = <BuildingMaterial>[].obs;
  final RxList<ParkingType> selectedParkingTypes = <ParkingType>[].obs;
  final RxBool isForSale = true.obs;
  final RxBool isForRent = false.obs;
  final RxBool hasInstallment = false.obs;

  List<Property> filterProperties(List<Property> properties) {
    return properties.where((property) {
      // Фильтр по городу
      if (selectedCity.value != 'Весь Таджикистан' &&
          property.city != selectedCity.value) {
        return false;
      }

      // Фильтр по цене
      if (property.price < minPrice.value || property.price > maxPrice.value) {
        return false;
      }

      // Фильтр по количеству комнат
      if (selectedRooms.isNotEmpty &&
          !selectedRooms.contains(property.numberOfRooms)) {
        return false;
      }

      // Фильтр по классу недвижимости
      if (selectedClasses.isNotEmpty &&
          !selectedClasses.contains(property.propertyClass)) {
        return false;
      }

      // Фильтр по материалу здания
      if (selectedMaterials.isNotEmpty &&
          !selectedMaterials.contains(property.buildingMaterial)) {
        return false;
      }

      // Фильтр по типу парковки
      if (selectedParkingTypes.isNotEmpty &&
          !selectedParkingTypes.contains(property.parkingType)) {
        return false;
      }

      // Фильтр по типу сделки
      if (isForSale.value && !property.isForSale) {
        return false;
      }
      if (isForRent.value && !property.isForRent) {
        return false;
      }

      // Фильтр по наличию рассрочки
      if (hasInstallment.value && !property.isInstallmentAvailable) {
        return false;
      }

      return true;
    }).toList();
  }

  void resetFilters() {
    selectedCity.value = 'Весь Таджикистан';
    minPrice.value = 0;
    maxPrice.value = 10000000;
    selectedRooms.clear();
    selectedClasses.clear();
    selectedMaterials.clear();
    selectedParkingTypes.clear();
    isForSale.value = true;
    isForRent.value = false;
    hasInstallment.value = false;
  }
}
