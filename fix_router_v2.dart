import 'dart:io';

void main() async {
  final file = File('lib/app/routes/router.dart');
  if (!await file.exists()) {
    print('router.dart not found');
    return;
  }
  String content = await file.readAsString();

  // Find words ending in .page
  // e.g. Name.page
  // Check if Name has 'Page' inside it (usually at end or before V2)
  // And replace with 'Route'.
  // Example: AddressManagerPage.page -> AddressManagerRoute.page
  // CartPageV2.page -> CartRouteV2.page

  // Regex to match Identifier.page
  final regex = RegExp(r'(\w+)\.page');

  content = content.replaceAllMapped(regex, (match) {
    String name = match.group(1)!;
    // Apply logic: if contains 'Page', replace with 'Route'
    // But be careful about 'HomePage' -> 'HomeRoute'.
    // 'DetailAddressPage' -> 'DetailAddressRoute'.

    // Check if generated file actually uses Route.
    // Assuming config replaceInRouteName: 'Page,Route'
    if (name.contains('Page')) {
      String newName = name.replaceAll('Page', 'Route');
      return '$newName.page';
    }
    return match.group(0)!;
  });

  await file.writeAsString(content);
  print('Fixed Router Names (Page->Route)');
}
