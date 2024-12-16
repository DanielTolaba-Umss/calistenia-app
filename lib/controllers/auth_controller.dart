// lib/controllers/auth_controller.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class AuthController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _userModel;
  bool _isLoading = false;

  // Constructor mejorado
  AuthController() {
    debugPrint('Inicializando AuthController');
    _initializeAuth();
  }

  // Getters
  User? get currentUser => _auth.currentUser;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Inicialización y escucha de cambios de autenticación
  Future<void> _initializeAuth() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      debugPrint('Usuario actual encontrado: ${currentUser.email}');
      await loadUserData();
    }

    _auth.authStateChanges().listen((User? user) async {
      debugPrint('Cambio en estado de autenticación: ${user?.email}');
      if (user != null) {
        await loadUserData();
      } else {
        _userModel = null;
        notifyListeners();
      }
    });
  }

  // Método para cargar datos del usuario
  Future<void> loadUserData() async {
    if (_auth.currentUser == null) return;

    try {
      final docSnapshot = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null) {
          _userModel = UserModel.fromMap(data, docSnapshot.id);
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error al cargar datos del usuario: $e');
    }
  }

  // Método de inicio de sesión
  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      User? user;
      try {
        final userCredential = await _auth.signInWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );
        user = userCredential.user;
      } catch (e) {
        if (e.toString().contains('PigeonUserDetails')) {
          // Si es el error de Pigeon, verificar si la autenticación fue exitosa
          user = _auth.currentUser;
        } else {
          rethrow;
        }
      }

      if (user != null) {
        // Si el usuario está autenticado, cargar sus datos
        await loadUserData();
        return null;
      }

      return 'Error al iniciar sesión';
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'No existe una cuenta con este email';
        case 'wrong-password':
          return 'Contraseña incorrecta';
        case 'invalid-email':
          return 'Email inválido';
        case 'user-disabled':
          return 'Esta cuenta ha sido deshabilitada';
        default:
          return e.message ?? 'Error de autenticación';
      }
    } catch (e) {
      return 'Error inesperado durante el inicio de sesión';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Método de registro

  Future<String?> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      User? user;
      try {
        final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );
        user = userCredential.user;
      } catch (e) {
        if (e.toString().contains('PigeonUserDetails')) {
          user = _auth.currentUser;
        } else {
          rethrow;
        }
      }

      if (user != null) {
        // Crear documento en Firestore
        final userData = {
          'uid': user.uid,
          'name': name.trim(),
          'email': email.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        };

        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(userData);

        // Cerrar sesión para que el usuario tenga que iniciar sesión manualmente
        await _auth.signOut();
        _userModel = null;
        notifyListeners();

        return null;
      }
      return 'Error al crear el usuario';
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'Ya existe una cuenta con este email';
        case 'invalid-email':
          return 'Email inválido';
        case 'weak-password':
          return 'La contraseña es demasiado débil';
        default:
          return e.message ?? 'Error en el registro';
      }
    } catch (e) {
      return 'Error inesperado durante el registro';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Método para recuperar contraseña
  Future<String?> resetPassword(String email) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _auth.sendPasswordResetEmail(
        email: email.trim(),
      );
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'auth/invalid-email':
          return 'Email inválido';
        case 'auth/user-not-found':
          return 'No existe una cuenta con este email';
        default:
          return e.message ?? 'Error al enviar el correo de recuperación';
      }
    } catch (e) {
      debugPrint('Error inesperado en resetPassword: $e');
      return 'Error inesperado al intentar recuperar la contraseña';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Método para cerrar sesión
  Future<void> signOut() async {
    try {
      _isLoading = true;
      notifyListeners();

      await _auth.signOut();
      _userModel = null;
    } catch (e) {
      debugPrint('Error al cerrar sesión: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Método para actualizar perfil
  Future<String?> updateProfile({
    String? name,
    String? photoUrl,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      if (_auth.currentUser == null) {
        return 'No hay usuario autenticado';
      }

      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name.trim();
      if (photoUrl != null) updates['photoUrl'] = photoUrl;

      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update(updates);

      await loadUserData();
      return null;
    } catch (e) {
      debugPrint('Error actualizando perfil: $e');
      return 'Error actualizando el perfil';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}