// Local data source for Fee (e.g., SQLite, cache)
import 'package:fee_easy/domain/entities/fee.dart';

abstract class FeeLocalDataSource {
  Future<Fee?> getFee(String id);
  Future<void> cacheFee(Fee fee);
}

// Simple in‑memory dummy implementation
class FeeLocalDataSourceImpl implements FeeLocalDataSource {
  final Map<String, Fee> _cache = {};

  @override
  Future<Fee?> getFee(String id) async => _cache[id];

  @override
  Future<void> cacheFee(Fee fee) async => _cache[fee.id] = fee;
}
