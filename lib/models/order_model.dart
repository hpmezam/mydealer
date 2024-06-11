class Order {
  final int srorden;
  final String codcliente;
  final String fecha;
  final String fechaweb;
  final String codformaenvio;
  final String codformapago;
  final String idorden;
  final String codvendedor;
  final String coddireccionenvio;
  final String numordenerp;
  final String observaciones;
  final String loginusuario;
  final String referencia1;
  final String referencia2;
  final double subtotal;
  final double descuento;
  final double impuesto;
  final double total;
  final String estado;
  final String origen;
  final String errorws;
  final String fechamovil;
  final String fechaenvioerp;

  Order({
    required this.srorden,
    required this.codcliente,
    required this.fecha,
    required this.fechaweb,
    required this.codformaenvio,
    required this.codformapago,
    required this.idorden,
    required this.codvendedor,
    required this.coddireccionenvio,
    required this.numordenerp,
    required this.observaciones,
    required this.loginusuario,
    required this.referencia1,
    required this.referencia2,
    required this.subtotal,
    required this.descuento,
    required this.impuesto,
    required this.total,
    required this.estado,
    required this.origen,
    required this.errorws,
    required this.fechamovil,
    required this.fechaenvioerp,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      srorden: json['srorden'],
      codcliente: json['codcliente'],
      fecha: json['fecha'],
      fechaweb: json['fechaweb'],
      codformaenvio: json['codformaenvio'],
      codformapago: json['codformapago'],
      idorden: json['idorden'],
      codvendedor: json['codvendedor'],
      coddireccionenvio: json['coddireccionenvio'],
      numordenerp: json['numordenerp'],
      observaciones: json['observaciones'],
      loginusuario: json['loginusuario'],
      referencia1: json['referencia1'],
      referencia2: json['referencia2'],
      subtotal: json['subtotal'].toDouble(),
      descuento: json['descuento'].toDouble(),
      impuesto: json['impuesto'].toDouble(),
      total: json['total'].toDouble(),
      estado: json['estado'],
      origen: json['origen'],
      errorws: json['errorws'],
      fechamovil: json['fechamovil'],
      fechaenvioerp: json['fechaenvioerp'],
    );
  }
}
