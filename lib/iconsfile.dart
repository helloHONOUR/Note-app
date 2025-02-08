import 'package:flutter/material.dart';

final Map<String, IconData> iconMapping = {
  // General Icons
  'home': Icons.home,
  'favorite': Icons.favorite,
  'alarm': Icons.alarm,
  'camera': Icons.camera,
  'email': Icons.email,
  'settings': Icons.settings,
  'shopping_cart': Icons.shopping_cart,
  'search': Icons.search,
  'delete': Icons.delete,
  'edit': Icons.edit,
  'save': Icons.save,
  'archive': Icons.archive,
  'share': Icons.share,

  // Note-Taking Specific
  'note': Icons.note,
  'description': Icons.description,
  'list': Icons.list,
  'check_circle': Icons.check_circle,
  'event': Icons.event,
  'calendar_today': Icons.calendar_today,
  'task_alt': Icons.task_alt,
  'lightbulb': Icons.lightbulb,
  'create': Icons.create,

  // Communication
  'chat': Icons.chat,
  'call': Icons.call,
  'message': Icons.message,
  'notifications': Icons.notifications,
  'contact_mail': Icons.contact_mail,
  'contact_phone': Icons.contact_phone,

  // Priority and Importance
  'star': Icons.star,
  'star_border': Icons.star_border,
  'priority_high': Icons.priority_high,
  'flag': Icons.flag,
  'error': Icons.error,

  // Tags and Categories
  'label': Icons.label,
  'tag': Icons.tag,
  'bookmark': Icons.bookmark,
  'category': Icons.category,
  'folder': Icons.folder,
  'inbox': Icons.inbox,

  // Actions
  'done': Icons.done,
  'close': Icons.close,
  'add': Icons.add,
  'remove': Icons.remove,
  'redo': Icons.redo,
  'undo': Icons.undo,

  // Multimedia and Attachments
  'image': Icons.image,
  'attach_file': Icons.attach_file,
  'photo_camera': Icons.photo_camera,
  'mic': Icons.mic,
  'video_call': Icons.video_call,
  'headset': Icons.headset,

  // Mood and Productivity
  'mood': Icons.mood,
  'mood_bad': Icons.mood_bad,
  'work': Icons.work,
  'fitness_center': Icons.fitness_center,
  'self_improvement': Icons.self_improvement,

  // Miscellaneous
  'build': Icons.build,
  'flight': Icons.flight,
  'restaurant': Icons.restaurant,
  'directions_walk': Icons.directions_walk,
  'school': Icons.school,
  'sports_soccer': Icons.sports_soccer,
  'computer': Icons.computer,
  'watch': Icons.watch,

  // default
  'defaulticon': Icons.not_interested,

  //
  'addingtagicon': Icons.add,
};
final Map<String, Color> colorMapping = {
  'lemonYellow': const Color.fromARGB(255, 201, 207, 66),
  'greenApple': const Color.fromARGB(255, 102, 204, 65),
  'seaBlue': const Color.fromARGB(255, 65, 204, 167),
  'royalBlue': const Color.fromARGB(255, 0, 89, 190),
  'royalBlueDuplicate': const Color.fromARGB(255, 2, 161, 119),
  'carrotOrange': const Color.fromARGB(255, 204, 132, 65),
  'purpleGrape': const Color.fromARGB(255, 151, 65, 204),
  'purpleGrapeDuplicate': const Color.fromARGB(255, 204, 65, 179),
  'defaultcolor': const Color.fromARGB(255, 213, 122, 122),
  'addingtagcolor': const Color.fromARGB(255, 57, 220, 128)
};
Map<int, String> monthsOfYear = {
  1: 'January',
  2: 'February',
  3: 'March',
  4: 'April',
  5: 'May',
  6: 'June',
  7: 'July',
  8: 'August',
  9: 'September',
  10: 'October',
  11: 'November',
  12: 'December',
};
Map<int, String> daysOfWeek = {
  1: 'Monday',
  2: 'Tuesday',
  3: 'Wednesday',
  4: 'Thursday',
  5: 'Friday',
  6: 'Saturday',
  7: 'Sunday',
};
