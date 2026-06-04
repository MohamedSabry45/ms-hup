import '../entities/customer_info.dart';

abstract class CustomerRepository {
  Future<CustomerInfo> getCustomerInfo();

  Future<void> updateContactBasicInfo({
    required int id,
    required String firstName,
    required String lastName,
    required String email,
    required String mobile,
  });
}
