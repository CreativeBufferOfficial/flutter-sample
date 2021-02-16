import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Creativebuffer/utils/modal/Fee.dart';
import 'package:Creativebuffer/utils/widget/AppBarWidget.dart';
import 'package:Creativebuffer/utils/widget/ScaleRoute.dart';
import 'package:Creativebuffer/paymentGateway/paytm/PaytmHomeScreen.dart';
import 'package:Creativebuffer/utils/widget/fees_payment_row_widget.dart';
import 'GooglePayScreen.dart';
import 'RazorPay/RazorPayHome.dart';
import 'package:Creativebuffer/paymentGateway/paypal/PaypalHomeScreen.dart';

class PaymentHome extends StatefulWidget {
  final Fee fee;
  final String id;
  PaymentHome(this.fee, this.id);

  @override
  _PaymentHomeState createState() => _PaymentHomeState();
}

class _PaymentHomeState extends State<PaymentHome> {
  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.indigo, //or set color with: Color(0xFF0000FF)
    ));

    return Padding(
      padding: EdgeInsets.only(top: statusBarHeight),
      child: Scaffold(
        appBar: AppBarWidget.header(context, 'Payment'),
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context, ScaleRoute(page: AddAmount(widget.fee)));
              },
              child: Card(
                elevation: 4.0,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 25.0,
                    backgroundColor: Colors.black12,
                    child: Image.asset('assets/images/paytm.png'),
                  ),
                  title: Text(
                    'Paytm',
                    style: Theme.of(context)
                        .textTheme
                        .headline
                        .copyWith(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    ScaleRoute(page: AddPaypalAmount(widget.fee, widget.id)));
              },
              child: Card(
                elevation: 4.0,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 25.0,
                    backgroundColor: Colors.black12,
                    child: Image.asset('assets/images/paypal.png'),
                  ),
                  title: Text(
                    'Paypal',
                    style: Theme.of(context)
                        .textTheme
                        .headline
                        .copyWith(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    ScaleRoute(page: GooglePayScreen(widget.fee, widget.id)));
              },
              child: Card(
                elevation: 4.0,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 25.0,
                    backgroundColor: Colors.orangeAccent,
                    child: Image.asset('assets/images/googleplay.png'),
                  ),
                  title: Text(
                    'GPay',
                    style: Theme.of(context).textTheme.headline.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Colors.redAccent),
                  ),
                ),
              ),
            ),
//            GestureDetector(
//              onTap: () {
//                Navigator.push(
//                    context, ScaleRoute(page: GooglePayScreen(widget.fee)));
//              },
//              child: Card(
//                elevation: 4.0,
//                child: ListTile(
//                  leading: CircleAvatar(
//                    radius: 25.0,
//                    backgroundColor: Colors.greenAccent,
//                    child: Image.asset('assets/images/payumoney.png'),
//                  ),
//                  title: Text(
//                    'PayUMoney',
//                    style: Theme.of(context).textTheme.headline.copyWith(
//                        fontWeight: FontWeight.w700,
//                        fontSize: 18,
//                        color: Colors.green),
//                  ),
//                ),
//              ),
//            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    ScaleRoute(page: RazorPayment(widget.fee, widget.id)));
              },
              child: Card(
                elevation: 4.0,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 25.0,
                    backgroundColor: Colors.blueAccent,
                    child: Image.asset('assets/images/razorpay.jpeg'),
                  ),
                  title: Text(
                    'Razorpay',
                    style: Theme.of(context).textTheme.headline.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Colors.blue),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class AddAmount extends StatelessWidget {
  final Fee fee;
  String amount;
  TextEditingController amountController = TextEditingController();

  AddAmount(this.fee) {
    amount = '${absoluteAmount(fee.balance)}';
    amountController.text = amount;
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.indigo, //or set color with: Color(0xFF0000FF)
    ));

    return Padding(
      padding: EdgeInsets.only(top: statusBarHeight),
      child: Scaffold(
        appBar: AppBarWidget.header(context, 'Amount'),
        backgroundColor: Colors.white,
        body: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: FeePaymentRow(fee),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  style: Theme.of(context).textTheme.title,
                  controller: amountController,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'please enter a valid amount';
                    }
                    return value;
                  },
                  decoration: InputDecoration(
                      hintText: "amount",
                      labelText: "amount",
                      labelStyle: Theme.of(context).textTheme.display1,
                      errorStyle:
                          TextStyle(color: Colors.pinkAccent, fontSize: 15.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        ScaleRoute(
                            page: PaytmPayment(fee,
                                '${absoluteAmount(amountController.text)}')));
                  },
                  color: Colors.purpleAccent,
                  textColor: Colors.white,
                  child: Text(
                    "Enter amount",
                    style: Theme.of(context)
                        .textTheme
                        .display1
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int absoluteAmount(String am) {
    int amount = int.parse(am);
    if (amount < 0) {
      return -amount;
    } else {
      return amount;
    }
  }
}
