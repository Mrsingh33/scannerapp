
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:get_mac/get_mac.dart';
import 'Scanpage.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scan Qr Code',
      theme: ThemeData(

        primarySwatch: Colors.blue,


      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {



 String qrResult;
  String macAdress = " " ;
  Future<void> initPlatformState() async {

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      macAdress = await GetMac.macAddress;
    } on PlatformException {
      macAdress = 'Failed to get Device MAC Address.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      macAdress = macAdress;
      print("mac address is" +macAdress);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Scan QR Code"
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            RaisedButton(
              child: Text(
                "Scan Your QR code",
              ),
              onPressed: () async {
                ScanResult scanning = await BarcodeScanner.scan();


                initPlatformState();


             setState(() {
               qrResult = scanning.rawContent;
               print(qrResult);

             });

                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scanpage(qrResult : qrResult,macAdress: macAdress),
                    ));
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)
              ),
            )
          ],
        ),
      ),
    );
  }
}
