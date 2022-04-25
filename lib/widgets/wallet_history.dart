import 'package:briefify/models/wallet_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WallletHistoryView extends StatelessWidget {
  final WalletModal walletindex;
  const WallletHistoryView({Key? key, required this.walletindex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Icon(
                  walletindex.status == 0 ?
                  CupertinoIcons.arrow_down_left : walletindex.status == 1 ?
                  CupertinoIcons.arrow_up_right : CupertinoIcons.clear,
                  color: walletindex.status == 0 ? Colors.yellow : walletindex.status == 1 ?
                  Colors.green: Colors.red,
                  size: 20,
                ),
              ),
              const SizedBox(
                width: 22,
              ),
              Container(
                child: Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            walletindex.status == 0 ? 'Pending': walletindex.status == 1 ? 'Success' : 'Rejected',
                            style: const TextStyle(fontSize: 9),
                          ),
                          const Text(
                            'Withdraw Request',
                            style: TextStyle(fontSize: 9),
                          ),
                           Text(
                            walletindex.created_at == null ? '02- Monday':
                             walletindex.created_at.toString(),
                            style: TextStyle(fontSize: 9),
                          ),
                        ],
                      ),
                      Text('\$'+walletindex.price.toString()),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        SizedBox(height: 20,)
      ],
    );
  }
}
