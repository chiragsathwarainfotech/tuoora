// Data model for Fee, converting between domain entity and JSON

import 'package:fee_easy/domain/entities/fee.dart';

class FeeModel extends Fee {
  const FeeModel({
    required super.id,
    required super.amount,
    required super.description,
  });

  factory FeeModel.fromJson(Map<String, dynamic> json) {
    return FeeModel(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'amount': amount, 'description': description};
  }
}
