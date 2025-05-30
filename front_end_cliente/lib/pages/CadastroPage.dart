import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front_end_cliente/data/notifiers.dart';
import 'package:front_end_cliente/wingets/CustomDrawer.dart';
import 'package:http/http.dart' as http;

class Cadastropage extends StatefulWidget {
  const Cadastropage({super.key});

  @override
  State<Cadastropage> createState() => _CadastropageState();
}

class _CadastropageState extends State<Cadastropage> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Cliente'),
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

                      cadastrarCliente(
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
                  child: Text("Cadastrar"),
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
            estadoController.text = endereco['estado'];
            ufController.text = endereco['uf'];
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

  //Função para cadastrar um cliente
  Future<void> cadastrarCliente(
    String nome,
    String email,
    String telefone,
    String cep,
    String localidade,
    String estado,
    String uf,
  ) async {
    final data = {
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
      final response = await http.post(
        Uri.parse("http://localhost:8090/projeto/api/v1/clientes"),
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        //Limpar os campos do formulário
        nameController.clear();
        emailController.clear();
        telefoneController.clear();
        cepController.clear();
        localidadeController.clear();
        estadoController.clear();
        ufController.clear();

        return showDialog<void>(
          context: context,
          barrierDismissible: false, //Usuario deve aprovar o alert
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Cadastrado com Sucesso'),
              content: const SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[Text('Cadastro realizado com sucesso!')],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ok'),
                ),
              ],
            );
          },
        );
      } else {
        throw Exception("Falha ao cadastrar cliente");
      }
    } catch (e) {
      throw Exception('Erro ao cadastrar o cliente.');
    }
  }
}
