# Desenvolvimento e publicação

Fluxo: `feat/<nome>` ou `fix/<nome>` a partir de `dev` → PR para `dev` → PR de
`dev` para `main`, usando merge commit. Após publicar, sincronize main de volta
em dev por merge. Não use force push.

Flutter checks valida localização, análise e testes em PRs e pushes para dev/main.
Push em main gera APK debug com configuração pública de produção, disponível
como artifact do GitHub Actions por 14 dias para instalação de teste.
Assinatura de release e publicação nas lojas continuam pendentes; consulte
privacidade-publicacao.md. Rollback: distribuir o artefato anterior.

A API segue dev → master. Publique API antes do app quando houver contrato novo,
com migrações incrementais compatíveis com os clientes instalados.

```bash
git fetch origin
git switch -c feat/minha-alteracao origin/dev
flutter analyze
flutter test
git push -u origin HEAD
# abrir PR para dev, depois dev para main
```

Proteções recomendadas para dev/main: exigir PR e check `verify`, impedir force
push e exclusão. Confira no GitHub se as regras estão ativadas.
