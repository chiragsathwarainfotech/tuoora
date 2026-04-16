// Fee entity representing a simple fee record
class Fee {
  final String id;
  final double amount;
  final String description;

  const Fee({
    required this.id,
    required this.amount,
    required this.description,
  });
}
