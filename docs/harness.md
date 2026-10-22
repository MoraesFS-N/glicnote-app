# Harness do GlicNote

Referência de decisões de produto, arquitetura e execução. Atualizado em 22/10/2026.
Este documento não comprova que um commit local já foi publicado: confirme a versão e
as migrações do ambiente antes de instalar um cliente com novo contrato.

## Produto e limites

GlicNote, da Tech Mow, é um diário de glicemia com registro opcional de insulina.
Não calcula doses nem fornece diagnóstico. Dados de saúde são privados por padrão.
O app deve funcionar no idioma do dispositivo (PT/EN/ES; inglês como fallback).

## Arquitetura e ambientes

- Flutter: `lib/main.dart` coordena sessão/navegação; `lib/screens.dart` contém as telas principais;
  `lib/screens/` concentra telas específicas e `lib/widgets/` componentes compartilhados.
- `lib/auth/` integra Supabase Auth com Google; `lib/data/` concentra cliente HTTP,
  repositório, serialização e modelos. Não faça HTTP diretamente em componentes visuais.
- API Java 17 / Spring Boot, JdbcClient, PostgreSQL e Flyway, no repositório
  `/home/moraes/Documents/Moraes/glicnote-api`. API usa Docker.
- Produção: API `https://glicnote-api.onrender.com`, Supabase Cloud para Auth/PostgreSQL.
  Configuração pública: `config/production.json`. Não usar `adb reverse` em produção.
- Desenvolvimento local: API 8081, Postgres 5433, Auth local 54321.
  API local conectada ao banco Cloud: 8082; esse ambiente compartilha dados reais.
- Schema privado `glicnote`: cliente acessa os dados pela API autenticada, não diretamente
  por PostgREST. Identidades e sessões pertencem ao Supabase Auth.

## Identidade e cadastro

Login Google via PKCE, sessão persistida e renovação automática. Reabrir o app não
exige novo login; falha temporária de rede não deve apagar a sessão. Logout remove a sessão.
Avatar usa foto Google com fallback. Nome e e-mail são somente leitura.
Campos bloqueados usam `LockedTextField` com fundo cinza azulado e cadeado.

Complete seu cadastro abre uma tela própria. Nome de usuário é único, 3–30 caracteres
`a-z`, `0-9`, `_`. Data de nascimento completa e tipo de diabetes são opcionais e
privados. Tipo usa `type_1` / `type_2` ou null. Idade é calculada a partir da data;
não persistir idade nem inventar ano de nascimento para cadastros antigos.
Fuso IANA é obtido do dispositivo. Dados complementares fica na parte inferior do perfil,
após privacidade e antes de sair. Ações que abrem formulários usam `NavigationCard`.

## Aferições e regras

- Registro em bottom sheet pequeno, com cancelar, glicemia, momento e insulina opcional em UI.
- Glicemia: inteiro positivo; interface aceita até 1000 mg/dL. Insulina: não negativa,
  menor que 100000 e até três casas decimais; vírgula é aceita na interface.
- Momentos: jejum, após café, almoço, lanche, jantar e outro. Identificadores de API:
  `fasting`, `after_breakfast`, `after_lunch`, `after_snack`, `after_dinner`, `other`.
- Para cada usuário, apenas uma aferição por momento em cada dia local, exceto `other`.
  Mudar valor ou insulina não permite repetir o mesmo momento/dia.
- `other` permite quantas aferições forem necessárias, exceto no exato mesmo instante.
  A regra não exige que os valores sejam iguais.
- API e índices únicos são a autoridade entre dispositivos; app também antecipa conflitos.
  Conflito de duplicidade retorna 409 / `duplicate_reading`.
- Desabilitar envio duplicado e fechamento durante gravação; manter ID/payload para retentativa
  idempotente. Não repetir automaticamente gravações em falhas transitórias.
- Preservar o fuso/dia histórico do registro. Após salvar, permanecer na Home.
- Aferição do dia atual mostra Hoje/Today/Hoy. Hora fica acima e fora do card principal.
- Quantidade de insulina usa `InsulinBadge`, apenas “25 UI” (IU em inglês), junto ao
  título quando possível; permitir ajuste responsivo sem overflow.
