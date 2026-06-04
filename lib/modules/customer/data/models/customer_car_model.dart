import 'dart:convert';

import '../../domain/entities/customer_car.dart';

class CustomerCarModel extends CustomerCar {
  const CustomerCarModel({
    required super.id,
    required super.model,
    required super.device,
    required super.color,
    required super.carLogo,
    required super.carImage,
    required super.plateNumber,
    required super.manufacturingYear,
    required super.chassisNumber,
    required super.carType,
    required super.tax,
  });

  factory CustomerCarModel.fromJson(Map<String, dynamic> json) {
    final parsedTax = _parseTax(json['tax']);
    return CustomerCarModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      model: json['model']?.toString() ?? '',
      device: json['device']?.toString() ?? '',
      color: json['color']?.toString() ?? '',
      carLogo: json['car_logo']?.toString(),
      carImage: json['car_image']?.toString(),
      plateNumber: json['plate_number']?.toString(),
      manufacturingYear: json['manufacturing_year']?.toString() ?? '',
      chassisNumber: json['chassis_number']?.toString() ?? '',
      carType: json['car_type']?.toString() ?? '',
      tax: parsedTax,
    );
  }

  static List<CustomerCarTaxItem> _parseTax(dynamic raw) {
    try {
      if (raw == null) return const <CustomerCarTaxItem>[];

      dynamic taxJson = raw;
      if (raw is String) {
        final trimmed = raw.trim();
        if (trimmed.isEmpty) return const <CustomerCarTaxItem>[];
        taxJson = jsonDecode(trimmed);
      }

      if (taxJson is List) {
        final result = <CustomerCarTaxItem>[];
        for (final item in taxJson) {
          if (item is Map) {
            final title = item['title']?.toString().trim() ?? '';
            final description = item['description']?.toString().trim() ?? '';
            if (title.isEmpty && description.isEmpty) continue;
            result.add(CustomerCarTaxItem(title: title, description: description));
          }
        }
        return result;
      }

      return const <CustomerCarTaxItem>[];
    } catch (_) {
      return const <CustomerCarTaxItem>[];
    }
  }
}
