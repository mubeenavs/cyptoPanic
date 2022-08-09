import 'package:http/http.dart';

import 'package:cryptoPanic/home/model/news.dart';

/// api Declaration
class HomeRepository {
  final url =
      "https://cryptopanic.com//api/v1/posts/?auth_token=ad939ca3bb96c0596877d5b79f7441dafc1283ce&public=true";

  /// Create a function to fetch  api data
  Future<News> fetchNews() async {
    final response = await get(Uri.parse(url));
    
    final cryptoNews =newsFromJson(response.body);
    
    return cryptoNews;
  }
}
