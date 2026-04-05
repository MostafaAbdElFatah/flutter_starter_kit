import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../extensions/context/context_navigator_extension.dart';

abstract class FailureState {
  String get errorMessage;
}

BlocListener<B, S> buildErrorListener<B extends StateStreamable<S>, S>({
  void Function(BuildContext context, S state)? onState,
  bool Function(S previous, S current)? listenWhen,
}) =>
    BlocListener<B, S>(
      listenWhen: listenWhen,
      listener: (context, state) {
        if (state is FailureState) {
          context.openFailureDialog(state.errorMessage);
        }
        onState?.call(context, state);
      },
    );
