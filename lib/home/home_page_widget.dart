import '../comanda/comanda_create_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'home_page_model.dart';
export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;
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

  @override
  void initState() {
    super.initState();
    fetchData();

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
      backgroundColor: FlutterFlowTheme.of(context).secondary,
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
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: 'Playfair Display',
                                color: FlutterFlowTheme.of(context).secondary,
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
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {},
                                    child: Icon(
                                      Icons.search,
                                      color:
                                          FlutterFlowTheme.of(context).tertiary,
                                      size: 24,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          5, 0, 0, 2),
                                      child: TextFormField(
                                        controller: _model.textController,
                                        focusNode: _model.textFieldFocusNode,
                                        onFieldSubmitted: (_) async {},
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          hintText:
                                              'Search artist, maker, department...',
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(4.0),
                                              topRight: Radius.circular(4.0),
                                            ),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(4.0),
                                              topRight: Radius.circular(4.0),
                                            ),
                                          ),
                                          errorBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(4.0),
                                              topRight: Radius.circular(4.0),
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(4.0),
                                              topRight: Radius.circular(4.0),
                                            ),
                                          ),
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Playfair Display',
                                              fontSize: 16,
                                              letterSpacing: 0,
                                            ),
                                        validator: _model
                                            .textControllerValidator
                                            .asValidator(context),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
                        Container(
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
                              return ComandaCard(
                                numeroMesa: comanda['numeroMesa'],
                                horaPedido: comanda['horaPedido'],
                                platos: comanda['platos'],
                              );
                            },
                          ),
                        ),
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
  final int numeroMesa;
  final String horaPedido;
  final List<String> platos;

  const ComandaCard({
    Key? key,
    required this.numeroMesa,
    required this.horaPedido,
    required this.platos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mesa $numeroMesa',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Hora del pedido: $horaPedido',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: platos
                      .map((plato) =>
                          Text('- $plato', style: TextStyle(fontSize: 14)))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const List<Map<String, dynamic>> comandas = [
  {
    'numeroMesa': 5,
    'horaPedido': '12:30 PM',
    'platos': [
      'Pizza Margarita',
      'Ensalada César',
      'Sopa de Tomate',
      'Pan de Ajo',
      'Lasaña',
      'Calzone',
      'Espaguetis Carbonara',
      'Tarta de Queso'
    ],
  },
  {
    'numeroMesa': 8,
    'horaPedido': '1:45 PM',
    'platos': [
      'Pasta Alfredo',
      'Tiramisú',
      'Bruschetta',
      'Risotto',
      'Carpaccio',
      'Gelato',
      'Caprese',
      'Panna Cotta'
    ],
  },

  // Agrega más comandas aquí según sea necesario
];
