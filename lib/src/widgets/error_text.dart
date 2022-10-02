import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class ErrorText extends StatefulWidget {
  final String? errorMessage;
  final String? toastMessage;
  final String defaultError = "error";
  const ErrorText(
      {required this.errorMessage, required this.toastMessage, super.key});

  @override
  State<ErrorText> createState() => _ErrorTextState();
}

class _ErrorTextState extends State<ErrorText> {
  @override
  void initState() {
    super.initState();
    if (widget.toastMessage != null && widget.toastMessage != "") {
      WidgetsBinding.instance.addPostFrameCallback((_) => GFToast.showToast(
            widget.toastMessage!,
            context,
            toastPosition: GFToastPosition.CENTER,
            textStyle: const TextStyle(fontSize: 16, color: GFColors.DARK),
            backgroundColor: GFColors.LIGHT,
            trailing: const Icon(
              Icons.error,
              color: GFColors.DANGER,
            ),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
          child: Text(
        "API error : ${widget.errorMessage ?? widget.defaultError}",
        style: const TextStyle(
          color: Colors.red,
        ),
      )),
    );
  }
}
