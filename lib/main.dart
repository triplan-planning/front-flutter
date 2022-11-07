import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/app.dart';

void main() async {
  const dotEnvPath = kDebugMode ? "assets/env/debug.env" : "assets/env/.env";
  await dotenv.load(fileName: dotEnvPath);

  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: MyApp()));
}
