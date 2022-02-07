import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ignore_for_file: prefer_const_constructors

import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicación',
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late WebViewController controller; //late dice q no tiene valor inicial
  TextEditingController controlador = TextEditingController();
  final FocusNode _commentFocus = FocusNode();///para quitar el foco

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.cyanAccent[400],
          child: Icon(Icons.home,color: Colors.black,),
          onPressed: () async {
            if (await controller.canGoBack()) {
              controller.loadUrl("https://www.google.com/intl/es/gmail/about/");
              controlador.text = "";
              _commentFocus.unfocus();///para quitar el foco
            }
          },
        ),
        appBar: AppBar(
          backgroundColor: Colors.cyanAccent[400],
          leading: IconButton(
              icon: Icon(Icons.clear,color: Colors.black),
              onPressed: () {
                controller.clearCache();
                CookieManager().clearCookies();
              }),
          title: Center(child: Text("LZBrowser",style: TextStyle(color: Colors.black))),
          actions: [
            IconButton(
                icon: Icon(Icons.refresh_rounded,color: Colors.black),
                onPressed: () async {
                  controller.reload();
                }),
            IconButton(
                icon: Icon(Icons.arrow_back,color: Colors.black),
                onPressed: () async {
                  if (await controller.canGoBack()) {
                    controller.goBack();
                  }
                }),
            IconButton(
                icon: Icon(Icons.arrow_forward,color: Colors.black),
                onPressed: () async {
                  if (await controller.canGoForward()) {
                    controller.goForward();
                  }
                }),
            
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 300.0,
                    margin: const EdgeInsets.only(
                        left: 20.0, bottom: 2, top: 6, right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.cyan,
                    ),
                    child: TextField(
                        focusNode: _commentFocus,///para quitar el foco
                        controller: controlador,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            border: InputBorder.none,
                            hintText: "Introduzca su búsqueda",
                            hintStyle: TextStyle(color: Colors.black))),
                  ),
                  Container(
                    width: 40.0,
                    margin: const EdgeInsets.only(
                      top: 5,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      color: Colors.deepOrange,
                    ),
                    child: IconButton(
                        icon: Icon(Icons.search_sharp),
                        onPressed: () async {
                          FocusManager.instance.primaryFocus?.unfocus();//hace q el teclado se esconda al tocar este boton
                          if (controlador.text.isNotEmpty) {
                            String txt = controlador.text;
                            String busqueda = "";
                            if (!txt.contains("https://")) {
                              busqueda = "https://" "$txt";
                            }

                            try {
                              http.Response response =
                                  await http.get(Uri.parse(busqueda));

                              if (response.statusCode == 200) {
                                controller.loadUrl(busqueda);
                              }
                            } catch (e) {
                              controller.loadUrl(
                                  "https://www.google.es/search?q=" "$txt");
                            }
                          }
                        }),
                  )
                ],
              ),
              Expanded(
                child: WebView(
                  initialUrl: "https://www.google.com/intl/es/gmail/about/",
                  onWebViewCreated: (WebViewController webViewController) {
                    controller = webViewController;
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
