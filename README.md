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
fvm flutter pub get
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

## Fluxo de branches

- `main`: versão estável, recebe pull requests de `dev` para publicar uma versão.
- `dev`: integração do desenvolvimento, recebe pull requests de funcionalidades e correções.
- `feat/<nome>` e `fix/<nome>`: branches de trabalho criadas a partir de `dev`.

### Iniciar uma alteração

```bash
git switch dev
git pull --ff-only origin dev
git switch -c feat/nome-da-funcionalidade
```

Faça as alterações, valide e publique a branch:

```bash
flutter analyze
flutter test
git add <arquivos-alterados>
git commit -m "feat: descreve a alteração"
git push -u origin feat/nome-da-funcionalidade
```

Abra um pull request com destino a `dev`. Depois de integrar e validar as
alterações em `dev`, abra um pull request de `dev` para `main`, usando merge
commit para preservar a relação entre os históricos das duas branches.

### Atualizar dev após uma publicação

```bash
git switch dev
git pull --ff-only origin dev
git fetch origin
git merge origin/main
git push origin dev
```

Evite commits diretos e force push em `main` e `dev`. Configure no GitHub a
proteção dessas branches para exigir pull requests antes de integrar mudanças.
