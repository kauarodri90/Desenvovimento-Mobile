import '../models/usuario.dart';
import '../database/database_helper.dart';

class UsuarioRepository {
  final dbHelper = DatabaseHelper();

  Future<void> criarUsuario(Usuario usuario) async {
    await dbHelper.insertUsuario(usuario);
  }

  Future<List<Usuario>> listarUsuarios() async {
    return await dbHelper.getUsuarios();
  }
}
