import 'package:flutter/material.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialBanner(
        content: const Text('No internet connection.'),
        contentTextStyle: const TextStyle(
          color: Colors.white, fontSize: 15,),
        backgroundColor: Colors.red,
        leading: const Icon(Icons.wifi_off, size: 15, color: Colors.white,),
        actions: [
          TextButton(onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
          },
              child: const Text('')),
        ]
    );
  }
}