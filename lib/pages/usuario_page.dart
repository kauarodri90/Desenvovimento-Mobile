import 'package:flutter/material.dart';
import '../repository/usuario_repository.dart';
import '../models/usuario.dart';
import '../widgets/acessibilidade_menu.dart';

class UsuarioPage extends StatefulWidget {
  const UsuarioPage({Key? key}) : super(key: key);

  @override
  _UsuarioPageState createState() => _UsuarioPageState();
}

class _UsuarioPageState extends State<UsuarioPage> {
  final UsuarioRepository _repository = UsuarioRepository();
  List<Usuario> _usuarios = [];
  bool _carregando = false;
  String _mensagem = '';

  @override
  void initState() {
    super.initState();
    _carregarUsuarios();
  }

  Future<void> _carregarUsuarios() async {
    setState(() {
      _carregando = true;
      _mensagem = '';
    });

    try {
      final usuarios = await _repository.listarUsuarios();
      setState(() => _usuarios = usuarios);
    } catch (e) {
      setState(() => _mensagem = 'Erro ao carregar usuários: $e');
    } finally {
      setState(() => _carregando = false);
    }
  }

  Future<void> _criarUsuario() async {
    try {
      final novoUsuario = Usuario(nome: 'Novo Usuário', email: 'novo@exemplo.com');
      await _repository.criarUsuario(novoUsuario);
      setState(() => _mensagem = 'Usuário criado com sucesso');
      await _carregarUsuarios();
    } catch (e) {
      setState(() => _mensagem = 'Erro ao criar usuário: $e');
    }
  }

  Future<void> _removerUsuario(int id) async {
    try {
      final db = _repository.dbHelper;
      final database = await db.database;
      await database.delete('usuarios', where: 'id = ?', whereArgs: [id]);
      setState(() => _mensagem = 'Usuário removido');
      await _carregarUsuarios();
    } catch (e) {
      setState(() => _mensagem = 'Erro ao remover: $e');
    }
  }

  Future<void> _editarUsuario(Usuario usuario) async {
    final nomeController = TextEditingController(text: usuario.nome);
    final emailController = TextEditingController(text: usuario.email);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Usuário'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              usuario.nome = nomeController.text;
              usuario.email = emailController.text;
              final db = _repository.dbHelper;
              final database = await db.database;
              await database.update(
                'usuarios',
                usuario.toMap(),
                where: 'id = ?',
                whereArgs: [usuario.id],
              );
              Navigator.pop(context);
              await _carregarUsuarios();
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Usuários'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _criarUsuario,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarUsuarios,
          ),
          const AcessibilidadeMenu(),
        ],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (_mensagem.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _mensagem,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _usuarios.length,
                    itemBuilder: (context, index) {
                      final usuario = _usuarios[index];
                      return ListTile(
                        title: Text(usuario.nome),
                        subtitle: Text(usuario.email),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _editarUsuario(usuario),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _removerUsuario(usuario.id!),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}