import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../modelos/UsuarioModel.dart';
import '../modelos/invitadoModel.dart';

class Conecciones {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<Invitado?> getProfile(String id) async {
    Invitado? invitado;
    try {
      DocumentSnapshot snap = await db.collection('invitados').doc(id).get();
      print(snap.data());
      if (snap.exists) {
        print(snap.data);
        invitado = Invitado.fromMap(snap);
        return invitado;
      }
    } catch (e) {
      print("Error en la toma de datos : " + e.toString());
    }
    return invitado;
  }

  Future<Usuario?> getProfileUsuario(String id) async {
    Usuario? usuario;
    try {
      DocumentSnapshot snap = await db.collection('usuarios').doc(id).get();
      print(snap.data());
      if (snap.exists) {
        print(snap.data);
        usuario = Usuario.fromMap((snap.data() as Map<dynamic, dynamic>));
        return usuario;
      }
    } catch (e) {
      print("Error en la toma de datos : " + e.toString());
    }
    return usuario;
  }
}
