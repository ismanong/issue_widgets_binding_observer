import 'package:flutter/material.dart';
import '../main.dart';

const rootIndexPagePath = '/';

Widget createPage(String url) {
  Widget child;
  final uri = Uri.parse(url);
  switch (uri.path) {
    case '/':
      child = MyHomePage(title: 'Flutter Demo Home Page');
      break;
    default:
      child = const Scaffold();
  }
  return child;
}