- Histórico tem filtro por data estilizado e indicador de mais momentos à direita.
  Carregar todas as páginas para filtros e médias corretos.

## Design e comportamento

- Fonte Istok Web. Fundo `#D9DEE5`; cards `#F3F1F9`; primária `#AB2958`, escura
  `#8C2251`, destaque `#BF3D6D`, lavanda `#E0DCEF`.
- Usar `GlicColors`, `GlicSpace`, `GlicLayout`, `GlicCard` e componentes existentes.
  Não duplicar layouts, regras de cor ou espaçamentos em telas.
- Home usa logo alternativa por extenso, sem “Olá, bem-vindo” / “Minha glicemia”.
  Médias e contagem ficam abaixo; cores do gráfico seguem o card glicêmico.
- Últimas aferições usa colunas dimensionadas para quatro posições na linha, mesmo com menos
  registros (reduzir posições quando a fonte estiver ampliada), distribuídas com Wrap. Reservar a mesma altura para insulina em todas
  quando houver algum registro com UI; não esticar colunas para preencher a linha.
- Transição lateral entre telas, splash animada e movimento suave da gota.
  Respeitar redução de movimentos. Skeletons no carregamento inicial; atualizações
  preservam dados existentes; vazio somente após resposta.
- Feedback transitório usa `AppToast`: verde para sucesso, amarelo para atenção
  (inclusive duplicidade), vermelho para erro, em tons suaves coordenados com o tema.
  Um toast por vez, com ícone, texto acessível e fechar. Validação permanece no campo;
  estados persistentes de falha mantêm contexto e opção de tentar novamente.
- Não há botão Atualizar permanente no topo. Retentativa aparece quando necessário.

## Social e medalhas

Implementados no backend, com telas ainda pendentes no Flutter: solicitações de
acompanhamento com aprovação, bloqueio, feed com publicação explícita e notificações.
Acompanhamento é direcionado; não liberar dados privados pela simples existência de uma
solicitação. Perfis públicos não expõem nascimento, diabetes, e-mail ou contato.
Medalhas cobrem quantidade de aferições, dias consecutivos e datas especiais.
Catálogo inicial: 1/10/50/100 registros, 3/7/14/30 dias, aniversário e ano novo.
Concessões têm edição e versão da regra; publicação no feed é opt-in.
Veja a modelagem para permissões e fluxos detalhados.

## Privacidade e publicação

Política acessível no login e perfil, offline e em `/privacy.html` na API.
Fonte dos textos: ARBs; `scripts/generate_privacy_docs.py` gera Markdown e HTML.
Há minuta e pendências reais em `docs/privacidade-publicacao.md`; não declarar
conformidade concluída. Faltam definições como contato e retenção; exclusão de conta/dados
no app e por URL pública ainda precisa implementação para publicação.
Assinatura de release, applicationId definitivo, AAB, material da loja e declarações de
saúde/dados também precisam revisão. Regras da Play Store devem ser verificadas no momento
 da publicação; não presumir que conta pessoal é aceita para este app de saúde.
Nunca copiar credenciais de conversas para documentos, logs ou Git.

## Verificação e execução

```bash
flutter pub get
flutter gen-l10n
flutter analyze
flutter test
flutter run --dart-define-from-file=config/production.json
flutter build apk --debug --dart-define-from-file=config/production.json
```

SDK disponível nesta máquina: `/home/moraes/develop/flutter/bin/flutter`.
Android SDK: `/home/moraes/Android/Sdk`. Use `adb devices` para descobrir o telefone atual.
Instalação com `adb install -r` preserva dados; não desinstale para resolver problemas
sem necessidade. Testes não devem inserir informações de saúde fictícias na conta real.
Na API, `scripts/test.sh` executa integração com Postgres isolado. Migrações novas precisam
passar esses testes. Atualize o [dicionário](banco-de-dados.md) quando mudar tabelas.
