import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'quote_model.g.dart';

@HiveType(typeId: 0)
class Quote extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String completedBy;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  DateTime time;

  @HiveField(4)
  String carEventName;

  @HiveField(5)
  String customerName;

  @HiveField(6)
  bool isVeteran;

  @HiveField(33)
  double? veteranDiscountPercentage;

  @HiveField(7)
  String address;

  @HiveField(8)
  String city;

  @HiveField(9)
  String state;

  @HiveField(10)
  String zipCode;

  @HiveField(11)
  String phoneNumber;

  @HiveField(12)
  String emailAddress;

  @HiveField(13)
  String carMake;

  @HiveField(14)
  String carModel;

  @HiveField(15)
  String carColor;

  @HiveField(16)
  PhotoTakenBy photoTakenBy;

  @HiveField(17)
  String availableDates;

  @HiveField(18)
  bool isPriorityService;

  @HiveField(19)
  DateTime? needByDate;

  @HiveField(20)
  bool wantsPhotosFromShoot;

  @HiveField(21)
  ProductSize productSize;

  @HiveField(22)
  String customSize;

  @HiveField(23)
  ShowboardType showboardType;

  @HiveField(24)
  String themeDescription;

  @HiveField(25)
  List<PrintMaterial> printMaterials;

  @HiveField(26)
  List<Substrate> substrates;

  @HiveField(27)
  bool isFramed;

  @HiveField(28)
  bool hasProtectiveCase;

  @HiveField(29)
  StandType standType;

  @HiveField(30)
  bool hasStandCarryingCase;

  @HiveField(34)
  bool hasCombinationCase;

  @HiveField(31)
  DateTime createdAt;

  @HiveField(32)
  DateTime updatedAt;

  Quote({
    String? id,
    this.completedBy = '',
    DateTime? date,
    DateTime? time,
    this.carEventName = '',
    this.customerName = '',
    this.isVeteran = false,
    this.veteranDiscountPercentage,
    this.address = '',
    this.city = '',
    this.state = '',
    this.zipCode = '',
    this.phoneNumber = '',
    this.emailAddress = '',
    this.carMake = '',
    this.carModel = '',
    this.carColor = '',
    this.photoTakenBy = PhotoTakenBy.photomotive,
    this.availableDates = '',
    this.isPriorityService = false,
    this.needByDate,
    this.wantsPhotosFromShoot = false,
    this.productSize = ProductSize.size8x12,
    this.customSize = '',
    this.showboardType = ShowboardType.standard,
    this.themeDescription = '',
    List<PrintMaterial>? printMaterials,
    List<Substrate>? substrates,
    this.isFramed = false,
    this.hasProtectiveCase = false,
    this.standType = StandType.none,
    this.hasStandCarryingCase = false,
    this.hasCombinationCase = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? const Uuid().v4(),
       date = date ?? DateTime.now(),
       time = time ?? DateTime.now(),
       printMaterials = printMaterials ?? [],
       substrates = substrates ?? [],
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  // Getter for veteran discount percentage with default value
  double get effectiveVeteranDiscountPercentage =>
      veteranDiscountPercentage ?? 5.0;

  Quote copyWith({
    String? id,
    String? completedBy,
    DateTime? date,
    DateTime? time,
    String? carEventName,
    String? customerName,
    bool? isVeteran,
    double? veteranDiscountPercentage,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? phoneNumber,
    String? emailAddress,
    String? carMake,
    String? carModel,
    String? carColor,
    PhotoTakenBy? photoTakenBy,
    String? availableDates,
    bool? isPriorityService,
    DateTime? needByDate,
    bool? wantsPhotosFromShoot,
    ProductSize? productSize,
    String? customSize,
    ShowboardType? showboardType,
    String? themeDescription,
    List<PrintMaterial>? printMaterials,
    List<Substrate>? substrates,
    bool? isFramed,
    bool? hasProtectiveCase,
    StandType? standType,
    bool? hasStandCarryingCase,
    bool? hasCombinationCase,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Quote(
      id: id ?? this.id,
      completedBy: completedBy ?? this.completedBy,
      date: date ?? this.date,
      time: time ?? this.time,
      carEventName: carEventName ?? this.carEventName,
      customerName: customerName ?? this.customerName,
      isVeteran: isVeteran ?? this.isVeteran,
      veteranDiscountPercentage:
          veteranDiscountPercentage ?? this.veteranDiscountPercentage,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      emailAddress: emailAddress ?? this.emailAddress,
      carMake: carMake ?? this.carMake,
      carModel: carModel ?? this.carModel,
      carColor: carColor ?? this.carColor,
      photoTakenBy: photoTakenBy ?? this.photoTakenBy,
      availableDates: availableDates ?? this.availableDates,
      isPriorityService: isPriorityService ?? this.isPriorityService,
      needByDate: needByDate ?? this.needByDate,
      wantsPhotosFromShoot: wantsPhotosFromShoot ?? this.wantsPhotosFromShoot,
      productSize: productSize ?? this.productSize,
      customSize: customSize ?? this.customSize,
      showboardType: showboardType ?? this.showboardType,
      themeDescription: themeDescription ?? this.themeDescription,
      printMaterials: printMaterials ?? this.printMaterials,
      substrates: substrates ?? this.substrates,
      isFramed: isFramed ?? this.isFramed,
      hasProtectiveCase: hasProtectiveCase ?? this.hasProtectiveCase,
      standType: standType ?? this.standType,
      hasStandCarryingCase: hasStandCarryingCase ?? this.hasStandCarryingCase,
      hasCombinationCase: hasCombinationCase ?? this.hasCombinationCase,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

@HiveType(typeId: 1)
enum PhotoTakenBy {
  @HiveField(0)
  photomotive,
  @HiveField(1)
  customer,
}

@HiveType(typeId: 2)
enum ProductSize {
  @HiveField(0)
  size8x12,
  @HiveField(1)
  size16x24,
  @HiveField(2)
  size20x30,
  @HiveField(3)
  size24x36,
  @HiveField(4)
  custom,
}

@HiveType(typeId: 3)
enum ShowboardType {
  @HiveField(0)
  standard,
  @HiveField(1)
  themedAI,
}

@HiveType(typeId: 4)
enum PrintMaterial {
  @HiveField(0)
  photoPaper,
  @HiveField(1)
  vinyl,
  @HiveField(2)
  aluminum,
  @HiveField(3)
  acrylic,
  @HiveField(4)
  canvas,
}

@HiveType(typeId: 5)
enum Substrate {
  @HiveField(0)
  none,
  @HiveField(1)
  foamBoard,
  @HiveField(2)
  dibond,
  @HiveField(3)
  pvc,
  @HiveField(4)
  gatorboard,
}

@HiveType(typeId: 6)
enum StandType {
  @HiveField(0)
  none,
  @HiveField(1)
  economy,
  @HiveField(2)
  premium,
  @HiveField(3)
  premiumSilver,
  @HiveField(4)
  premiumBlack,
}

// Extension methods for displaying enum values
extension PhotoTakenByExtension on PhotoTakenBy {
  String get displayName {
    switch (this) {
      case PhotoTakenBy.photomotive:
        return 'Photomotive';
      case PhotoTakenBy.customer:
        return 'Customer';
    }
  }
}

extension ProductSizeExtension on ProductSize {
  String get displayName {
    switch (this) {
      case ProductSize.size8x12:
        return '8x12';
      case ProductSize.size16x24:
        return '16x24';
      case ProductSize.size20x30:
        return '20x30';
      case ProductSize.size24x36:
        return '24x36';
      case ProductSize.custom:
        return 'Custom Size';
    }
  }
}

extension ShowboardTypeExtension on ShowboardType {
  String get displayName {
    switch (this) {
      case ShowboardType.standard:
        return 'Standard';
      case ShowboardType.themedAI:
        return 'Themed (AI)';
    }
  }
}

extension PrintMaterialExtension on PrintMaterial {
  String get displayName {
    switch (this) {
      case PrintMaterial.photoPaper:
        return 'Photo Paper';
      case PrintMaterial.vinyl:
        return 'Vinyl';
      case PrintMaterial.aluminum:
        return 'Aluminum';
      case PrintMaterial.acrylic:
        return 'Acrylic';
      case PrintMaterial.canvas:
        return 'Canvas';
    }
  }
}

extension SubstrateExtension on Substrate {
  String get displayName {
    switch (this) {
      case Substrate.none:
        return 'None';
      case Substrate.foamBoard:
        return 'Foam Board';
      case Substrate.dibond:
        return 'Dibond';
      case Substrate.pvc:
        return 'PVC';
      case Substrate.gatorboard:
        return 'Gatorboard';
    }
  }
}

extension StandTypeExtension on StandType {
  String get displayName {
    switch (this) {
      case StandType.none:
        return 'None';
      case StandType.economy:
        return 'Economy Black';
      case StandType.premium:
        return 'Premium';
      case StandType.premiumSilver:
        return 'Premium Silver';
      case StandType.premiumBlack:
        return 'Premium Black';
    }
  }
}
