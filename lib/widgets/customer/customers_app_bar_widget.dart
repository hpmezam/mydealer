import 'package:flutter/material.dart';

class CustomersAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final TabController tabController;
  final TextEditingController searchController;
  final Function(String) onSearchChanged;
  final bool isSearching;

  const CustomersAppBarWidget({
    Key? key,
    required this.title,
    required this.tabController,
    required this.searchController,
    required this.onSearchChanged,
    required this.isSearching,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight +
          (isSearching
              ? 56.0
              : 0)), // Ajusta el tamaño del AppBar con el buscador
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: AppBar(
          title: isSearching
              ? TextField(
                  controller: searchController,
                  autofocus: true,
                  onChanged: onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Buscar...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                  style: TextStyle(color: Colors.white),
                )
              : Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(isSearching ? Icons.close : Icons.search),
              onPressed: () {
                // Toggle search state and clear text if closing search
                if (isSearching) {
                  searchController.clear();
                  onSearchChanged('');
                }
                onSearchTapped();
              },
            ),
          ],
          bottom: TabBar(
            controller: tabController,
            tabs: const [
              Tab(text: "Pedidos"),
              Tab(text: "P Pend"),
              Tab(text: "Cobros"),
              Tab(text: "C Pend"),
            ],
          ),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
        ),
      ),
    );
  }

  void onSearchTapped() {
    // Implementa lógica adicional al presionar el icono de búsqueda
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight +
      56.0); // Ajusta el tamaño preferido para incluir el TabBar y el buscador
}
