import 'package:emergency_ambulance/Assistants/requestAssistant.dart';
import 'package:emergency_ambulance/Models/address.dart';
import 'package:emergency_ambulance/Models/allUsers.dart';
import 'package:emergency_ambulance/Models/directionDetails.dart';
import 'package:emergency_ambulance/configMap.dart';
import 'package:emergency_ambulance/dataHandler/appData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class AssistantMethods {
  static Future<String> searchCoordinateAddress(
      Position currentPosition, context) async {
    String placeAdress = "";
    String st1, st2, st3, st4;
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${currentPosition.latitude},${currentPosition.longitude}&key=AIzaSyDoWSObQL_A27DQ_LjbXJmwNtmw1AWtuec";

    var response = await RequestAssistant.getRequest(url);

    if (response != "failed") {
      //palceAdress = response["results"][0]["formatted_address"];
      st1 = response["results"][0]["address_components"][4]["long_name"];
      st2 = response["results"][0]["address_components"][7]["long_name"];
      st3 = response["results"][0]["address_components"][6]["long_name"];
      st4 = response["results"][0]["address_components"][9]["long_name"];

      placeAdress = st1 + "," + st2 + "," + st3 + "," + st4;

      Address userPickUpAdress = Address();
      userPickUpAdress.longitude = currentPosition.longitude;
      userPickUpAdress.latitude = currentPosition.latitude;
      userPickUpAdress.placeName = placeAdress;

      Provider.of<AppData>(context, listen: false)
          .updatePickUpLocationAddress(userPickUpAdress);
    }

    return placeAdress;
  }

  static Future<String> placeName(
      Position currentPosition, BuildContext context) async {
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${currentPosition.latitude},${currentPosition.longitude}&key=AIzaSyDoWSObQL_A27DQ_LjbXJmwNtmw1AWtuec";

    var response = await RequestAssistant.getRequest(url);
    // String place = response["plus_code"]["compound_code"];
    String place = response["results"][0]["address_components"][0]["long_name"];
    print(place);

    return place;
  }

  static Future<DirectionDetails> obtainPlaceDirectionDetails(
      LatLng initialPosition, LatLng finalLocation) async {
    String directionUrl =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalLocation.latitude},${finalLocation.longitude}&key=AIzaSyDoWSObQL_A27DQ_LjbXJmwNtmw1AWtuec";

    var res = await RequestAssistant.getRequest(directionUrl);

    if (res == "failed") {
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();

    directionDetails.encodedPoints =
        res["routes"][0]["overview_polyline"]["points"];

    directionDetails.distanceText =
        res["routes"][0]["legs"][0]["distance"]["text"];

    directionDetails.distanceValue =
        res["routes"][0]["legs"][0]["distance"]["value"];

    directionDetails.durationText =
        res["routes"][0]["legs"][0]["duration"]["text"];

    directionDetails.durationValue =
        res["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetails;
  }

  static int calculateFares(DirectionDetails directionDetails) {
    double timeTravelFare = (directionDetails.durationValue / 60) * 0.20;
    double distanceTravelFare = (directionDetails.distanceValue / 1000) * 0.20;
    double totalFareAmount = timeTravelFare + distanceTravelFare;

    // 1$ to GHS
    double totalLocalAmount = totalFareAmount * 6.00;

    return totalLocalAmount.truncate();
  }

  static void getCurrentOnlineUserInfo() async {
    firebaseUser = await FirebaseAuth.instance.currentUser;
    String useId = firebaseUser.uid;
    DatabaseReference reference =
        FirebaseDatabase.instance.reference().child("users").child(useId);

    reference.once().then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        userCurrentInfo = Users.fromSnapshot(dataSnapshot);
      }
    });
  }
}
