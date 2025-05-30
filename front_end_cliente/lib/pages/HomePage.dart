import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:front_end_cliente/data/notifiers.dart';
import 'package:front_end_cliente/pages/EditPage.dart';
import 'package:front_end_cliente/wingets/CustomDrawer.dart';
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<dynamic> clientes = [];
  String textoProcura = '';
  List<dynamic> filtroClientes = [];

  @override
  void initState() {
    super.initState();
    carregarClientes();
  }

  @override
  Widget build(BuildContext context) {
    // Filtro para pesquisar o nome do cliente
    filtroClientes =
        textoProcura.isEmpty
            ? clientes
            : clientes
                .where(
                  (cliente) => cliente['nome'].toLowerCase().contains(
                    textoProcura.toLowerCase(),
                  ) /* ||
                      cliente['email'].toLowerCase().contains(
                        textoProcura.toLowerCase(),
                      ),*/,
                )
                .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Clientes'),
        actions: [
          IconButton(
            onPressed: () {
              isDarkModeNotifier.value =
                  !isDarkModeNotifier.value; // altera qual o modo que esta
            },
            icon: ValueListenableBuilder(
              valueListenable:
                  isDarkModeNotifier, // verficia qual o modo que esta
              builder: (context, isDarkMode, child) {
                return Icon(
                  isDarkMode ? Icons.light_mode : Icons.dark_mode,
                ); //criando um botao para alterar entra dark e light mode
              },
            ),
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            clientes
                    .isEmpty // Se nao houver clientes, exibe a mensagem
                ? Center(
                  child: Text(
                    "Nenhum cliente cadastrado",
                    style: TextStyle(color: Colors.black, fontSize: 48),
                  ),
                )
                : Column(
                  children: [
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          textoProcura = value.toLowerCase();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Pesquisa",
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: filtroClientes.length,
                        separatorBuilder:
                            (BuildContext context, int index) => Divider(),
                        itemBuilder: (BuildContext context, int index) {
                          var cliente = filtroClientes[index];
                          return ListTile(
                            leading: Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.blue,
                            ),
                            title: Text(
                              cliente['nome'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('E-mail: ${cliente['email']}'),
                                Text('Telefone: ${cliente['telefone']}'),
                                Text('CEP: ${cliente['cep']}'),
                                Text('Localidade: ${cliente['localidade']}'),
                                Text('Estado: ${cliente['estado']}'),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                Editpage(cliente: cliente),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    deletarCliente(cliente['id']);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
      ),
    );
  }

  // Função para carregar a lista de clientes
  Future<void> carregarClientes() async {
    try {
      final response = await http.get(
        Uri.parse("http://localhost:8090/projeto/api/v1/clientes"),
        headers: {'Content-Type': 'application/json; charset=utf8'},
      );

      if (response.statusCode == 200) {
        setState(() {
          String data = utf8.decode(response.bodyBytes);
          clientes = json.decode(data);
        });
      } else {
        throw Exception("Falha ao carregar clientes");
      }
    } catch (e) {
      throw Exception('Erro ao carregar o cliente.');
    }
  }

  // Função para deletar cliente
  Future<void> deletarCliente(String clienteId) async {
    bool? confirmacao = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Deseja deletar o cliente?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, true); //Retorna true se confirmar
              },
              child: Text('Sim'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, false); //Retorna false se cancelar
              },
              child: Text('Não'),
            ),
          ],
        );
      },
    );

    if (confirmacao == true) {
      // Se o usuario confirmar a exclusao, executa o codigo abaixo
      try {
        final responseDelete = await http.delete(
          Uri.parse("http://localhost:8090/projeto/api/v1/clientes/$clienteId"),
          headers: {'Content-Type': 'application/json; charset=utf8'},
        );

        if (responseDelete.statusCode == 204) {
          setState(() {
            clientes.removeWhere((cliente) => cliente['id'] == clienteId);
          });
          //Exibe um dialog de sucesso
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: Text('Deletado com Sucesso'),
                  content: Text('O cliente foi deletado com sucesso!'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Ok'),
                    ),
                  ],
                ),
          );
        } else {
          throw Exception("Falha ao deletar cliente");
        }
      } catch (e) {
        throw Exception('Erro ao deletar cliente.');
      }
    }
  }
}
