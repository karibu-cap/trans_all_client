// ignore_for_file: long-method

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:karibu_core_internationalization/internationalization.dart';

/// AppInternalization defines all the 'local' strings displayed to
/// the user.
/// Local strings are strings that do not come from a database.
/// e.g: error messages, page titles.
class AppInternationalization extends Translations {
  final Locale _locale;

  static final Map<String, String> _placeholder = {
    LocalizedString.defaultLanguage: LocalizedString.placeholder,
  };

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
          'payMethod': 'Payment method',
          'selectPayMethod': 'Select a payment method.',
          'transferDetail': 'Transfer detail',
          'payLabelTextNumber': 'Payer number',
          'creditedLabelNumber': 'Number to credit',
          'creditedAmount': 'Amount to credit',
          'proceed': 'Proceed',
          'history': 'History',
          'home': 'Home',
          'share': 'Share',
          'howItWorks': 'How It Works',
          'amount': 'Amount',
          'from': 'From',
          'to': 'To',
          'status': 'Status',
          'noTransferHistory': 'No History Found',
          'raison': 'Raison',
          'retry': 'Try Again',
          'since': 'Since',
          'days': 'day(s)',
          'reproduce': 'Reproduce',
          'errorEmptyNumberField': 'Please enter a number',
          'errorEmptyAmountField': 'Please enter an amount',
          'errorSelectedPaymentMode': 'Please select a payment methode',
          'greaterThan': 'greater than',
          'lessThan': 'less than',
          'number': 'number',
          'invalid': 'invalid',
          'unsupportedOperator': 'Unsupported operator',
          'unsupportedPaymentMethod': 'Unsupported payment method',
          'invalidNumber': 'Invalid number',
          'transferOf': 'Transfer of @amountToPay',
          'initializationOfTransfer': 'Please wait. We make your transfer.',
          'appName': 'TransAll',
          'welcome':
              'Gain efficiency and serenity with our transfer management solution.',
          'next': 'Next',
          'successTransaction': 'Your transaction was successful',
          'failedTransfer': 'Your transaction was fail',
          'payer': 'Payer',
          'receiver': 'Receiver',
          'waitingPaymentValidation': 'Waiting for payment validation.',
          'paymentValidationFailure': 'Payment validation failure.',
          'or': ' or ',
          'getStart': 'Get Started',
          'initTransferMessage': 'We make your transfer.',
          'failTransferMessage':
              'Please wait a few moments, we will restart your transfer.',
          'emptyPaymentGateway': 'No payment method available.',
          'emptyTransfer': 'No transfer operator available.',
          'receiverNumber': 'Receive Number',
          'availablePayment': 'Payment available',
          'iniCreditTransfer': 'Init Credit Transfer',
          'waitingPaymentValidation_1': 'Your transaction has been initiated.',
          'waitingPaymentValidation_2':
              'Once the payment message has been received, dial the @code to finalize the payment.',
          'transactionId': 'Transaction Id',
          'noInternetConnection': 'No access to the Internet.',
          'initPayment': 'Initialisation of payemnt',
          'invalidGatewayNumber': 'Invalid @gateway number.',
          'availableOperator': 'Available Transfer',
          'prev': 'Previous',
          'complete': 'Complete',
          'of': 'Of',
          'availablePaymentDescription':
              'The available payment services to which the amount to be paid could be debited.',
          'availableOperatorDescription':
              'The available services allow the transfer for airtime or forfait transfers.',
          'contact': 'Contacts',
          'contactRequestMessage':
              'Please activate the contact access for a better experience.',
          'allowAccess': 'Allow access',
          'selectBuyerContactMessage':
              "Select the payer's number from your contacts.",
          'selectReceiverContactMessage':
              'Select the number to be credited from your contacts.',
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
              'Do you confirm the addition of @number as default payment number?',
          'confirmation': 'Confirmation',
          'contactAccessAdvantage1':
              'Directly select a payment contact or a contact to be credited.',
          'contactAccessAdvantage2': 'Autocomplete input fields.',
          'signalOnInternetAbsent':
              'Please connect to the Internet before continuing.',
          'airtimeHistory': 'History',
          'pendingTransaction': 'Pending transfers',
          'numberSaveSuccessful': 'Number saved successfully.',
          'invalidAmount': 'Invalid amount',
          'today': 'Today',
          'anErrorOccurred': 'An error or network error occurred.',
          'buyerPhoneNumber': 'Buyer Number',
          'paymentOperator': 'Payment operator',
          'noContactFound': 'No contact found.',
          'selectDefaultBuyerContactMessage':
              'Select the payer number from the registered payment numbers',
          'pendingTransfer': 'Pending transfers',
          'yesterday': 'Yesterday',
        },
        'fr': {
          'iniCreditTransfer': 'Transfert De Credit Initié',
          'primaryTitle': 'Flutter Page Principal Demo',
          'buyAirtime': 'Acheter Du Credit',
          'moneyTransfer': "Transfert D'argent",
          'transTu': 'TransAll',
          'payMethod': 'Methode de payment',
          'selectPayMethod': 'Sélectionnez une methode de paiement.',
          'transferDetail': 'Détail de transfert',
          'payLabelTextNumber': 'Numéro de payment',
          'creditedLabelNumber': 'Numéro à créditer',
          'creditedAmount': 'Montant à créditer',
          'proceed': 'Procéder',
          'history': 'Historique',
          'home': 'Acceuil',
          'share': 'Partager',
          'howItWorks': 'Comment ça marche',
          'amount': 'Montant',
          'from': 'De',
          'to': 'Vers',
          'status': 'Status',
          'noTransferHistory': 'Aucun historique trouvé',
          'raison': 'Raison',
          'retry': 'Réessayer',
          'since': "Il y'a",
          'days': 'jour(s)',
          'reproduce': 'Clone',
          'errorEmptyNumberField': 'Veuillez saisir un numéro',
          'errorEmptyAmountField': 'Veuillez saisir un montant',
          'errorSelectedPaymentMode':
              'Veuillez selectioner une methode de payment',
          'greaterThan': 'supérieur à',
          'lessThan': 'inférieur à',
          'number': 'numéro',
          'invalid': 'non valide',
          'unsupportedOperator': 'Operateur non supporté',
          'unsupportedPaymentMethod': 'Methode de payment non supporté',
          'invalidNumber': 'Numéro invalid',
          'transferOf': 'Transfert de @amountToPay',
          'initializationOfTransfer':
              'Veuillez patienter. Nous éffectuons votre transfert.',
          'appName': 'TransAll',
          'welcome':
              'Gagnez en efficacité et en sérénité grâce à notre solution de gestion de transfert.',
          'next': 'Suivant',
          'successTransaction': 'Votre transaction a été effectuée avec succès',
          'failedTransfer': 'Votre transaction a échoué',
          'payer': 'Payeur',
          'receiver': 'Bénéficiaire',
          'waitingPaymentValidation':
              'En attente de la validation du paiement.',
          'paymentValidationFailure': 'Échec de validation du payment',
          'or': ' ou ',
          'getStart': 'Démarrer',
          'initTransferMessage': 'Nous effectuons votre transfert.',
          'failTransferMessage':
              'Veuillez patienter quelques instants, nous allons redémarrer votre transfert.',
          'emptyPaymentGateway': 'Aucun mode de paiement disponible.',
          'emptyTransfer': 'Aucun operateur de transfert disponible.',
          'receiverNumber': 'Numero du destinataire',
          'initPayment': 'Initialisation du payment',
          'availablePayment': 'Methode De Paiement',
          'waitingPaymentValidation_1': 'Votre transaction a été initiée.',
          'waitingPaymentValidation_2':
              'Une fois le message de paiement reçu, composez le @code pour finaliser le paiement.',
          'transactionId': 'Transaction Id',
          'noInternetConnection': 'Aucun accès à internet.',
          'invalidGatewayNumber': 'Numéro @gateway invalide.',
          'availableOperator': 'Transfert Disponible',
          'prev': 'Précédent',
          'complete': 'Terminer',
          'of': 'Sur',
          'availablePaymentDescription':
              'Les services de paiement disponible sur lequel le montant à payer pourra etre  débité.',
          'availableOperatorDescription':
              'Les services disponibles permettent le transfert de crédits ou de forfait.',
          'contact': 'Contacts',
          'contactRequestMessage':
              "Veuillez activer l'accès au contact pour une meilleure expérience.",
          'allowAccess': "Autoriser l'accès",
          'selectBuyerContactMessage':
              'Sélectionnez le numéro du payeur parmis vos contacts.',
          'selectReceiverContactMessage':
              'Sélectionnez le numéro à crediter à partir de vos contacts.',
          'pay': 'Payer',
          'saveContactNumber': 'Numéros de paiement',
          'buyerPhoneNumber': 'Numéro du créditeur',
          'emptyBuyerContactsList': 'Aucun contacts de paiement trouvé.',
          'noResultFound': 'Aucun résultat trouvé.',
          'airtime': 'Credit',
          'confirmation': 'Confirmation',
          'noThank': 'Non, Merci',
          'yes': 'Oui!',
          'transactionType': 'Type de transaction',
          'success': 'Reussit!',
          'numberSaveSuccessful': 'Numéro sauvegardé avec succès.',
          'setAsDefaultBuyer': 'Definir comme payeur par defaut',
          'search': 'Recherche',
          'ooops': 'Oooops!',
          'newTransaction': 'Nouvelle Transaction',
          'goToHistory': "Aller Vers L'histoire",
          'airtimeHistory': 'Historique',
          'by': 'Via',
          'pending': 'En attente',
          'ok': 'Ok',
          'succeed': 'Terminé',
          'allowContactAccess': "Autoriser l'accès aux contacts!",
          'cancelled': 'Annulé',
          'advantages': 'Avantages',
          'noContactFound': 'Aucun contact trouvé.',
          'waitMessage': 'Veuillez patienter.',
          'contactAccessAdvantage1':
              'Sélectionnez directement un contact de paiement ou un contact à créditer.',
          'contactAccessAdvantage2': 'Champs de saisie automatique.',
          'signalOnInternetAbsent':
              'Veuillez vous connecter enfin de continuer.',
          'pendingTransfer': 'Transferts en attente',
          'today': "Aujourd'hui",
          'paymentOperator': 'Operateur de payment',
          'yesterday': 'Hier',
          'buildNumber': 'Numéro de build',
          'version': 'Version',
          'anErrorOccurred':
              'Une erreur ou une mauvaise connexion a été détectée.',
          'confirmSetAsDefault':
              "Confirmer vous l'ajout de @number comme numero de payment par default?",
          'invalidAmount': 'Montant invalide',
          'selectDefaultBuyerContactMessage':
              'Sélectionnez le numéro du payeur parmi les numéros de paiement enregistrés',
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

  /// Returns the localized value of initTransferMessage.
  String get initTransferMessage {
    return _stringOfLocalizedValue(
      'initTransferMessage',
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

  /// Returns the localized value of failedTransfer.
  String get failedTransfer {
    return _stringOfLocalizedValue(
      'failedTransfer',
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

  /// Returns the localized value of payMethod.
  String get payMethod {
    return _stringOfLocalizedValue(
      'payMethod',
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

  /// Constructor of [AppInternationalization].
  AppInternationalization(this._locale);
}
