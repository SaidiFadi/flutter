import 'package:delivery_app/screens/history_screen.dart';
import 'package:flutter/material.dart';

class DeliveryData extends ChangeNotifier {
  List<DeliveryHistory> deliveredOrders = [];

  void addDeliveredOrder(DeliveryHistory order) {
    deliveredOrders.add(order);
    notifyListeners();
  }
}