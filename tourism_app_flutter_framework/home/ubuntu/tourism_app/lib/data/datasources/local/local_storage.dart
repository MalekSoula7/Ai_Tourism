



abstract class LocalStorage {
  // Define methods like saveToken, getToken, clearData etc.
  Future<void> saveToken(String token);
  Future<String?> getIdToken();
  // Future<void> clearData();
}

