extension StringExtension on String? {
  bool get nullOrEmpty {
    return this == null || (this?.isEmpty == true);
  }

  String toSimpleString({int maxLength = 10}) {
    if (this == null) {
      return "";
    }
    if (this!.length <= maxLength) {
      return this!;
    } else {
      return '${this!.substring(0, maxLength)}...';
    }
  }

  int? calculateAge() {
    if (this == null) return null;

    try {
      final birthDate = DateTime.parse(this!);
      final now = DateTime.now();

      int age = now.year - birthDate.year;
      if (now.month < birthDate.month ||
          (now.month == birthDate.month && now.day < birthDate.day)) {
        age--;
      }

      return age;
    } catch (e) {
      return null;
    }
  }
}

extension IntExtension on int? {
  String convertMinusToHours() {
    if (this == null) {
      return "0";
    }
    final int hours = this! ~/ 60; // Sử dụng toán tử chia nguyên
    final int minutes = this! % 60; // Sử dụng toán tử chia lấy dư
    return '${hours}h ${minutes}p';
  }
}
