abstract class AuthRepository {
  Future<void> signIn();

  Future<void> checkEmail(String email);
  Future<void> forgotPassword(String password);

}
