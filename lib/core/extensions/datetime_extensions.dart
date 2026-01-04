import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

extension DateTimeX on DateTime {
  String get timeAgo => timeago.format(this);

  String get formattedTime => DateFormat.jm().format(this);

  String get formattedDate => DateFormat.yMMMd().format(this);

  String get formattedDateTime => DateFormat.yMMMd().add_jm().format(this);

  String get chatTimestamp {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(year, month, day);

    if (messageDate == today) {
      return formattedTime;
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else if (now.difference(this).inDays < 7) {
      return DateFormat.EEEE().format(this);
    } else {
      return DateFormat.MMMd().format(this);
    }
  }

  String get conversationTimestamp {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(year, month, day);

    if (messageDate == today) {
      return formattedTime;
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else if (now.difference(this).inDays < 7) {
      return DateFormat.E().format(this);
    } else if (now.year == year) {
      return DateFormat.MMMd().format(this);
    } else {
      return DateFormat.yMMMd().format(this);
    }
  }

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// Ultra-concise last seen format (no prefix)
  /// UI can add "Last seen " prefix if needed
  /// Examples:
  /// - "just now"
  /// - "2:30 PM" (today)
  /// - "yesterday"
  /// - "Monday"
  /// - "Jan 5"
  /// - "Jan 5, 2024"
  String get lastSeenFormatted {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (isToday) {
      return DateFormat.jm().format(this); // "2:30 PM"
    } else if (isYesterday) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return DateFormat.EEEE().format(this); // "Monday"
    } else if (now.year == year) {
      return DateFormat.MMMd().format(this); // "Jan 5"
    } else {
      return DateFormat.yMMMd().format(this); // "Jan 5, 2024"
    }
  }
}
