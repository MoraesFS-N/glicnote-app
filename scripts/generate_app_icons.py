"""Regenerate launcher icons: uv run --with cairosvg python scripts/generate_app_icons.py"""
import json
from pathlib import Path
import xml.etree.ElementTree as ET

import cairosvg

ROOT = Path(__file__).resolve().parents[1]
BACKGROUND = '#F3F1F9'
svg = ET.parse(ROOT / 'assets/branding/icon.svg').getroot()
art = ''.join(ET.tostring(child, encoding='unicode') for child in svg)


def source(background=False, scale=1):
    inset = (162 - 162 * scale) / 2
    rect = f'<rect width="162" height="162" fill="{BACKGROUND}"/>' if background else ''
    return (f'<svg xmlns="http://www.w3.org/2000/svg" width="162" height="162" viewBox="0 0 162 162">'
            f'{rect}<g transform="translate({inset} {inset}) scale({scale})">{art}</g></svg>').encode()


def render(path, size, background=True, scale=1):
    path.parent.mkdir(parents=True, exist_ok=True)
    cairosvg.svg2png(bytestring=source(background, scale), write_to=str(path),
                     output_width=size, output_height=size)


res = ROOT / 'android/app/src/main/res'
for density, size in [('mdpi', 48), ('hdpi', 72), ('xhdpi', 96), ('xxhdpi', 144), ('xxxhdpi', 192)]:
    render(res / f'mipmap-{density}/ic_launcher.png', size)
    render(res / f'drawable-{density}/ic_launcher_foreground.png', round(size * 108 / 48), False, .8)
adaptive = res / 'mipmap-anydpi-v26/ic_launcher.xml'
adaptive.parent.mkdir(parents=True, exist_ok=True)
adaptive.write_text('''<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@color/ic_launcher_background" />
    <foreground android:drawable="@drawable/ic_launcher_foreground" />
</adaptive-icon>
''')
(res / 'values/ic_launcher_colors.xml').write_text(
    f'<?xml version="1.0" encoding="utf-8"?>\n<resources>\n    <color name="ic_launcher_background">{BACKGROUND}</color>\n</resources>\n')
ios = ROOT / 'ios/Runner/Assets.xcassets/AppIcon.appiconset'
for icon in json.loads((ios / 'Contents.json').read_text())['images']:
    if 'filename' in icon:
        size = float(icon['size'].split('x')[0]) * float(icon['scale'].rstrip('x'))
        render(ios / icon['filename'], round(size))
for name, size in [('Icon-192.png', 192), ('Icon-512.png', 512),
                   ('Icon-maskable-192.png', 192), ('Icon-maskable-512.png', 512)]:
    render(ROOT / 'web/icons' / name, size, scale=.8 if 'maskable' in name else 1)
render(ROOT / 'web/favicon.png', 32)
