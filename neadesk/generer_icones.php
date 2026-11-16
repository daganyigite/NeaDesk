<?php
/**
 * NEADESK — génère toutes les icônes de l'application à partir des PNG 1024 px
 * rendus depuis neadesk/sources/*.svg.
 *
 * Usage : php neadesk/generer_icones.php <dossier des PNG rendus> <racine du dépôt>
 * PNG attendus : icone.png, icone-mac.png, icone-ios.png, icone-rond.png,
 *                icone-android-avant.png, silhouette-noire.png, silhouette-blanche.png
 */

[$_, $src, $racine] = $argv + [null, null, null];
if (!$src || !$racine) {
    fwrite(STDERR, "Usage : php generer_icones.php <dossier PNG> <racine du dépôt>\n");
    exit(1);
}

function charger(string $fichier): GdImage
{
    $im = imagecreatefrompng($fichier) ?: throw new RuntimeException("Illisible : $fichier");
    imagesavealpha($im, true);
    return $im;
}

/** Redimensionne en gardant la transparence. */
function taille(GdImage $im, int $w, ?int $h = null): GdImage
{
    $h ??= $w;
    $out = imagecreatetruecolor($w, $h);
    imagealphablending($out, false);
    imagesavealpha($out, true);
    imagefill($out, 0, 0, imagecolorallocatealpha($out, 0, 0, 0, 127));
    imagecopyresampled($out, $im, 0, 0, 0, 0, $w, $h, imagesx($im), imagesy($im));
    return $out;
}

function png(GdImage $im, bool $alpha = true): string
{
    imagesavealpha($im, $alpha);
    ob_start();
    imagepng($im, null, 9);
    return ob_get_clean();
}

function ecrire(string $chemin, string $donnees): void
{
    global $racine;
    $complet = "$racine/$chemin";
    if (!is_dir(dirname($complet))) {
        mkdir(dirname($complet), 0777, true);
    }
    file_put_contents($complet, $donnees);
    echo "  $chemin\n";
}

/** Fichier .ico avec une image PNG par taille (Windows Vista et plus). */
function ico(GdImage $im, array $tailles): string
{
    $images = array_map(fn ($t) => png(taille($im, $t)), $tailles);
    $entete = pack('vvv', 0, 1, count($tailles));
    $repertoire = '';
    $position = 6 + 16 * count($tailles);
    foreach ($tailles as $i => $t) {
        $octets = strlen($images[$i]);
        $repertoire .= pack('CCCCvvVV', $t >= 256 ? 0 : $t, $t >= 256 ? 0 : $t, 0, 0, 1, 32, $octets, $position);
        $position += $octets;
    }
    return $entete . $repertoire . implode('', $images);
}

/** Fichier .icns (Mac) avec des images PNG. */
function icns(GdImage $im): string
{
    $types = ['icp4' => 16, 'icp5' => 32, 'ic11' => 32, 'ic12' => 64, 'ic07' => 128,
        'ic08' => 256, 'ic13' => 256, 'ic09' => 512, 'ic14' => 512, 'ic10' => 1024];
    $corps = '';
    foreach ($types as $type => $t) {
        $donnees = png(taille($im, $t));
        $corps .= $type . pack('N', 8 + strlen($donnees)) . $donnees;
    }
    return 'icns' . pack('N', 8 + strlen($corps)) . $corps;
}

/** Image opaque (iOS refuse la transparence). */
function opaque(GdImage $im, int $t): string
{
    $out = imagecreatetruecolor($t, $t);
    imagefill($out, 0, 0, imagecolorallocate($out, 0x1d, 0x5f, 0xd1));
    imagealphablending($out, true);
    imagecopyresampled($out, $im, 0, 0, 0, 0, $t, $t, imagesx($im), imagesy($im));
    return png($out, false);
}

$icone = charger("$src/icone.png");
$mac = charger("$src/icone-mac.png");
$ios = charger("$src/icone-ios.png");
$rond = charger("$src/icone-rond.png");
$avant = charger("$src/icone-android-avant.png");
$noire = charger("$src/silhouette-noire.png");
$blanche = charger("$src/silhouette-blanche.png");

echo "Windows / Linux / commun\n";
ecrire('res/icon.png', png(taille($icone, 1024)));
ecrire('res/32x32.png', png(taille($icone, 32)));
ecrire('res/64x64.png', png(taille($icone, 64)));
ecrire('res/128x128.png', png(taille($icone, 128)));
ecrire('res/128x128@2x.png', png(taille($icone, 256)));
ecrire('res/icon.ico', ico($icone, [16, 24, 32, 48, 64, 128, 256]));
ecrire('res/tray-icon.ico', ico($icone, [16, 20, 24, 32, 48]));
ecrire('flutter/windows/runner/resources/app_icon.ico', ico($icone, [16, 24, 32, 48, 64, 128, 256]));
ecrire('fastlane/metadata/android/en-US/images/icon.png', png(taille($icone, 256)));

echo "Mac\n";
ecrire('res/mac-icon.png', png(taille($mac, 1024)));
ecrire('flutter/macos/Runner/AppIcon.icns', icns($mac));
ecrire('res/mac-tray-light-x2.png', png(taille($noire, 48)));
ecrire('res/mac-tray-dark-x2.png', png(taille($blanche, 60)));

echo "Android\n";
foreach (['mdpi' => 1, 'hdpi' => 1.5, 'xhdpi' => 2, 'xxhdpi' => 3, 'xxxhdpi' => 4] as $densite => $f) {
    $d = "flutter/android/app/src/main/res/mipmap-$densite";
    ecrire("$d/ic_launcher.png", png(taille($icone, (int) (48 * $f))));
    ecrire("$d/ic_launcher_round.png", png(taille($rond, (int) (48 * $f))));
    ecrire("$d/ic_launcher_foreground.png", png(taille($avant, (int) (108 * $f))));
}

echo "iPhone / iPad\n";
$dossierIos = 'flutter/ios/Runner/Assets.xcassets/AppIcon.appiconset';
foreach (glob("$racine/$dossierIos/Icon-App-*.png") as $fichier) {
    preg_match('/Icon-App-([\d.]+)x[\d.]+@(\d)x\.png$/', $fichier, $m);
    ecrire("$dossierIos/" . basename($fichier), opaque($ios, (int) round($m[1] * $m[2])));
}

echo "Terminé.\n";
