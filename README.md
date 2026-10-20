# GlicNote

Aplicativo Flutter de acompanhamento glicêmico, com interface baseada nas referências visuais Home, History e Splash.

## Funcionalidades da primeira versão
- Splash de entrada com marca GlicNote
- Home com última medição, resumo e histórico recente
- Histórico de medições, filtro por período e gráfico simples
- Registro local demonstrativo de uma nova medição (sem persistência)
- Tema Material 3 com tokens de cores e espaçamentos

## Rodar

Requer Flutter SDK instalado.

```bash
flutter pub get
flutter run
```

Ou com FVM:

```bash
fvm fvm flutter pub get
fvm flutter run
```

Os projetos Android, iOS, Linux e Web estão incluídos. Os registros são dados de demonstração e ficam apenas em memória.

## Estrutura
- `lib/main.dart`: entrada e navegação.
- `lib/design_system.dart`: cores, tema e componentes.
- `lib/screens.dart`: splash, início, histórico e novo registro.

## Próximos passos
Persistência SQLite/Drift, autenticação, gráficos históricos reais, acessibilidade, testes e integração com API.

> Este aplicativo não substitui orientações médicas.
