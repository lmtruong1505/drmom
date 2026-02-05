import 'dart:io';

void main() async {
  final dir = Directory('lib');
  if (!await dir.exists()) {
    print('lib folder not found');
    return;
  }

  int fixedCount = 0;
  await for (final entity in dir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      try {
        final content = await entity.readAsString();
        // Regex to find 'class Name with _$Name' NOT preceded by 'abstract '
        // Using negative lookbehind (?<!abstract\s)
        final regex = RegExp(r'(?<!abstract\s)class\s+(\w+)\s+with\s+_\$\1');

        if (regex.hasMatch(content)) {
          final newContent = content.replaceAllMapped(regex, (match) {
            return 'abstract class ${match.group(1)} with _\$${match.group(1)}';
          });

          if (newContent != content) {
            await entity.writeAsString(newContent);
            print('Fixed: ${entity.path}');
            fixedCount++;
          }
        }
      } catch (e) {
        print('Error processing ${entity.path}: $e');
      }
    }
  }
  print('Total files fixed: $fixedCount');
}
