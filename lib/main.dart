import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';

import 'package:http/http.dart' as http;

void main() {
  runApp(const UrlShortnerApp());
}

class UrlShortnerApp extends StatefulWidget {
  const UrlShortnerApp({super.key});

  @override
  State<UrlShortnerApp> createState() => _UrlShortnerAppState();
}

class _UrlShortnerAppState extends State<UrlShortnerApp> {
  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  var shortenLink = '';
  var originalLink = '';

  Future<String> getData() async {
    var url = controller.text;
    var response = await http.post(
      Uri.parse('http://localhost:80/api/url/create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'url': url,
      }),
    );
    var jsonData = jsonDecode(response.body);

    setState(() {
      shortenLink = "wi.vi/${jsonData['key']}";
    });

    return 'Success';
  }

  Future<String> getOriginalUrl() async {
    var urlKey = controller2.text;
    if (urlKey.contains('/')) {
      urlKey = urlKey.split('/').last;
    }
    var response =
        await http.get(Uri.parse('http://localhost:80/api/url/$urlKey'));
    var jsonData = jsonDecode(response.body);

    setState(() {
      originalLink = jsonData['url'];
    });

    return 'Success';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Url shortener web app',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Shorten any url'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        label: const Text('Enter URL'),
                        hintText: 'Enter URL',
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.teal,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.teal,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            getData();
                          },
                          child: const Text('Click to Shorten')),
                      const SizedBox(width: 20),
                      ElevatedButton(
                          onPressed: () {
                            FlutterClipboard.copy(shortenLink);
                          },
                          child: const Text('Copy to Clipboard'))
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Shorten Link is: ',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        shortenLink,
                        style: const TextStyle(
                          fontSize: 24.0,
                          color: Color.fromARGB(255, 4, 216, 85),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: controller2,
                      decoration: InputDecoration(
                        label: const Text('Enter shortened URL'),
                        hintText: 'Enter shortened URL',
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.teal,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.teal,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        getOriginalUrl();
                      },
                      child: const Text('Get original url')),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Text(
                      'Original Link is: ',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      originalLink,
                      style: const TextStyle(
                        fontSize: 24.0,
                        color: Color.fromARGB(255, 4, 216, 85),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ])
                ],
              ),
            ),
          )),
    );
  }
}
