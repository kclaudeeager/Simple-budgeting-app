import 'package:flutter/cupertino.dart';

class EmojiFeed{
  final IconData emoji;
  final String name;
  String? description="";

  EmojiFeed({required this.emoji, required this.name,  this.description});

  factory EmojiFeed.fromJson(Map<String, dynamic> json){
    return EmojiFeed(
      emoji: json['emoji'],
      name: json['name'],
      description: json['description']
    );
  }
}