import 'enum_topic.dart';

class ResponseModel{
  final Topic topic;
  final dynamic data;

  const ResponseModel({
    required this.topic,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'topic': this.topic,
      'data': this.data,
    };
  }

  factory ResponseModel.fromMap(Map<String, dynamic> map) {
    return ResponseModel(
      topic:Topic.values.singleWhere((e)=>e.name == map['topic']),
      data: map['data'] as dynamic,
    );
  }
}