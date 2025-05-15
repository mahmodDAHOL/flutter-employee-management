import 'field_type_model.dart';

class FormFieldData {
  final String fieldName;
  final FieldType type;
  final String? label;
  final dynamic options;
  final dynamic defaultValue;

  FormFieldData({
    required this.fieldName,
    required this.type,
    this.label,
    this.options,
    this.defaultValue,
  });

  Map<String, dynamic> toMap() {
    return {
      'fieldName': fieldName,
      'type': fieldTypeToString(type),
      'label': label,
      'options': options,
      'defaultValue': defaultValue,
    };
  }

  factory FormFieldData.fromJson(Map<String, dynamic> json) {
    return FormFieldData(
      fieldName: json['fieldName'],
      type: stringToFieldType(json['type']),
      label: json['label'],
      options: json['options'],
      defaultValue: json['defaultValue'],
    );
  }
}
