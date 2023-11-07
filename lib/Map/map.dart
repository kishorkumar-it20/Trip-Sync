import 'package:bithack_tripsync/Available%20driver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_search/mapbox_search.dart';

class MapScreen extends StatefulWidget {
  final String selectedVehicle;

  MapScreen({required this.selectedVehicle});
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  LatLng _currentLocation = LatLng(0.0, 0.0); // Initialize with a default value
  LatLng _destination = LatLng(0.0, 0.0); // Initialize with a default value
  List<LatLng> _routeCoordinates = [];
  double _distance = 0.0;

  TextEditingController _searchController = TextEditingController();
  int _clickCount = 0;
  bool _showExtraButton = false;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            width: double.infinity,
            height: 550,
            child: Column(
              children: [
                Expanded(
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      center: _currentLocation,
                      zoom: 13.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                        'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                        additionalOptions: const{
                          'accessToken':
                          'sk.eyJ1Ijoia2lzaG9yMDciLCJhIjoiY2xsb3hocGlxMDBwZjNncHMzZTQwNGV1bCJ9.C5YYZ0Z4u5oshgp78KV-SQ',
                          'id': 'mapbox/streets-v11',
                        },
                      ),
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: _routeCoordinates,
                            color: Colors.blue,
                            strokeWidth: 4.0,
                          ),
                        ],
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            width: 40.0,
                            height: 40.0,
                            point: _currentLocation,
                            builder: (ctx) => Container(
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          if (_destination.latitude != 0.0)
                            Marker(
                              width: 40.0,
                              height: 40.0,
                              point: _destination,
                              builder: (ctx) => Container(
                                child: const Icon(
                                  Icons.location_on,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: 400,
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey,
                      width: 2.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.send, size: 20, color: Colors.grey),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintStyle: TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                                letterSpacing: 1),
                            border: InputBorder.none,
                            hintText: 'Choose Your Destination',
                          ),
                          onChanged: (query) {
                            // Handle search as the user types
                            // You can debounce or throttle the search to reduce API requests.
                            // For simplicity, we'll perform a search for each input change here.
                            searchDestination(query);
                          },
                        ),
                      ),
                      FloatingActionButton(
                        onPressed: () async {
                          final permission = await requestLocationPermission();
                          if (permission == LocationPermission.always ||
                              permission == LocationPermission.whileInUse) {
                            await fetchRouteCoordinates();
                            _mapController.fitBounds(
                              LatLngBounds.fromPoints(
                                  [_currentLocation, _destination]),
                            );
                            setState(() {
                              _clickCount++;
                              if (_clickCount % 2 == 0) {
                                _showExtraButton = true;
                              }
                            });
                          } else {
                            // Handle location permission denied
                          }
                        },
                        backgroundColor: const Color(0xFF27374D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        mini: true,
                        child: const Icon(
                          Icons.directions,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                "Mode of Travel: ${widget.selectedVehicle}",
                style: const TextStyle(fontSize: 25, letterSpacing: 1),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Distance: ${_distance.toStringAsFixed(2)} km',
                style: const TextStyle(fontSize: 25, letterSpacing: 1),
              ),
              const SizedBox(
                height: 40,
              ),
              Visibility(
                visible: _showExtraButton,
                child: SizedBox(
                  width: 340,
                  height: 60, // Adjust the width according to your needs
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> AvailableDrivers()));
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      primary: const Color(0xFF27374D),
                      onPrimary: const Color(0xFF27374D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Select the Driver',
                      style: TextStyle(
                          color: Colors.white, letterSpacing: 2, fontSize: 20),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<void> searchDestination(String query) async {
    final mapBoxSearch = PlacesSearch(
      apiKey: 'sk.eyJ1Ijoia2lzaG9yMDciLCJhIjoiY2xsb3hocGlxMDBwZjNncHMzZTQwNGV1bCJ9.C5YYZ0Z4u5oshgp78KV-SQ',
      limit: 5,
      language: 'en',
    );

    final places = await mapBoxSearch.getPlaces(
      query,
      // Specify the types of places you're interested in
    );

    if (places!.isNotEmpty) {
      final firstPlace = places[0];
      setState(() {
        _destination = LatLng(
            firstPlace.geometry!.coordinates![1],
            firstPlace.geometry!.coordinates![0]);
      });
    }
  }

  Future<void> fetchRouteCoordinates() async {
    Position currentPos = await Geolocator.getCurrentPosition();

    String apiKey = 'sk.eyJ1Ijoia2lzaG9yMDciLCJhIjoiY2xsb3hocGlxMDBwZjNncHMzZTQwNGV1bCJ9.C5YYZ0Z4u5oshgp78KV-SQ';
    final String apiUrl =
        'https://api.mapbox.com/directions/v5/mapbox/driving/${currentPos.longitude},${currentPos.latitude};${_destination.longitude},${_destination.latitude}';

    final response = await http.get(Uri.parse('$apiUrl?access_token=$apiKey'));
    print('Response body: ${response.body}');
    final responseData = json.decode(response.body);
    print('Parsed response data: $responseData');

    final routes = responseData['routes'];
    if (routes.isNotEmpty) {
      final route = routes[0];
      final distance = route['distance'] / 1000; // Convert to kilometers
      setState(() {
        _distance = distance;
      });

      final geometry = route['geometry'];

      if (geometry != null && geometry is Map<String, dynamic>) {
        final coordinates = geometry['coordinates'] as List<dynamic>;
        _routeCoordinates = coordinates.map((coords) {
          if (coords is List && coords.length >= 2) {
            final latitude = coords[1];
            final longitude = coords[0];
            return LatLng(latitude, longitude);
          } else {
            // Handle unexpected data format
            return LatLng(0.0, 0.0); // Default coordinate or some meaningful value
          }
        }).toList();
      }
    } else {
      // Handle the case where no route is found.
      setState(() {
        _distance = 0.0;
        _routeCoordinates = [];
      });
    }
  }

  Future<LocationPermission> requestLocationPermission() async {
    final LocationPermission permission = await Geolocator.requestPermission();
    return permission;
  }

  // Function to get the user's current location
  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print("Error getting user location: $e");
    }
  }
}
