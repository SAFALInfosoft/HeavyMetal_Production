import 'package:flutter/material.dart';

class ProductModel {
  String? itemName;
  String? grade;
  String? uom;
  String? odMm;
  String? thkMin;
  String? thkMax;
  String? thkMm;
  String? lengthMin;
  String? lengthMax;
  String? noOfPieces;
  String? weight;

  ProductModel({
    this.itemName,
    this.grade,
    this.uom,
    this.odMm,
    this.thkMin,
    this.thkMax,
    this.thkMm,
    this.lengthMin,
    this.lengthMax,
    this.noOfPieces,
    this.weight,
  });
}