import '../comanda/comanda_create_widget.dart';
import '../config.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'comanda.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;
  List<Comanda> comandas = [];

  String _response = '';
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Future<void> fetchData() async {
    final url = 'http://192.168.100.224:3000/voice-to-text/hola';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print('---------xx--------hola');

        // _response = json.decode(response.body).toString();
        setState(() {
          _response = response.body;
          print('respuesta : ' + _response);
        });
      } else {
        setState(() {
          _response = 'Error: ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        _response = 'Error: $e';
      });
    }
  }

  Future<void> fetchComandas() async {
    final response = await http.get(Uri.parse('$backendUrl/pedido'));

    if (response.statusCode == 200) {
      print("comandas: " + response.body.toString());
      final List<dynamic> comandaList = json.decode(response.body);
      setState(() {
        comandas = comandaList.map((data) => Comanda.fromJson(data)).toList();
      });
    } else {
      print('Error al cargar comandas');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchComandas();

    _model = Provider.of<HomePageModel>(context, listen: false);
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Stack(
              children: [
                Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: Image.network(
                    'https://media.revistaad.es/photos/6564b1c0eac3ac56e8b13723/1:1/pass/undefined',
                    width: double.infinity,
                    height: 255,
                    fit: BoxFit.cover,
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 60, 20, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 17),
                          child: Image.network(
                            'https://scontent.fvvi1-1.fna.fbcdn.net/v/t1.15752-9/441501511_814139113971100_2713612025277906792_n.png?_nc_cat=104&ccb=1-7&_nc_sid=5f2048&_nc_ohc=6xRn7uJFBkEQ7kNvgF4F63i&_nc_ht=scontent.fvvi1-1.fna&oh=03_Q7cD1QHqyMLcymWyaNeG94vpX0D5Kz_oc05cdamCSpawCDkezg&oe=667DBBC3',
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Text(
                          'Tu lugar favorito',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Playfair Display',
                                    color: FlutterFlowTheme.of(context).dark400,
                                    fontSize: 16,
                                    letterSpacing: 0,
                                    fontStyle: FontStyle.italic,
                                  ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 27, 0, 0),
                          child: Container(
                            width: double.infinity,
                            height: 52,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(-1, 0),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(10, 15, 0, 20),
                            child: Text(
                              'Tus Comandas',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Playfair Display',
                                    fontSize: 15,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ),
                        RefreshIndicator(
                          onRefresh: fetchComandas,
                          child: Container(
                            height: MediaQuery.of(context).size.height *
                                0.6, // Ajusta según sea necesario
                            child: GridView.builder(
                              padding: EdgeInsets.zero,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 1.0,
                              ),
                              itemCount: comandas.length,
                              itemBuilder: (context, index) {
                                final comanda = comandas[index];

                                // Parsear los datos de la comanda
                                List<String> platos = comanda.plato
                                    .map((item) =>
                                        '${item['cantidad']} x ${item['nombre']}')
                                    .toList();
                                List<String> bebidas = comanda.bebida
                                    .map((item) =>
                                        '${item['cantidad']} x ${item['nombre']}')
                                    .toList();

                                return ComandaCard(
                                  nroPedido: comanda.nroPedido,
                                  numeroMesa: comanda.nroMesa,
                                  horaPedido: comanda.fecha,
                                  hora: comanda.hora,
                                  platos: platos,
                                  bebidas: bebidas,
                                  extras: comanda.extras,
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // fetchData();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ComandaCreateWidget(),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: FlutterFlowTheme.of(context).alternate,
      ),
    );
  }
}

class ComandaCard extends StatelessWidget {
  final int nroPedido;
  final int numeroMesa;
  final String horaPedido;
  final String hora;
  final List<String> platos;
  final List<String> bebidas;
  final String extras;

  const ComandaCard({
    Key? key,
    required this.nroPedido,
    required this.numeroMesa,
    required this.horaPedido,
    required this.hora,
    required this.platos,
    required this.bebidas,
    required this.extras,
  }) : super(key: key);

  void _confirmDeletion(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Eliminar Comanda'),
          content: Text('¿Estás seguro de que deseas eliminar esta comanda?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
            TextButton(
              child: Text('Eliminar', style: TextStyle(color: Colors.red)),
              onPressed: () {
                deletePedido(context, nroPedido);
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showDetailsModal(context),
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Mesa $numeroMesa',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.red),
                onPressed: () => _confirmDeletion(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> deletePedido(BuildContext context, int nro) async {
    final response = await http.delete(Uri.parse('$backendUrl/pedido/$nro'));

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Comanda eliminada con éxito')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error al eliminar comanda')));
    }
  }

  void _showDetailsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mesa: $numeroMesa',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Hora del pedido: $horaPedido $hora',
                    style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                Text('Platos:',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ...platos
                    .map((plato) =>
                        Text('- $plato', style: TextStyle(fontSize: 14)))
                    .toList(),
                SizedBox(height: 10),
                Text('Bebidas:',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ...bebidas
                    .map((bebida) =>
                        Text('- $bebida', style: TextStyle(fontSize: 14)))
                    .toList(),
                SizedBox(height: 10),
                Text('Extras:',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(extras, style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
        );
      },
    );
  }
}



// const List<Map<String, dynamic>> comandas = [
//   {
//     'numeroMesa': 5,
//     'horaPedido': '12:30 PM',
//     'platos': [
//       'Pizza Margarita',
//       'Ensalada César',
//       'Sopa de Tomate',
//       'Pan de Ajo',
//       'Lasaña',
//       'Calzone',
//       'Espaguetis Carbonara',
//       'Tarta de Queso'
//     ],
//   },
//   {
//     'numeroMesa': 8,
//     'horaPedido': '1:45 PM',
//     'platos': [
//       'Pasta Alfredo',
//       'Tiramisú',
//       'Bruschetta',
//       'Risotto',
//       'Carpaccio',
//       'Gelato',
//       'Caprese',
//       'Panna Cotta'
//     ],
//   },

  // Agrega más comandas aquí según sea necesario
// ];
