class HomeOrders {
  final int realizados;
  final int pendientes;

  HomeOrders({required this.realizados, required this.pendientes});

  factory HomeOrders.fromJson(Map<String, dynamic> json) {
    return HomeOrders(
      realizados: json['datos']['realizados'] as int,
      pendientes: json['datos']['pendientes'] as int,
    );
  }
}

class HomePayments {
  final int realizados;
  final int pendientes;

  HomePayments({required this.realizados, required this.pendientes});

  factory HomePayments.fromJson(Map<String, dynamic> json) {
    return HomePayments(
      realizados: json['datos']['realizados'] as int,
      pendientes: json['datos']['pendientes'] as int,
    );
  }
}
