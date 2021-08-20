import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class MenuItemModel {
  final String? id;
  List<String> imgPath;
  String name;
  String description;
  List<MenuItemModelDetail> item;
  
  MenuItemModel({
    this.id,
    required this.imgPath,
    required this.name,
    required this.description,
    required this.item,
  });

  MenuItemModel copyWith({
    String? id,
    List<String>? imgPath,
    String? name,
    String? description,
    List<MenuItemModelDetail>? item,
  }) {
    return MenuItemModel(
      id: id ?? this.id,
      imgPath: imgPath ?? this.imgPath,
      name: name ?? this.name,
      description: description ?? this.description,
      item: item ?? this.item,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imgPath': imgPath,
      'name': name,
      'description': description,
      'item': item.map((x) => x.toMap()).toList(),
    };
  }

  factory MenuItemModel.fromMap(Map<String, dynamic> map) {
    return MenuItemModel(
      id: map['id'],
      imgPath: List<String>.from(map['imgPath']),
      name: map['name'],
      description: map['description'],
      item: List<MenuItemModelDetail>.from(map['item']?.map((x) => MenuItemModelDetail.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory MenuItemModel.fromJson(String source) => MenuItemModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MenuItemModel(id: $id, imgPath: $imgPath, name: $name, description: $description, item: $item)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is MenuItemModel &&
      other.id == id &&
      listEquals(other.imgPath, imgPath) &&
      other.name == name &&
      other.description == description &&
      listEquals(other.item, item);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      imgPath.hashCode ^
      name.hashCode ^
      description.hashCode ^
      item.hashCode;
  }
}

class MenuItemModelDetail {
  final String name;
  final num unit;
  final TextEditingController? controller;
  final TextEditingController? unitController;

  MenuItemModelDetail({
    required this.name,
    required this.unit,
    this.controller,
    this.unitController,
  });

  MenuItemModelDetail copyWith({
    String? name,
    num? unit,
    TextEditingController? controller,
    TextEditingController? unitController,
  }) {
    return MenuItemModelDetail(
      name: name ?? this.name,
      unit: unit ?? this.unit,
      controller: controller ?? this.controller,
      unitController: unitController ?? this.unitController,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'unit': unit,
      // 'controller': controller?.text,
      // 'unitController': unitController?.text,
    };
  }

  factory MenuItemModelDetail.fromMap(Map<String, dynamic> map) {
    return MenuItemModelDetail(
      name: map['name'],
      unit: map['unit'],
      // controller: null,
      // unitController: null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MenuItemModelDetail.fromJson(String source) => MenuItemModelDetail.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MenuItemModelDetail(name: $name, unit: $unit, controller: $controller, unitController: $unitController)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is MenuItemModelDetail &&
      other.name == name &&
      other.unit == unit &&
      other.controller == controller &&
      other.unitController == unitController;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      unit.hashCode ^
      controller.hashCode ^
      unitController.hashCode;
  }
}
