import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? paymentIntent;

  CreatePaymentIntent() async {
    try {
      Map<String, dynamic> body = {'amount': '100', 'currency': 'INR'};
      http.Response response = await http.post(
        Uri.parse("https://api.stripe.com/v1/payment_intents"),
        headers: {
          'Authorization':
              'Bearer sk_test_51NmWjYSCOk5cIgx4d8uwgXsMifGIEET0xDoX0PDWjmdrV1mpyqHerQj7TPo3XIltCEZyNVgO1C3ZrX8ltOmCkZoQ001OyDBsnB',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void MakePayment() async {
    try {
      paymentIntent = await CreatePaymentIntent();
      var gpay = const PaymentSheetGooglePay(
        merchantCountryCode: "IND",
        currencyCode: "INR",
        testEnv: true,
      );
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent!["client_secret"],
              style: ThemeMode.light,
              merchantDisplayName: "Vikas",
              googlePay: gpay));
      DisplayPaymentSheet();
    } catch (e) {}
  }

  void DisplayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      print("done");
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Payment Page",
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              elevation: 5,
              focusElevation: 15,
              color: Colors.purple,
              padding: const EdgeInsets.only(
                  left: 25, right: 25, top: 10, bottom: 10),
              onPressed: () {
                MakePayment();
              },
              child: const Text(
                "Pay with Stripe",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            MaterialButton(
              elevation: 5,
              focusElevation: 15,
              color: Colors.blue,
              padding: const EdgeInsets.only(
                  left: 25, right: 25, top: 10, bottom: 10),
              onPressed: () {},
              child: const Text(
                "Pay with RazerPay",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
