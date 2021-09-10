import 'package:emergency_ambulance/Models/address.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

class AppData extends ChangeNotifier {
  Address pickUpLocation, dropOffLocation;

  void updatePickUpLocationAddress(Address pickUpAdress) {
    //
    pickUpLocation = pickUpAdress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Address dropAddress) {
    //
    dropOffLocation = dropAddress;
    notifyListeners();
  }
}
