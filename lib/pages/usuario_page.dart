import 'package:flutter/material.dart';
import '../repository/usuario_repository.dart';

class UsuarioPage extends StatefulWidget {
  const UsuarioPage({Key? key}) : super(key: key);

  @override
  _UsuarioPageState createState() => _UsuarioPageState();
}

class _UsuarioPageState extends State<UsuarioPage> {
  final UsuarioRepository _repository = UsuarioRepository();
  List<dynamic> _usuarios = [];
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
      final novoUsuario = await _repository.criarUsuario({
        'nome': 'Novo Usuário',
        'email': 'novo@exemplo.com'
      });
      setState(() {
        _mensagem = 'Usuário criado: ${novoUsuario['nome']}';
        _carregarUsuarios(); // Recarrega a lista
      });
    } catch (e) {
      setState(() => _mensagem = 'Erro ao criar usuário: $e');
    }
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
                        title: Text(usuario['nome'] ?? 'Sem nome'),
                        subtitle: Text(usuario['email'] ?? 'Sem email'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            try {
                              await _repository.removerUsuario(usuario['id']);
                              setState(() {
                                _mensagem = 'Usuário removido';
                                _carregarUsuarios();
                              });
                            } catch (e) {
                              setState(() => _mensagem = 'Erro ao remover: $e');
                            }
                          },
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