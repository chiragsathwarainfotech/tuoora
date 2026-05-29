class AppImages {
  // Base paths
  static const String _iconsPath = 'assets/icons';

  // --- Brand ---
  /// Full Tuoora logo with wordmark, used in the header of auth screens.
  static const String logoWithName = '$_iconsPath/logo_w_name.png';

  // --- Header & Navigation Icons ---
  static const String icBank = '$_iconsPath/ic_bank.svg';
  static const String icBell = '$_iconsPath/ic_bell.svg';

  // --- Fee Breakdown & Academic Icons ---
  static const String icTuition = '$_iconsPath/ic_tuition.svg';
  static const String icTransport = '$_iconsPath/ic_transport.svg';
  static const String icLab = '$_iconsPath/ic_lab.svg';
  static const String icCertificate = '$_iconsPath/ic_certificate.svg';

  // --- Payment History Icons ---
  static const String icVisa = '$_iconsPath/ic_visa.svg';
  static const String icApplePay = '$_iconsPath/ic_apple_pay.svg';
  static const String icDownload = '$_iconsPath/ic_download.svg';
  static const String icCalendar = '$_iconsPath/ic_calendar.svg';
  static const String icFilter = '$_iconsPath/ic_filter.svg';

  // --- Status & Tracking Icons ---
  static const String icCheck = '$_iconsPath/ic_check.svg';
  static const String icClose = '$_iconsPath/ic_close.svg';

  // --- Action Icons (edit / delete) ---
  /// Pencil icon used wherever an edit affordance is shown.
  /// Render via [AppActionIcon] to get the standard primary-brand tint.
  static const String icEdit = '$_iconsPath/ic_edit.svg';

  /// Trash icon used wherever a delete affordance is shown.
  /// Render via [AppActionIcon] to get the standard primary-brand tint.
  static const String icDelete = '$_iconsPath/ic_delete.svg';
}
