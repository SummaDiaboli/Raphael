import 'package:flutter/material.dart';
//import 'dart:io';
// import 'package:mapbox_gl/mapbox_gl.dart';
/* import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart'; */

class PollsPage extends StatefulWidget {
  @override
  _PollsPageState createState() => _PollsPageState();
}

class _PollsPageState extends State<PollsPage> {
  // PermissionStatus _permissionStatus = PermissionStatus.unknown;

  /* @override
  void initState() {
    super.initState();

    _listenForPermissionStatus();
    requestPermission(PermissionGroup.location);
  }

  void _listenForPermissionStatus() {
    final Future<PermissionStatus> statusFuture =
        PermissionHandler().checkPermissionStatus(PermissionGroup.location);

    statusFuture.then((PermissionStatus status) {
      setState(() {
        _permissionStatus = status;
      });
    });
  }

  Future<void> requestPermission(PermissionGroup permission) async {
    final List<PermissionGroup> permissions = <PermissionGroup>[permission];
    final Map<PermissionGroup, PermissionStatus> permissionRequestResult =
        await PermissionHandler().requestPermissions(permissions);

    setState(() {
      print(permissionRequestResult);
      _permissionStatus = permissionRequestResult[permission];
      print(_permissionStatus);
    });
  } */

  @override
  Widget build(BuildContext context) {
    return Container();
    /* Column(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(37.4219999, -122.0862462),
            ),
            onMapCreated: (GoogleMapController controller) {},
          ),
        )
      ],
    ); */
  }
}
