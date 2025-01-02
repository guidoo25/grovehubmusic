import 'package:flutter/material.dart';

class BarraLateralAdmin extends StatelessWidget {
  const BarraLateralAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      color: const Color(0xFF212121),
      child: Column(
        children: [
          // Logo y título
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF9800),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      'R',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Panel Admin',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.grey),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildMenuItem(
                  icon: Icons.admin_panel_settings,
                  title: 'Roles & Acceso',
                  isSelected: true,
                ),
                _buildExpandableSection(
                  title: 'Lista de Usuarios',
                  icon: Icons.people,
                  items: [
                    'Todos los usuarios',
                    'Usuarios suscritos',
                    'Administradores',
                    'Moderadores',
                    'Gestores de artistas',
                  ],
                ),
                _buildExpandableSection(
                  title: 'Contenido de Usuario',
                  icon: Icons.content_copy,
                  items: ['Publicaciones', 'Comentarios', 'Multimedia'],
                ),
                _buildExpandableSection(
                  title: 'Solicitudes',
                  icon: Icons.request_page,
                  items: ['Pendientes', 'Aprobadas', 'Rechazadas'],
                ),
                const Divider(color: Colors.grey),
                // Estadísticas
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatItem('Usuarios', '159', Colors.blue),
                      _buildStatItem('Suscriptores', '11', Colors.green),
                      _buildStatItem('Administradores', '1', Colors.orange),
                      _buildStatItem('Moderadores', '0', Colors.purple),
                      _buildStatItem('Gestores', '0', Colors.teal),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    bool isSelected = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isSelected ? const Color(0xFF3D3D3D) : Colors.transparent,
      ),
      child: ListTile(
        leading: Icon(icon, color: isSelected ? Colors.white : Colors.grey),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
          ),
        ),
        selected: isSelected,
        onTap: () {},
      ),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required IconData icon,
    required List<String> items,
  }) {
    return ExpansionTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(
        title,
        style: const TextStyle(color: Colors.grey),
      ),
      children: items
          .map((item) => _buildMenuItem(
                icon: Icons.circle,
                title: item,
                isSelected: false,
              ))
          .toList(),
    );
  }

  Widget _buildStatItem(String label, String count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.circle, size: 12, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Text(
            count,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
