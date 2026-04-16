// Remote data source for Fee (e.g., API calls)
import 'package:fee_easy/domain/entities/fee.dart';

abstract class FeeRemoteDataSource {
  // Simulate fetching fee from remote source
  Future<Fee> fetchFee(String id);
}

// Simple dummy implementation (replace with real API later)
class FeeRemoteDataSourceImpl implements FeeRemoteDataSource {
  @override
  Future<Fee> fetchFee(String id) async {
    // Dummy data
    return Fee(id: id, amount: 0.0, description: 'Remote fee placeholder');
  }
}
