import 'package:artstation/models/models.dart';

abstract class BaseUserRepository {
  Future<User> getUserWithId({String userId});
  Future<void> updateUser({User user});
  Future<List<User>> searchUsers({String query});
}