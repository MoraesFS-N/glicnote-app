import 'package:flutter/material.dart';
import '../design_system.dart';

/// Campo somente para leitura, com aparência distinta dos campos editáveis.
class LockedTextField extends StatelessWidget {
  const LockedTextField({super.key, required this.value, required this.label,
    required this.icon, this.helperText});
  final String value;
  final String label;
  final IconData icon;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: GlicColors.lockedBorder));
    return TextFormField(key: ValueKey('$label-$value'), initialValue: value,
      readOnly: true, showCursor: false, enableInteractiveSelection: true,
      style: const TextStyle(color: GlicColors.lockedText),
      decoration: InputDecoration(labelText: label, helperText: helperText,
        filled: true, fillColor: GlicColors.lockedSurface,
        labelStyle: const TextStyle(color: GlicColors.lockedText),
        floatingLabelStyle: const TextStyle(color: GlicColors.lockedText),
        border: border, enabledBorder: border, focusedBorder: border,
        prefixIcon: Icon(icon, color: GlicColors.lockedText),
        suffixIcon: const Icon(Icons.lock_outline, size: 18, color: GlicColors.lockedText)),
    );
  }
}
