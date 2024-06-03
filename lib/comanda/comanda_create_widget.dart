import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import 'comanda_create_model.dart';
import 'models.dart';
export 'comanda_create_model.dart';

class ComandaCreateWidget extends StatefulWidget {
  const ComandaCreateWidget({
    super.key,
    this.artPiece,
  });

  final dynamic artPiece;

  @override
  State<ComandaCreateWidget> createState() => _ComandaCreateWidgetState();
}

class _ComandaCreateWidgetState extends State<ComandaCreateWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late ComandaCreateModel _model;
  String _response = '';
  late List<Map<String, String>> platos2;
  late io.Socket socket;
  int nro_mesa = 0;
  String nombre_cliente = "";
  List<dynamic> platos = []; // Lista de platos vacía inicialmente
  List<dynamic> bebidas = []; // Lista de platos vacía inicialmente
  String extrasList = ""; // Lista de platos vacía inicialmente

  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  String _filePath = '';
  Order? currentOrder;
  TextEditingController nroMesaController = TextEditingController();
  TextEditingController nombreClienteController = TextEditingController();
  TextEditingController detallesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _model = Provider.of<ComandaCreateModel>(context, listen: false);
    _initRecorder();
    initSocket();
    nroMesaController = TextEditingController(text: nro_mesa.toString());
    nombreClienteController = TextEditingController(text: nombre_cliente);
    // platos = _model.initialPlatos;
  }

  void initSocket() {
    socket = io.io(
        'http://192.168.100.224:3000/comanda',
        io.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .enableAutoConnect() // auto-connection enabled
            .build());

    socket.onConnect((_) {
      print('--------connect');
    });

    socket.on('textConverted', (data) {
      print("------ORDER RECEIVED");
      if (!mounted)
        return; // Verificar si el widget está montado antes de llamar a setState

      // Acceder a la clave 'text' y decodificar el JSON
      final Map<String, dynamic> jsonData = jsonDecode(data['text']);
      print("jsonData: $jsonData"); // Imprimir el valor de jsonData

      setState(() {
        // Obtener platos
        final List<Map<String, dynamic>> plates = [];
        final List<dynamic> dish = jsonData['dishes'] ?? [];
        for (final plateData in dish) {
          plates.add({
            'cantidad': (plateData['amount'] ?? 0).toString(),
            'nombre': plateData['name'] ?? '',
          });
        }

        // Obtener bebidas
        final List<dynamic> drink = jsonData['drinks'] ?? [];
        final List<Map<String, dynamic>> drinks = [];
        for (final drinkData in drink) {
          drinks.add({
            'cantidad': (drinkData['amount'] ?? 0).toString(),
            'nombre': drinkData['name'] ?? '',
          });
        }

        // Obtener extras
        String extrasData = jsonData['extras'] ?? {};

        // Actualizar los platos, bebidas y extras
        nro_mesa = jsonData['number_table'] ?? 0;
        nombre_cliente = jsonData['customer_name'] ?? '';
        extrasList = jsonData['extras'] ?? '';

        platos = plates;
        bebidas = drinks;
        extrasList = extrasData;
        nroMesaController = TextEditingController(text: nro_mesa.toString());
        nombreClienteController = TextEditingController(text: nombre_cliente);
        detallesController = TextEditingController(text: extrasData);
        // Imprimir la orden recibida en la consola
        print('Order received:');
        print('Platos: ${platos.map((plate) => plate['nombre'])}');
        print('Bebidas: ${bebidas.map((drink) => drink['nombre'])}');
        print('Extras: ${extrasList}');
      });

      socket.onError((data) {
        print('Error: $data');
      });
    });

    socket.onDisconnect((_) => print('disconnect'));
  }

  Future<void> _initRecorder() async {
    await Permission.microphone.request();
    await _recorder.openRecorder();
  }

  Future<void> _startRecording() async {
    final directory = await getApplicationDocumentsDirectory();
    _filePath = '${directory.path}/temp_audio.wav';

    await _recorder.startRecorder(
      toFile: _filePath,
      codec: Codec.pcm16WAV,
    );
    setState(() {
      _isRecording = true;
    });
  }

  Future<void> _stopRecording() async {
    await _recorder.stopRecorder();
    setState(() {
      _isRecording = false;
    });
    await Future.delayed(Duration(
        milliseconds:
            500)); // Pequeña pausa para asegurar que el archivo esté escrito completamente.
    print('File path: $_filePath');
    print('File size: ${File(_filePath!).lengthSync()} bytes');
  }

  Future<void> _pauseRecording() async {
    await _recorder.pauseRecorder();
  }

  Future<void> _resumeRecording() async {
    await _recorder.resumeRecorder();
  }

  Future<void> _sendRecording() async {
    if (_filePath == null) {
      print('No file path available');
      return;
    }

    final file = File(_filePath!);
    final fileSize = await file.length();

    final uri = Uri.parse('http://192.168.100.224:3000/voice-to-text');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        _filePath!,
      ));

    try {
      final response = await request.send();

      if (response.statusCode == 201) {
        print('Audio enviado con éxito');
      } else {
        print('Error al enviar audio: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al enviar audio: $e');
    }
  }

  @override
  void dispose() {
    nroMesaController.dispose();
    nombreClienteController.dispose();
    socket.dispose(); // Cancelar suscripción al socket

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Customize what your widget looks like when it's loading.
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).secondary,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        leading: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {
            Navigator.of(context).pop(); // Navegar hacia atrás
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 24,
          ),
        ),
        title: Text(
          'Formulario Comanda',
          style: FlutterFlowTheme.of(context).bodySmall.override(
                fontFamily: 'Playfair Display',
                fontSize: 18,
                letterSpacing: 0,
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(15, 20, 15, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 10, 0, 5),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 6, 0),
                                  child: Text(
                                    'Nro Mesa',
                                    style: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .override(
                                          fontFamily: 'Playfair Display',
                                          color: FlutterFlowTheme.of(context)
                                              .tertiary,
                                          fontSize: 15,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: nroMesaController,
                                    decoration: InputDecoration(
                                      hintText: 'Introduce el número de mesa',
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .override(
                                            fontFamily: 'Playfair Display',
                                            color: FlutterFlowTheme.of(context)
                                                .tertiary
                                                .withOpacity(0.5),
                                            fontSize: 15,
                                          ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          width: 1,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          width: 2,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Playfair Display',
                                          fontSize: 15,
                                          letterSpacing: 0,
                                        ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 30,
                            thickness: 0.5,
                            color: FlutterFlowTheme.of(context).tertiary,
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 10, 0, 5),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 6, 0),
                                  child: Text(
                                    'Nombre del Comensal',
                                    style: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .override(
                                          fontFamily: 'Playfair Display',
                                          color: FlutterFlowTheme.of(context)
                                              .tertiary,
                                          fontSize: 15,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: nombreClienteController,
                                    decoration: InputDecoration(
                                      hintText:
                                          'Introduce el nombre del comensal',
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .override(
                                            fontFamily: 'Playfair Display',
                                            color: FlutterFlowTheme.of(context)
                                                .tertiary
                                                .withOpacity(0.5),
                                            fontSize: 15,
                                          ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          width: 1,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          width: 2,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Playfair Display',
                                          fontSize: 15,
                                          letterSpacing: 0,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 30,
                            thickness: 0.5,
                            color: FlutterFlowTheme.of(context).tertiary,
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 10, 0, 5),
                            child: Text(
                              'Platos',
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    fontFamily: 'Playfair Display',
                                    color:
                                        FlutterFlowTheme.of(context).tertiary,
                                    fontSize: 15,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          Column(
                            children: List.generate(platos.length, (index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: TextFormField(
                                        initialValue: platos[index]['cantidad'],
                                        decoration: InputDecoration(
                                          hintText: 'Cantidad',
                                          hintStyle: FlutterFlowTheme.of(
                                                  context)
                                              .bodySmall
                                              .override(
                                                fontFamily: 'Playfair Display',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .tertiary
                                                        .withOpacity(0.5),
                                                fontSize: 15,
                                              ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Playfair Display',
                                              fontSize: 15,
                                              letterSpacing: 0,
                                            ),
                                        onChanged: (value) {
                                          setState(() {
                                            platos[index]['cantidad'] = value;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      flex: 4,
                                      child: TextFormField(
                                        initialValue: platos[index]['nombre'],
                                        decoration: InputDecoration(
                                          hintText: 'Nombre del plato',
                                          hintStyle: FlutterFlowTheme.of(
                                                  context)
                                              .bodySmall
                                              .override(
                                                fontFamily: 'Playfair Display',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .tertiary
                                                        .withOpacity(0.5),
                                                fontSize: 15,
                                              ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Playfair Display',
                                              fontSize: 15,
                                              letterSpacing: 0,
                                            ),
                                        onChanged: (value) {
                                          setState(() {
                                            platos[index]['nombre'] = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  platos.add({'cantidad': '', 'nombre': ''});
                                });
                              },
                              child: Text('Añadir Plato'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 30,
                      thickness: 0.5,
                      color: FlutterFlowTheme.of(context).tertiary,
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
                            child: Text(
                              'Detalles extras',
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    fontFamily: 'Playfair Display',
                                    color:
                                        FlutterFlowTheme.of(context).tertiary,
                                    fontSize: 15,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: detallesController,
                              decoration: InputDecoration(
                                hintText: 'Introduce información extra',
                                hintStyle: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      fontFamily: 'Playfair Display',
                                      color: FlutterFlowTheme.of(context)
                                          .tertiary
                                          .withOpacity(0.5),
                                      fontSize: 15,
                                    ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).primary,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).primary,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Playfair Display',
                                    fontSize: 15,
                                    letterSpacing: 0,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Aquí van los botones de grabación
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: _isRecording ? null : _startRecording,
                            child: Text('Grabar'),
                          ),
                          ElevatedButton(
                            onPressed: _isRecording ? _pauseRecording : null,
                            child: Text('Pausar'),
                          ),
                          ElevatedButton(
                            onPressed: _isRecording ? _stopRecording : null,
                            child: Text('Detener'),
                          ),
                          ElevatedButton(
                            onPressed: _isRecording ? _resumeRecording : null,
                            child: Text('Reanudar'),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _sendRecording,
                      child: Text('Enviar Audio'),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 84,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondary,
              ),
              child: Align(
                alignment: AlignmentDirectional(0, 0),
                child: FFButtonWidget(
                  onPressed: () async {},
                  text: 'Add to Collection',
                  icon: Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                    size: 15,
                  ),
                  options: FFButtonOptions(
                    width: 200,
                    height: 50,
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 2, 0),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle:
                        FlutterFlowTheme.of(context).titleMedium.override(
                              fontFamily: 'Playfair Display',
                              color: Colors.white,
                              fontSize: 14,
                              letterSpacing: 0,
                              fontWeight: FontWeight.bold,
                            ),
                    elevation: 2,
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
