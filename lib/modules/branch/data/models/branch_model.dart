import '../../domain/entities/branch.dart';

class BranchModel extends Branch {
  const BranchModel({
    required super.id,
    required super.name,
    super.isCarStation,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final isCarStationRaw = json['is_car_station'];
    return BranchModel(
      id: id is int ? id : int.tryParse(id?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      isCarStation: isCarStationRaw is int
          ? isCarStationRaw
          : int.tryParse(isCarStationRaw?.toString() ?? '') ?? 1,
    );
  }
}
