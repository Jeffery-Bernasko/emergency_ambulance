// import 'dart:js';

import 'package:emergency_ambulance/Assistants/assistantMethod.dart';
import 'package:emergency_ambulance/Assistants/requestAssistant.dart';
import 'package:emergency_ambulance/Models/address.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class AppData extends ChangeNotifier {
  Address pickUpLocation, dropOffLocation;

  void updatePickUpLocationAddress(Address pickUpAdress) {
    //
    pickUpLocation = pickUpAdress;
    notifyListeners();
  }

  Future<Position> location(BuildContext context) async {
    Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    Address addr = Address();
    addr.longitude = pos.longitude;
    addr.latitude = pos.latitude;
    updatePickUpLocationAddress(addr);
    print("${pos.longitude},${pos.latitude}");
    return pos;
  }

  void updateDropOffLocationAddress(Address dropAddress) {
    //
    dropOffLocation = dropAddress;
    notifyListeners();
  }
}
