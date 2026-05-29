/// Static offline-payment details shown on the subscription renewal screen.
///
/// These are placeholders until the backend exposes an API for the QR code and
/// bank details. When that endpoint lands, fetch these values at runtime and
/// keep [qrImageUrl] pointing at the returned QR; the renewal UI already falls
/// back to a placeholder when [qrImageUrl] is null.
class SubscriptionPaymentInfo {
  const SubscriptionPaymentInfo._();

  static const String holderName = 'Tuoora Education';
  static const String bankName = 'HDFC Bank';
  static const String accountNumber = '50200087654321';
  static const String ifscCode = 'HDFC0001234';
  static const String upiId = 'tuoora@hdfc';

  /// Remote QR image URL. Null until the backend provides it — the UI shows a
  /// placeholder in that case.
  static const String? qrImageUrl = null;
}
