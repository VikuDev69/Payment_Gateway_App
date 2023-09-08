import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripeServices {
  Map<String, dynamic>? paymentIntent;

  void MakePayment() async {
    try {
      paymentIntent = await CreatePaymentIntent();
      var gpay = const PaymentSheetGooglePay(
        merchantCountryCode: "US",
        currencyCode: "USD",
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

  CreatePaymentIntent() async {
    try {
      Map<String, dynamic> body = {'amount': '100', 'currency': 'USD'};
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
}
