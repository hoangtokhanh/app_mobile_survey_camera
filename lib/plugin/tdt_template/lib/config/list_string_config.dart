class ListStringConfig {
  static final Map<String, dynamic> listString = {
    'product_weight_list': {50: '50 kg', 1000: '1 Tấn'},
    'line_printer': {
      'BIXOLON_1': 'Bixolon 1',
      'BIXOLON_2': 'Bixolon 2',
      'BIXOLON_3': 'Bixolon 3',
      'BIXOLON_4': 'Bixolon 4',
      'BIXOLON_5': 'Bixolon 5',
      'BIXOLON_6': 'Bixolon 6',
    },
    'role_account': {
      'admin': 'Admin',
      'transport': 'Transport',
      'operation': 'Operation',
      'manager': 'Manager',
    }
  };

  static Map getListString(String key) {
    return listString[key] ?? {};
  }

  static void setListString(String key, Map data) {
    listString[key] = data;
  }

  static String getValueInList(String listString, key) {
    return getListString(listString)[key] ?? key;
  }
}
