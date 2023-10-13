import 'package:flutter/material.dart';
import '../template_web/fields/boolean.dart';
import '../template_web/fields/checkbox_field.dart';
import '../template_web/fields/dropdown_field.dart';
import '../template_web/fields/image.dart';
import '../template_web/fields/name_with_avatar.dart';
import '../template_web/fields/number_field.dart';
import '../template_web/fields/password_field.dart';
import '../template_web/fields/relation_field.dart';
import '../template_web/fields/text_dropdown_field.dart';
import '../template_web/fields/text_field.dart';

class ComponentConfig {
  static Map<String, Widget> mapComponent = {
    'dropdown': const MyDropdownField(),
    'relation': const MyRelationField(),
    'text_dropdown_field': const MyTextDropdownField(),
    'boolean': const MyBooleanField(),
    'checkbox': const MyCheckboxField(),
    'password': const PasswordField(),
    'image': const ImageField(),
    'name_with_avatar': const NameWithAvatar(),
    'number': const MyNumberField(),
    'text_field': const MyTextField(),
  };
}
