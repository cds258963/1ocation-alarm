import 'package:flutter/material.dart';

class MapProvider extends ChangeNotifier {
  double _latitude = 39.9042; // 北京默认值
  double _longitude = 116.4074;
  String? _address;
  bool _isLocating = false;

  double get latitude => _latitude;
  double get longitude => _longitude;
  String? get address => _address;
  bool get isLocating => _isLocating;

  void updateLocation(double latitude, double longitude, {String? address}) {
    _latitude = latitude;
    _longitude = longitude;
    _address = address;
    notifyListeners();
  }

  void setAddress(String address) {
    _address = address;
    notifyListeners();
  }

  void setLocating(bool value) {
    _isLocating = value;
    notifyListeners();
  }
}
