import 'package:flutter/material.dart';

class PaymentBottomDialog extends StatelessWidget {
  const PaymentBottomDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Chọn phương thức thanh toán",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.credit_card, color: Colors.white),
            title: Text("Thanh toán qua thẻ", style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              // Xử lý thanh toán qua thẻ
            },
          ),
          ListTile(
            leading: Icon(Icons.account_balance_wallet, color: Colors.white),
            title: Text("Thanh toán bằng Momo", style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              // Xử lý thanh toán qua Momo
            },
          ),
        ],
      ),
    );
  }
}
