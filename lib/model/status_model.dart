import 'dart:convert';

class StatusResponse {
  final bool status;
  final String? message;
  final dynamic data;

  StatusResponse({
    required this.status,
    this.data,
    this.message
  });

  StatusResponse copyWith({
    bool? status,
    String? message,
    dynamic data,
  }) {
    return StatusResponse(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'message': message,
      'data': data,
    };
  }

  factory StatusResponse.fromMap(Map<String, dynamic> map) {
    return StatusResponse(
      status: map['status'],
      message: map['message'],
      data: map['data'],
    );
  }

  String toJson() => json.encode(toMap());

  factory StatusResponse.fromJson(String source) => StatusResponse.fromMap(json.decode(source));

  @override
  String toString() => 'StatusResponse(status: $status, message: $message, data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is StatusResponse &&
      other.status == status &&
      other.message == message &&
      other.data == data;
  }

  @override
  int get hashCode => status.hashCode ^ message.hashCode ^ data.hashCode;
}
