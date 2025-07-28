import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuarios.dart'; // Asegúrate de que la ruta sea correcta
import 'package:firebase_auth/firebase_auth.dart';

final usuarioActual = FirebaseAuth.instance.currentUser;
final uid = usuarioActual?.uid;


class UsuariosService {
  final CollectionReference _usuariosRef =
  FirebaseFirestore.instance.collection('usuarios');

  // Future<void> guardarUsuario(Usuarios usuario) async {
  //   try {
  //     // Usamos el método toJson() del modelo Usuarios
  //     await _usuariosRef.doc(usuario.id).set(usuario.toJson());
  //   } catch (e) {
  //     throw Exception('Error al guardar usuario: $e');
  //   }
  // }

  Future<Usuarios?> obtenerUsuarioActual() async {
    try {
      final usuarioFirebase = FirebaseAuth.instance.currentUser;
      if (usuarioFirebase != null) {
        final doc = await _usuariosRef.doc(usuarioFirebase.uid).get();
        if (doc.exists) {
          return Usuarios.fromFirestore(doc);
        }
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener usuario: $e');
    }
  }


  Future<Usuarios?> obtenerUsuario(String uid) async {
    try {
      final doc = await _usuariosRef.doc(uid).get();
      if (doc.exists) {
        return Usuarios.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener usuario: $e');
    }
  }

  // Opcional: Para obtener un stream de todos los usuarios o por rol
  Stream<List<Usuarios>> getUsuarios({String? rol}) {
    Query query = _usuariosRef;
    if (rol != null) {
      query = query.where('rol', isEqualTo: rol);
    }
    return query.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Usuarios.fromFirestore(doc))
        .toList());
  }
}