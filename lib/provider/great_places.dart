import 'dart:io';
import 'package:flutter/material.dart';
import '../models/place.dart';
import '../helpers/db_helper.dart';
import '../helpers/location_helper.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Place findById(String id) {
    return _items.firstWhere((place) => place.id == id);
  }

  Future<void> addPlace(String title, File image, PlaceLocation loc) async {
    final address =
        await LocationHelper.getPlaceAddress(loc.latitude, loc.longitude);
    final updatedLoc = PlaceLocation(
        latitude: loc.latitude, longitude: loc.longitude, address: address);

    final newPlace = Place(
        id: DateTime.now().toString(),
        title: title,
        location: updatedLoc,
        image: image);
    _items.add(newPlace);
    notifyListeners();
    DBHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'loc_lat': newPlace.location.latitude,
      'loc_lng': newPlace.location.longitude,
      'address': newPlace.location.address,
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('user_places');
    _items = dataList
        .map(
          (item) => Place(
              id: item['id'],
              title: item['title'],
              location: PlaceLocation(
                  latitude: item['loc_lat'],
                  longitude: item['loc_lng'],
                  address: item['address']),
              image: File(item['image'])),
        )
        .toList();
    notifyListeners();
  }
}
