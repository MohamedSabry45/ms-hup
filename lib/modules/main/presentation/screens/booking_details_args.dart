import 'package:reservation_workshop/modules/main/presentation/widgets/notification_card.dart';

class BookingDetailsArgs {
  final NotificationCardModel model;
  final String bookingStart;
  final int locationId;
  final int serviceId;
  final int? deviceId;
  final String bookingNote;
  final String? bookingType;

  const BookingDetailsArgs({
    required this.model,
    required this.bookingStart,
    required this.locationId,
    required this.serviceId,
    this.deviceId,
    required this.bookingNote,
    this.bookingType,
  });
}
