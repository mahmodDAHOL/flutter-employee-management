enum FieldType { text, date, select, check, link, tabBreak, image, id, hidden }

// Convert enum to String
String fieldTypeToString(FieldType type) {
  return type.toString().split('.').last;
}

// Convert String to enum
FieldType stringToFieldType(String? typeName) {
  switch (typeName) {
    case 'text':
      return FieldType.text;
    case 'date':
      return FieldType.date;
    case 'select':
      return FieldType.select;
    case 'check':
      return FieldType.check;
    case 'link':
      return FieldType.link;
    case 'tabBreak':
      return FieldType.tabBreak;
    case 'image':
      return FieldType.image;
    case 'id':
      return FieldType.id;
    case 'hidden':
      return FieldType.hidden;
    default:
      return FieldType.hidden;
  }
}