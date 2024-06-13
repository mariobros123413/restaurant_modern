import 'dart:convert';

class Comanda {
  final int nroPedido;
  final int idMesero;
  final int nroMesa;
  final String nombreComensal;
  final String fecha;
  final String hora;
  bool estado;
  final List<Map<String, dynamic>> plato;
  final List<Map<String, dynamic>> bebida;
  final String extras;

  Comanda({
    required this.nroPedido,
    required this.idMesero,
    required this.nroMesa,
    required this.nombreComensal,
    required this.fecha,
    required this.hora,
    required this.estado,
    required this.plato,
    required this.bebida,
    required this.extras,
  });

  factory Comanda.fromJson(Map<String, dynamic> json) {
    print("plato : " + json['plato']);
    return Comanda(
      nroPedido: json['nro_pedido'],
      idMesero: json['id_mesero'],
      nroMesa: json['nro_mesa'],
      nombreComensal: json['nombre_comensal'],
      fecha: json['fecha'],
      hora: json['hora'],
      estado: json['estado'],
      plato: parseItems(json['plato']),
      bebida: parseItems(json['bebida']),
      extras: json['extras'],
    );
  }

  static List<Map<String, dynamic>> parseItems(String items) {
    // Convertir a un formato JSON adecuado
    String jsonReady = items.replaceAll('\'', '\"');
    jsonReady = jsonReady.replaceAll('nombre:', '\"nombre\":');
    jsonReady = jsonReady.replaceAll('cantidad:', '\"cantidad\":');

    // Asegurar que todos los valores de tipo string estén entre comillas dobles
    jsonReady = jsonReady.replaceAllMapped(RegExp(r'\"nombre\":\s*([^",}]+)'),
        (match) => '\"nombre\": \"${match[1]}\"');

    try {
      final List<dynamic> parsedList = json.decode(jsonReady);
      return parsedList
          .map<Map<String, dynamic>>((item) => Map<String, dynamic>.from(item))
          .toList();
    } catch (e) {
      // Puedes manejar o logear el error aquí
      print('Error parsing JSON: $e');
      return [];
    }
  }
}
