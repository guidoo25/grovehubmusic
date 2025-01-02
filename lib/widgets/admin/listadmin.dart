import 'package:flutter/material.dart';

class TablaUsuarios extends StatelessWidget {
  const TablaUsuarios({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF212121),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Total de registros: ',
                  style: TextStyle(color: Colors.grey),
                ),
                const Text(
                  '1',
                  style: TextStyle(color: Colors.white),
                ),
                const Spacer(),
                // Filtros y búsqueda
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_list),
                  label: const Text('Filtros'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey,
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 200,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar...',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(
                      label: Text(
                        'Usuario',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Roles',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Fondos',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Estadísticas',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Acciones',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                  rows: [
                    DataRow(
                      cells: [
                        DataCell(
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 16,
                                backgroundImage:
                                    NetworkImage('https://picsum.photos/200'),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'admin',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    'admin@example.com',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        DataCell(
                          Wrap(
                            spacing: 4,
                            children: [
                              _buildRoleChip('Admin', Colors.orange),
                              _buildRoleChip('Gestor', Colors.blue),
                            ],
                          ),
                        ),
                        const DataCell(
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Fondos: 25.1',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                'Transacciones: 8',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const DataCell(
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'En línea',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                'Seguidores: 1',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Colors.grey, size: 20),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.grey, size: 20),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(Icons.more_vert,
                                    color: Colors.grey, size: 20),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleChip(String label, Color color) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
      backgroundColor: color.withOpacity(0.2),
      side: BorderSide(color: color),
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
