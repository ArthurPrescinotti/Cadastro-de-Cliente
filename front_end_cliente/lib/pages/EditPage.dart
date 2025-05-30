import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:front_end_cliente/data/notifiers.dart';
import 'package:front_end_cliente/pages/HomePage.dart';
import 'package:front_end_cliente/wingets/CustomDrawer.dart';
import 'package:http/http.dart' as http;

class Editpage extends StatefulWidget {
  final dynamic cliente;

  const Editpage({super.key, required this.cliente});

  @override
  State<Editpage> createState() => _EditpageState();
}

class _EditpageState extends State<Editpage> {
  List<dynamic> clientes = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();
  TextEditingController cepController = TextEditingController();
  TextEditingController localidadeController = TextEditingController();
  TextEditingController estadoController = TextEditingController();
  TextEditingController ufController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Puxando os nomes para os controller
    nameController.text = widget.cliente['nome'];
    emailController.text = widget.cliente['email'];
    telefoneController.text = widget.cliente['telefone'];
    cepController.text = widget.cliente['cep'];
    localidadeController.text = widget.cliente['localidade'];
    estadoController.text = widget.cliente['estado'];
    ufController = widget.cliente['uf'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edicao de Cliente'),
        actions: [
          IconButton(
            onPressed: () {
              isDarkModeNotifier.value =
                  !isDarkModeNotifier.value; // altera qual o modo que esta
            },
            icon: ValueListenableBuilder(
              valueListenable:
                  isDarkModeNotifier, // verficia qual o modo que esta
              builder: (context, isDarMode, child) {
                return Icon(
                  isDarMode ? Icons.light_mode : Icons.dark_mode,
                ); //criando um botao para alterar entra dark e light mode
              },
            ),
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: "Nome",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Por favor, insira um nome válido.";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.mail),
                    labelText: "E-Mail",
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains('@') ||
                        !value.contains('.')) {
                      return "Por favor, insira um e-mail válido.";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: telefoneController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.phone),
                    labelText: "Telefone",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Por favor, insira um telefone válido.";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: cepController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.location_on),
                    labelText: "CEP",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Por favor, insira um CEP válido.";
                    }
                    return null;
                  },
                  onChanged: (cep) {
                    if (cep.length == 8) {
                      buscarEndereco(cep);
                    } else {
                      setState(() {
                        localidadeController.text = "";
                        estadoController.text = "";
                      });
                    }
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: localidadeController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.location_city),
                    labelText: "Cidade",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Por favor, insira um CEP válido.";
                    }
                    return null;
                  },
                  enabled: false,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: estadoController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.flag),
                    labelText: "Estado",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Por favor, insira um CEP válido.";
                    }
                    return null;
                  },
                  enabled: false,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: ufController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.flag),
                    labelText: "Uf",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Por favor, insira um CEP válido.";
                    }
                    return null;
                  },
                  enabled: false,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      String nome = nameController.text;
                      String email = emailController.text;
                      String telefone = telefoneController.text;
                      String cep = cepController.text;
                      String localidade = localidadeController.text;
                      String estado = estadoController.text;
                      String uf = ufController.text;

                      editarCliente(
                        nome,
                        email,
                        telefone,
                        cep,
                        localidade,
                        estado,
                        uf,
                      );
                    }
                  },
                  child: Text("Atualizar"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Funcao para pesquisar o CEP em uma API externa
  Future<void> buscarEndereco(String cep) async {
    try {
      Map<String, dynamic> endereco = {};
      final response = await http.get(
        Uri.parse("https://viacep.com.br/ws/$cep/json/"),
      );

      if (response.statusCode == 200) {
        setState(() {
          String data = utf8.decode(response.bodyBytes);
          endereco = json.decode(data);
        });

        if (endereco.isNotEmpty && !endereco.containsKey('erro')) {
          setState(() {
            localidadeController.text = endereco['localidade'];
            ufController.text = endereco['uf'];
            estadoController.text = endereco['estado'];
          });
        } else {
          print("Erro: CEP invalido ou nao encontrado.");
          setState(() {
            localidadeController.text = "";
            estadoController.text = "";
            ufController.text = "";
          });
        }
      }
    } catch (e) {
      print("Erro ao buscar o CEP.");
      setState(() {
        localidadeController.text = "";
        estadoController.text = "";
        ufController.text = "";
      });
    }
  }

  Future<void> editarCliente(
    String nome,
    String email,
    String telefone,
    String cep,
    String localidade,
    String estado,
    String uf,
  ) async {
    final data = {
      "id": widget.cliente['id'],
      "nome": nome,
      "email": email,
      "telefone": telefone,
      "cep": cep,
      "localidade": localidade,
      "estado": estado,
      "uf": uf,
    };

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    try {
      final response = await http.put(
        Uri.parse("http://localhost:8090/projeto/api/v1/clientes"),
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        // Exibindo o alert primeiro

        showDialog<void>(
          context: context,
          barrierDismissible: false, // Usuário deve aprovar o alert
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Cliente Atualizado'),
              content: const SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[Text('Cliente atualizado com sucesso!')],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Fechar o alert
                    // Agora, navegar para a homepage após o fechamento do dialog
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Homepage()),
                    );
                  },
                  child: const Text('Ok'),
                ),
              ],
            );
          },
        );
      } else {
        throw Exception("Falha ao atualizar cliente");
      }
    } catch (e) {
      throw Exception('Erro ao editar o cliente.');
    }
  }
}
