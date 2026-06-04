import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:reservation_workshop/constants/app_constants.dart';
import 'package:reservation_workshop/core/network/api_endpoints.dart';
import 'package:reservation_workshop/core/network/local/cache_helper.dart';
import 'package:reservation_workshop/core/utils/strings/prefkeys.dart';
import 'package:reservation_workshop/modules/home/data/models/brand_model.dart';

abstract class BrandsRemoteDataSource {
  Future<List<BrandModel>> getBrands();
}

class BrandsRemoteDataSourceImpl implements BrandsRemoteDataSource {
  final http.Client _client;

  BrandsRemoteDataSourceImpl({http.Client? client}) : _client = client ?? http.Client();

  @override
  Future<List<BrandModel>> getBrands() async {
    final baseUrl = AppConstants.kBaseUrl.trim();
    final token = AppConstants.token ?? CacheHelper.getData<String>(key: PrefKeys.kAccessToken);

    final uri = Uri.parse('$baseUrl${ApiEndpoints.brands}');

    final headers = <String, String>{
      'Accept': 'application/json',
    };

    if (token != null && token.trim().isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await _client.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as List<dynamic>;
      return jsonResponse.map((item) => BrandModel.fromJson(item as Map<String, dynamic>)).toList();
    }

    throw Exception('Failed to load brands');
  }
}
