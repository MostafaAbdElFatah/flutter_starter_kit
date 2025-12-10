import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

/// A generic base Cubit that can be extended by all feature-specific cubits.
///
/// Provides:
/// - Static `of` helper for convenient access from the widget tree.
/// - Optional logging on state changes.
abstract class BaseCubit<StateType> extends Cubit<StateType> {
  BaseCubit(super.initialState);

  /// Retrieves the cubit instance from the widget tree.
  static T of<T extends Cubit<dynamic>>(
    BuildContext context, {
    bool listen = false,
  }) => BlocProvider.of<T>(context, listen: listen);
}

extension CubitX<T extends Cubit<dynamic>> on BuildContext {
  T get cubit => BlocProvider.of<T>(this);
}