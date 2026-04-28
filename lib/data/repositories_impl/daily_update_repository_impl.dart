import 'package:fee_easy/data/models/daily_update_model.dart';

abstract class DailyUpdateRepositoryImpl {
  Future<DailyUpdate> createDailyUpdate(Map<String, dynamic> data);
  Future<List<DailyUpdate>> listDailyUpdates();
}
