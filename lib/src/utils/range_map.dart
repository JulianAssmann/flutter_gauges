import 'interval.dart';

// TODO: Improve performance. See
// - https://en.wikipedia.org/wiki/Segment_tree
// - https://en.wikipedia.org/wiki/Interval_tree
// - https://github.com/jpnurmi/interval_tree

/// A data structure that associates intervals with intervals.
///
/// '''dart
/// var intervalMap = IntervalMap();
/// intervalMap.add(Interval(0, 50), Interval(-50, 50));
/// intervalMap.add(Interval(50, 100), Interval(50, 100));
/// intervalMap.mapValue(20);
/// '''
class IntervalMap {
  final _intervals = <MapEntry<Interval, Interval>>[];
  double _minValue = double.infinity;
  double _maxValue = double.negativeInfinity;

  IntervalMap();

  void addAll(Iterable<MapEntry<Interval, Interval>> iterable) {
    _intervals.addAll(iterable);
    _intervals.sort((a, b) => a.key.min < b.key.min ? -1 : 1);

    if (_intervals.length > 0) {
      _minValue = _intervals.elementAt(0).key.min;
      _maxValue = _intervals.elementAt(_intervals.length - 1).key.max;
    }
  }

  void add(Interval from, Interval to) {
    addAll([MapEntry(from, to)]);
  }

  double mapValue(double value) {
    if (_intervals.length <= 0) return 0;

    if (value < _minValue) {
      return _intervals.first.value.min;
    } else if (value > _maxValue) {
      return _intervals.last.value.max;
    } else {
      for (var i = 0; i < _intervals.length; i++) {
        final from = _intervals[i].key;
        final to = _intervals[i].value;

        if (_intervals[i].key.contains(value)) {
          return from.mapValueToInterval(value, to);
        }
      }
      return 0;
    }
  }
}
