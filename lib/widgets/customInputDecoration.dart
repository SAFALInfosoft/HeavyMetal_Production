import 'package:flutter/material.dart';

/// A reusable function to generate InputDecoration for TextFields
InputDecoration customInputDecoration(String label) {
  return InputDecoration(
    label: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Text(
        label,
        overflow: TextOverflow.visible,
      ),
    ),
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
}

