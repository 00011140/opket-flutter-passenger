import 'dart:convert';

class ErrorResponse {
  final String message;

  ErrorResponse({
    required this.message,
  });

  factory ErrorResponse.fromMap(Map<String, dynamic> data) {
    return ErrorResponse(
      message: data['message'] ?? 'No message provided',
    );
  }

  /// Converts the object to a Map (not JSON string)
  Map<String, dynamic> toMap() {
    return {
      "message": message,
    };
  }

  /// Optional: convert to JSON string
  String toJson() => json.encode(toMap());
}
