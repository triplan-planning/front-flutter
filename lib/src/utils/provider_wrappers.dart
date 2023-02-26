import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension AsyncValueToWidget<T> on AsyncValue<T> {
  Widget toWidget(Widget Function(T) widgetBuilder) {
    return when(
      data: widgetBuilder,
      error: _defaultError,
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  Widget toWidgetWithLoading(Widget Function(T) widgetBuilder,
      {required Widget loadingWidget}) {
    return when(
      data: widgetBuilder,
      error: _defaultError,
      loading: () => loadingWidget,
    );
  }

  Widget toWidgetIgnoreError(Widget Function(T) builder) {
    return when(
      data: builder,
      error: (error, stackTrace) => Container(),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  Widget toWidgetDataOnly(Widget Function(T) builder) {
    return whenData(builder).asData?.value ?? Container();
  }
}

Widget _defaultError(Object error, StackTrace? stack) {
  log("[PROVIDER WIDGET] : $error");
  return ErrorWidget("Error : $error");
}
