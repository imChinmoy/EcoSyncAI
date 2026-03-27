import 'package:ecosyncai/core/locale/locale_controller.dart';
import 'package:flutter/material.dart';

/// Provides [LocaleController] to the widget tree (e.g. Profile language picker).
class AppLocaleScope extends InheritedWidget {
  const AppLocaleScope({
    super.key,
    required this.controller,
    required super.child,
  });

  final LocaleController controller;

  static LocaleController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppLocaleScope>();
    assert(scope != null, 'AppLocaleScope not found in context');
    return scope!.controller;
  }

  @override
  bool updateShouldNotify(AppLocaleScope oldWidget) =>
      oldWidget.controller != controller;
}
