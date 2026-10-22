# GlicNote

Aplicativo Flutter de acompanhamento glicêmico, com interface baseada nas referências visuais Home, History e Splash.

## Referências do projeto

- [Harness: decisões, regras, arquitetura e verificação](docs/harness.md)
- [Dicionário de todas as tabelas e campos](docs/banco-de-dados.md)
- [Instruções para agentes](AGENTS.md)

O app integra Google/Supabase Auth e a API para persistir aferições, perfil e contato.
Sem autenticação habilitada, usa demonstração em memória. Consulte o harness para rodar.

## Idiomas

O app segue o idioma do dispositivo: português, inglês e espanhol. Para idiomas não suportados, usa inglês. Datas, horários, números, calendários e textos de acessibilidade acompanham a localização.

As traduções ficam em `lib/l10n/app_{en,pt,es}.arb`. Após alterá-las, execute `flutter gen-l10n`. `lib/l10n/localization.dart` centraliza formatos e os nomes traduzidos dos momentos da medição; os identificadores dos registros permanecem estáveis ao trocar o idioma.

## Modelagem

Veja [a modelagem de domínio](docs/modelagem-dominio.md) para entidades, relacionamentos, permissões e fluxos de autenticação, aferições, acompanhamento, feed e medalhas.

### Login com Google no ambiente local

Com a autenticação local da API iniciada (`python3 scripts/start-local-auth.py`
no repositório `glicnote-api`), execute no telefone conectado:

```bash
adb reverse tcp:54321 tcp:54321
adb reverse tcp:8081 tcp:8081
flutter run --dart-define-from-file=/home/moraes/Documents/Moraes/glicnote-api/.local/flutter-auth.json
```

Esse arquivo contém somente a configuração pública do aplicativo. O segredo OAuth
fica no `.env` da API, fora do Git. O retorno do navegador usa
`com.glicnote.app://login-callback`, com PKCE. A área autenticada abre após a API
validar a sessão e retornar o perfil. Aferições, perfil e contato de emergência são persistidos pela API.
O histórico percorre a paginação completa; médias e filtros são calculados sobre
os registros carregados. A opção de tentar novamente é apresentada em falhas de carregamento.
O fuso IANA do dispositivo acompanha a criação de cada aferição, usando
[flutter_timezone](https://pub.dev/packages/flutter_timezone).
O e-mail é somente leitura; o perfil exige um nome de usuário único.
Feed, acompanhamento e medalhas já têm endpoints na API e ainda não têm telas
integradas neste aplicativo.

Sem `AUTH_ENABLED=true`, o aplicativo continua disponível no modo de demonstração.

### Aferições repetidas

Cada usuário pode registrar uma aferição por momento em cada dia local, exceto
“Outro”. O app mostra um aviso ao repetir o momento; a API confirma a regra entre
dispositivos e em edições. Mudar glicemia ou insulina não libera outro registro
para o mesmo momento/dia. O dia histórico é preservado no fuso da aferição.

“Outro” permite vários registros por dia; somente o mesmo instante é bloqueado,
independentemente da glicemia ou insulina.

### Abertura e carregamento

A sessão autenticada é persistida pelo Supabase no dispositivo e restaurada ao
reabrir o aplicativo. A renovação automática permanece ativa; se o token já estiver
expirado na abertura, o app aguarda sua renovação antes de buscar o perfil na API.
Sair da conta remove a sessão persistida. Falhas temporárias de rede mostram a
opção de tentar novamente, sem apagar a sessão por iniciativa do aplicativo.

Skeletons reutilizáveis cobrem a abertura, Home, histórico e contato de emergência.
Estados vazios aparecem após a resposta; atualizações preservam aferições já
carregadas. As animações respeitam a redução de movimentos do dispositivo.
Salvar uma aferição mantém a Home selecionada, e aferições do dia usam Hoje/Today/Hoy.

### Supabase Cloud em desenvolvimento

A configuração pública do projeto remoto fica em
`/home/moraes/Documents/Moraes/glicnote-api/.local/flutter-cloud.json`.
Ela aponta para o Supabase Cloud (Auth e PostgreSQL) e para a API de desenvolvimento
na porta 8082. A API usa `.env.cloud` do seu repositório, separado do `.env` local.

```bash
adb reverse tcp:8082 tcp:8082
flutter run --dart-define-from-file=/home/moraes/Documents/Moraes/glicnote-api/.local/flutter-cloud.json
```

O primeiro login neste projeto cria uma conta no ambiente Cloud. Contas e registros
do Supabase local não são copiados automaticamente. Para uso sem o computador,
é preciso publicar a API e substituir `API_BASE_URL` pelo endereço HTTPS público.

### Foto e política de privacidade

O avatar Google é apresentado no perfil e na Home, com fallback para o ícone
quando a imagem não carregar. A política preliminar pode ser lida offline no
login ou perfil. Veja [a minuta](docs/politica-de-privacidade.md) e as
[pendências de publicação](docs/privacidade-publicacao.md).

### API pública no Render

A configuração completa do ambiente remoto está em `config/production.json`,
com a API em `https://glicnote-api.onrender.com` e Supabase Cloud. Esse arquivo
contém somente configuração pública do cliente. Execute:

```bash
flutter run --dart-define-from-file=config/production.json
```

Esse ambiente usa a internet e dispensa `adb reverse` e a API local. No plano
gratuito do Render, a primeira chamada após inatividade pode demorar; se ocorrer
timeout, aguarde a inicialização e toque em Tentar novamente.
A minuta pública da política fica em `https://glicnote-api.onrender.com/privacy.html`.

### Cadastro complementar

O link Complete seu cadastro abre uma tela separada com nome de usuário, data de
nascimento completa opcional e fuso do dispositivo. Nome/e-mail são somente para
leitura, fornecidos pelo Google. A idade é calculada a partir da data, sem salvar
um valor de idade no banco. A data completa não aparece no perfil público.
O tipo de diabetes (1 ou 2) também é opcional e privado.
A API precisa estar na migração V6 e na versão correspondente do contrato de perfil.

## Desenvolvimento e publicação

Veja [o fluxo dev → main](docs/desenvolvimento-deploy.md).
