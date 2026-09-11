import 'package:hive_ce/hive.dart';
import 'package:smsforward/models/filter/filter.dart';

class FilterRepository {
  Future<List<Filter>> loadFilters() async {
    final box = await Hive.openBox<Filter>('filters');
    return box.values.toList();
  }

  Future<void> addFilter(Filter filter) async {
    final box = await Hive.openBox<Filter>('filters');
    await box.put(filter.id, filter);
  }

  Future<void> deleteFilter(String id) async {
    final box = await Hive.openBox<Filter>('filters');
    await box.delete(id);
  }
}