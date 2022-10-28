import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:triplan/src/models/transaction.dart';

import '../models/user.dart';

class TransactionFormUserItem extends StatefulWidget {
  const TransactionFormUserItem(
      {required this.user,
      required this.onChanged,
      this.initialValue = "1",
      super.key});

  final User user;
  final void Function(TransactionTarget) onChanged;
  final String initialValue;

  @override
  State<TransactionFormUserItem> createState() =>
      _TransactionFormUserItemState();
}

class _TransactionFormUserItemState extends State<TransactionFormUserItem> {
  final _weight = TextEditingController();

  void updateTrigger(String value) {
    TransactionTarget target = TransactionTarget(
      userId: widget.user.id,
      weight: int.tryParse(value) ?? 0,
    );
    widget.onChanged(target);
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // set initial value to
      updateTrigger(widget.initialValue);
      _weight.value = TextEditingValue(text: widget.initialValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.person),
      title: Text(widget.user.name),
      trailing: SizedBox(
          width: 50,
          child: TextFormField(
            onChanged: updateTrigger,
            controller: _weight,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              FilteringTextInputFormatter.singleLineFormatter
            ],
          )),
    );
  }
}
