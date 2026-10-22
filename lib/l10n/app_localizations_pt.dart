// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get home => 'Início';

  @override
  String get register => 'Registrar';

  @override
  String get history => 'Histórico';

  @override
  String get profile => 'Perfil';

  @override
  String get myProfile => 'Meu perfil';

  @override
  String get tagline => 'Seu cuidado, um registro de cada vez.';

  @override
  String get splashFooter => 'Seu acompanhamento sempre por perto.';

  @override
  String get glucoseLevel => 'Seu nível glicêmico';

  @override
  String get average => 'Média de registros';

  @override
  String get measurements => 'Medições';

  @override
  String get records => 'registros';

  @override
  String get newReading => 'Nova medição';

  @override
  String get recentReadings => 'Últimas aferições';

  @override
  String get noReadings => 'Nenhuma aferição registrada.';

  @override
  String get seeAll => 'Ver todas as aferições';

  @override
  String get morning => 'Manhã';

  @override
  String get afternoon => 'Tarde';

  @override
  String get night => 'Noite';

  @override
  String get emptyChart => 'Sem medições';

  @override
  String get historySubtitle => 'Acompanhe a evolução dos seus registros.';

  @override
  String get overview => 'Visão geral';

  @override
  String get emptyHistory => 'Nenhum registro encontrado.';

  @override
  String get profileSubtitle => 'Um espaço para seus dados pessoais.';

  @override
  String get yourProfile => 'Seu perfil';

  @override
  String get profileTagline => 'Seu cuidado começa com você.';

  @override
  String get personalDetails => 'Dados pessoais';

  @override
  String get name => 'Nome';

  @override
  String get nameError => 'Informe seu nome.';

  @override
  String get email => 'E-mail';

  @override
  String get emailError => 'Informe um e-mail válido.';

  @override
  String get saveProfile => 'Salvar perfil';

  @override
  String get profileSaved => 'Perfil atualizado nesta sessão.';

  @override
  String get contactSaved => 'Contato atualizado nesta sessão.';

  @override
  String get sessionNotice =>
      'Seus dados ficam apenas nesta sessão e serão apagados ao reiniciar o app.';

  @override
  String get emergencyContact => 'Contato de emergência';

  @override
  String get addContact => 'Adicionar contato';

  @override
  String get contactSubtitle => 'Opcional. Cadastre alguém de sua confiança.';

  @override
  String get contactName => 'Nome do contato';

  @override
  String get contactNameError => 'Informe o nome do contato.';

  @override
  String get phone => 'Telefone com DDD';

  @override
  String get phoneHint => '(11) 99999-9999';

  @override
  String get phoneError => 'Informe um telefone válido com DDD.';

  @override
  String get relationship => 'Vínculo (opcional)';

  @override
  String get relationshipHint => 'Ex.: mãe, amigo, companheiro';

  @override
  String get saveContact => 'Salvar contato';

  @override
  String get cancel => 'Cancelar';

  @override
  String get readingSubtitle => 'Registre uma nova medição de glicemia.';

  @override
  String get glucoseField => 'Glicemia (mg/dL)';

  @override
  String get valueError => 'Informe um valor válido.';

  @override
  String get readingMoment => 'Momento da medição';

  @override
  String get insulinField => 'Insulina utilizada (UI) — opcional';

  @override
  String get insulinHint => 'Ex.: 2,5';

  @override
  String get insulinError => 'Informe uma quantidade válida em UI.';

  @override
  String get saveReading => 'Salvar medição';

  @override
  String get memoryNotice => 'Os dados ficam apenas em memória nesta versão.';

  @override
  String get readingSaved => 'Medição adicionada nesta sessão.';

  @override
  String get filterDate => 'Filtrar por data';

  @override
  String get selectPeriod => 'Selecione o período';

  @override
  String get apply => 'Aplicar';

  @override
  String get clearPeriod => 'Limpar período';

  @override
  String get moreFilters => 'Ver mais filtros à direita';

  @override
  String get iconLabel => 'Ícone GlicNote';

  @override
  String get all => 'Todos';

  @override
  String get fasting => 'Jejum';

  @override
  String get afterBreakfast => 'Após café';

  @override
  String get afterLunch => 'Após almoço';

  @override
  String get afterSnack => 'Após lanche';

  @override
  String get afterDinner => 'Após janta';

  @override
  String get other => 'Outro';

  @override
  String get insulinUnit => 'UI';

  @override
  String lastReading(String date, String time) {
    return 'Última aferição: $date às $time';
  }

  @override
  String readingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count registros',
      one: '1 registro',
    );
    return '$_temp0';
  }

  @override
  String insulinAmount(String amount) {
    return '$amount UI';
  }

  @override
  String get loginTitle => 'Seu cuidado começa aqui';

  @override
  String get loginSubtitle =>
      'Entre com sua conta Google para acessar o GlicNote.';

  @override
  String get signInWithGoogle => 'Entrar com Google';

  @override
  String get signOut => 'Sair da conta';

  @override
  String get loginError => 'Não foi possível entrar. Tente novamente.';

  @override
  String get accountLoadError =>
      'Não foi possível carregar sua conta. Verifique a conexão e tente novamente.';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get noReadingsTitle => 'Sua primeira aferição';

  @override
  String get noReadingsDescription =>
      'Registre uma medição para começar seu acompanhamento.';

  @override
  String get refresh => 'Atualizar';

  @override
  String get loading => 'Carregando…';

  @override
  String get syncError =>
      'Não foi possível carregar os dados. Toque em atualizar para tentar novamente.';

  @override
  String get saveError =>
      'Não foi possível salvar. Confira sua conexão e tente novamente.';

  @override
  String get profileSaveError =>
      'Não foi possível salvar o perfil. Confira os dados e se o nome de usuário está disponível.';

  @override
  String get username => 'Nome de usuário';

  @override
  String get usernameError => 'Use de 3 a 30 letras minúsculas, números ou _.';

  @override
  String get internationalPhoneError =>
      'Inclua o código do país, por exemplo +55 48 99999-1234.';

  @override
  String get duplicateReading =>
      'Já existe uma aferição para esse momento neste dia. Confira o histórico antes de registrar novamente.';

  @override
  String get duplicateOtherReading =>
      'Já existe um registro de “Outro” neste exato horário. Confira o histórico antes de registrar novamente.';

  @override
  String get today => 'Hoje';

  @override
  String get privacyPolicy => 'Política de privacidade';

  @override
  String get privacyVersion => 'Versão preliminar 0.3 • 22/10/2026';

  @override
  String get privacyDraft =>
      'Esta política está em revisão. O canal de contato, os prazos de retenção e as bases legais precisam ser definidos antes da publicação definitiva.';

  @override
  String get privacyResponsibleTitle => 'Quem é responsável';

  @override
  String get privacyResponsibleBody =>
      'A Tech Mow é responsável pelo GlicNote. O e-mail para assuntos de privacidade ainda será informado nesta política.';

  @override
  String get privacyDataTitle => 'Dados que usamos';

  @override
  String get privacyDataBody =>
      'No login Google, recebemos identificador, nome, e-mail e endereço da foto de perfil. Você pode informar nome de usuário, data de nascimento completa e tipo de diabetes (opcionais), aferições de glicemia, insulina, momento e horário da medição e contato de emergência. O servidor registra o fuso e o dia local da aferição. Dados de saúde são dados pessoais sensíveis. Informe dados de terceiros, como o contato de emergência, com conhecimento dessa pessoa.';

  @override
  String get privacyPurposeTitle => 'Para que usamos os dados';

  @override
  String get privacyPurposeBody =>
      'Usamos os dados para identificar sua conta, manter sua sessão, organizar seu histórico, calcular médias e sua idade e apresentar seu perfil e contato de emergência. O serviço não acessa sua senha Google, Gmail ou Drive. Esta versão não inclui publicidade ou ferramentas de analytics no app.';

  @override
  String get privacySessionTitle => 'Sessão e foto de perfil';

  @override
  String get privacySessionBody =>
      'A sessão fica salva no dispositivo para evitar novos logins a cada abertura. Sair da conta remove a sessão local, mas mantém os dados no servidor. A foto é carregada do endereço fornecido pelo Google; esse acesso pode transmitir seu endereço IP e informações técnicas ao servidor de imagens.';

  @override
  String get privacySharingTitle => 'Privacidade e compartilhamento';

  @override
  String get privacySharingBody =>
      'Seu histórico e contato de emergência são privados. Nenhuma aferição é publicada automaticamente. Os recursos sociais previstos permitem compartilhar conteúdos escolhidos por você com pessoas aprovadas para acompanhar sua conta; essas telas ainda não estão disponíveis nesta versão do app.';

  @override
  String get privacyProvidersTitle => 'Serviços e armazenamento';

  @override
  String get privacyProvidersBody =>
      'O Google participa da autenticação e do fornecimento da foto. O Supabase hospeda a autenticação e o banco de dados; o projeto atual usa uma região nos Estados Unidos. O Render hospeda a API do GlicNote. Esses serviços podem tratar dados em outros países, conforme suas configurações e condições.';

  @override
  String get privacyRetentionTitle => 'Retenção e segurança';

  @override
  String get privacyRetentionBody =>
      'Utilizamos autenticação, controle de acesso na API e conexões protegidas com o banco. As aferições permanecem no servidor após fechar o app ou sair da conta. A Tech Mow ainda precisa definir e documentar prazos de retenção, tratamento de backups e procedimento de exclusão. Não há garantia de segurança absoluta.';

  @override
  String get privacyRightsTitle => 'Seus direitos e solicitações';

  @override
  String get privacyRightsBody =>
      'Você pode solicitar informações sobre o uso dos seus dados, acesso, correção e, nas hipóteses aplicáveis, exclusão, portabilidade e revogação de consentimento. O canal de atendimento será informado aqui. Esta versão ainda não possui exportação nem exclusão automática da conta no app; sair da conta não exclui a conta ou as aferições. Ler esta política ou entrar com Google não substitui consentimento específico quando ele for necessário.';

  @override
  String get privacyUpdatesTitle => 'Atualizações';

  @override
  String get privacyUpdatesBody =>
      'Esta política será atualizada conforme o GlicNote evoluir. Mudanças de finalidades, compartilhamento, provedores, retenção ou contato devem ser refletidas nesta página e na versão pública. O GlicNote serve para organização pessoal e não substitui acompanhamento profissional de saúde.';

  @override
  String get completeRegistration => 'Complete seu cadastro';

  @override
  String get additionalDetails => 'Dados complementares';

  @override
  String get registrationHint =>
      'Nome de usuário, nascimento e tipo de diabetes';

  @override
  String get registrationDescription =>
      'Escolha seu nome de usuário e, se quiser, informe sua data de nascimento e o tipo de diabetes. Esses dados ficam no seu perfil privado.';

  @override
  String get googleIdentityHint =>
      'Nome e e-mail vêm da sua conta Google e não podem ser editados aqui.';

  @override
  String get birthDate => 'Data de nascimento — opcional';

  @override
  String get birthDateHint =>
      'Usada para mostrar sua idade e reconhecer seu aniversário.';

  @override
  String get clearBirthDate => 'Remover data de nascimento';

  @override
  String get timeZone => 'Fuso horário';

  @override
  String get timeZoneHint => 'Preenchido de acordo com o dispositivo.';

  @override
  String ageYears(int age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other: '$age anos',
      one: '1 ano',
    );
    return '$_temp0';
  }

  @override
  String get diabetesType => 'Tipo de diabetes';

  @override
  String get diabetesTypeField => 'Tipo de diabetes — opcional';

  @override
  String get diabetesTypeOne => 'Tipo 1';

  @override
  String get diabetesTypeTwo => 'Tipo 2';

  @override
  String get notProvided => 'Não informado';
}
