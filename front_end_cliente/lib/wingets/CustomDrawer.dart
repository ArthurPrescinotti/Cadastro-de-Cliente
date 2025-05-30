import 'package:flutter/material.dart';
import 'package:front_end_cliente/pages/CadastroPage.dart';
import 'package:front_end_cliente/pages/HomePage.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            title: Text('Página Inicial'),
            onTap: () {
              Navigator.pop(context); // Fechar o Drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Homepage()),
              );
            },
          ),
          ListTile(
            title: Text('Cadastro'),
            onTap: () {
              Navigator.pop(context); // Fecha o Drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Cadastropage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
