enum BabySex { female, male, other }

extension BabySexName on BabySex {
  String get value {
    switch (this) {
      case BabySex.female:
        return 'female';
      case BabySex.male:
        return 'male';
      case BabySex.other:
        return 'other';
    }
  }
}

BabySex babySexFromValue(String value) {
  switch (value) {
    case 'female':
      return BabySex.female;
    case 'male':
      return BabySex.male;
    case 'other':
      return BabySex.other;
    default:
      return BabySex.other;
  }
}
