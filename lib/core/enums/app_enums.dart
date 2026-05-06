enum UpdateRecipient {
  students,
  parents,
  both;

  String toJson() => name;
}

enum UpdateTargetType {
  all,
  batch;

  String toJson() => name;
}

enum UpdateCategory {
  Academic,
  Administrative,
  Emergency,
  Event,
  Other;

  String toJson() => name;
}

enum AppInputFieldVariant { standard, profile }
