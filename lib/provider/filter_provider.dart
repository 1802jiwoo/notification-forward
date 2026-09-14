import 'package:flutter/cupertino.dart';
import 'package:smsforward/models/filter/filter.dart';
import 'package:smsforward/repository/filter_repository.dart';

class FilterProvider extends ChangeNotifier {
  final FilterRepository filterRepository = FilterRepository();
  List<Filter> _filters = [];

  List<Filter> get filters => _filters;

  Future<void> loadFilters() async {
    _filters = await filterRepository.loadFilters();
    notifyListeners();
  }

  Future<void> addFilter(Filter filter) async {
    await filterRepository.addFilter(filter);
    await loadFilters();
  }

  Future<void> deleteFilter(String id) async {
    await filterRepository.deleteFilter(id);
    await loadFilters();
  }

  Future<void> toggleFilterActive(String id) async {
    final filter = _filters.firstWhere((filter) => filter.id == id);
    filter.isActive = !filter.isActive;
    await filterRepository.updateFilter(filter);
    notifyListeners();
  }
}