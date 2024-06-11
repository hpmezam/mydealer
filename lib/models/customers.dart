class Customer {
  final String codCliente;
  final String codTipoCliente;
  final String nombre;
  final String email;
  final String password;
  final String pais;
  final String provincia;
  final String ciudad;
  final String codVendedor;
  final String codFormaPago;
  final String estado;
  final double limiteCredito;
  final double saldoPendiente;
  final String cedulaRuc;
  final String codListaPrecio;
  final String calificacion;
  final String nombreComercial;

  Customer({
    required this.codCliente,
    required this.codTipoCliente,
    required this.nombre,
    required this.email,
    required this.password,
    required this.pais,
    required this.provincia,
    required this.ciudad,
    required this.codVendedor,
    required this.codFormaPago,
    required this.estado,
    required this.limiteCredito,
    required this.saldoPendiente,
    required this.cedulaRuc,
    required this.codListaPrecio,
    required this.calificacion,
    required this.nombreComercial,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      codCliente: json['codcliente'] ?? '',
      codTipoCliente: json['codtipocliente'] ?? '',
      nombre: json['nombre'] ?? '',
      email: json['email']?.replaceAll("'", "") ?? '',
      password: json['password'] ?? '',
      pais: json['pais']?.replaceAll("'", "") ?? '',
      provincia: json['provincia'] ?? '',
      ciudad: json['ciudad']?.replaceAll("'", "") ?? '',
      codVendedor: json['codvendedor']?.replaceAll("'", "") ?? '',
      codFormaPago: json['codformapago']?.replaceAll("'", "") ?? '',
      estado: json['estado'] ?? '',
      limiteCredito:
          double.tryParse(json['limitecredito']?.toString() ?? '0') ?? 0.0,
      saldoPendiente:
          double.tryParse(json['saldopendiente']?.toString() ?? '0') ?? 0.0,
      cedulaRuc: json['cedularuc']?.replaceAll("'", "") ?? '',
      codListaPrecio: json['codlistaprecio']?.replaceAll("'", "") ?? '',
      calificacion: json['calificacion']?.replaceAll("'", "") ?? '',
      nombreComercial: json['nombrecomercial'] ?? '',
    );
  }
}
