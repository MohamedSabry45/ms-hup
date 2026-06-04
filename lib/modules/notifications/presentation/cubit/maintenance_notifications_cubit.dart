import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:reservation_workshop/core/network/local/cache_helper.dart';
import 'package:reservation_workshop/core/utils/strings/prefkeys.dart';

import 'package:reservation_workshop/modules/notifications/data/datasources/maintenance_notifications_remote_datasource.dart';
import 'package:reservation_workshop/modules/notifications/presentation/cubit/maintenance_notifications_state.dart';

class MaintenanceNotificationsCubit extends Cubit<MaintenanceNotificationsState> {
  MaintenanceNotificationsCubit() : super(const MaintenanceNotificationsInitial());

  late final MaintenanceNotificationsRemoteDataSource _remote = MaintenanceNotificationsRemoteDataSource();

  Future<bool> _isGuestMode() async {
    return await CacheHelper.getDataAsync<bool>(key: PrefKeys.kIsGuestMode) ?? false;
  }

  Future<void> load({String status = 'all'}) async {
    emit(const MaintenanceNotificationsLoading());
    try {
      if (await _isGuestMode()) {
        emit(MaintenanceNotificationsSuccess([]));
        return;
      }
      final items = await _remote.getMaintenanceNotifications(status: status);
      emit(MaintenanceNotificationsSuccess(items));
    } catch (e) {
      emit(MaintenanceNotificationsError(e.toString()));
    }
  }

  Future<void> refresh() => load(status: 'all');

  Future<void> markRead({required List<String> notificationIds}) async {
    if (notificationIds.isEmpty) return;

    try {
      await _remote.markRead(notificationIds: notificationIds);
      await refresh();
    } catch (e) {
      emit(MaintenanceNotificationsError(e.toString()));
    }
  }

  Future<void> markAllRead() async {
    try {
      await _remote.markAllRead();
      await refresh();
    } catch (e) {
      emit(MaintenanceNotificationsError(e.toString()));
    }
  }
}
