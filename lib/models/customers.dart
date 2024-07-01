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

    Map<String, dynamic> toMap() {
    return {
      'codrutadet': codRutaDet,
      'codcliente': codCliente,
      'coddireccionenvio': codDireccionEnvio,
      'cedularuc': cedulaRuc,
      'cliente_nombre': nombreCliente,
      'direccion': direccion,
      'latitud': latitud,
      'longitud': longitud,
      'limitecredito': limiteCredito,
      'saldopendiente': saldoPendiente,
    };
  }

  static Customer fromMap(Map<String, dynamic> map) {
    return Customer(
      codRutaDet: map['codrutadet'],
      codCliente: map['codcliente'],
      codDireccionEnvio: map['coddireccionenvio'],
      cedulaRuc: map['cedularuc'],
      nombreCliente: map['cliente_nombre'],
      direccion: map['direccion'],
      latitud: map['latitud'] != null ? map['latitud'] as double : null,
      longitud: map['longitud'] != null ? map['longitud'] as double : null,
      limiteCredito: map['limitecredito'] as double,
      saldoPendiente: map['saldopendiente'] as double,
    );
  }

    Customer copy({
    int? codRutaDet,
    String? codCliente,
    String? codDireccionEnvio,
    String? cedulaRuc,
    String? nombreCliente,
    String? direccion,
    double? latitud,
    double? longitud,
    double? limiteCredito,
    double? saldoPendiente,
  }) {
    return Customer(
      codRutaDet: codRutaDet ?? this.codRutaDet,
      codCliente: codCliente ?? this.codCliente,
      codDireccionEnvio: codDireccionEnvio ?? this.codDireccionEnvio,
      cedulaRuc: cedulaRuc ?? this.cedulaRuc,
      nombreCliente: nombreCliente ?? this.nombreCliente,
      direccion: direccion ?? this.direccion,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      limiteCredito: limiteCredito ?? this.limiteCredito,
      saldoPendiente: saldoPendiente ?? this.saldoPendiente,
    );
  }
}
