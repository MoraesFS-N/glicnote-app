# GlicNote — instruções para agentes

Leia [o harness](docs/harness.md) antes de modificar o projeto. Consulte também
[a modelagem](docs/modelagem-dominio.md) e [o dicionário do banco](docs/banco-de-dados.md)
quando alterar contratos, persistência ou permissões.

- Preserve o trabalho existente e os dados reais do usuário; não faça reset ou seed em produção.
- Componentes visuais devem ser reutilizáveis, com cores/espaçamentos em `lib/design_system.dart`.
- Textos visíveis devem ter traduções PT/EN/ES nos ARBs; gere a localização após alterações.
- Novas regras de persistência precisam de validação na API e migração incremental, nunca editar migrações aplicadas.
- Não registre tokens, senhas ou segredos OAuth. Configuração pública do app não deve conter segredos.
- Verifique mudanças com análise e testes adequados. Não publique resultados de testes ou deploy que não executou.
- Atualize a documentação junto com mudanças em regras, tabelas ou contratos. Diferencie implementado de planejado.
