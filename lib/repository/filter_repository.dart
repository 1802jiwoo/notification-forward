import 'package:hive_ce/hive.dart';
import 'package:smsforward/core/app_channel.dart';
import 'package:smsforward/models/filter/filter.dart';

class FilterRepository {
  Future<List<Filter>> loadFilters() async {
    final box = await Hive.openBox<Filter>('filters');
    return box.values.toList();
  }

  Future<void> addFilter(Filter filter) async {
    final box = await Hive.openBox<Filter>('filters');
    await box.put(filter.id, filter);
    await _syncToNative(box);
  }

  Future<void> updateFilter(Filter filter) async {
    final box = await Hive.openBox<Filter>('filters');
    await box.put(filter.id, filter);
    await _syncToNative(box);
  }

  Future<void> deleteFilter(String id) async {
    final box = await Hive.openBox<Filter>('filters');
    await box.delete(id);
    await _syncToNative(box);
  }

  Future<void> _syncToNative(Box<Filter> box) async {
    final filters = box.values
        .where((filter) => filter.isActive)
        .map((filter) => filter.toMap())
        .toList();
    await AppChannel.instance.invokeMethod('saveFilters', filters);
  }
}
