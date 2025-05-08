import 'dart:convert';
import 'package:http/http.dart' as http;

class UsuarioRepository {
  static const String _baseUrl = 'https://kauabeeceptor.free.beeceptor.com';
  static const String _endpoint = '/usuarios';

  // Headers comuns para todas as requisições
  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Método para tratar erros de resposta
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.body.isNotEmpty ? json.decode(response.body) : null;
    } else {
      throw Exception(
          'Falha na requisição: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }

  // GET - Listar todos os usuários
  Future<List<dynamic>> listarUsuarios() async {
    final response = await http.get(
      Uri.parse('$_baseUrl$_endpoint'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  // GET - Obter um usuário específico por ID
  Future<dynamic> obterUsuario(String id) async {
    final response = await http.get(
      Uri.parse('$_baseUrl$_endpoint/$id'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  // POST - Criar um novo usuário
  Future<dynamic> criarUsuario(Map<String, dynamic> usuario) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$_endpoint'),
      headers: _headers,
      body: json.encode(usuario),
    );
    return _handleResponse(response);
  }

  // PUT - Atualizar um usuário completo
  Future<dynamic> atualizarUsuario(String id, Map<String, dynamic> usuario) async {
    final response = await http.put(
      Uri.parse('$_baseUrl$_endpoint/$id'),
      headers: _headers,
      body: json.encode(usuario),
    );
    return _handleResponse(response);
  }

  // PATCH - Atualizar parcialmente um usuário
  Future<dynamic> atualizarParcialUsuario(String id, Map<String, dynamic> campos) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl$_endpoint/$id'),
      headers: _headers,
      body: json.encode(campos),
    );
    return _handleResponse(response);
  }

  // DELETE - Remover um usuário
  Future<void> removerUsuario(String id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl$_endpoint/$id'),
      headers: _headers,
    );
    _handleResponse(response);
  }
}