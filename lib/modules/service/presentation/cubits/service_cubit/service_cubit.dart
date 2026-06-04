import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:reservation_workshop/core/network/local/cache_helper.dart';
import 'package:reservation_workshop/core/utils/strings/prefkeys.dart';

import '../../../data/datasources/service_remote_datasource.dart';
import 'service_state.dart';

class ServiceCubit extends Cubit<ServiceState> {
  ServiceCubit() : super(ServiceInitial());

  static ServiceCubit get(context) => BlocProvider.of<ServiceCubit>(context);

  late final ServiceRemoteDataSource _remote = ServiceRemoteDataSource();

  Future<bool> _isGuestMode() async {
    return await CacheHelper.getDataAsync<bool>(key: PrefKeys.kIsGuestMode) ?? false;
  }

  Future<void> load({required int locationId}) async {
    emit(ServiceLoading());
    try {
      if (await _isGuestMode()) {
        emit(ServiceSuccess(locationId: locationId, services: []));
        return;
      }
      final services = await _remote.getServices(locationId: locationId);
      emit(ServiceSuccess(locationId: locationId, services: services));
    } catch (e) {
      emit(ServiceError(e.toString()));
    }
  }

  void clear() {
    emit(ServiceInitial());
  }
}
