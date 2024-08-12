import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapScreen extends StatefulWidget {
  final LatLng deliveryLocation;

  MapScreen({required this.deliveryLocation});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _currentLocation;
  bool _isLoading = true;
  final MapController _mapController = MapController();
  List<LatLng> _routePoints = [];

  @override
void initState() {
  super.initState();
  _getCurrentLocation();
  _mapController.mapEventStream.listen((event) {
    if (event is MapEventMoveEnd && _currentLocation != null) {
      _mapController.move(_currentLocation!, 13.0);
    }
  });
}

  Future<void> _getCurrentLocation() async {
  try {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _isLoading = false;
    });
    print("Current Location: $_currentLocation");
    print("Delivery Location: ${widget.deliveryLocation}");
    _getRoute();
  } catch (e) {
    print("Error getting location: $e");
    setState(() {
      _isLoading = false;
    });
  }
}

  Future<void> _getRoute() async {
    if (_currentLocation == null) {
      print("Current location is null. Cannot get route.");
      return;
    }

    final apiKey = '5b3ce3597851110001cf62487fe955d6b4ce4e72b9a6a14267cd1d9d'; // Replace with your API key
    final apiUrl = 'https://api.openrouteservice.org/v2/directions/driving-car';

    try {
      final response = await http.get(
        Uri.parse('$apiUrl?api_key=$apiKey&start=${_currentLocation!.longitude},${_currentLocation!.latitude}&end=${widget.deliveryLocation.longitude},${widget.deliveryLocation.latitude}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final coords = data['features'][0]['geometry']['coordinates'] as List;
        setState(() {
          _routePoints = coords.map((coord) => LatLng(coord[1], coord[0])).toList();
        });
        print("Route points: ${_routePoints.length}");
      } else {
        print('Failed to get route. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error getting route: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Delivery Route')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
  initialCenter: _currentLocation ?? widget.deliveryLocation,
  initialZoom: 13.0,
),
                  children: [
                    TileLayer(
  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
),
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: _routePoints,
                          color: Colors.blue,
                          strokeWidth: 3.0,
                        ),
                      ],
                    ),
                    MarkerLayer(
                      markers: [
                        if (_currentLocation != null)
                          Marker(
                            point: _currentLocation!,
                            width: 80,
                            height: 80,
                            child: Icon(Icons.location_on, color: Colors.blue, size: 40),
                          ),
                        Marker(
                          point: widget.deliveryLocation,
                          width: 80,
                          height: 80,
                          child: Icon(Icons.location_on, color: Colors.red, size: 40),
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Distance: ${_calculateDistance().toStringAsFixed(2)} km',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text('Estimated Time: ${_estimateTime()} minutes',
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _getCurrentLocation();
        },
        child: Icon(Icons.my_location),
      ),
    );
  }

  double _calculateDistance() {
    if (_routePoints.isEmpty) return 0;
    double totalDistance = 0;
    for (int i = 0; i < _routePoints.length - 1; i++) {
      totalDistance += Geolocator.distanceBetween(
        _routePoints[i].latitude,
        _routePoints[i].longitude,
        _routePoints[i + 1].latitude,
        _routePoints[i + 1].longitude,
      );
    }
    return totalDistance / 1000; // Convert meters to kilometers
  }

  String _estimateTime() {
    double distance = _calculateDistance();
    double averageSpeed = 30; // km/h, adjust as needed
    int minutes = (distance / averageSpeed * 60).round();
    return minutes.toString();
  }
}