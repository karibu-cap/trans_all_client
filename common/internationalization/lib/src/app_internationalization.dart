// ignore_for_file: long-method

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

/// AppInternalization defines all the 'local' strings displayed to
/// the user.
/// Local strings are strings that do not come from a database.
/// e.g: error messages, page titles.
class AppInternationalization extends Translations {
  final Locale _locale;

  /// The locales supported by the application.
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('fr'),
  ];

  // Loaded from a map, but will eventually be loaded from a JSON
  // file.
  @override
  Map<String, Map<String, String>> get keys => {
        'en': {
          'primaryTitle': 'Flutter Demo Home Page',
          'buyAirtime': 'Buy Airtime',
          'moneyTransfer': 'Money Transfer',
          'transTu': 'TransAll',
          'buildNumber': 'Build Number',
          'version': 'Version',
          'selectPayMethod': 'Select a method of payment.',
          'transferDetail': 'Details of transfer',
          'payLabelTextNumber': 'Payer number',
          'creditedLabelNumber': 'Beneficiary number',
          'creditedAmount': 'Amount to credit',
          'proceed': 'Proceed',
          'history': 'History',
          'home': 'Home',
          'share': 'Share',
          'howItWorks': 'How does it work?',
          'amount': 'Amount',
          'from': 'From',
          'to': 'To',
          'status': 'Status',
          'noTransferHistory': 'No history found',
          'raison': 'Raison',
          'retry': 'Try Again',
          'since': 'Since',
          'refresh': 'Refresh',
          'days': 'day(s)',
          'reproduce': 'Reproduce',
          'errorEmptyNumberField': 'Please enter a number',
          'errorEmptyAmountField': 'Please enter an amount',
          'errorSelectedPaymentMode': 'Please select a payment method',
          'greaterThan': 'greater than',
          'lessThan': 'less than',
          'number': 'number',
          'invalid': 'invalid',
          'unsupportedOperator': 'Unsupported operator',
          'unsupportedPaymentMethod': 'Unsupported payment method',
          'invalidNumber': 'Invalid number',
          'transferOf': 'Transfer of @amountToPay',
          'initializationOfTransfer':
              'Please be patient while we conduct your transfer.',
          'appName': 'TransAll',
          'welcome':
              'Gain efficiency and peace of mind with our transfer management solution.',
          'next': 'Next',
          'successTransaction': 'Your transaction  was successful',
          'failedTransferMessage': 'Your transaction failed',
          'payer': 'Payer',
          'receiver': 'Receiver',
          'waitingPaymentValidation': 'Waiting for payment validation.',
          'paymentValidationFailure': 'Payment validation failure.',
          'or': ' or ',
          'getStart': 'Get Started',
          'failTransferMessage':
              'Please be patient while we restart your transfer.',
          'emptyPaymentGateway': 'No payment method available.',
          'emptyPaymentGatewayOrOperation':
              'No payment method or operator available.',
          'emptyTransfer': 'No transfer operator available.',
          'receiverNumber': 'Receiver Number',
          'availablePayment': 'Payment method(s)',
          'iniCreditTransfer': 'Credit transfer initiated',
          'waitingPaymentValidation_1': 'Your transaction has been initiated.',
          'waitingPaymentValidation_2':
              'Once you\'ve received the payment message, enter the @code to finalize the payment.',
          'transactionId': 'Transaction ID',
          'noInternetConnection': 'No connection.',
          'initPayment': 'Payment initiation',
          'invalidGatewayNumber': 'Invalid @gateway number.',
          'availableOperator': 'Available operator(s)',
          'prev': 'Previous',
          'complete': 'Complete',
          'of': 'Of',
          'availablePaymentDescription': 'Services enabling payment.',
          'availableOperatorDescription':
              'Services enabling airtime transfers.',
          'contact': 'Contacts',
          'contactRequestMessage':
              'Please activate the contact access for a better experience.',
          'allowAccess': 'Allow access',
          'selectBuyerContactMessage':
              "Select the payer's number from your contacts.",
          'selectReceiverContactMessage':
              'Select the beneficiary\'s number from your contacts.',
          'pay': 'Pay',
          'saveContactNumber': 'Payment number',
          'emptyBuyerContactsList': 'No payment contact number found.',
          'noResultFound': 'No result found.',
          'airtime': 'Airtime',
          'noThank': 'No, thanks',
          'yes': 'Yes!',
          'search': 'Search',
          'success': 'Success!',
          'ooops': 'Oooops!',
          'goToHistory': 'Go To History',
          'newTransaction': 'New Transaction',
          'by': 'By',
          'pending': 'Pending',
          'succeed': 'Succeed',
          'cancelled': 'Cancelled',
          'waitMessage': 'Please wait',
          'transactionType': 'Transaction Type',
          'ok': 'Ok',
          'advantages': 'Advantages',
          'allowContactAccess': 'Allow access to your contacts!',
          'setAsDefaultBuyer': 'Set as default buyer',
          'confirmSetAsDefault':
              'Do you confirm the addition of @number as the default payment number?',
          'confirmation': 'Confirmation',
          'contactAccessAdvantage1':
              'Directly select a buyer contact or a beneficiary contact.',
          'contactAccessAdvantage2': 'Auto-complete fields.',
          'signalOnInternetAbsent':
              'Please connect to the Internet before continuing.',
          'airtimeHistory': 'History',
          'chooseNumberToSend':
              'If yes, choose the number that will receive the sms',
          'pendingTransaction': 'Pending transfers',
          'numberSaveSuccessful': 'Number saved successfully.',
          'invalidAmount': 'Invalid amount',
          'today': 'Today',
          'contactRefreshed': 'Contact refreshed.',
          'anErrorOccurred':
              'An error occurred, please try again. If the problem persist, contact support.',
          'buyerPhoneNumber': 'Buyer Number',
          'paymentOperator': 'Payment Method',
          'noContactFound': 'No contact found.',
          'selectDefaultBuyerContactMessage':
              'Select the payer number from the registered payment numbers',
          'pendingTransfer': 'Pending transfers',
          'yesterday': 'Yesterday',
          'sentRequestBySmsTitle': 'Do you want to send your request by sms?',
          'TransAll': 'TransAll',
          'connectionRestore': 'Connection restored',
          'forfeit': 'Forfeit',
          'day': 'day',
          'month': 'month',
          'week': 'week',
          'noForfeitFound': 'No forfeit found',
          'forfeitSelected': 'Forfeit Selected',
          'call': 'call',
          'troubleInternetConnection': 'Trouble with internet connection.',
          'sms': 'sms',
          'all': 'All',
          'data': 'data',
          'insufficientFund':
              'The buyer account @number is unsuficient for the current operation.',
          'cancel': 'Cancel',
          'transactionCancelled': 'Transaction cancelled',
          'no': 'No',
          'chatHelperMessage': 'Hello, Need help?',
          'chatServiceMessage':
              'You will be redirected to our customer service in order to get some assistance.',
          'shareTransAllLinkMessage': 'Hello,'
              'I use Transall to buy or renew data bundle. It\'s fast, secure and user-friendly '
              'do as I do by following this link to download ',
          'userNumberNotFound': 'The buyer phone number @number is not found.',
          'clientWithMultiplePendingTransfer':
              ' @receiverNumber already have ongoing transfer request. Please wait until it\'s finished.',
          'troubleWithProvider':
              'Unable to initialize the payment. Please try another payment method.',
          'unsupportedProvider':
              'The payment gateway is not longer supported. Please try another payment method.',
          'invalidFeatureProvider':
              'The operator choosen is not longer supported. Please try another operator.',
          'paymentFailed': 'PAYMENT FAILED',
          'paymentInitialized': 'PAYMENT INITIALIZED',
          'paymentPending': 'PENDING PAYMENT',
          'succeedTransfer': 'SUCCESSFUL TRANSFER',
          'waitingRequest': 'TRANSFER WAITING',
          'requestSend': 'TRANSFER PROCESSING',
          'failedTransfer': 'TRANSFER FAILED',
        },
        'fr': {
          'failedTransfer': 'TRAITEMENT ÉCHOUÉ',
          'requestSend': 'TRAITEMENT DU TRANSFERT',
          'waitingRequest': 'TRANSFERT EN COURS',
          'succeedTransfer': 'TRANSFERT REUSSI',
          'paymentPending': 'PAIEMENT EN COURS',
          'paymentInitialized': 'PAIEMENT INITIALISÉ',
          'paymentFailed': 'PAIEMENT ÉCHOUÉ',
          'invalidFeatureProvider':
              'L\' operateur choisi n\'est plus supporté. Veuillez essayer un autre operateur.',
          'unsupportedProvider':
              'La methode paiement choisie n\'est plus supporté. Veuillez essayer un autre moyen de paiement.',
          'troubleWithProvider':
              'Impossible d\'initialiser le paiement. Veuillez essayer un autre mode de paiement.',
          'clientWithMultiplePendingTransfer':
              '@receiverNumber a déjà un transfert en cours. Veuillez attendre qu\'il soit fini.',
          'userNumberNotFound': 'Le numero du payer @number est introuvable.',
          'shareTransAllLinkMessage': 'Salut,'
              'J\'utilise Transall pour acheter ou renouveler mes forfait et données internet. C\'est rapide, sûr et facile à utiliser '
              'fait comme moi en suivant ce lien pour télécharger ',
          'insufficientFund':
              'Le compte de @number est insuffisant pour effectuer cette opération.',
          'transactionCancelled': 'La transaction a été annulée.',
          'chatHelperMessage': 'Bonjour, Besoin d\'aide?',
          'chatServiceMessage':
              'Vous serez redirigé vers le service client afin de recevoir de l\'aide.',
          'no': 'Non',
          'call': 'appel',
          'cancel': 'Annuler',
          'all': 'Tout',
          'troubleInternetConnection': 'Problème de connexion internet.',
          'sms': 'sms',
          'data': 'internet',
          'forfeit': 'Forfait',
          'week': 'semaine',
          'month': 'mois',
          'noForfeitFound': 'Aucun forfait trouvé',
          'connectionRestore': 'De nouveau connecté',
          'iniCreditTransfer': 'Transfert de crédit initié',
          'sentRequestBySmsTitle': 'Voulez vous envoyer votre demande par sms?',
          'primaryTitle': 'Flutter Page Principal Demo',
          'buyAirtime': 'Acheter Du Crédit',
          'moneyTransfer': "Transfert D'argent",
          'transTu': 'TransAll',
          'selectPayMethod': 'Sélectionner un mode de paiement.',
          'transferDetail': 'Détail du transfert',
          'payLabelTextNumber': 'Numéro de paiement',
          'creditedLabelNumber': 'Numéro du bénéficiaire',
          'creditedAmount': 'Montant à créditer',
          'proceed': 'Poursuivre',
          'history': 'Historique',
          'home': 'Acceuil',
          'share': 'Partager',
          'howItWorks': 'Comment cela fonctionne-t-il ?',
          'amount': 'Montant',
          'from': 'De',
          'to': 'Vers',
          'status': 'Status',
          'noTransferHistory': 'Pas d\'historique trouvé',
          'raison': 'Raison',
          'retry': 'Réessayer',
          'since': "Il y'a",
          'days': 'jour(s)',
          'reproduce': 'Clone',
          'errorEmptyNumberField': 'Veuillez saisir un numéro',
          'errorEmptyAmountField': 'Veuillez saisir un montant',
          'errorSelectedPaymentMode':
              'Veuillez sélectionner un mode de paiement',
          'greaterThan': 'supérieur à',
          'lessThan': 'inférieur à',
          'number': 'numéro',
          'invalid': 'non valide',
          'unsupportedOperator': 'Opérateur non pris en charge.',
          'unsupportedPaymentMethod': 'Mode de paiement non prise en charge',
          'invalidNumber': 'Numéro invalid',
          'transferOf': 'Transfert de @amountToPay',
          'initializationOfTransfer':
              'Veuillez patienter, Nous éffectuons votre transfert.',
          'appName': 'TransAll',
          'welcome':
              'Gagnez en efficacité et en tranquillité d\'esprit grâce à notre solution de gestion des transferts.',
          'next': 'Suivant',
          'successTransaction': 'Votre transaction a été effectuée avec succès',
          'failedTransferMessage': 'Votre transaction a échoué',
          'payer': 'Payeur',
          'receiver': 'Bénéficiaire',
          'waitingPaymentValidation':
              'En attente de la validation du paiement.',
          'paymentValidationFailure': 'Échec de la validation du paiement.',
          'or': ' ou ',
          'getStart': 'Démarrer',
          'failTransferMessage':
              'Veuillez patienter quelques instants, nous allons relancer votre transfert.',
          'emptyPaymentGateway': 'Aucune méthode de paiement disponible.',
          'emptyPaymentGatewayOrOperation':
              'Aucune méthode de paiement ou operateur disponible.',
          'emptyTransfer': 'Pas d\'opérateur de transfert disponible.',
          'receiverNumber': 'Numéro du bénéficiaire',
          'initPayment': 'Initialisation du paiement',
          'availablePayment': 'Mode(s) De Paiement',
          'waitingPaymentValidation_1': 'Votre transaction a été initiée.',
          'waitingPaymentValidation_2':
              'Une fois que vous avez reçu le message de paiement, saisissez le @code pour finaliser le paiement.',
          'transactionId': 'Transaction Id',
          'noInternetConnection': 'Aucune connexion',
          'invalidGatewayNumber': 'Numéro @gateway non valide.',
          'availableOperator': 'Opérateur(s) Disponible(s)',
          'prev': 'Précédent',
          'complete': 'Terminer',
          'of': 'Sur',
          'availablePaymentDescription':
              'Services permettant d\'effectuer des paiements.',
          'availableOperatorDescription':
              'Services permettant d\'effectuer des transferts de credit.',
          'contact': 'Contacts',
          'contactRequestMessage':
              "Veuillez activer l'accès aux contacts pour une meilleure expérience.",
          'allowAccess': "Autoriser l'accès",
          'selectBuyerContactMessage':
              'Sélectionnez le numéro du payeur dans vos contacts.',
          'selectReceiverContactMessage':
              'Sélectionnez le numéro du bénéficiaire dans vos contacts.',
          'pay': 'Payer',
          'saveContactNumber': 'Numéros de paiement',
          'buyerPhoneNumber': 'Numéro de paiement',
          'emptyBuyerContactsList':
              'Aucun contact de paiement n\'a été trouvé.',
          'noResultFound': 'Aucun résultat trouvé.',
          'airtime': 'Credit',
          'confirmation': 'Confirmation',
          'noThank': 'Non, Merci',
          'yes': 'Oui!',
          'transactionType': 'Type de transaction',
          'success': 'Reussit!',
          'numberSaveSuccessful': 'Numéro sauvegardé avec succès.',
          'setAsDefaultBuyer': 'Définir en tant que payeur par défaut',
          'search': 'Recherche',
          'ooops': 'Oooops!',
          'newTransaction': 'Nouvelle Transaction',
          'goToHistory': "Aller à l'historique",
          'airtimeHistory': 'Historique',
          'by': 'Via',
          'pending': 'En attente',
          'ok': 'Ok',
          'succeed': 'Terminé',
          'allowContactAccess': "Autoriser l'accès aux contacts!",
          'cancelled': 'Annulé',
          'advantages': 'Avantages',
          'noContactFound': 'Aucun contact n\'a été trouvé.',
          'waitMessage': 'Veuillez patienter.',
          'contactAccessAdvantage1':
              'Sélection directe du contact de paiement ou du bénéficiaire.',
          'contactAccessAdvantage2': 'Champs de saisie automatique.',
          'signalOnInternetAbsent':
              'Veuillez activer votre connexion internet pour continuer.',
          'pendingTransfer': 'Transferts en attente',
          'today': "Aujourd'hui",
          'paymentOperator': 'Mode de paiement',
          'yesterday': 'Hier',
          'buildNumber': 'Numéro de build',
          'version': 'Version',
          'refresh': 'Rafraîchir',
          'chooseNumberToSend':
              'Si oui, sélectionnez le numéro qui recevira votre demande',
          'anErrorOccurred':
              'Une erreur survenue veillez réessayer. Si le probleme persiste veuillez nous contacter.',
          'confirmSetAsDefault':
              "Confirmez-vous l'ajout de @number comme numéro de paiement par défaut ?",
          'contactRefreshed': 'Contact mis à jour',
          'invalidAmount': 'Montant non valide',
          'day': 'jour',
          'forfeitSelected': 'Forfait Selectionné',
          'selectDefaultBuyerContactMessage':
              'Sélectionnez le numéro du payeur parmi les numéros de paiement enregistrés',
          'TransAll': 'TransAll',
        },
      };

  /// Update the current locale.
  void setLocale(Locale locale) {
    if (locale == _locale) return;
    Get.updateLocale(locale);
  }

  /// Get the current language code.
  Locale get locale => _locale;

  String _stringOfLocalizedValue(
    String value,
  ) {
    return value.tr;
  }

  /// Returns the localized value of failedTransfer.
  String get failedTransfer {
    return _stringOfLocalizedValue(
      'failedTransfer',
    );
  }

  /// Returns the localized value of requestSend.
  String get requestSend {
    return _stringOfLocalizedValue(
      'requestSend',
    );
  }

  /// Returns the localized value of waitingRequest.
  String get waitingRequest {
    return _stringOfLocalizedValue(
      'waitingRequest',
    );
  }

  /// Returns the localized value of succeedTransfer.
  String get succeedTransfer {
    return _stringOfLocalizedValue(
      'succeedTransfer',
    );
  }

  /// Returns the localized value of paymentPending.
  String get paymentPending {
    return _stringOfLocalizedValue(
      'paymentPending',
    );
  }

  /// Returns the localized value of paymentInitialized.
  String get paymentInitialized {
    return _stringOfLocalizedValue(
      'paymentInitialized',
    );
  }

  /// Returns the localized value of paymentFailed.
  String get paymentFailed {
    return _stringOfLocalizedValue(
      'paymentFailed',
    );
  }

  /// Returns the localized value of invalidFeatureProvider.
  String get invalidFeatureProvider {
    return _stringOfLocalizedValue(
      'invalidFeatureProvider',
    );
  }

  /// Returns the localized value of unsupportedProvider.
  String get unsupportedProvider {
    return _stringOfLocalizedValue(
      'unsupportedProvider',
    );
  }

  /// Returns the localized value of troubleWithProvider.
  String get troubleWithProvider {
    return _stringOfLocalizedValue(
      'troubleWithProvider',
    );
  }

  /// Returns the localized value of no.
  String get no {
    return _stringOfLocalizedValue(
      'no',
    );
  }

  /// Returns the localized value of all.
  String get all {
    return _stringOfLocalizedValue(
      'all',
    );
  }

  /// Returns the localized value of clientWithMultiplePendingTransfer.
  String get clientWithMultiplePendingTransfer {
    return _stringOfLocalizedValue(
      'clientWithMultiplePendingTransfer',
    );
  }

  /// Returns the localized value of transactionCancelled.
  String get transactionCancelled {
    return _stringOfLocalizedValue(
      'transactionCancelled',
    );
  }

  /// Returns the localized value of userNumberNotFound.
  String get userNumberNotFound {
    return _stringOfLocalizedValue(
      'userNumberNotFound',
    );
  }

  /// Returns the localized value of insufficientFund.
  String get insufficientFund {
    return _stringOfLocalizedValue(
      'insufficientFund',
    );
  }

  /// Returns the localized value of chatServiceMessage.
  String get chatServiceMessage {
    return _stringOfLocalizedValue(
      'chatServiceMessage',
    );
  }

  /// Returns the localized value of cancel.
  String get cancel {
    return _stringOfLocalizedValue(
      'cancel',
    );
  }

  /// Returns the localized value of chatHelperMessage.
  String get chatHelperMessage {
    return _stringOfLocalizedValue(
      'chatHelperMessage',
    );
  }

  /// Returns the localized value of shareTransAllLinkMessage.
  String get shareTransAllLinkMessage {
    return _stringOfLocalizedValue(
      'shareTransAllLinkMessage',
    );
  }

  /// Returns the localized value of call.
  String get call {
    return _stringOfLocalizedValue(
      'call',
    );
  }

  /// Returns the localized value of data.
  String get data {
    return _stringOfLocalizedValue(
      'data',
    );
  }

  /// Returns the localized value of emptyPaymentGatewayOrOperation.
  String get emptyPaymentGatewayOrOperation {
    return _stringOfLocalizedValue(
      'emptyPaymentGatewayOrOperation',
    );
  }

  /// Returns the localized value of sms.
  String get sms {
    return _stringOfLocalizedValue(
      'sms',
    );
  }

  /// Returns the localized value of month.
  String get month {
    return _stringOfLocalizedValue(
      'month',
    );
  }

  /// Returns the localized value of week.
  String get week {
    return _stringOfLocalizedValue(
      'week',
    );
  }

  /// Returns the localized value of day.
  String get day {
    return _stringOfLocalizedValue(
      'day',
    );
  }

  /// Returns the localized value of forfeitSelected.
  String get forfeitSelected {
    return _stringOfLocalizedValue(
      'forfeitSelected',
    );
  }

  /// Returns the localized value of forfeit.
  String get forfeit {
    return _stringOfLocalizedValue(
      'forfeit',
    );
  }

  /// Returns the localized value of noForfeitFound.
  String get noForfeitFound {
    return _stringOfLocalizedValue(
      'noForfeitFound',
    );
  }

  /// Returns the localized value of contactRefreshed.
  String get contactRefreshed {
    return _stringOfLocalizedValue(
      'contactRefreshed',
    );
  }

  /// Returns the localized value of connectionRestore.
  String get connectionRestore {
    return _stringOfLocalizedValue(
      'connectionRestore',
    );
  }

  /// Returns the localized value of refresh.
  String get refresh {
    return _stringOfLocalizedValue(
      'refresh',
    );
  }

  /// Returns the localized value of chooseNumberToSend.
  String get chooseNumberToSend {
    return _stringOfLocalizedValue(
      'chooseNumberToSend',
    );
  }

  /// Returns the localized value of sentRequestBySmsTitle.
  String get sentRequestBySmsTitle {
    return _stringOfLocalizedValue(
      'sentRequestBySmsTitle',
    );
  }

  /// Returns the localized value of version.
  String get version {
    return _stringOfLocalizedValue(
      'version',
    );
  }

  /// Returns the localized value of buildNumber.
  String get buildNumber {
    return _stringOfLocalizedValue(
      'buildNumber',
    );
  }

  /// Returns the localized value of anErrorOccurred.
  String get anErrorOccurred {
    return _stringOfLocalizedValue(
      'anErrorOccurred',
    );
  }

  /// Returns the localized value of transactionType.
  String get transactionType {
    return _stringOfLocalizedValue(
      'transactionType',
    );
  }

  /// Returns the localized value of paymentOperator.
  String get paymentOperator {
    return _stringOfLocalizedValue(
      'paymentOperator',
    );
  }

  /// Returns the localized value of confirmSetAsDefault.
  String get confirmSetAsDefault {
    return _stringOfLocalizedValue(
      'confirmSetAsDefault',
    );
  }

  /// Returns the localized value of buyerPhoneNumber.
  String get buyerPhoneNumber {
    return _stringOfLocalizedValue(
      'buyerPhoneNumber',
    );
  }

  /// Returns the localized value of yesterday.
  String get yesterday {
    return _stringOfLocalizedValue(
      'yesterday',
    );
  }

  /// Returns the localized value of today.
  String get today {
    return _stringOfLocalizedValue(
      'today',
    );
  }

  /// Returns the localized value of noContactFound.
  String get noContactFound {
    return _stringOfLocalizedValue(
      'noContactFound',
    );
  }

  /// Returns the localized value of advantages.
  String get advantages {
    return _stringOfLocalizedValue(
      'advantages',
    );
  }

  /// Returns the localized value of contactAccessAdvantage1.
  String get contactAccessAdvantage1 {
    return _stringOfLocalizedValue(
      'contactAccessAdvantage1',
    );
  }

  /// Returns the localized value of contactAccessAdvantage2.
  String get contactAccessAdvantage2 {
    return _stringOfLocalizedValue(
      'contactAccessAdvantage2',
    );
  }

  /// Returns the localized value of signalOnInternetAbsent.
  String get signalOnInternetAbsent {
    return _stringOfLocalizedValue(
      'signalOnInternetAbsent',
    );
  }

  /// Returns the localized value of pending.
  String get pending {
    return _stringOfLocalizedValue(
      'pending',
    );
  }

  /// Returns the localized value of allowContactAccess.
  String get allowContactAccess {
    return _stringOfLocalizedValue(
      'allowContactAccess',
    );
  }

  /// Returns the localized value of succeed.
  String get succeed {
    return _stringOfLocalizedValue(
      'succeed',
    );
  }

  /// Returns the localized value of cancelled.
  String get cancelled {
    return _stringOfLocalizedValue(
      'cancelled',
    );
  }

  /// Returns the localized value of pendingTransfer.
  String get pendingTransfer {
    return _stringOfLocalizedValue(
      'pendingTransfer',
    );
  }

  /// Returns the localized value of airtimeHistory.
  String get airtimeHistory {
    return _stringOfLocalizedValue(
      'airtimeHistory',
    );
  }

  /// Returns the localized value of goToHistory.
  String get goToHistory {
    return _stringOfLocalizedValue(
      'goToHistory',
    );
  }

  /// Returns the localized value of newTransaction.
  String get newTransaction {
    return _stringOfLocalizedValue(
      'newTransaction',
    );
  }

  /// Returns the localized value of ooops.
  String get ooops {
    return _stringOfLocalizedValue(
      'ooops',
    );
  }

  /// Returns the localized value of success.
  String get success {
    return _stringOfLocalizedValue(
      'success',
    );
  }

  /// Returns the localized value of search.
  String get search {
    return _stringOfLocalizedValue(
      'search',
    );
  }

  /// Returns the localized value of numberSaveSuccessful.
  String get numberSaveSuccessful {
    return _stringOfLocalizedValue(
      'numberSaveSuccessful',
    );
  }

  /// Returns the localized value of setAsDefaultBuyer.
  String get setAsDefaultBuyer {
    return _stringOfLocalizedValue(
      'setAsDefaultBuyer',
    );
  }

  /// Returns the localized value of noThank.
  String get noThank {
    return _stringOfLocalizedValue(
      'noThank',
    );
  }

  /// Returns the localized value of yes.
  String get yes {
    return _stringOfLocalizedValue(
      'yes',
    );
  }

  /// Returns the localized value of saveContactNumber.
  String get saveContactNumber {
    return _stringOfLocalizedValue(
      'saveContactNumber',
    );
  }

  /// Returns the localized value of confirmation.
  String get confirmation {
    return _stringOfLocalizedValue(
      'confirmation',
    );
  }

  /// Returns the localized value of invalidAmount.
  String get invalidAmount {
    return _stringOfLocalizedValue(
      'invalidAmount',
    );
  }

  /// Returns the localized value of emptyBuyerContactsList.
  String get emptyBuyerContactsList {
    return _stringOfLocalizedValue(
      'emptyBuyerContactsList',
    );
  }

  /// Returns the localized value of receiver.
  String get receiver {
    return _stringOfLocalizedValue(
      'receiver',
    );
  }

  /// Returns the localized value of pay.
  String get pay {
    return _stringOfLocalizedValue(
      'pay',
    );
  }

  /// Returns the localized value of selectBuyerContactMessage.
  String get selectBuyerContactMessage {
    return _stringOfLocalizedValue(
      'selectBuyerContactMessage',
    );
  }

  /// Returns the localized value of selectReceiverContactMessage.
  String get selectReceiverContactMessage {
    return _stringOfLocalizedValue(
      'selectReceiverContactMessage',
    );
  }

  /// Returns the localized value of allowAccess.
  String get allowAccess {
    return _stringOfLocalizedValue(
      'allowAccess',
    );
  }

  /// Returns the localized value of contact.
  String get contact {
    return _stringOfLocalizedValue(
      'contact',
    );
  }

  /// Returns the localized value of noResultFound.
  String get noResultFound {
    return _stringOfLocalizedValue(
      'noResultFound',
    );
  }

  /// Returns the localized value of contactRequestMessage.
  String get contactRequestMessage {
    return _stringOfLocalizedValue(
      'contactRequestMessage',
    );
  }

  /// Returns the localized value of availableOperator.
  String get availableOperator {
    return _stringOfLocalizedValue(
      'availableOperator',
    );
  }

  /// Returns the localized value of waitMessage.
  String get waitMessage {
    return _stringOfLocalizedValue(
      'waitMessage',
    );
  }

  /// Returns the localized value of transactionId.
  String get transactionId {
    return _stringOfLocalizedValue(
      'transactionId',
    );
  }

  /// Returns the localized value of initPayment.
  String get initPayment {
    return _stringOfLocalizedValue(
      'initPayment',
    );
  }

  /// Returns the localized value of iniCreditTransfer.
  String get iniCreditTransfer {
    return _stringOfLocalizedValue(
      'iniCreditTransfer',
    );
  }

  /// Returns the localized value of receiverNumber.
  String get receiverNumber {
    return _stringOfLocalizedValue(
      'receiverNumber',
    );
  }

  /// Returns the localized value of noInternetConnection.
  String get noInternetConnection {
    return _stringOfLocalizedValue(
      'noInternetConnection',
    );
  }

  /// Returns the localized value of troubleInternetConnection.
  String get troubleInternetConnection {
    return _stringOfLocalizedValue(
      'troubleInternetConnection',
    );
  }

  /// Returns the localized value of ok.
  String get ok {
    return _stringOfLocalizedValue(
      'ok',
    );
  }

  /// Returns the localized value of availablePayment.
  String get availablePayment {
    return _stringOfLocalizedValue(
      'availablePayment',
    );
  }

  /// Returns the localized value of availablePaymentDescription.
  String get availablePaymentDescription {
    return _stringOfLocalizedValue(
      'availablePaymentDescription',
    );
  }

  /// Returns the localized value of availableOperatorDescription.
  String get availableOperatorDescription {
    return _stringOfLocalizedValue(
      'availableOperatorDescription',
    );
  }

  /// Returns the localized value of emptyPaymentGateway.
  String get emptyPaymentGateway {
    return _stringOfLocalizedValue(
      'emptyPaymentGateway',
    );
  }

  /// Returns the localized value of emptyTransfer.
  String get emptyTransfer {
    return _stringOfLocalizedValue(
      'emptyTransfer',
    );
  }

  /// Returns the localized value of getStart.
  String get getStart {
    return _stringOfLocalizedValue(
      'getStart',
    );
  }

  /// Returns the localized value of or.
  String get or {
    return _stringOfLocalizedValue(
      'or',
    );
  }

  /// Returns the localized value of waitingPaymentValidation.
  String get waitingPaymentValidation {
    return _stringOfLocalizedValue(
      'waitingPaymentValidation',
    );
  }

  /// Returns the localized value of appName.
  String get appName {
    return _stringOfLocalizedValue(
      'appName',
    );
  }

  /// Returns the localized value of waitingPaymentValidation_2.
  String get waitingPaymentValidation_2 {
    return _stringOfLocalizedValue(
      'waitingPaymentValidation_2',
    );
  }

  /// Returns the localized value of waitingPaymentValidation_1.
  String get waitingPaymentValidation_1 {
    return _stringOfLocalizedValue(
      'waitingPaymentValidation_1',
    );
  }

  /// Returns the localized value of paymentValidationFailure.
  String get paymentValidationFailure {
    return _stringOfLocalizedValue(
      'paymentValidationFailure',
    );
  }

  /// Returns the localized value of failTransferMessage.
  String get failTransferMessage {
    return _stringOfLocalizedValue(
      'failTransferMessage',
    );
  }

  /// Returns the localized value of creditedLabelNumber.
  String get creditedLabelNumber {
    return _stringOfLocalizedValue(
      'creditedLabelNumber',
    );
  }

  /// Returns the localized value of initializationOfTransfer.
  String get initializationOfTransfer {
    return _stringOfLocalizedValue(
      'initializationOfTransfer',
    );
  }

  /// Returns the localized value of failedTransferMessage.
  String get failedTransferMessage {
    return _stringOfLocalizedValue(
      'failedTransferMessage',
    );
  }

  /// Returns the localized value of successTransaction.
  String get successTransaction {
    return _stringOfLocalizedValue(
      'successTransaction',
    );
  }

  /// Returns the localized value of welcome.
  String get welcome {
    return _stringOfLocalizedValue(
      'welcome',
    );
  }

  /// Returns the localized value of next.
  String get next {
    return _stringOfLocalizedValue(
      'next',
    );
  }

  /// Returns the localized value of of.
  String get of {
    return _stringOfLocalizedValue(
      'of',
    );
  }

  /// Returns the localized value of complete.
  String get complete {
    return _stringOfLocalizedValue(
      'complete',
    );
  }

  /// Returns the localized value of prev.
  String get prev {
    return _stringOfLocalizedValue(
      'prev',
    );
  }

  /// Returns the localized value of transTu.
  String get transTu {
    return _stringOfLocalizedValue(
      'transTu',
    );
  }

  /// Returns the localized value of transferOf.
  String get transferOf {
    return _stringOfLocalizedValue(
      'transferOf',
    );
  }

  /// Returns the localized value of primaryTitle.
  String get primaryTitle {
    return _stringOfLocalizedValue(
      'primaryTitle',
    );
  }

  /// Returns the localized value of greaterThan.
  String get greaterThan {
    return _stringOfLocalizedValue(
      'greaterThan',
    );
  }

  /// Returns the localized value of lessThan.
  String get lessThan {
    return _stringOfLocalizedValue(
      'lessThan',
    );
  }

  /// Returns the localized value of number.
  String get number {
    return _stringOfLocalizedValue(
      'number',
    );
  }

  /// Returns the localized value of unsupportedOperator.
  String get unsupportedOperator {
    return _stringOfLocalizedValue(
      'unsupportedOperator',
    );
  }

  /// Returns the localized value of unsupportedPaymentMethod.
  String get unsupportedPaymentMethod {
    return _stringOfLocalizedValue(
      'unsupportedPaymentMethod',
    );
  }

  /// Returns the localized value of invalid.
  String get invalid {
    return _stringOfLocalizedValue(
      'invalid',
    );
  }

  /// Returns the localized value of invalid.
  String get invalidNumber {
    return _stringOfLocalizedValue(
      'invalidNumber',
    );
  }

  /// Returns the localized value of invalidGatewayNumber.
  String get invalidGatewayNumber {
    return _stringOfLocalizedValue(
      'invalidGatewayNumber',
    );
  }

  /// Returns the localized value of errorEmptyAmountField.
  String get errorEmptyAmountField {
    return _stringOfLocalizedValue(
      'errorEmptyAmountField',
    );
  }

  /// Returns the localized value of errorEmptyNumberField.
  String get errorEmptyNumberField {
    return _stringOfLocalizedValue(
      'errorEmptyNumberField',
    );
  }

  /// Returns the localized value of errorSelectedPaymentMode.
  String get errorSelectedPaymentMode {
    return _stringOfLocalizedValue(
      'errorSelectedPaymentMode',
    );
  }

  /// Returns the localized value of reproduce.
  String get clone {
    return _stringOfLocalizedValue(
      'reproduce',
    );
  }

  /// Returns the localized value of since.
  String get since {
    return _stringOfLocalizedValue(
      'since',
    );
  }

  /// Returns the localized value of days.
  String get days {
    return _stringOfLocalizedValue(
      'days',
    );
  }

  /// Returns the localized value of noTransferHistory.
  String get noTransferHistory {
    return _stringOfLocalizedValue(
      'noTransferHistory',
    );
  }

  /// Returns the localized value of status.
  String get status {
    return _stringOfLocalizedValue(
      'status',
    );
  }

  /// Returns the localized value of raison.
  String get raison {
    return _stringOfLocalizedValue(
      'raison',
    );
  }

  /// Returns the localized value of amount.
  String get amount {
    return _stringOfLocalizedValue(
      'amount',
    );
  }

  /// Returns the localized value of from.
  String get from {
    return _stringOfLocalizedValue(
      'from',
    );
  }

  /// Returns the localized value of to.
  String get to {
    return _stringOfLocalizedValue(
      'to',
    );
  }

  /// Returns the localized value of buyAirtime.
  String get buyAirtime {
    return _stringOfLocalizedValue(
      'buyAirtime',
    );
  }

  /// Returns the localized value of moneyTransfer.
  String get moneyTransfer {
    return _stringOfLocalizedValue(
      'moneyTransfer',
    );
  }

  /// Returns the localized value of by.
  String get by {
    return _stringOfLocalizedValue(
      'by',
    );
  }

  /// Returns the localized value of selectPayMethod.
  String get selectPayMethod {
    return _stringOfLocalizedValue(
      'selectPayMethod',
    );
  }

  /// Returns the localized value of transferDetail.
  String get transferDetail {
    return _stringOfLocalizedValue(
      'transferDetail',
    );
  }

  /// Returns the localized value of payLabelTextNumber.
  String get payLabelTextNumber {
    return _stringOfLocalizedValue(
      'payLabelTextNumber',
    );
  }

  /// Returns the localized value of selectDefaultBuyerContactMessage.
  String get selectDefaultBuyerContactMessage {
    return _stringOfLocalizedValue(
      'selectDefaultBuyerContactMessage',
    );
  }

  /// Returns the localized value of payer.
  String get payer {
    return _stringOfLocalizedValue(
      'payer',
    );
  }

  /// Returns the localized value of creditedAmount.
  String get creditedAmount {
    return _stringOfLocalizedValue(
      'creditedAmount',
    );
  }

  /// Returns the localized value of proceed.
  String get proceed {
    return _stringOfLocalizedValue(
      'proceed',
    );
  }

  /// Returns the localized value of retry.
  String get retry {
    return _stringOfLocalizedValue(
      'retry',
    );
  }

  /// Returns the localized value of home.
  String get home {
    return _stringOfLocalizedValue(
      'home',
    );
  }

  /// Returns the localized value of historical.
  String get history {
    return _stringOfLocalizedValue(
      'history',
    );
  }

  /// Returns the localized value of airtime.
  String get airtime {
    return _stringOfLocalizedValue(
      'airtime',
    );
  }

  /// Returns the localized value of how it work.
  String get howItWorks {
    return _stringOfLocalizedValue(
      'howItWorks',
    );
  }

  /// Returns the localized value of share.
  String get share {
    return _stringOfLocalizedValue(
      'share',
    );
  }

  /// Returns the localized value of TransAll.
  String get transAll {
    return _stringOfLocalizedValue(
      'TransAll',
    );
  }

  /// Constructor of [AppInternationalization].
  AppInternationalization(this._locale);
}
