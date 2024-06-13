class Customer {
  final int codRutaDet;
  final String codCliente;
  final String codDireccionEnvio;
  final String cedulaRuc;
  final String nombreCliente;
  final String direccion;
  final double? latitud;
  final double? longitud;
  final double limiteCredito;
  final double saldoPendiente;

  Customer({
    required this.codRutaDet,
    required this.codCliente,
    required this.codDireccionEnvio,
    required this.cedulaRuc,
    required this.nombreCliente,
    required this.direccion,
    this.latitud,
    this.longitud,
    required this.limiteCredito,
    required this.saldoPendiente,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      codRutaDet: json['codrutadet'] ?? 0,
      codCliente: json['codcliente']?.replaceAll("'", "") ?? '',
      codDireccionEnvio: json['coddireccionenvio']?.replaceAll("'", "") ?? '',
      cedulaRuc: json['cedularuc']?.replaceAll("'", "") ?? '',
      nombreCliente: json['cliente_nombre']?.replaceAll("'", "") ?? '',
      direccion: json['direccion']?.replaceAll("'", "") ?? '',
      latitud: json['latitud'] != null ? double.tryParse(json['latitud'].toString()) : null,
      longitud: json['longitud'] != null ? double.tryParse(json['longitud'].toString()) : null,
      limiteCredito: double.tryParse(json['limitecredito'].toString()) ?? 0.0,
      saldoPendiente: double.tryParse(json['saldopendiente'].toString()) ?? 0.0,
    );
  }
}
