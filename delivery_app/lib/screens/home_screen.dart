import 'package:delivery_app/utils/delivery_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:delivery_app/screens/history_screen.dart';
import 'package:delivery_app/screens/map_screen.dart';
import 'package:delivery_app/screens/profile_screen.dart';
import 'package:delivery_app/screens/scan_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Order> orders = [
    Order(
      id: 'HNX0021TM8',
      status: OrderStatus.waitingPickup,
      customerName: 'John Doe',
      address: '123 Main St, City',
      distance: 3.5,
      latitude: 36.718979,
      longitude: 10.205915,
      placedTime: DateTime.now().subtract(Duration(minutes: 30)),
    ),
    Order(
      id: 'TMD486FV82',
      status: OrderStatus.inProgress,
      customerName: 'Jane Smith',
      address: '456 Elm St, Town',
      distance: 5.2,
      latitude: 36.893166,
      longitude: 10.162913,
      placedTime: DateTime.now().subtract(Duration(hours: 1)),
    ),
    Order(
      id: 'WDF22D5E88',
      status: OrderStatus.delivered,
      customerName: 'Bob Johnson',
      address: '789 Oak St, Village',
      distance: 2.8,
      latitude: 36.846199,
      longitude: 10.216814,
      placedTime: DateTime.now().subtract(Duration(hours: 2)),
    ),
  ];

 void _updateOrderStatus(Order updatedOrder) {
    setState(() {
      int index = orders.indexWhere((order) => order.id == updatedOrder.id);
      if (index != -1) {
        orders[index] = updatedOrder;
        if (updatedOrder.status == OrderStatus.delivered) {
          // Add the delivered order to history
          Provider.of<DeliveryData>(context, listen: false).addDeliveredOrder(
            DeliveryHistory(
              orderId: updatedOrder.id,
              customerName: updatedOrder.customerName,
              fromAddress: 'Pickup Address', // You may need to add this to your Order class
              toAddress: updatedOrder.address,
              distance: updatedOrder.distance,
              deliveryTime: DateTime.now().difference(updatedOrder.placedTime),
              cost: 0.0, // You may need to add this to your Order class
              rating: 0.0, // You may need to add this later
              photos: [], // You may need to add this later
              dateTime: DateTime.now(),
              items: ['Item'], // You may need to add this to your Order class
              notes: 'No notes', // You may need to add this to your Order class
              deliveryPersonNotes: 'No notes', // You may need to add this later
            ),
          );
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deliveries'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search orders...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return OrderCard(
                  order: orders[index],
                  onStatusChange: _updateOrderStatus,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HistoryScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          }
        },
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Order order;
  final Function(Order) onStatusChange;

  const OrderCard({Key? key, required this.order, required this.onStatusChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.id}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                _buildStatusChip(),
              ],
            ),
            SizedBox(height: 8),
            Text('Customer: ${order.customerName}'),
            Text('Address: ${order.address}'),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Distance: ${order.distance.toStringAsFixed(1)} km'),
                Text('Placed: ${_formatDate(order.placedTime)}'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapScreen(
                          deliveryLocation: LatLng(order.latitude, order.longitude),
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.map),
                  label: Text('View on Map'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScanScreen(
                          order: order,
                          onStatusChange: onStatusChange,
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.qr_code_scanner),
                  label: Text('Scan'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    Color color;
    String label;

    switch (order.status) {
      case OrderStatus.waitingPickup:
        color = Colors.orange;
        label = 'Waiting Pickup';
        break;
      case OrderStatus.inProgress:
        color = Colors.blue;
        label = 'In Progress';
        break;
      case OrderStatus.delivered:
        color = Colors.green;
        label = 'Delivered';
        break;
    }

    return Chip(
      label: Text(label),
      backgroundColor: color,
      labelStyle: TextStyle(color: Colors.white),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }
}

class Order {
  final String id;
  final OrderStatus status;
  final String customerName;
  final String address;
  final double latitude;
  final double longitude;
  final double distance;
  final DateTime placedTime;

  Order({
    required this.id,
    required this.status,
    required this.customerName,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.placedTime,
  });
}

enum OrderStatus {
  waitingPickup,
  inProgress,
  delivered,
}