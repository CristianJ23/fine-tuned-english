// lib/announcements_page.dart (o donde lo tengas)
import 'package:flutter/material.dart';
import '../widgets/announcement_card.dart'; // Asegúrate de crear este archivo

class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({super.key});

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  // Lista de anuncios de ejemplo para demostrar la UI
  final List<Map<String, dynamic>> _announcements = [
    {
      'type': 'Tarea creada',
      'description': 'Lorem Lopus bebesss sadbas asdddsahb',
      'date': '12/05/1015',
      'time': '10:30',
      'color': const Color(0xFFFFEBEE), // Rojo claro para "Tarea creada"
      'icon': Icons.laptop, // Un icono de laptop para tareas
      'iconColor': Colors.redAccent,
      'trailingIcon': Icons.remove_red_eye_outlined, // Ojo para "ver"
      'trailingIconColor': Colors.green,
    },
    {
      'type': 'Cancelacion de clases',
      'description': 'Lorem Lopus bebesss sadbas asdddsahb',
      'date': '12/05/1015',
      'time': '10:30',
      'color': const Color(0xFFE3F2FD), // Azul claro para "Cancelación"
      'icon': Icons.close, // Icono de "cerrar" o "cancelar"
      'iconColor': Colors.blueAccent,
      'trailingIcon': null, // No trailing icon for cancellation
      'trailingIconColor': null,
    },
    {
      'type': 'Cambio de fecha de la tarea',
      'description': 'Lorem Lopus bebesss sadbas asdddsahb',
      'date': '12/05/1015',
      'time': '10:30',
      'color': const Color(0xFFE8F5E9), // Verde claro para "Cambio de fecha"
      'icon': Icons.timer_outlined, // Icono de reloj
      'iconColor': Colors.green,
      'trailingIcon': Icons.edit_note, // Lápiz para "editar" o "ver"
      'trailingIconColor': Colors.green,
    },
    {
      'type': 'Detalles de la tarea',
      'description': 'Lorem Lopus bebesss sadbas asdddsahb',
      'date': '12/05/1015',
      'time': '10:30',
      'color': const Color(0xFFFFFDE7), // Amarillo claro para "Detalles"
      'icon': Icons.info_outline, // Icono de información
      'iconColor': Colors.amber,
      'trailingIcon': Icons.remove_red_eye_outlined, // Ojo para "ver"
      'trailingIconColor': Colors.green,
    },
  ];

  // Estado para los tabs (Todas, No Leído)
  int _selectedIndex = 0; // 0 para 'Todas', 1 para 'No Leído'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Fondo similar al de otras páginas
      appBar: AppBar(
        backgroundColor: const Color(0xFF213354), // Color de la barra de navegación
        elevation: 0,
        // **¡CAMBIO CLAVE AQUÍ!**
        // Eliminamos el 'leading' personalizado con Icons.menu.
        // Flutter agregará automáticamente un botón de "back"
        // cuando esta página sea mostrada usando Navigator.push.
        // Si esta página es la primera en la pila (ej. si se abre con pushReplacement),
        // no mostrará el botón de atrás.
        automaticallyImplyLeading: true, // Esto es true por defecto, pero lo ponemos para claridad.
        iconTheme: const IconThemeData(color: Colors.white), // Color del ícono de atrás
        title: const Text(
          'Anuncios',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white), // Icono de recargar
            onPressed: () {
              // Acción de recargar/deshacer anuncios
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Container(
            color: const Color(0xFF213354), // Fondo de los tabs
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTab('Todas', 0),
                _buildTab('No Leído', 1),
              ],
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _announcements.length,
        itemBuilder: (context, index) {
          final announcement = _announcements[index];
          // Aquí puedes aplicar lógica para filtrar por "No Leído"
          // Por simplicidad, se muestran todos los anuncios en este ejemplo
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: AnnouncementCard(
              type: announcement['type'],
              description: announcement['description'],
              date: announcement['date'],
              time: announcement['time'],
              backgroundColor: announcement['color'],
              leadingIcon: announcement['icon'],
              leadingIconColor: announcement['iconColor'],
              trailingIcon: announcement['trailingIcon'],
              trailingIconColor: announcement['trailingIconColor'],
              onTap: () {
                // Acción al pulsar la tarjeta de anuncio
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Abriendo ${announcement['type']}')),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
          // Aquí puedes añadir lógica para filtrar la lista de anuncios
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Colors.white : Colors.transparent,
              width: 2.0,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}