import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:triplan/src/models/transaction.dart';

import '../models/user.dart';

class TransactionFormUserItem extends StatefulWidget {
  const TransactionFormUserItem(
      {required this.user, required this.onChanged, super.key});

  final User user;
  final void Function(Map<User, TransactionTarget?>?) onChanged;

  @override
  State<TransactionFormUserItem> createState() =>
      _TransactionFormUserItemState();
}

class _TransactionFormUserItemState extends State<TransactionFormUserItem> {
  // no default value because they don't get passed to parent widget
  // TODO : handle default value for custom form widget
  final _weight = TextEditingController();

  void updateTrigger() {
    TransactionTarget target = TransactionTarget(
      userId: widget.user.id,
      weight: int.parse(_weight.text),
    );
    var map = <User, TransactionTarget>{};
    map[widget.user] = target;
    widget.onChanged(map);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.person),
      title: Text(widget.user.name),
      trailing: SizedBox(
          width: 50,
          child: TextFormField(
            onChanged: (value) => {updateTrigger()},
            controller: _weight,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
          )),
    );
  }
}
