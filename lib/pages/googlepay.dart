import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:smsapp/paymentconfigurationfiles/payconfig.dart';

class waterpayment extends StatelessWidget {
  const waterpayment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('waterpayment'),
      ),
      drawer: Drawer(),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          GooglePayButton(
            paymentConfiguration: defaultGooglePayConfig,
            paymentItems: [PaymentItem(amount: '1000', label: 'water')],
            type: GooglePayButtonType.buy,
            margin: const EdgeInsets.only(top: 15.0),
            // onPaymentResult: onGooglePayResult,
            onPaymentResult: (data) {
              print(data);
            },
            loadingIndicator: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
