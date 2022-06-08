import 'package:http/http.dart';
import 'dart:convert';

final List<CurrencyData> CURRENCIES_DATA = [
  CurrencyData('euro', 4.5, 'assets/euro.png'),
  CurrencyData('dollar', 4.28, 'assets/dollar.png'),
  CurrencyData('pound', 5.78, 'assets/pound.png'),
];

class CurrencyData {
  final String name;
  final double ronConvertion;
  final String assetPath;

  CurrencyData(this.name, this.ronConvertion, this.assetPath);
}
