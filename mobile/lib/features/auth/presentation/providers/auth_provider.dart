import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_user.dart';

// --- 1. STATE (Kondisi Layar) ---
// Kita mendefinisikan 4 kondisi yang mungkin terjadi di layar Login
abstract class AuthState {}

class AuthInitial extends AuthState {} // Tampilan awal (belum ngapa-ngapain)

class AuthLoading
    extends AuthState {} // Tombol dipencet, muncul muter-muter (loading)

class AuthSuccess extends AuthState {
  // Login berhasil!
  final User user;
  AuthSuccess(this.user);
}

class AuthError extends AuthState {
  // Login gagal (password salah, dll)
  final String message;
  AuthError(this.message);
}

// --- 2. NOTIFIER (Yang Ngatur Logika) ---
class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUser _loginUser;

  // Nilai awal adalah AuthInitial
  AuthNotifier(this._loginUser) : super(AuthInitial());

  // Fungsi yang bakal dipanggil sama tombol Login di UI nanti
  Future<void> login(String email, String password) async {
    state =
        AuthLoading(); // Ubah state jadi loading (UI bakal nampilin muter-muter)

    // Panggil UseCase dari Domain Layer
    final result = await _loginUser.execute(email, password);

    // Fold dari Either (Dartz): Kiri itu Error, Kanan itu Sukses
    result.fold(
      (failure) => state = AuthError(
        failure.message,
      ), // Kalau gagal, kirim pesan error ke UI
      (user) =>
          state = AuthSuccess(user), // Kalau sukses, kirim data user ke UI
    );
  }
}

// --- 3. PROVIDER (Yang Dibaca sama UI) ---
// Perhatikan gimana kita ngambil LoginUser dari gudang GetIt (sl()) yang udah kita bikin tadi
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(sl<LoginUser>());
});
