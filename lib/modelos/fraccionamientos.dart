import 'package:flutter/material.dart';

class Fraccionamiento {
  String? nombre;
  String? urlLogopng;
  String? urlLogojpg;
  ColorF? color;
  String? id;
  String? keyStripe;
  String? urlApi;
  bool? pagar;
  bool? amenidades;
  bool? reportes;
  String? terminos;
  String? urlUbicacion;
  String? logoWeb;
  List<String>? reglasWeb;
  bool? idNumerico;
  bool? fastEntry;

  Fraccionamiento(
      {this.nombre,
      this.urlLogopng,
      this.color,
      this.urlLogojpg,
      this.id,
      this.keyStripe,
      this.urlApi,
      this.urlUbicacion,
      this.pagar,
      this.amenidades,
      this.terminos,
      this.logoWeb,
      this.reglasWeb,
      this.idNumerico,
      this.fastEntry,
      this.reportes});

  Color getColor() {
    return Color.fromARGB(255, color!.r, color!.g, color!.b);
  }

  factory Fraccionamiento.fromJson(Map<String, dynamic> json) =>
      Fraccionamiento(
        nombre: json["nombre"] == null ? null : json["nombre"],
        id: json["id"] == null ? null : json["id"],
        urlLogopng: json["urlLogopng"] == null ? null : json["urlLogopng"],
        urlLogojpg: json["urlLogojpg"] == null ? null : json["urlLogojpg"],
        keyStripe: json["keyStripe"] == null ? null : json["keyStripe"],
        urlApi: json["urlApi"] == null ? null : json["urlApi"],
        pagar: json["pagar"] == null ? null : json["pagar"],
        logoWeb: json["logoWeb"] == null ? null : json["logoWeb"],
        reglasWeb: json["reglasWeb"] == null
            ? null
            : List<String>.from(json["reglasWeb"].map((x) => x)),
        urlUbicacion:
            json["urlUbicacion"] == null ? null : json["urlUbicacion"],
        amenidades: json["amenidades"] == null ? false : json["amenidades"],
        reportes: json["reportes"] == null ? false : json["reportes"],
        idNumerico: json["idNumerico"] == null ? false : json["idNumerico"],
        terminos: json["terminos"] == null ? null : json["terminos"],
        fastEntry: json["fastEntry"] == null ? false : json["fastEntry"],
        color: json["color"] == null ? null : ColorF.fromJson(json["color"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "nombre": nombre == null ? null : nombre,
        "urlLogopng": urlLogopng == null ? null : urlLogopng,
        "urlLogojpg": urlLogojpg == null ? null : urlLogojpg,
        "keyStripe": keyStripe == null ? null : keyStripe,
        "urlApi": urlApi == null ? null : urlApi,
        "pagar": pagar == null ? null : pagar,
        "amenidades": amenidades == null ? null : amenidades,
        "terminos": terminos == null ? false : terminos,
        "reportes": reportes == null ? false : reportes,
        "logoWeb": logoWeb == null ? null : logoWeb,
        "idNumerico": idNumerico == null ? null : idNumerico,
        "fastEntry": fastEntry == null ? false : fastEntry,
        "urlUbicacion": urlUbicacion == null ? false : urlUbicacion,
        "color": color == null ? null : color!.toJson(),
      };
}

class ColorF {
  ColorF({
    required this.r,
    required this.g,
    required this.b,
  });

  int r;
  int g;
  int b;

  factory ColorF.fromJson(Map<String, dynamic> json) => ColorF(
        r: json["r"] == null ? null : json["r"],
        g: json["g"] == null ? null : json["g"],
        b: json["b"] == null ? null : json["b"],
      );

  Map<String, dynamic> toJson() => {
        "r": r == null ? null : r,
        "g": g == null ? null : g,
        "b": b == null ? null : b,
      };
}
