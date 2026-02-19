import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

extension EncodeFile on File {
  Future<String?> imageToBase64() async {
    try {
      List<int> imageBytes = await readAsBytes();
      String base64Image = base64Encode(imageBytes);
      return base64Image;
    } catch (e) {
      debugPrint("can't encode image : $e");
      return null;
    }
  }
}
