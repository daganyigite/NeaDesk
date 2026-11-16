import 'package:flutter/material.dart';

/// Palette et styles de l'interface NEADESK.
///
/// Toutes les couleurs de l'interface NEADESK sont définies ici (le thème
/// général `MyTheme` dans common.dart s'appuie aussi sur ces valeurs).
class NeaStyle {
  NeaStyle._();

  // Accent unique (identique en mode clair et sombre).
  static const Color accent = Color(0xFF2563EB);
  static const Color accentHover = Color(0xFF1D4ED8);
  static const Color onAccent = Color(0xFFFFFFFF);

  // Mode sombre.
  static const Color darkBackground = Color(0xFF0F1420);
  static const Color darkPanel = Color(0xFF1A2030);
  static const Color darkBorder = Color(0xFF2A3142);
  static const Color darkField = Color(0xFF3A4256);
  static const Color darkText = Color(0xFFF1F5F9);
  static const Color darkMuted = Color(0xFFA3ADC2);
  static const Color darkSuccess = Color(0xFF22C55E);
  static const Color darkWarning = Color(0xFFF59E0B);
  static const Color darkError = Color(0xFFEF4444);

  // Mode clair (mêmes rôles, teintes ajustées pour le contraste AA sur blanc).
  static const Color lightBackground = Color(0xFFF4F5F7);
  static const Color lightPanel = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFDDE1E7);
  static const Color lightField = Color(0xFFCFD3D9);
  static const Color lightText = Color(0xFF1A1D23);
  static const Color lightMuted = Color(0xFF545B68);
  static const Color lightSuccess = Color(0xFF15803D);
  static const Color lightWarning = Color(0xFFB45309);
  static const Color lightError = Color(0xFFDC2626);

  /// Fond des cartes de postes (zone de l'icône).
  static const Color peerCardTop = Color(0xFF2B3140);

  static const String mono = 'Consolas';
  static const List<String> monoFallback = [
    'Menlo',
    'Roboto Mono',
    'DejaVu Sans Mono',
    'monospace'
  ];

  static bool dark(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark;

  static Color _pick(BuildContext c, Color d, Color l) => dark(c) ? d : l;

  /// Fond principal (zone « Contrôler un poste distant »).
  static Color page(BuildContext c) =>
      _pick(c, darkBackground, lightBackground);

  /// Panneaux et cartes (panneau « Votre poste », encadrés, champs).
  static Color panel(BuildContext c) => _pick(c, darkPanel, lightPanel);
  static Color line(BuildContext c) => _pick(c, darkBorder, lightBorder);

  /// Bordure des champs de saisie et boutons secondaires (un peu plus visible).
  static Color field(BuildContext c) => _pick(c, darkField, lightField);
  static Color text(BuildContext c) => _pick(c, darkText, lightText);
  static Color muted(BuildContext c) => _pick(c, darkMuted, lightMuted);
  static Color success(BuildContext c) => _pick(c, darkSuccess, lightSuccess);
  static Color warning(BuildContext c) => _pick(c, darkWarning, lightWarning);
  static Color error(BuildContext c) => _pick(c, darkError, lightError);

  /// Fond léger d'un élément qui a le focus clavier.
  static Color focusFill(BuildContext c) => accent.withOpacity(0.22);

  /// Petit titre de section en majuscules (« VOTRE POSTE »).
  static TextStyle sectionTitle(BuildContext c) => TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.7,
      color: muted(c));

  /// Libellé de champ (« Identifiant », « Mot de passe à usage unique »).
  static TextStyle label(BuildContext c) =>
      TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: muted(c));

  /// Police normale de l'interface (pour les textes à côté du mono).
  static TextStyle ui(BuildContext c, double size, {Color? color}) {
    final base = Theme.of(c).textTheme.bodyMedium;
    return TextStyle(
        fontFamily: base?.fontFamily,
        fontFamilyFallback: base?.fontFamilyFallback,
        fontSize: size,
        fontWeight: FontWeight.normal,
        color: color ?? text(c));
  }

  static TextStyle monoStyle(BuildContext c, double size,
          {FontWeight weight = FontWeight.w600}) =>
      TextStyle(
          fontFamily: mono,
          fontFamilyFallback: monoFallback,
          fontSize: size,
          fontWeight: weight,
          color: text(c));

  /// Bordure qui devient épaisse et bleue quand le bouton a le focus clavier.
  static MaterialStateProperty<BorderSide> _focusSide(Color normal) =>
      MaterialStateProperty.resolveWith((states) =>
          states.contains(MaterialState.focused)
              ? const BorderSide(color: accent, width: 2)
              : BorderSide(color: normal));

  /// Bouton carré à bordure (copier, afficher, nouveau mot de passe…).
  static Widget squareButton(BuildContext c,
      {required IconData icon,
      required String tooltip,
      required VoidCallback onTap}) {
    return Tooltip(
      message: tooltip,
      child: SizedBox(
        width: 36,
        height: 36,
        child: OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.zero,
            foregroundColor: text(c),
            backgroundColor: panel(c),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ).copyWith(side: _focusSide(line(c))),
          child: Icon(icon, size: 18, semanticLabel: tooltip),
        ),
      ),
    );
  }

  /// Bouton secondaire en contour (« Transférer des fichiers », « Installer »).
  static ButtonStyle outlined(BuildContext c, {Color? border}) =>
      OutlinedButton.styleFrom(
        foregroundColor: text(c),
        backgroundColor: panel(c),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        minimumSize: const Size(0, 36),
        textStyle: const TextStyle(fontSize: 13),
      ).copyWith(side: _focusSide(border ?? line(c)));

  /// Bouton discret sans bordure (« Paramètres », « Aide », liens).
  static ButtonStyle link(BuildContext c) => TextButton.styleFrom(
        foregroundColor: text(c),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        minimumSize: const Size(0, 34),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        textStyle: const TextStyle(fontSize: 13),
      ).copyWith(
          side: MaterialStateProperty.resolveWith((states) =>
              states.contains(MaterialState.focused)
                  ? const BorderSide(color: accent, width: 2)
                  : BorderSide.none));

  /// Bouton principal (« Se connecter »), grisé quand il est désactivé.
  static ButtonStyle primary(BuildContext c) => ButtonStyle(
        elevation: const MaterialStatePropertyAll(0),
        padding: const MaterialStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 24)),
        shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        textStyle: const MaterialStatePropertyAll(
            TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) return line(c);
          if (states.contains(MaterialState.hovered) ||
              states.contains(MaterialState.focused)) {
            return accentHover;
          }
          return accent;
        }),
        foregroundColor: MaterialStateProperty.resolveWith((states) =>
            states.contains(MaterialState.disabled) ? muted(c) : onAccent),
        side: MaterialStateProperty.resolveWith((states) =>
            states.contains(MaterialState.focused)
                ? BorderSide(color: text(c), width: 2)
                : BorderSide.none),
      );
}
