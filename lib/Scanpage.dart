import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:get_mac/get_mac.dart';



 class Scanpage extends StatefulWidget {
   String qrResult;
   String macAdress;
   Scanpage({this.qrResult,this.macAdress});


   @override
   _ScanpageState createState() => _ScanpageState(qrResult,macAdress);
 }
 
 class _ScanpageState extends State<Scanpage> {
  String qrResult;
  String macAdress;
   _ScanpageState(this.qrResult,this.macAdress);

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
     return WebviewScaffold(
       appBar: (
       AppBar(
         actions: <Widget>[
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
       )
       ),

                      url: "http://website/index.php?text="+qrResult+"&macid="+macAdress,

                      appCacheEnabled: true,
                      withZoom: true,
                      withLocalStorage: true,
                      hidden: true,

                      initialChild: Container(

                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),

                    );


   }
 }
 
