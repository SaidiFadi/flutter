import 'package:delivery_app/utils/delivery_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  final List<DeliveryHistory> deliveryHistory = [
    DeliveryHistory(
      orderId: 'ORD001',
      customerName: 'Alice Johnson',
      fromAddress: '123 Pickup St, PickupCity',
      toAddress: '456 Delivery Ave, DeliveryTown',
      distance: 15.7,
      deliveryTime: Duration(minutes: 45),
      cost: 25.99,
      rating: 4.8,
      photos: ['assets/img/delivery1.jpg', 'assets/delivery2.jpg'],
      dateTime: DateTime.now().subtract(Duration(days: 2)),
      items: ['Large Pizza', '2x Soda'],
      notes: 'Leave at the door',
      deliveryPersonNotes: 'Customer was very friendly',
    ),
    
  ];

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delivery History'),
      ),
      body: Consumer<DeliveryData>(
        builder: (context, deliveryData, child) {
          return ListView.builder(
            itemCount: deliveryData.deliveredOrders.length,
            itemBuilder: (context, index) {
              return DeliveryHistoryCard(
                deliveryHistory: deliveryData.deliveredOrders[index],
                onTap: () => _showDetailedModal(context, deliveryData.deliveredOrders[index]),
              );
            },
          );
        },
      ),
    );
  }
  void _showDetailedModal(BuildContext context, DeliveryHistory delivery) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (_, controller) => DetailedDeliveryView(
          delivery: delivery,
          scrollController: controller,
        ),
      ),
    );
  }
}

class DeliveryHistoryCard extends StatelessWidget {
  final DeliveryHistory deliveryHistory;
  final VoidCallback onTap;

  const DeliveryHistoryCard({
    Key? key,
    required this.deliveryHistory,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text('Order #${deliveryHistory.orderId}'),
        subtitle: Text('${deliveryHistory.customerName} - ${DateFormat('MMM d, y').format(deliveryHistory.dateTime)}'),
        trailing: Text('\$${deliveryHistory.cost.toStringAsFixed(2)}'),
        onTap: onTap,
      ),
    );
  }
}

class DetailedDeliveryView extends StatelessWidget {
  final DeliveryHistory delivery;
  final ScrollController scrollController;

  const DetailedDeliveryView({
    Key? key,
    required this.delivery,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
      padding: EdgeInsets.all(16),
      children: [
        Text('Order #${delivery.orderId}', style: Theme.of(context).textTheme.headlineMedium),
        SizedBox(height: 16),
        _buildInfoRow('Customer', delivery.customerName),
        _buildInfoRow('From', delivery.fromAddress),
        _buildInfoRow('To', delivery.toAddress),
        _buildInfoRow('Distance', '${delivery.distance.toStringAsFixed(1)} km'),
        _buildInfoRow('Delivery Time', '${delivery.deliveryTime.inMinutes} minutes'),
        _buildInfoRow('Cost', '\$${delivery.cost.toStringAsFixed(2)}'),
        _buildInfoRow('Rating', '${delivery.rating.toStringAsFixed(1)} / 5.0'),
        _buildInfoRow('Date & Time', DateFormat('MMM d, y HH:mm').format(delivery.dateTime)),
        SizedBox(height: 16),
        Text('Items', style: Theme.of(context).textTheme.headlineMedium),
        ...delivery.items.map((item) => Padding(
          padding: EdgeInsets.only(left: 16, top: 8),
          child: Text('• $item'),
        )),
        SizedBox(height: 16),
        Text('Notes', style: Theme.of(context).textTheme.headlineMedium),
        Text(delivery.notes),
        SizedBox(height: 16),
        Text('Delivery Person Notes', style: Theme.of(context).textTheme.headlineMedium),
        Text(delivery.deliveryPersonNotes),
        SizedBox(height: 16),
        Text('Photos', style: Theme.of(context).textTheme.headlineMedium),
        SizedBox(height: 8),
        Container(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: delivery.photos.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: 8),
                child: Image.asset(delivery.photos[index], width: 120, height: 120, fit: BoxFit.cover),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}

class DeliveryHistory {
  final String orderId;
  final String customerName;
  final String fromAddress;
  final String toAddress;
  final double distance;
  final Duration deliveryTime;
  final double cost;
  final double rating;
  final List<String> photos;
  final DateTime dateTime;
  final List<String> items;
  final String notes;
  final String deliveryPersonNotes;

  DeliveryHistory({
    required this.orderId,
    required this.customerName,
    required this.fromAddress,
    required this.toAddress,
    required this.distance,
    required this.deliveryTime,
    required this.cost,
    required this.rating,
    required this.photos,
    required this.dateTime,
    required this.items,
    required this.notes,
    required this.deliveryPersonNotes,
  });
}