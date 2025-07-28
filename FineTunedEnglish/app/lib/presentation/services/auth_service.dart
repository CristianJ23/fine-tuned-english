import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuarios.dart';


class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static Usuarios? currentUser;

  Future<String?> signInWithEmailAndPassword({ required String email, required String password }) async {
    try {
      final querySnapshot = await _firestore
          .collection('usuarios')
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        currentUser = Usuarios.fromFirestore(querySnapshot.docs.first);
        return null;
      } else {
        return 'Correo electrónico o contraseña incorrectos.';
      }
    } catch (e) {
      return 'Ocurrió un error. Por favor, intenta de nuevo.';
    }
  }

  Future<void> signOut() async {
    currentUser = null;
  }

  Future<String?> registerStudent({
    required String email,
    required String password,
    required String nombres,
    required String apellidos,
    required String numeroCedula,
    required String telefono,
    required String nivelEducacion,
    required DateTime fechaNacimiento,
  }) async {
    try {
      final existingUser = await _firestore.collection('usuarios').where('email', isEqualTo: email).get();
      if (existingUser.docs.isNotEmpty) {
        return 'El correo electrónico ya está en uso.';
      }

      await _firestore.collection('usuarios').add({
        'email': email,
        'password': password,
        'nombres': nombres,
        'apellidos': apellidos,
        'numeroCedula': numeroCedula,
        'telefono': telefono,
        'nivelEducacion': nivelEducacion,
        'fechaNacimiento': Timestamp.fromDate(fechaNacimiento),
        'rol': 'estudiante',
      });
      return null;
    } catch (e) {
      return 'Ocurrió un error en el registro: ${e.toString()}';
    }
  }

  static Usuarios? get currentUserStatic {
    return currentUser;
  }
}