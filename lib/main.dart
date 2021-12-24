import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inputformat/card_date_input_formatter.dart';
import 'package:inputformat/card_number_input_formatter.dart';
import 'package:inputformat/phone_input_fotmatter.dart';
import 'package:inputformat/provider/service/api_config.dart';
import 'package:inputformat/provider/service/api_service.dart';

import 'provider/service/api_client.dart';

void main() {
  ApiClient.init(
    ApiConfig(
      baseUrl: 'https://jsonplaceholder.typicode.com/',
      customHeader: {'Content-Type': "application/x-www-form-urlencoded"},
      cacheData: true,
      interceptor: [
        ApiService(),
      ],
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          runSpacing: 20,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  onPressed: () {
                    ApiClient.connect(ApiMethod.get, 'todos/1')
                        .then((value) => {log(value.toString())});
                  },
                  color: Colors.grey,
                  child: const Text('Fetch Api'),
                ),
                MaterialButton(
                  onPressed: () {
                    ApiClient.clearCache(
                      url: 'todos/1',
                      method: ApiMethod.get,
                    ).then((value) => {log('clear success')});
                  },
                  color: Colors.grey,
                  child: const Text('Clear Cache'),
                ),
              ],
            ),
            InputBox(
              title: 'Card number',
              hintText: '0000 0000 0000 0000',
              textInputType: TextInputType.number,
              inputFormatters: [
                CardNumberInputFormatter(),
              ],
            ),
            InputBox(
              title: 'Card date',
              hintText: 'ММ / YYYY',
              textInputType: TextInputType.number,
              inputFormatters: [
                CardDateInputFormatter(),
              ],
            ),
            InputBox(
              title: 'CVV/CVC',
              hintText: 'CVV/CVC',
              textInputType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
            ),
            InputBox(
              title: 'Birthday',
              hintText: 'DD/MM/YYYY',
              textInputType: TextInputType.number,
              inputFormatters: [
                DateInputFormatter(),
              ],
            ),
            const InputBox(
              title: 'Phone',
              hintText: '+# (###) ###-##-##',
              textInputType: TextInputType.number,
              inputFormatters: [],
            ),
            const InputBox(
              title: 'Currency',
              hintText: 'Currency',
              textInputType: TextInputType.number,
              inputFormatters: [],
            )
          ],
        ),
      ),
    );
  }
}

class InputBox extends StatelessWidget {
  const InputBox({
    Key? key,
    required this.title,
    required this.hintText,
    this.textInputType = TextInputType.multiline,
    this.inputFormatters,
  }) : super(key: key);
  final String title, hintText;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType textInputType;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        TextFormField(
          keyboardType: textInputType,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hintText,
            fillColor: Colors.grey[200],
            filled: true,
          ),
        ),
      ],
    );
  }
}
