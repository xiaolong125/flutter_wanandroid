abstract final class AppRoutes {
  static const startup = '/startup';
  static const login = '/login';
  static const register = '/register';
  static const home = '/';
  static const search = '/search';
  static const searchResult = '/search/result';
  static const detail = '/detail';

  static const searchKeywordParam = 'keyword';

  static String searchResultLocation(String keyword) {
    final encodedKeyword = Uri.encodeQueryComponent(keyword);
    return '$searchResult?$searchKeywordParam=$encodedKeyword';
  }
}
