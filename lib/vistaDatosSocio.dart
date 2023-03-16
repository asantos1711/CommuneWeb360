import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:g_recaptcha_v3/g_recaptcha_v3.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

import 'conecciones/conecciones.dart';
import 'modelos/UsuarioModel.dart';
import 'modelos/fraccionamientos.dart';

class VistaDatosSocio extends StatefulWidget {
  String qrCode;
  VistaDatosSocio({required this.qrCode});

  @override
  State<VistaDatosSocio> createState() => _VistaDatosSocioState();
}

class _VistaDatosSocioState extends State<VistaDatosSocio> {
  late double h, w;
  late String _token;

  final FirebaseFirestore db = FirebaseFirestore.instance;
  Color _colorFrac = Colors.white;
  late Usuario usuario;

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
      future: conecciones.getProfileUsuario(this.widget.qrCode),
      builder: (c, AsyncSnapshot<Usuario?> s) {
        if (s.connectionState == ConnectionState.waiting) {
          return const Center(child: const CircularProgressIndicator());
        }

        if (s.data == null || !s.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [const Text("¡UPS! No existe el Usuario")],
          );
        }

        usuario = s.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            const Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "¡Hola!, estos son tus datos para acceder a la aplicación:",
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            _datosUsuario(),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "¡Atención!, No compartas tus credenciales de acceso con nadie más",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red[900]),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Si no tienes la aplicación móvil Cumbres Residenciales, puedes descargarla en los siguientes sitios:",
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: InkWell(
                      onTap: () {
                        _launchUrl(
                            "https://play.google.com/store/apps/details?id=com.commune.communeapp");
                      },
                      child: Icon(
                        FontAwesomeIcons.googlePlay,
                        size: 30,
                        color: Colors.blue[800],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  Container(
                    child: InkWell(
                      onTap: () {
                        _launchUrl(
                            "https://apps.apple.com/mx/app/cumbres-residencial/id1555505159");
                      },
                      child: Icon(FontAwesomeIcons.appStore,
                          size: 30, color: Colors.blue[800]),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            _logo(usuario),
          ],
        );
      },
    );
  }

  Future<void> _launchUrl(String _url) async {
    if (!await launchUrl(Uri.parse(_url))) {
      throw 'Could not launch $_url';
    }
  }

  _datosUsuario() {
    return Container(
      //height: h * 0.4,
      child: Column(
        children: [
          _texto(usuario.email.toString(), "Correo"),
          _texto(usuario.password.toString(), "Password"),
          // Container(
          //   child: TextFormFieldBorder(
          //     "Correo",
          //     TextEditingController(
          //         text: this.widget.usuario!.email.toString() ?? ""),
          //     readOnly: true,
          //   ),
        ],
      ),
    );
  }

  _texto(String texto, String label) {
    return Container(
      width: w * 0.7,
      child: TextField(
        decoration: InputDecoration(
            label: Text(label),
            suffixIcon: InkWell(
                onTap: () {
                  FlutterClipboard.copy(texto).then((value) {
                    Alert(
                      context: context,
                      //title: "",
                      desc: "Copiado",
                      buttons: [
                        DialogButton(
                          radius: const BorderRadius.all(Radius.circular(25)),
                          color: Colors.blue,
                          child: const Text(
                            "Aceptar",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          width: 120,
                        )
                      ],
                    ).show();
                  });
                },
                child: const Icon(
                  Icons.copy,
                ))),
        readOnly: true,
        controller: TextEditingController(text: texto),
      ),
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

  _logo(Usuario invitado) {
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

  Future<Fraccionamiento?> getFraccionamientoId(String id) async {
    //var snap = _databaseServices.getFracionamientosById(usuario.idFraccionamiento);

    Fraccionamiento _fracc = new Fraccionamiento();

    if (id == "") {
      print("Double tap");
      return null;
    }

    DocumentSnapshot snaps =
        await db.collection('fraccionamientos').doc(id).get();
    print(snaps.data());

    if (snaps.exists) {
      print("dentro");
      Map<String, dynamic> mapa = snaps.data() as Map<String, dynamic>;
      _fracc = Fraccionamiento.fromJson(mapa);
      return _fracc;
    }

    //print(usuarioBloc.miFraccionamiento.color?.r);
  }
}
