import 'dart:io';
import 'dart:async';


import '../../services/device_service.dart';
import '../../models/location_model.dart';


import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../core/utils/responsive.dart';
import '../../models/device_model.dart';
import '../../services/routing_service.dart';
import 'package:url_launcher/url_launcher.dart';

const Color _blue = Color(0xFF2563EB);
const Color _lightBlue = Color(0xFFEAF2FF);
const Color _textDark = Color(0xFF17233B);
const Color _textGrey = Color(0xFF667085);

class LocateScreen extends StatefulWidget {
  final DeviceModel device;

  const LocateScreen({
    super.key,
    required this.device,
  });

  @override
  State<LocateScreen> createState() => _LocateScreenState();
}

class _LocateScreenState extends State<LocateScreen> {
  Timer? _trackingTimer;
  bool isSimulatingUser = false;
  LatLng? simulatedUserLocation;
  int _simulationIndex = 0;


  StreamSubscription? _locationSubscription;


  LocationModel? liveObjectLocation;


  bool bleAvailable = true;


  late double rssi;
  late String proximityStatus;


  String gpsStatus = "Location unavailable";


  Position? currentPosition;
  bool isGettingLocation = false;


  final MapController _mapController = MapController();


  bool isTracking = false;
  List<LatLng> routePoints = [];


  double? routeDistanceKm;
  int? routeDurationMinutes;


  final RoutingService _routingService =
      RoutingService();


  LatLng? get objectLocation {
    final location =
        liveObjectLocation ?? widget.device.location;


    if (location == null) {
      return null;
    }


    return LatLng(
      location.latitude,
      location.longitude,
    );
  }

  @override
  void initState() {
    super.initState();

    rssi = widget.device.rssi.toDouble();
    proximityStatus = _getProximityStatus(rssi);


    _listenToObjectLocation();
  }


  void _listenToObjectLocation() {
    final deviceService = DeviceService();


    _locationSubscription = deviceService
        .watchDevices()
        .listen((devices) async {
      try {
        final updatedDevice = devices.firstWhere(
          (device) => device.id == widget.device.id,
        );


        if (!mounted) return;


        setState(() {
          liveObjectLocation = updatedDevice.location;
        });


        if (isTracking && currentPosition != null) {
          await _updateLiveRoute();
        }
      } catch (_) {
        // Device not found in current snapshot.
      }
    });
  }

  Future<void> _updateLiveRoute() async {
    final object = objectLocation;


    if (object == null || currentPosition == null) {
      return;
    }


    try {
      final result = await _routingService.getRoute(
        start: LatLng(
          currentPosition!.latitude,
          currentPosition!.longitude,
        ),
        destination: object,
      );


      if (!mounted) return;


      setState(() {
        routePoints = result.points;
        routeDistanceKm = result.distanceKm;
        routeDurationMinutes = result.durationMinutes;
      });
    } catch (e) {
      debugPrint(
        'LIVE ROUTE ERROR: $e',
      );
    }
  }

  String _getProximityStatus(double rssi) {
    if (rssi >= -55) {
      return "Very Close";
    } else if (rssi >= -70) {
      return "Close";
    } else if (rssi >= -85) {
      return "Far";
    } else {
      return "Out of Range";
    }
  }

  Future<void> _getCurrentLocation() async {
    debugPrint('LOCATION: function started');


    if (!mounted) return;


    setState(() {
      isGettingLocation = true;
      gpsStatus = "Getting your location...";
    });


    try {
      debugPrint('LOCATION: checking location service');


      final serviceEnabled =
          await Geolocator.isLocationServiceEnabled();


      debugPrint('LOCATION: service enabled = $serviceEnabled');


      if (!serviceEnabled) {
        if (!mounted) return;


        setState(() {
          gpsStatus = "Location services are disabled";
          isGettingLocation = false;
        });


        return;
      }


      debugPrint('LOCATION: checking permission');


      LocationPermission permission =
          await Geolocator.checkPermission();


      debugPrint('LOCATION: permission = $permission');


      if (permission == LocationPermission.denied) {
        debugPrint('LOCATION: requesting permission');


        permission = await Geolocator.requestPermission();


        debugPrint(
          'LOCATION: permission after request = $permission',
        );
      }


      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (!mounted) return;


        setState(() {
          gpsStatus = "Location permission denied";
          isGettingLocation = false;
        });


        return;
      }


      debugPrint('LOCATION: requesting GPS position');


      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      ).timeout(
        const Duration(seconds: 10),
      );


