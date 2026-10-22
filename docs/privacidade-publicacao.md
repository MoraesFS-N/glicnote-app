# Preparação da política para publicação

Responsável informado: **Tech Mow**. Versão preliminar 0.3, 22/10/2026.
O aviso no app e o documento público descrevem o estado atual; não representam
um fluxo de consentimento, exportação ou exclusão de conta já implementado.

Antes da versão definitiva, preencher/validar:

- Identificação do responsável (nome legal, natureza e identificação aplicável) e e-mail de privacidade.
- Bases legais por finalidade, incluindo aferições e insulina como dados sensíveis;
  definir eventual consentimento destacado, específico, revogável e comprovável.
  Login Google e leitura da política não substituem esse fluxo.
- Prazos de retenção e exclusão, incluindo backups, logs e conta no Supabase Auth.
- Canal de solicitações e procedimento para acesso, correção, exportação, exclusão
  e revogação. O app ainda não implementa exportação/exclusão completa da conta.
- Público etário e eventual tratamento de dados de crianças/adolescentes.
- Papéis e contratos dos fornecedores, localização dos dados, transferências
  internacionais, responsáveis por suporte e procedimento de incidentes.
- Confirmar ausência de ferramentas de publicidade/analytics e atualizar se isso mudar.
- Quando a API migrar ao Render, atualizar provedores e hospedagem no texto.
- Publicar a URL HTTPS estável `/privacy.html` da API e registrá-la no Google OAuth
  e na loja do aplicativo quando aplicável. O HTML ainda é uma minuta em revisão.

Textos do app: `lib/l10n/app_{pt,en,es}.arb`. Após editar:

```bash
flutter gen-l10n
python3 scripts/generate_privacy_docs.py --api-root /home/moraes/Documents/Moraes/glicnote-api
```

O script gera a minuta Markdown dos dois repositórios e o HTML da API a partir
do conteúdo português do app, evitando manter três versões manuais divergentes.

Referências: [LGPD](https://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/l13709.htm),
[ANPD — direitos dos titulares](https://www.gov.br/anpd/pt-br/assuntos/titular-de-dados-1/direito-dos-titulares),
[Google OAuth — verificação de marca](https://developers.google.com/identity/protocols/oauth2/production-readiness/branding-verification).
