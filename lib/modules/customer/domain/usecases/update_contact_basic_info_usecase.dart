import '../repositories/customer_repository.dart';

class UpdateContactBasicInfoUsecase {
  final CustomerRepository _repo;

  const UpdateContactBasicInfoUsecase(this._repo);

  Future<void> call({
    required int id,
    required String firstName,
    required String lastName,
    required String email,
    required String mobile,
  }) {
    return _repo.updateContactBasicInfo(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      mobile: mobile,
    );
  }
}