      debugPrint(
        'LOCATION: position received = '
        '${position.latitude}, ${position.longitude}',
      );


      if (!mounted) return;


      setState(() {
        currentPosition = position;
        gpsStatus =
            "${position.latitude.toStringAsFixed(5)}, "
            "${position.longitude.toStringAsFixed(5)}";
        isGettingLocation = false;
      });


      final userLocation = LatLng(
        position.latitude,
        position.longitude,
      );


      final object = objectLocation;


      if (object == null) {
        return;
      }


      final bounds = LatLngBounds(
        userLocation,
        object,
      );


      _mapController.fitCamera(
        CameraFit.bounds(
          bounds: bounds,
          padding: const EdgeInsets.all(60),
        ),
      );
    } catch (e) {
      debugPrint('LOCATION ERROR: $e');


      if (!mounted) return;


      setState(() {
        gpsStatus = "Location error: $e";
        isGettingLocation = false;
      });
    }
  }

  Future<void> _trackObject() async {
    if (currentPosition == null) {
      await _getCurrentLocation();
    }


    if (currentPosition == null) {
      return;
    }


    setState(() {
      isTracking = true;
    });


    try {
      final userLocation = LatLng(
        currentPosition!.latitude,
        currentPosition!.longitude,
      );


      final object = objectLocation;


      if (object == null) {
        if (!mounted) return;


        setState(() {
          isTracking = false;
        });


        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Object location is not available.',
            ),
          ),
        );


        return;
      }


      final result = await _routingService.getRoute(
        start: userLocation,
        destination: object,
      );


      if (!mounted) return;


      setState(() {
        routePoints = result.points;
        routeDistanceKm = result.distanceKm;
        routeDurationMinutes =
            result.durationMinutes;
        isTracking = false;
      });


      if (routePoints.isNotEmpty) {
        _mapController.fitCamera(
          CameraFit.bounds(
            bounds: LatLngBounds.fromPoints(
              routePoints,
            ),
            padding: const EdgeInsets.all(50),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;


      setState(() {
        isTracking = false;
      });


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not calculate route: $e',
          ),
        ),
      );
    }
  }

  Future<void> _openDirections() async {
    if (currentPosition == null) {
      await _getCurrentLocation();
    }


    final destination = objectLocation;


    if (destination == null) {
      if (!mounted) return;


      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Object location is not available.',
          ),
        ),
      );


      return;
    }


    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&destination=${destination.latitude},'
      '${destination.longitude}'
      '&travelmode=driving',
    );


    final launched = await launchUrl(uri);


    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not open navigation.',
          ),
        ),
      );
    }
  }

  Future<void> _simulateUserMoving() async {
    final object = objectLocation;


    if (object == null) return;


    final start = currentPosition != null
        ? LatLng(
            currentPosition!.latitude,
            currentPosition!.longitude,
          )
        : const LatLng(19.1000, 72.9000);


    final result = await _routingService.getRoute(
      start: start,
      destination: object,
    );


    if (result.points.isEmpty) return;


    _simulationIndex = 0;


    setState(() {
      isSimulatingUser = true;
      simulatedUserLocation = result.points.first;
      routePoints = result.points;
      routeDistanceKm = result.distanceKm;
      routeDurationMinutes = result.durationMinutes;
    });


    _trackingTimer?.cancel();


    _trackingTimer = Timer.periodic(
      const Duration(seconds: 3),
      (timer) async {
        if (_simulationIndex >= result.points.length - 1) {
          timer.cancel();


          if (!mounted) return;


          setState(() {
            isSimulatingUser = false;
            simulatedUserLocation = object;
            routePoints = [object];
            routeDistanceKm = 0;
            routeDurationMinutes = 0;
          });


          return;
        }


        _simulationIndex += 1;


        final newPosition =
            result.points[_simulationIndex];


        final remainingPoints =
            result.points.sublist(_simulationIndex);


        if (!mounted) return;


        setState(() {
          simulatedUserLocation = newPosition;
          routePoints = remainingPoints;
        });
      },
    );
  }

  String get locationMode {
    return bleAvailable ? "BLE Proximity" : "GPS / GSM";
  }

  @override
  Widget build(BuildContext context) {
    final deviceName = widget.device.name;
    final imagePath = widget.device.imagePath;
    final connected = widget.device.connected;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFEAF3FF),
              Color(0xFFF7FAFF),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.w(context, 0.055),
              vertical: Responsive.h(context, 0.02),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: _textDark,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),

                    SizedBox(
                      width: Responsive.w(context, 0.04),
                    ),

                    Expanded(
                      child: Text(
                        "Locate Device",
                        style: TextStyle(
                          fontSize: Responsive.font(context, 5.8),
                          fontWeight: FontWeight.w700,
                          color: _textDark,
                        ),
                      ),
                    ),

                    const Icon(
                      Icons.more_vert_rounded,
                      color: _textDark,
                    ),
                  ],
                ),

                SizedBox(
                  height: Responsive.h(context, 0.02),
                ),

                // MAP
                _buildMapPreview(context),

                SizedBox(
                  height: Responsive.h(context, 0.018),
                ),

                // RSSI / PROXIMITY
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(
                    Responsive.w(context, 0.04),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFE6ECF5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: Responsive.w(context, 0.11),
                                height: Responsive.w(context, 0.11),
                                decoration: BoxDecoration(
                                  color: _lightBlue,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Icons.bluetooth_rounded,
                                  color: _blue,
                                ),
                              ),

                              SizedBox(
                                width: Responsive.w(context, 0.03),
                              ),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "BLE Signal",
                                    style: TextStyle(
                                      color: _textGrey,
                                      fontSize: Responsive.font(context, 3.1),
                                    ),
                                  ),

                                  SizedBox(
                                    height: Responsive.h(context, 0.003),
                                  ),

                                  Text(
                                    proximityStatus,
                                    style: TextStyle(
                                      color: _textDark,
                                      fontSize: Responsive.font(context, 4.1),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          Text(
                            "${rssi.toInt()} dBm",
                            style: TextStyle(
                              color: _blue,
                              fontSize: Responsive.font(context, 4.0),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: Responsive.h(context, 0.018),
                      ),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: ((rssi + 100) / 70).clamp(0.0, 1.0),
                          minHeight: 7,
                          backgroundColor: const Color(0xFFE8EDF5),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            _blue,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: Responsive.h(context, 0.012),
                      ),

                      Text(
                        bleAvailable
                            ? "Bluetooth proximity is active"
                            : "BLE unavailable • Using GPS / GSM",
                        style: TextStyle(
                          color: _textGrey,
                          fontSize: Responsive.font(context, 3.0),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: Responsive.h(context, 0.025),
                ),

                // REFRESH BUTTON
                SizedBox(
                  width: double.infinity,
                  height: Responsive.h(context, 0.065),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      setState(() {
                        rssi = widget.device.rssi.toDouble();
                        proximityStatus =
                            _getProximityStatus(rssi);
                      });

                      await _getCurrentLocation();
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text(
                      "Refresh Location",
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _blue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: Responsive.h(context, 0.015),
                ),


                SizedBox(
                  width: double.infinity,
                  height: Responsive.h(context, 0.065),
                  child: OutlinedButton.icon(
                    onPressed: isTracking
                        ? null
                        : _trackObject,
                    icon: isTracking
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.navigation_rounded),


                    label: Text(
                      isTracking
                          ? "Finding Route..."
                          : "Track Object",
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _blue,
                      side: BorderSide(
                        color: _blue,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: Responsive.h(context, 0.015),
                ),


                SizedBox(
                  width: double.infinity,
                  height: Responsive.h(context, 0.06),
                  child: OutlinedButton.icon(
                    onPressed: isSimulatingUser
                        ? null
                        : _simulateUserMoving,
                    icon: Icon(
                      isSimulatingUser
                          ? Icons.directions_car_rounded
                          : Icons.play_arrow_rounded,
                    ),
                    label: Text(
                      isSimulatingUser
                          ? "You are moving..."
                          : "Simulate You Moving",
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _blue,
                      side: BorderSide(
                        color: _blue,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),

                if (routeDistanceKm != null &&
                    routeDurationMinutes != null) ...[
                  SizedBox(
                    height: Responsive.h(context, 0.018),
                  ),


                  Row(
                    children: [
                      Expanded(
                        child: _buildRouteInfo(
                          context,
                          Icons.route_rounded,
                          "Distance",
                          "${routeDistanceKm!.toStringAsFixed(1)} km",
                        ),
                      ),


                      SizedBox(
                        width: Responsive.w(context, 0.03),
                      ),


                      Expanded(
                        child: _buildRouteInfo(
                          context,
                          Icons.access_time_rounded,
                          "ETA",
                          "${routeDurationMinutes!} min",
                        ),
                      ),
                    ],
                  ),
                ],

                if (routeDistanceKm != null) ...[
                  SizedBox(
                    height: Responsive.h(context, 0.015),
                  ),


                  SizedBox(
                    width: double.infinity,
                    height: Responsive.h(context, 0.065),
                    child: ElevatedButton.icon(
                      onPressed: _openDirections,
                      icon: const Icon(
                        Icons.directions_rounded,
                      ),
                      label: const Text(
                        "Get Directions",
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _blue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statusPill(
    BuildContext context,
    bool connected,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.w(context, 0.04),
        vertical: Responsive.h(context, 0.009),
      ),
      decoration: BoxDecoration(
        color: connected
            ? const Color(0xFFE4F7EA)
            : const Color(0xFFFEECEC),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: Responsive.w(context, 0.018),
            height: Responsive.w(context, 0.018),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: connected
                  ? const Color(0xFF2DB55D)
                  : Colors.red,
            ),
          ),

          SizedBox(
            width: Responsive.w(context, 0.02),
          ),

          Text(
            connected ? "Connected" : "Disconnected",
            style: TextStyle(
              color: connected
                  ? const Color(0xFF239447)
                  : Colors.red,
              fontSize: Responsive.font(context, 3.4),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.w(context, 0.04),
        vertical: Responsive.h(context, 0.018),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE6ECF5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: Responsive.w(context, 0.105),
            height: Responsive.w(context, 0.105),
            decoration: BoxDecoration(
              color: _lightBlue,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: color,
              size: Responsive.w(context, 0.055),
            ),
          ),

          SizedBox(
            width: Responsive.w(context, 0.035),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: _textGrey,
                    fontSize: Responsive.font(context, 3.2),
                  ),
                ),
                SizedBox(
                  height: Responsive.h(context, 0.004),
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _textDark,
                    fontSize: Responsive.font(context, 4.0),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteInfo(
    BuildContext context,
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.w(context, 0.035),
        vertical: Responsive.h(context, 0.014),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F8FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE1E8F5),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: _blue,
            size: Responsive.w(context, 0.05),
          ),


          SizedBox(
            width: Responsive.w(context, 0.025),
          ),


          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: _textGrey,
                    fontSize:
                        Responsive.font(context, 2.8),
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: _textDark,
                    fontSize:
                        Responsive.font(context, 3.5),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPreview(BuildContext context) {
    final object = objectLocation;


    final userLocation =
        simulatedUserLocation ??
        (currentPosition != null
            ? LatLng(
                currentPosition!.latitude,
                currentPosition!.longitude,
              )
            : null);


    final initialCenter = currentPosition != null
        ? LatLng(
            currentPosition!.latitude,
            currentPosition!.longitude,
          )
        : (object ?? const LatLng(19.0760, 72.8777));

    return Container(
      width: double.infinity,
      height: Responsive.h(context, 0.34),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFFEAF2FF),
        border: Border.all(
          color: const Color(0xFFD5E4FF),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: initialCenter,
              initialZoom: 15,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'com.example.traceit',
              ),


              PolylineLayer(
                polylines: [
                  if (routePoints.isNotEmpty)
                    Polyline(
                      points: routePoints,
                      strokeWidth: 5,
                      color: _blue,
                    ),
                ],
              ),


              MarkerLayer(
                markers: [
                  if (object != null)
                    Marker(
                      point: object,
                    width: 55,
                    height: 55,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _blue,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _blue.withValues(alpha: 0.25),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),


                  if (userLocation != null)
                    Marker(
                      point: userLocation,
                      width: 45,
                      height: 45,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _blue,
                            width: 3,
                          ),
                        ),
                        child: const Icon(
                          Icons.person,
                          color: _blue,
                          size: 24,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),


          Positioned(
            top: 16,
            left: 16,
            child: _mapLabel(
              context,
              "Live location",
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapLabel(
    BuildContext context,
    String text,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.w(context, 0.03),
        vertical: Responsive.h(context, 0.009),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          color: _textDark,
          fontSize: Responsive.font(context, 3.2),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _trackingTimer?.cancel();
    _locationSubscription?.cancel();
    super.dispose();
  }
}
