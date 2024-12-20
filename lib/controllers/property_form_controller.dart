import 'package:get/get.dart';
import 'package:real_estate_app/models/property.dart';
import 'package:real_estate_app/data/dummy_data.dart';
import 'package:image_picker/image_picker.dart';

class PropertyFormController extends GetxController {
  final title = ''.obs;
  final price = 0.0.obs;
  final address = ''.obs;
  final city = 'Душанбе'.obs;
  final constructionStage = ConstructionStage.landAllocated.obs;
  final completionQuarter = CompletionQuarter.q2_2024.obs;
  final buildingMaterial = BuildingMaterial.brick.obs;
  final numberOfRooms = 1.obs;
  final propertyClass = PropertyClass.economy.obs;
  final parkingType = ParkingType.none.obs;
  final latitude = 38.5598.obs;
  final longitude = 68.7870.obs;
  final description = ''.obs;
  final isForRent = false.obs;
  final isForSale = true.obs;
  final rentPrice = 0.0.obs;
  final isInstallmentAvailable = false.obs;
  final initialPayment = 0.obs;
  final installmentMonths = 0.obs;
  final images = <String>[].obs;

  final ImagePicker _imagePicker = ImagePicker();

  Future<void> addImage() async {
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // В реальном приложении здесь был бы код для загрузки изображения на сервер
      // Пока просто добавим путь к файлу
      images.add(image.path);
    }
  }

  void removeImage(int index) {
    images.removeAt(index);
  }

  bool validateForm() {
    if (title.value.isEmpty) return false;
    if (price.value <= 0) return false;
    if (address.value.isEmpty) return false;
    if (city.value.isEmpty) return false;
    if (description.value.isEmpty) return false;
    if (!isForRent.value && !isForSale.value) return false;
    if (isForRent.value && rentPrice.value <= 0) return false;
    if (isInstallmentAvailable.value && (initialPayment.value <= 0 || installmentMonths.value <= 0)) {
      return false;
    }
    return true;
  }

  void submitForm() {
    if (!validateForm()) {
      Get.snackbar(
        'Ошибка',
        'Пожалуйста, заполните все обязательные поля',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final property = Property(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.value,
      price: price.value,
      address: address.value,
      city: city.value,
      constructionStage: constructionStage.value,
      completionQuarter: completionQuarter.value,
      buildingMaterial: buildingMaterial.value,
      numberOfRooms: numberOfRooms.value,
      propertyClass: propertyClass.value,
      parkingType: parkingType.value,
      latitude: latitude.value,
      longitude: longitude.value,
      images: images,
      description: description.value,
      createdAt: DateTime.now(),
      isForRent: isForRent.value,
      isForSale: isForSale.value,
      rentPrice: isForRent.value ? rentPrice.value : null,
      isInstallmentAvailable: isInstallmentAvailable.value,
      installmentTerms: isInstallmentAvailable.value
          ? {
              'initialPayment': initialPayment.value,
              'months': installmentMonths.value,
            }
          : null,
    );

    // В реальном приложении здесь был бы код для сохранения в базу данных
    dummyProperties.add(property);
    Get.back();
    Get.snackbar(
      'Успешно',
      'Объект недвижимости добавлен',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void resetForm() {
    title.value = '';
    price.value = 0.0;
    address.value = '';
    city.value = 'Душанбе';
    constructionStage.value = ConstructionStage.landAllocated;
    completionQuarter.value = CompletionQuarter.q2_2024;
    buildingMaterial.value = BuildingMaterial.brick;
    numberOfRooms.value = 1;
    propertyClass.value = PropertyClass.economy;
    parkingType.value = ParkingType.none;
    latitude.value = 38.5598;
    longitude.value = 68.7870;
    description.value = '';
    isForRent.value = false;
    isForSale.value = true;
    rentPrice.value = 0.0;
    isInstallmentAvailable.value = false;
    initialPayment.value = 0;
    installmentMonths.value = 0;
    images.clear();
  }
}
