// UseCase to fetch a Fee by ID
import '../../domain/entities/fee.dart';
import '../../domain/repositories/fee_repository.dart';

class GetFeeUseCase {
  final FeeRepository repository;

  const GetFeeUseCase(this.repository);

  Future<Fee> call(String id) async {
    return await repository.getFee(id);
  }
}
