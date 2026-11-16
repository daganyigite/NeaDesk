import 'package:flutter/material.dart';

/// Couleurs et styles de l'interface NEADESK (maquette validée).
class NeaStyle {
  NeaStyle._();

  static const Color accent = Color(0xFF1D5FD1);
  static const String mono = 'Consolas';
  static const List<String> monoFallback = [
    'Menlo',
    'Roboto Mono',
    'DejaVu Sans Mono',
    'monospace'
  ];

  static bool dark(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark;

  /// Fond du panneau « Votre poste ».
  static Color panel(BuildContext c) =>
      dark(c) ? const Color(0xFF1C2029) : Colors.white;

  /// Fond de la partie droite (contrôler un poste).
  static Color page(BuildContext c) =>
      dark(c) ? const Color(0xFF14171D) : const Color(0xFFF4F5F7);

  static Color line(BuildContext c) =>
      dark(c) ? const Color(0xFF2A2F3A) : const Color(0xFFE3E5E9);

  static Color field(BuildContext c) =>
      dark(c) ? const Color(0xFF343A47) : const Color(0xFFCFD3D9);

  static Color muted(BuildContext c) =>
      dark(c) ? const Color(0xFFA3A9B6) : const Color(0xFF5B616E);

  static Color text(BuildContext c) =>
      dark(c) ? const Color(0xFFE8EAEE) : const Color(0xFF1A1D23);

  /// Petit titre de section en majuscules (« VOTRE POSTE »).
  static TextStyle sectionTitle(BuildContext c) => TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.7,
      color: muted(c));

  static TextStyle label(BuildContext c) =>
      TextStyle(fontSize: 13, color: muted(c));

  static TextStyle monoStyle(BuildContext c, double size,
          {FontWeight weight = FontWeight.w600}) =>
      TextStyle(
          fontFamily: mono,
          fontFamilyFallback: monoFallback,
          fontSize: size,
          fontWeight: weight,
          color: text(c));

  /// Bouton carré à bordure (copier, nouveau mot de passe…).
  static Widget squareButton(BuildContext c,
      {required IconData icon,
      required String tooltip,
      required VoidCallback onTap}) {
    return Tooltip(
      message: tooltip,
      child: SizedBox(
        width: 40,
        height: 40,
        child: OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.zero,
            foregroundColor: text(c),
            backgroundColor: panel(c),
            side: BorderSide(color: line(c)),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Icon(icon, size: 18),
        ),
      ),
    );
  }

  /// Bouton secondaire (« Transférer des fichiers »).
  static ButtonStyle outlined(BuildContext c) => OutlinedButton.styleFrom(
        foregroundColor: text(c),
        backgroundColor: panel(c),
        side: BorderSide(color: field(c)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        minimumSize: const Size(0, 36),
        textStyle: const TextStyle(fontSize: 13),
      );

  /// Bouton principal (« Se connecter »).
  static ButtonStyle primary() => ElevatedButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      );
}
