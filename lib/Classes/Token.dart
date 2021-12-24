

class Token {
  String accessToken;
  double expires;
  String scope;
  String tokenType;
  
  Token({
    required this.accessToken,
    required this.expires,
    required this.scope,
    required this.tokenType
  });
  
  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      accessToken: json['access_token'],
      expires: (DateTime.now().millisecondsSinceEpoch/1000) + json['expires_in'],
      scope: json['scope'],
      tokenType: json['token_type'],
    );
  }
}