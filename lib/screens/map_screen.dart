import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/place.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation initLocation;
  final bool isSelecting;
  MapScreen(
      {this.initLocation =
          const PlaceLocation(latitude: 23.423, longitude: 14.33),
      this.isSelecting = false});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _pickedLocation;

  void _selectLocat(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
        actions: <Widget>[
          if (widget.isSelecting)
            IconButton(
                icon: Icon(Icons.check),
                onPressed: _pickedLocation == null
                    ? null
                    : () {
                        Navigator.of(context).pop(_pickedLocation);
                      }),
        ],
      ),
      body: GoogleMap(
        markers: (_pickedLocation == null && widget.isSelecting)
            ? null
            : {
                Marker(
                    markerId: MarkerId('m1'),
                    position: _pickedLocation ??
                        LatLng(widget.initLocation.latitude,
                            widget.initLocation.longitude)),
              },
        onTap: widget.isSelecting ? _selectLocat : null,
        initialCameraPosition: CameraPosition(
            zoom: 16,
            target: LatLng(
                widget.initLocation.latitude, widget.initLocation.longitude)),
      ),
    );
  }
}
