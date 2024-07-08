class AllCustomers {
  final String codcliente;
  final String codtipocliente;
  final String nombre;
  final String email;
  final String password;
  final String pais;
  final String provincia;
  final String ciudad;
  final String codvendedor;
  final String codformapago;
  final String estado;
  final double limitecredito;
  final double saldopendiente;
  final double vencido;
  final String cedularuc;
  final String codlistaprecio;
  final String calificacion;
  final String nombrecomercial;
  final String login;

  AllCustomers({
    required this.codcliente,
    required this.codtipocliente,
    required this.nombre,
    required this.email,
    required this.password,
    required this.pais,
    required this.provincia,
    required this.ciudad,
    required this.codvendedor,
    required this.codformapago,
    required this.estado,
    required this.limitecredito,
    required this.saldopendiente,
    required this.vencido,
    required this.cedularuc,
    required this.codlistaprecio,
    required this.calificacion,
    required this.nombrecomercial,
    required this.login,
  });

  factory AllCustomers.fromJson(Map<String, dynamic> json) {
    return AllCustomers(
      codcliente: json['codcliente'],
      codtipocliente: json['codtipocliente'],
      nombre: json['nombre'],
      email: json['email'],
      password: json['password']?.replace("'", "") ?? '',
      pais: json['pais'],
      provincia: json['provincia']?.replace("'", "") ?? '',
      ciudad: json['ciudad'],
      codvendedor: json['codvendedor'],
      codformapago: json['codformapago'],
      estado: json['estado'],
      limitecredito: json['limitecredito'].toDouble(),
      saldopendiente: json['saldopendiente'].toDouble(),
      vencido: json['vencido'].toDouble(),
      cedularuc: json['cedularuc'],
      codlistaprecio: json['codlistaprecio'],
      calificacion: json['calificacion'],
      nombrecomercial: json['nombrecomercial']?.replace("'", "") ?? '',
      login: json['login']?.replace("'", "") ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'codcliente': codcliente,
      'codtipocliente': codtipocliente,
      'nombre': nombre,
      'email': email,
      'password': password,
      'pais': pais,
      'provincia': provincia,
      'ciudad': ciudad,
      'codvendedor': codvendedor,
      'codformapago': codformapago,
      'estado': estado,
      'limitecredito': limitecredito,
      'saldopendiente': saldopendiente,
      'vencido': vencido,
      'cedularuc': cedularuc,
      'codlistaprecio': codlistaprecio,
      'calificacion': calificacion,
      'nombrecomercial': nombrecomercial,
      'login': login,
    };
  }

  static AllCustomers fromMap(Map<String, dynamic> map) {
    return AllCustomers(
      codcliente: map['codcliente'],
      codtipocliente: map['codtipocliente'],
      nombre: map['nombre'],
      email: map['email'],
      password: map['password']?.replace("'", "") ?? '',
      pais: map['pais'],
      provincia: map['provincia']?.replace("'", "") ?? '',
      ciudad: map['ciudad'],
      codvendedor: map['codvendedor'],
      codformapago: map['codformapago'],
      estado: map['estado'],
      limitecredito: map['limitecredito'].toDouble(),
      saldopendiente: map['saldopendiente'].toDouble(),
      vencido: map['vencido'].toDouble(),
      cedularuc: map['cedularuc'],
      codlistaprecio: map['codlistaprecio'],
      calificacion: map['calificacion'],
      nombrecomercial: map['nombrecomercial']?.replace("'", "") ?? '',
      login: map['login']?.replace("'", "") ?? '',
    );
  }

  AllCustomers copy({
    String? codcliente,
    String? codtipocliente,
    String? nombre,
    String? email,
    String? password,
    String? pais,
    String? provincia,
    String? ciudad,
    String? codvendedor,
    String? codformapago,
    String? estado,
    double? limitecredito,
    double? saldopendiente,
    double? vencido,
    String? cedularuc,
    String? codlistaprecio,
    String? calificacion,
    String? nombrecomercial,
    String? login,
  }) {
    return AllCustomers(
      codcliente: codcliente ?? this.codcliente,
      codtipocliente: codtipocliente ?? this.codtipocliente,
      nombre: nombre ?? this.nombre,
      email: email ?? this.email,
      password: password ?? this.password,
      pais: pais ?? this.pais,
      provincia: provincia ?? this.provincia,
      ciudad: ciudad ?? this.ciudad,
      codvendedor: codvendedor ?? this.codvendedor,
      codformapago: codformapago ?? this.codformapago,
      estado: estado ?? this.estado,
      limitecredito: limitecredito ?? this.limitecredito,
      saldopendiente: saldopendiente ?? this.saldopendiente,
      vencido: vencido ?? this.vencido,
      cedularuc: cedularuc ?? this.cedularuc,
      codlistaprecio: codlistaprecio ?? this.codlistaprecio,
      calificacion: calificacion ?? this.calificacion,
      nombrecomercial: nombrecomercial ?? this.nombrecomercial,
      login: login ?? this.login,
    );
  }
}
