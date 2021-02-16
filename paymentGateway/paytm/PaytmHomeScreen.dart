import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:Creativebuffer/utils/apis/Apis.dart';
import 'package:Creativebuffer/utils/modal/Fee.dart';
import 'PaymentStatusScreen.dart';
import 'settings.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PaytmPayment extends StatefulWidget {
  final Fee fee;
  final String amount;

  PaytmPayment(this.fee, this.amount);

  _PaytmPaymentState createState() => _PaytmPaymentState(amount);
}

class _PaytmPaymentState extends State<PaytmPayment> {
  String amount;
  bool isGet = false;

  _PaytmPaymentState(this.amount);

  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  static Random seed = Random();
  static int val = seed.nextInt(100000);
  final orderId = 'TEST_$val';
  final customerId = '$val';
  final email = 'abc1@abc.com';

  StreamSubscription _onDestroy;
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  var isCompleted = false;

  @override
  void dispose() {
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    flutterWebviewPlugin.close();

    _onDestroy = flutterWebviewPlugin.onDestroy.listen((_) {
      print("destroy");
    });

    _onStateChanged =
        flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      print("onStateChanged: ${state.type} ${state.url}");
    });

    // Add a listener to on url changed
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {

        print("URL changed: $url");

        if (url.endsWith('request1.jsp')) {
          setState(() {
            isGet = true;
          });
        }

        if (url.endsWith('callback') && isGet) {
          isPaymentSuccesful().then((value) {
            if (value) {
              setState(() {
                isCompleted = true;
                isGet = false;
                flutterWebviewPlugin.close();
              });
            }
          });

          flutterWebviewPlugin.getCookies().then((cookies) {
            print("cookies $cookies");
            print('TXNID $cookies["TXNID"]');
            print('STATUS $cookies["STATUS"]');
            print('RESPCODE $cookies["RESPCODE"]');
            print('RESPMSG $cookies["RESPMSG"]');
            print('TXNDATE $cookies["TXNDATE"]');

//               add logic to make show payment status
            flutterWebviewPlugin.close();
          });
        } else {
          setState(() {
            isCompleted = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final queryParams =
        '?order_id=$orderId&customer_id=$customerId&amount=$amount&email=$email';

    //print(Settings.apiUrl);

    return isCompleted
        ? PaymentStatusScreen(widget.fee,amount)
        : WebviewScaffold(
            url: Settings.apiUrl + queryParams,
            appBar: new AppBar(
              title: new Text("Pay using PayTM"),
            ));
  }

  Future<bool> isPaymentSuccesful() async {
    print('${widget.fee.id}');
    final response = await http
        .get(InfixApi.studentFeePayment('9', widget.fee.id, amount, '9', 'C'));
    var jsonData = json.decode(response.body);
    return jsonData['success'];
  }
}
