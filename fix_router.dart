import 'dart:io';

void main() async {
  final file = File('lib/app/routes/router.dart');
  if (!await file.exists()) {
    print('router.dart not found');
    return;
  }
  String content = await file.readAsString();

  // Regex to replace const PageInfo('Name') with Name.page
  final regex = RegExp(r"const PageInfo\('(\w+)'\)");

  // We need to be careful. If Name is not imported or generated, it errors.
  // But we rely on compiler to catch that later.

  content = content.replaceAllMapped(regex, (match) {
    String name = match.group(1)!;
    return '$name.page';
  });

  await file.writeAsString(content);
  print('Replaced PageInfo usages in router.dart');
}
