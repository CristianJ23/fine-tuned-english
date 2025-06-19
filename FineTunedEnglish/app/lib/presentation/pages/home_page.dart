import 'package:flutter/material.dart';
import '../widgets/course_card.dart';
import '../widgets/news_card.dart';
import '../widgets/section_header.dart';
import '../widgets/task_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: const Color(0xFFF4F5F7),
            elevation: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hola, Maximiliano',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Welcome to Fine App',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.bar_chart_rounded, color: Colors.black54),
                onPressed: () {},
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildFilterChips(),
                  const SizedBox(height: 24),
                  
                  const SectionHeader(title: 'Novedades'),
                  const SizedBox(height: 16),
                  _buildNewsSection(),
                  const SizedBox(height: 24),

                  const SectionHeader(title: 'Tareas Pendientes'),
                  const SizedBox(height: 16),
                  const TaskCard(
                    category: 'Revisión de Examen',
                    title: 'Examen final de gramática',
                    date: 'Domingo 28 Dic.   8:00 pm',
                    color: Color(0xFFA8C686),
                    icon: Icons.star,
                    iconColor: Colors.amber,
                  ),
                  const SizedBox(height: 12),
                  const TaskCard(
                    category: 'Proyecto Final',
                    title: 'Entrega de ensayo sobre Shakespeare',
                    date: 'Lunes 29 Dic.   11:59 pm',
                    color: Color(0xFF3B82F6),
                    icon: Icons.star,
                    iconColor: Colors.amber,
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                        side: BorderSide(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: const Text('Ver más'),
                    ),
                  ),
                  const SizedBox(height: 24),

                  const SectionHeader(title: 'Cursos'),
                  const SizedBox(height: 16),
                  const CourseCard(),
                  const SizedBox(height: 12),
                  const CourseCard(),
                  const SizedBox(height: 24),

                  _buildSupportBanner(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() { return SizedBox( height: 35, child: ListView( scrollDirection: Axis.horizontal, children: [ 'Horarios', 'Notas', 'Tareas', 'Cursos', 'Certificados', ].map((label) { return Padding( padding: const EdgeInsets.only(right: 8.0), child: Chip( label: Text(label), backgroundColor: Colors.white, shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20), side: BorderSide(color: Colors.grey.shade300), ), ), ); }).toList(), ), ); }
  
  Widget _buildNewsSection() { return SizedBox( height: 200, child: ListView( scrollDirection: Axis.horizontal, children: const [ NewsCard( title: 'Torneo de fútbol inter-clases', date: 'Jueves 11 Jun. 9:00 pm', imageUrl: 'assets/images/soccer_ball.png', color: Color(0xFF86C6B4), isLiked: true, ), SizedBox(width: 16), NewsCard( title: 'Nuevas becas disponibles para el próximo ciclo', date: 'Domingo 28 Dic.', imageUrl: '', color: Color(0xFFF5B084), isLiked: false, ), ], ), ); }
  
  Widget _buildSupportBanner() { return Container( padding: const EdgeInsets.all(16), decoration: BoxDecoration( color: Colors.grey.shade200, borderRadius: BorderRadius.circular(12), ), child: Row( children: [ Icon(Icons.support_agent, color: Colors.grey.shade700), const SizedBox(width: 16), const Expanded( child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [ Text('¿Tienes alguna duda?', style: TextStyle(fontWeight: FontWeight.bold)), Text('Contacta a nuestro equipo de soporte aquí', style: TextStyle(fontSize: 12)), ], ), ), ], ), ); }
}
