// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuoteAdapter extends TypeAdapter<Quote> {
  @override
  final int typeId = 0;

  @override
  Quote read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Quote(
      id: fields[0] as String?,
      completedBy: fields[1] as String,
      date: fields[2] as DateTime?,
      time: fields[3] as DateTime?,
      carEventName: fields[4] as String,
      customerName: fields[5] as String,
      isVeteran: fields[6] as bool,
      veteranDiscountPercentage: fields[33] as double?,
      address: fields[7] as String,
      city: fields[8] as String,
      state: fields[9] as String,
      zipCode: fields[10] as String,
      phoneNumber: fields[11] as String,
      emailAddress: fields[12] as String,
      carMake: fields[13] as String,
      carModel: fields[14] as String,
      carColor: fields[15] as String,
      photoTakenBy: fields[16] as PhotoTakenBy,
      availableDates: fields[17] as String,
      isPriorityService: fields[18] as bool,
      needByDate: fields[19] as DateTime?,
      wantsPhotosFromShoot: fields[20] as bool,
      productSize: fields[21] as ProductSize,
      customSize: fields[22] as String,
      showboardType: fields[23] as ShowboardType,
      themeDescription: fields[24] as String,
      printMaterials: (fields[25] as List?)?.cast<PrintMaterial>(),
      substrates: (fields[26] as List?)?.cast<Substrate>(),
      isFramed: fields[27] as bool,
      hasProtectiveCase: fields[28] as bool,
      standType: fields[29] as StandType,
      hasStandCarryingCase: fields[30] as bool,
      hasCombinationCase: fields[34] as bool?,
      createdAt: fields[31] as DateTime?,
      updatedAt: fields[32] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Quote obj) {
    writer
      ..writeByte(35)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.completedBy)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.time)
      ..writeByte(4)
      ..write(obj.carEventName)
      ..writeByte(5)
      ..write(obj.customerName)
      ..writeByte(6)
      ..write(obj.isVeteran)
      ..writeByte(33)
      ..write(obj.veteranDiscountPercentage)
      ..writeByte(7)
      ..write(obj.address)
      ..writeByte(8)
      ..write(obj.city)
      ..writeByte(9)
      ..write(obj.state)
      ..writeByte(10)
      ..write(obj.zipCode)
      ..writeByte(11)
      ..write(obj.phoneNumber)
      ..writeByte(12)
      ..write(obj.emailAddress)
      ..writeByte(13)
      ..write(obj.carMake)
      ..writeByte(14)
      ..write(obj.carModel)
      ..writeByte(15)
      ..write(obj.carColor)
      ..writeByte(16)
      ..write(obj.photoTakenBy)
      ..writeByte(17)
      ..write(obj.availableDates)
      ..writeByte(18)
      ..write(obj.isPriorityService)
      ..writeByte(19)
      ..write(obj.needByDate)
      ..writeByte(20)
      ..write(obj.wantsPhotosFromShoot)
      ..writeByte(21)
      ..write(obj.productSize)
      ..writeByte(22)
      ..write(obj.customSize)
      ..writeByte(23)
      ..write(obj.showboardType)
      ..writeByte(24)
      ..write(obj.themeDescription)
      ..writeByte(25)
      ..write(obj.printMaterials)
      ..writeByte(26)
      ..write(obj.substrates)
      ..writeByte(27)
      ..write(obj.isFramed)
      ..writeByte(28)
      ..write(obj.hasProtectiveCase)
      ..writeByte(29)
      ..write(obj.standType)
      ..writeByte(30)
      ..write(obj.hasStandCarryingCase)
      ..writeByte(34)
      ..write(obj.hasCombinationCase)
      ..writeByte(31)
      ..write(obj.createdAt)
      ..writeByte(32)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PhotoTakenByAdapter extends TypeAdapter<PhotoTakenBy> {
  @override
  final int typeId = 1;

  @override
  PhotoTakenBy read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PhotoTakenBy.photomotive;
      case 1:
        return PhotoTakenBy.customer;
      default:
        return PhotoTakenBy.photomotive;
    }
  }

  @override
  void write(BinaryWriter writer, PhotoTakenBy obj) {
    switch (obj) {
      case PhotoTakenBy.photomotive:
        writer.writeByte(0);
        break;
      case PhotoTakenBy.customer:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhotoTakenByAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProductSizeAdapter extends TypeAdapter<ProductSize> {
  @override
  final int typeId = 2;

  @override
  ProductSize read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ProductSize.size8x12;
      case 1:
        return ProductSize.size16x24;
      case 2:
        return ProductSize.size20x30;
      case 3:
        return ProductSize.size24x36;
      case 4:
        return ProductSize.custom;
      default:
        return ProductSize.size8x12;
    }
  }

  @override
  void write(BinaryWriter writer, ProductSize obj) {
    switch (obj) {
      case ProductSize.size8x12:
        writer.writeByte(0);
        break;
      case ProductSize.size16x24:
        writer.writeByte(1);
        break;
      case ProductSize.size20x30:
        writer.writeByte(2);
        break;
      case ProductSize.size24x36:
        writer.writeByte(3);
        break;
      case ProductSize.custom:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductSizeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ShowboardTypeAdapter extends TypeAdapter<ShowboardType> {
  @override
  final int typeId = 3;

  @override
  ShowboardType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ShowboardType.standard;
      case 1:
        return ShowboardType.themedAI;
      default:
        return ShowboardType.standard;
    }
  }

  @override
  void write(BinaryWriter writer, ShowboardType obj) {
    switch (obj) {
      case ShowboardType.standard:
        writer.writeByte(0);
        break;
      case ShowboardType.themedAI:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShowboardTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PrintMaterialAdapter extends TypeAdapter<PrintMaterial> {
  @override
  final int typeId = 4;

  @override
  PrintMaterial read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PrintMaterial.photoPaper;
      case 1:
        return PrintMaterial.vinyl;
      case 2:
        return PrintMaterial.aluminum;
      case 3:
        return PrintMaterial.acrylic;
      case 4:
        return PrintMaterial.canvas;
      default:
        return PrintMaterial.photoPaper;
    }
  }

  @override
  void write(BinaryWriter writer, PrintMaterial obj) {
    switch (obj) {
      case PrintMaterial.photoPaper:
        writer.writeByte(0);
        break;
      case PrintMaterial.vinyl:
        writer.writeByte(1);
        break;
      case PrintMaterial.aluminum:
        writer.writeByte(2);
        break;
      case PrintMaterial.acrylic:
        writer.writeByte(3);
        break;
      case PrintMaterial.canvas:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrintMaterialAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SubstrateAdapter extends TypeAdapter<Substrate> {
  @override
  final int typeId = 5;

  @override
  Substrate read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Substrate.none;
      case 1:
        return Substrate.foamBoard;
      case 2:
        return Substrate.dibond;
      case 3:
        return Substrate.pvc;
      case 4:
        return Substrate.gatorboard;
      default:
        return Substrate.none;
    }
  }

  @override
  void write(BinaryWriter writer, Substrate obj) {
    switch (obj) {
      case Substrate.none:
        writer.writeByte(0);
        break;
      case Substrate.foamBoard:
        writer.writeByte(1);
        break;
      case Substrate.dibond:
        writer.writeByte(2);
        break;
      case Substrate.pvc:
        writer.writeByte(3);
        break;
      case Substrate.gatorboard:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubstrateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StandTypeAdapter extends TypeAdapter<StandType> {
  @override
  final int typeId = 6;

  @override
  StandType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return StandType.none;
      case 1:
        return StandType.economy;
      case 2:
        return StandType.premium;
      case 3:
        return StandType.premiumSilver;
      case 4:
        return StandType.premiumBlack;
      default:
        return StandType.none;
    }
  }

  @override
  void write(BinaryWriter writer, StandType obj) {
    switch (obj) {
      case StandType.none:
        writer.writeByte(0);
        break;
      case StandType.economy:
        writer.writeByte(1);
        break;
      case StandType.premium:
        writer.writeByte(2);
        break;
      case StandType.premiumSilver:
        writer.writeByte(3);
        break;
      case StandType.premiumBlack:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StandTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
