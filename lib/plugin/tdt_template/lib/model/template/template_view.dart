mixin TemplateView {
  Map<String, dynamic> getView() {
    return {
      'edit_view': [
        {'field': 'name', 'label': 'Name', 'type': 'text_field', 'span': 12}
      ],
      'list_view': [
        {
          'field': 'name',
          'label': 'Name',
        }
      ]
    };
  }
}
