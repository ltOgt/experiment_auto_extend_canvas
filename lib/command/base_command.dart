import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class BaseCommand {
  static T dependOn<T>() => rootContext.read<T>();

  /// A context beneath multiProvider to access all dependencies
  static BuildContext? _rootContext;
  static BuildContext get rootContext => _rootContext!;

  static void initRootContext(BuildContext context) {
    if (_rootContext != null) print("RootContext already set!");

    _rootContext = context;
  }
}
