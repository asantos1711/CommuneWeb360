import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:g_recaptcha_v3/g_recaptcha_v3.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'conecciones/conecciones.dart';
import 'modelos/fraccionamientos.dart';
import 'package:http/http.dart' as http;
import 'modelos/invitadoModel.dart';

class VistaUrl extends StatefulWidget {
  String qrCode;
  VistaUrl({required this.qrCode});

  @override
  State<VistaUrl> createState() => _VistaUrlState();
}

class _VistaUrlState extends State<VistaUrl> {
  late double h, w;
  late String _token;

  final FirebaseFirestore db = FirebaseFirestore.instance;
  Color _colorFrac = Colors.white;

  @override
  void initState() {
    getToken();
    super.initState();
  }

  Future<void> getToken() async {
    String token = await GRecaptchaV3.execute('submit') ?? 'null returned';
    setState(() {
      _token = token;
    });
  }

  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: _carga(),
      ),
    );
  }

  _carga() {
    Conecciones conecciones = Conecciones();
    return FutureBuilder(
      future: conecciones.getProfile(this.widget.qrCode),
      builder: (c, AsyncSnapshot<Invitado?> s) {
        if (s.connectionState == ConnectionState.waiting) {
          return const Center(child: const CircularProgressIndicator());
        }

        if (s.data == null || !s.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [const Text("¡UPS! No existe el Qr")],
          );
        }

        Invitado invitado = s.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "¡Hola! ${invitado.nombre}, este es tu código QR de acceso.\n Recuerda respetar el reglamento.",
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            _reglamento(),
            const SizedBox(
              height: 30,
            ),
            QrImage(
              data: this.widget.qrCode.toString(),
              version: QrVersions.auto,
              size: 200,
            ),
            _logo(invitado),
          ],
        );
      },
    );
  }

  _launchURLBrowser(String url) async {
    //const url = 'https://www.google.com/maps/dir//21.1109375,-86.8425279/@21.1108518,-86.9125808,12z';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _logo(Invitado invitado) {
    return FutureBuilder(
      future: getFraccionamientoId(invitado.idFraccionamiento!),
      builder: (e, AsyncSnapshot<Fraccionamiento?> s) {
        if (s.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        String url = s.data!.urlLogopng.toString();
        _colorFrac = s.data!.getColor();
        String urlUbicacion = s.data!.urlUbicacion.toString();

        return Column(
          children: [
            Container(
              child: const Text("¿No sabes cómo llegar? "),
            ),
            InkWell(
              onTap: () {
                _launchURLBrowser(urlUbicacion);
              },
              child: Container(
                  padding: const EdgeInsets.only(
                      left: 20, right: 15, top: 10, bottom: 10),
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: _colorFrac,
                    border: Border.all(width: 1.0, color: _colorFrac),
                    borderRadius: const BorderRadius.all(Radius.circular(
                            25.0) //                 <--- border radius here
                        ),
                  ),
                  child: const Text(
                    "Ver ubicación",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 150,
              child: Image.network(url),
            ),
          ],
        );
      },
    );
  }

  _reglamento() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 15, top: 10, bottom: 10),
      margin: const EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        border: Border.all(width: 1.0),
        borderRadius: const BorderRadius.all(
            Radius.circular(25.0) //                 <--- border radius here
            ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            child: Text("1.- LÍMITE DE VELOCIDAD 30 KM/H BOULEVARD",
                style: TextStyle(color: Colors.red[900]))),
        Container(
          child: Text("2.- LÍMITE DE VELOCIDAD 30 KM/H EN CALLES INTERNAS",
              style: TextStyle(color: Colors.red[900])),
        ),
        Container(
          child: Text(
              "3.- SANCIÓN DE \$ 750. 00 PESOS M.N. POR EXCESO DE VELOCIDAD",
              style: TextStyle(color: Colors.red[900])),
        ),
        Container(
          child: Text("4.- PROHIBIDO TEXTEAR MIENTRAS CONDUCES",
              style: TextStyle(color: Colors.red[900])),
        ),
        Container(
          child: Text(
              "5.- ES NECESARIO PRESENTAR UNA IDENTIFICACIÓN OFICIAL AL INGRESAR",
              style: TextStyle(color: Colors.red[900])),
        ),
        Container(
          child: Text("6.- NO ESTACIONARSE EN PROPIEDADES PRIVADAS",
              style: TextStyle(color: Colors.red[900])),
        ),
      ]),
    );
  }

  Future<Fraccionamiento?> getFraccionamientoId(String id) async {
    //var snap = _databaseServices.getFracionamientosById(usuario.idFraccionamiento);

    Fraccionamiento fraccionamiento = new Fraccionamiento();

    if (id == "") {
      print("Double tap");
      return null;
    }
    final String _url =
        'https://communedemo-default-rtdb.firebaseio.com/configuracion/fraccionamiento/${id}.json';

    try {
      final response = await http.get(Uri.parse(_url));
      //print("Response***"+response.request.toString());
      final decodedData = jsonDecode(response.body);
      //print("CONFIGURACIÓN " + decodedData.toString());
      fraccionamiento = Fraccionamiento.fromJson(decodedData);
      return fraccionamiento;
    } on TimeoutException catch (exception) {
      print(
          'Error al cargar la configuracion. Tiempo de espera exedido: ${exception.message}');
    } catch (exception) {
      print("Erro inesperado al cargar la configuración: $exception");
    }
  }
}
