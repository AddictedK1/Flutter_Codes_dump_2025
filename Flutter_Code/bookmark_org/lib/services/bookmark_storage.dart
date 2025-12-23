import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/bookmark.dart';

class BookmarkStorage {
  static const String _fileName = 'bookmarks.json';

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$_fileName');
  }

  Future<List<Bookmark>> loadBookmarks() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) {
        return [];
      }

      final contents = await file.readAsString();
      final List<dynamic> jsonData = json.decode(contents);
      return jsonData.map((json) => Bookmark.fromJson(json)).toList();
    } catch (e) {
      print('Error loading bookmarks: $e');
      return [];
    }
  }

  Future<void> saveBookmarks(List<Bookmark> bookmarks) async {
    try {
      final file = await _localFile;
      final jsonData = bookmarks.map((bookmark) => bookmark.toJson()).toList();
      await file.writeAsString(json.encode(jsonData));
    } catch (e) {
      print('Error saving bookmarks: $e');
    }
  }

  Future<String> exportBookmarksToText(List<Bookmark> bookmarks) async {
    try {
      final path = await _localPath;
      final file = File('$path/bookmarks_export.txt');

      final StringBuffer buffer = StringBuffer();
      buffer.writeln('=== BOOKMARKS EXPORT ===');
      buffer.writeln('Generated: ${DateTime.now()}');
      buffer.writeln();

      // Group bookmarks by category
      final Map<String, List<Bookmark>> categorizedBookmarks = {};
      for (var bookmark in bookmarks) {
        categorizedBookmarks
            .putIfAbsent(bookmark.category, () => [])
            .add(bookmark);
      }

      // Sort categories alphabetically
      final sortedCategories = categorizedBookmarks.keys.toList()..sort();

      for (var category in sortedCategories) {
        buffer.writeln('[$category]');
        final categoryBookmarks = categorizedBookmarks[category]!;

        // Sort bookmarks alphabetically within category
        categoryBookmarks.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );

        for (var bookmark in categoryBookmarks) {
          buffer.writeln('  • ${bookmark.name}');
          buffer.writeln('    ${bookmark.url}');
        }
        buffer.writeln();
      }

      await file.writeAsString(buffer.toString());
      return file.path;
    } catch (e) {
      print('Error exporting bookmarks: $e');
      rethrow;
    }
  }
}
