import 'package:flutter/material.dart';

import '../../../../core/assets/localization_keys.dart';
import '../../domain/entities/base_url_type.dart';

class BaseUrlTypeSegmentedButton extends StatelessWidget {
  final BaseUrlType selectedBaseUrlType;
  final void Function(Set<BaseUrlType>) onSelectionChanged;
  const BaseUrlTypeSegmentedButton({
    super.key,
    required this.selectedBaseUrlType,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<BaseUrlType>(
      selected: {selectedBaseUrlType},
      onSelectionChanged: onSelectionChanged,
      segments: [
        ButtonSegment<BaseUrlType>(
          value: BaseUrlType.defaultUrl,
          label: Text(LocalizationKeys.defaultMode),
          icon: Icon(Icons.check_circle_outline),
        ),
        ButtonSegment<BaseUrlType>(
          value: BaseUrlType.custom,
          label: Text(LocalizationKeys.customMode),
          icon: Icon(Icons.edit),
        ),
      ],
    );
  }
}
