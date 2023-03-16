import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../Encrypt.dart';

class Usuario {
  String? nombre;
  String? telefono;
  String? email;
  String? password;
  String? idResidente;
  String? direccion;
  String? tipo;
  String? estatus;
  int? lote;
  String? idTitular;
  int? idRegistro;
  String? tokenNoti;
  String? idFraccionamiento;
  int? lotePadre;

  //Solo para asociados de Obra
  String? idInvitacion;
  String? puesto;

  Usuario({
    this.nombre,
    this.telefono,
    this.email,
    this.password,
    this.direccion,
    this.idResidente,
    this.tipo,
    this.estatus,
    this.lote,
    this.idTitular,
    this.idFraccionamiento,
    this.tokenNoti,
    this.idRegistro,
    this.lotePadre,
    this.idInvitacion,
    this.puesto,
  });

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'telefono': telefono,
        'email': email,
        'direccion': direccion,
        'password': EncryptData.encryptAES(password!),
        'tipo': tipo,
        'idResidente': idResidente,
        'estatus': estatus,
        'lote': lote ?? null,
        'idTitular': idTitular,
        'tokenNoti': tokenNoti,
        'idRegistro': idRegistro,
        'idFraccionamiento': idFraccionamiento,
        'lotePadre': lotePadre,
        'idInvitacion': idInvitacion,
        'puesto': puesto,
      };

  factory Usuario.fromMap(Map data) {
    return Usuario(
      nombre: data['nombre'] ?? '',
      telefono: data['telefono'] ?? '',
      email: data['email'] ?? null,
      password: data['password'] == null
          ? ""
          : EncryptData.decryptAES(data['password']),
      direccion: data['direccion'],
      tipo: data['tipo'],
      idResidente: data['idResidente'] ?? '',
      estatus: data['estatus'] ?? '',
      idTitular: data['idTitular'] ?? '',
      tokenNoti: data['tokenNoti'] ?? '',
      idFraccionamiento: data['idFraccionamiento'] ?? '',
      idRegistro: data['idRegistro'] ?? null,
      lotePadre: data['lotePadre'] ?? null,
      idInvitacion: data['idInvitacion'] ?? null,
      puesto: data['puesto'] ?? null,
      lote: int.parse(data['lote'].toString()),
    );
  }

  factory Usuario.fromFirestore(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    Map data = doc.data();
    return Usuario(
      nombre: data['nombre'] ?? '',
      telefono: data['telefono'] ?? '',
      email: data['email'] ?? null,
      tipo: data['tipo'],
      direccion: data['direccion'],
      idResidente: data['idResidente'] ?? '',
      estatus: data['estatus'] ?? '',
      idRegistro: data['idRegistro'] ?? null,
      idFraccionamiento: data['idFraccionamiento'] ?? '',
      tokenNoti: data['tokenNoti'] ?? '',
      idTitular: data['idTitular'] ?? '',
      lotePadre: data['lotePadre'] ?? null,
      idInvitacion: data['idInvitacion'] ?? null,
      puesto: data['puesto'] ?? null,
      lote: int.tryParse(data['lote'].toString()) ?? null,
    );
  }
}
