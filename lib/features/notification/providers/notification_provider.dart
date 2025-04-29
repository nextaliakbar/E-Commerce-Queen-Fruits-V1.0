import 'package:ecommerce_app_queen_fruits_v1_0/features/notification/domain/repositories/notification_repo.dart';
import 'package:flutter/foundation.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationRepo? notificationRepo;

  NotificationProvider({required this.notificationRepo});
}