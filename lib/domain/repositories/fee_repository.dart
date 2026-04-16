// Repository interface for Fee entity
import '../../domain/entities/fee.dart';

abstract class FeeRepository {
  Future<Fee> getFee(String id);
}
