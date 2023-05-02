
import 'package:device_space/device_space.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  DeviceSpace? _storageSpace;

  @override
  void initState() {
    super.initState();
    initDeviceSpace();
  }

  void initDeviceSpace() async {
    final storageSpace = await getDeviceSpace(
      lowOnSpaceThreshold: 2 * 1024 * 1024 * 1024, // 2GB
      fractionDigits: 1,
    );
    
    setState(() {
      _storageSpace = storageSpace;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Device Space'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: CircularProgressIndicator(
                      strokeWidth: 20,
                      value: _storageSpace?.usageValue ?? null,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        (_storageSpace?.lowOnSpace ?? false)
                            ? Colors.red
                            : Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  if (_storageSpace == null) ...[
                    Text(
                      'Loading',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ],
                  if (_storageSpace != null) ...[
                    Column(
                      children: [
                        Text(
                          '${_storageSpace?.freeSize}',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        if (_storageSpace?.lowOnSpace != true) ...[
                          Text(
                            'Remaining',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ],
                        if (_storageSpace?.lowOnSpace == true) ...[
                          Text(
                            'Low On Space',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
