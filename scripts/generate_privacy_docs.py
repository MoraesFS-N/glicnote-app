#!/usr/bin/env python3
"""Gera documentos a partir dos textos pt do app; opcionalmente atualiza a API."""
import argparse
import html
import json
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument('--api-root', type=Path)
args = parser.parse_args()
root = Path(__file__).resolve().parents[1]
pt = json.loads((root / 'lib/l10n/app_pt.arb').read_text())
sections = ['Responsible', 'Data', 'Purpose', 'Session', 'Sharing', 'Providers', 'Retention', 'Rights', 'Updates']
md = '# Política de privacidade — GlicNote\n\n' + pt['privacyVersion'] + '\n\n> ' + pt['privacyDraft'] + '\n'
for section in sections:
    md += '\n## ' + pt['privacy' + section + 'Title'] + '\n\n' + pt['privacy' + section + 'Body'] + '\n'
(root / 'docs/politica-de-privacidade.md').write_text(md)
if args.api_root:
    (args.api_root / 'docs/politica-de-privacidade.md').write_text(md)
    body = ''.join('<section><h2>' + html.escape(pt['privacy' + s + 'Title']) + '</h2><p>' + html.escape(pt['privacy' + s + 'Body']) + '</p></section>' for s in sections)
    page = '''<!doctype html><html lang="pt-BR"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="robots" content="noindex"><title>Privacidade — GlicNote</title><style>body{margin:0;background:#D9DEE5;color:#191C1B;font:17px/1.7 system-ui,sans-serif}main{max-width:760px;margin:auto;padding:32px 20px}h1,h2{color:#8C2251;line-height:1.3}h1{font-size:32px}h2{font-size:22px}section,.notice{background:#F3F1F9;border-radius:24px;padding:24px;margin:20px 0}p{margin:12px 0}.notice{border-left:4px solid #AB2958}</style></head><body><main><h1>GlicNote · Política de privacidade</h1><p>''' + html.escape(pt['privacyVersion']) + '</p><aside class="notice">' + html.escape(pt['privacyDraft']) + '</aside>' + body + '</main></body></html>\n'
    (args.api_root / 'src/main/resources/static/privacy.html').write_text(page)
