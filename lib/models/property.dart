enum ConstructionStage {
  landAllocated,
  foundation,
  floors1to5,
  floors6to10,
  floors11to15,
  floors16to20,
  floors21to25,
  facade,
  finishing,
  completed
}

enum CompletionQuarter {
  q2_2024,
  q3_2024,
  q4_2024,
  q1_2025,
  q2_2025,
  q3_2025,
  q4_2025,
  q1_2026,
  q2_2026,
  q3_2026,
  q4_2026,
  q1_2027,
  q2_2027,
  q3_2027,
  q4_2027,
  q1_2028,
  q2_2028,
  q3_2028,
  q4_2028,
  completed
}

enum BuildingMaterial {
  brick,
  monolithic,
  panel
}

enum PropertyClass {
  economy,
  comfort,
  elite
}

enum ParkingType {
  none,
  covered,
  open,
  underground
}

class Property {
  final String id;
  final String title;
  final double price;
  final String address;
  final String city;
  final ConstructionStage constructionStage;
  final CompletionQuarter completionQuarter;
  final BuildingMaterial buildingMaterial;
  final int numberOfRooms;
  final PropertyClass propertyClass;
  final ParkingType parkingType;
  final double latitude;
  final double longitude;
  final List<String> images;
  final String description;
  final DateTime createdAt;
  final bool isForRent;
  final bool isForSale;
  final double? rentPrice;
  final bool isInstallmentAvailable;
  final Map<String, dynamic>? installmentTerms;

  Property({
    required this.id,
    required this.title,
    required this.price,
    required this.address,
    required this.city,
    required this.constructionStage,
    required this.completionQuarter,
    required this.buildingMaterial,
    required this.numberOfRooms,
    required this.propertyClass,
    required this.parkingType,
    required this.latitude,
    required this.longitude,
    required this.images,
    required this.description,
    required this.createdAt,
    required this.isForRent,
    required this.isForSale,
    this.rentPrice,
    required this.isInstallmentAvailable,
    this.installmentTerms,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(),
      address: json['address'],
      city: json['city'],
      constructionStage: ConstructionStage.values[json['constructionStage']],
      completionQuarter: CompletionQuarter.values[json['completionQuarter']],
      buildingMaterial: BuildingMaterial.values[json['buildingMaterial']],
      numberOfRooms: json['numberOfRooms'],
      propertyClass: PropertyClass.values[json['propertyClass']],
      parkingType: ParkingType.values[json['parkingType']],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      images: List<String>.from(json['images']),
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      isForRent: json['isForRent'],
      isForSale: json['isForSale'],
      rentPrice: json['rentPrice']?.toDouble(),
      isInstallmentAvailable: json['isInstallmentAvailable'],
      installmentTerms: json['installmentTerms'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'address': address,
      'city': city,
      'constructionStage': constructionStage.index,
      'completionQuarter': completionQuarter.index,
      'buildingMaterial': buildingMaterial.index,
      'numberOfRooms': numberOfRooms,
      'propertyClass': propertyClass.index,
      'parkingType': parkingType.index,
      'latitude': latitude,
      'longitude': longitude,
      'images': images,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'isForRent': isForRent,
      'isForSale': isForSale,
      'rentPrice': rentPrice,
      'isInstallmentAvailable': isInstallmentAvailable,
      'installmentTerms': installmentTerms,
    };
  }
}
