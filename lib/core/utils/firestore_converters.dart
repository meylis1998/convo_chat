import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

/// Converts DateTime to/from Firestore Timestamp
class TimestampConverter implements JsonConverter<DateTime, dynamic> {
  const TimestampConverter();

  @override
  DateTime fromJson(dynamic json) {
    if (json is Timestamp) {
      return json.toDate();
    }
    if (json is String) {
      return DateTime.parse(json);
    }
    if (json is int) {
      return DateTime.fromMillisecondsSinceEpoch(json);
    }
    return DateTime.now();
  }

  @override
  dynamic toJson(DateTime object) => Timestamp.fromDate(object);
}

/// Converts nullable DateTime to/from Firestore Timestamp
class TimestampNullableConverter implements JsonConverter<DateTime?, dynamic> {
  const TimestampNullableConverter();

  @override
  DateTime? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is Timestamp) {
      return json.toDate();
    }
    if (json is String) {
      return DateTime.tryParse(json);
    }
    if (json is int) {
      return DateTime.fromMillisecondsSinceEpoch(json);
    }
    return null;
  }

  @override
  dynamic toJson(DateTime? object) {
    if (object == null) return null;
    return Timestamp.fromDate(object);
  }
}

/// Converts a String-to-DateTime map to/from Firestore format
class TimestampMapConverter implements JsonConverter<Map<String, DateTime>, dynamic> {
  const TimestampMapConverter();

  @override
  Map<String, DateTime> fromJson(dynamic json) {
    if (json == null) return {};
    if (json is! Map) return {};

    final result = <String, DateTime>{};
    final map = json as Map<String, dynamic>;
    for (final entry in map.entries) {
      final key = entry.key.toString();
      final value = entry.value;
      if (value is Timestamp) {
        result[key] = value.toDate();
      } else if (value is String) {
        final parsed = DateTime.tryParse(value);
        if (parsed != null) result[key] = parsed;
      }
    }
    return result;
  }

  @override
  dynamic toJson(Map<String, DateTime> object) {
    return object.map((key, value) => MapEntry(key, Timestamp.fromDate(value)));
  }
}

/// Converts a reactions map for emoji-to-users mappings
class ReactionsConverter implements JsonConverter<Map<String, List<String>>, dynamic> {
  const ReactionsConverter();

  @override
  Map<String, List<String>> fromJson(dynamic json) {
    if (json == null) return {};
    if (json is! Map) return {};

    final result = <String, List<String>>{};
    final map = json as Map<String, dynamic>;
    for (final entry in map.entries) {
      final key = entry.key.toString();
      final value = entry.value;
      if (value is List) {
        result[key] = value.map((e) => e.toString()).toList();
      }
    }
    return result;
  }

  @override
  dynamic toJson(Map<String, List<String>> object) => object;
}
