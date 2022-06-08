import 'package:currency_unac/currencies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';

void main() {
  runApp(const CurrencyConvertorApp());
}

class CurrencyConvertorApp extends StatelessWidget {
  const CurrencyConvertorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController controller = TextEditingController();

  double? valueReceived = 0;
  double? valueConverted = 0;

  String? errorText;

  List<DropdownMenuItem<CurrencyData>> getCurrenciesMenuItems() {
    List<DropdownMenuItem<CurrencyData>> result = [];

    for (var element in CURRENCIES_DATA) {
      result.add(DropdownMenuItem(value: element, child: Text(element.name)));
    }

    return result;
  }

  Future<dynamic> fetchGet() async {
    final url = Uri.parse(
        "https://exchangecurrenciesdemo.herokuapp.com/api/convert/usd/cop");
    final headers = {"Content-type": "application/json", "Costumer": "Andres"};
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      // Si el servidor devuelve una repuesta OK, parseamos el JSON
      return json.decode(response.body);
    } else {
      // Si esta respuesta no fue OK, lanza un error.
      throw Exception('Failed to load post');
    }
  }

  void currecyChaged() async {
    var data = await fetchGet();

    var valueReceived = double.tryParse(controller.text);
    if (controller.text.isEmpty) {
      errorText = 'Please enter a number';
      valueConverted = 0;
    } else if (valueReceived == null) {
      errorText = 'This is not a number';
      valueConverted = 0;
    } else {
      valueConverted = valueReceived * 3799.5;
      errorText = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Currency Convertor',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                errorText: errorText,
                hintText: 'Enter a number',
                suffix: IconButton(
                  onPressed: () {
                    controller.clear();
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  icon: const Icon(Icons.close),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  currecyChaged();
                });
              },
              child: const Text('Convert!'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${valueConverted!.toStringAsFixed(2)} COP',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 30.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
