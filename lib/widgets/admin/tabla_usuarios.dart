import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grovehubmusic/cubit/Usertlistt.dart';
import 'package:grovehubmusic/pages/foro/filtroscreen.dart';
import 'package:grovehubmusic/services/services_auth.dart';
import 'package:grovehubmusic/widgets/admin/RegisterUserForm.dart';

class TablaUsuarios extends StatefulWidget {
  const TablaUsuarios({Key? key}) : super(key: key);

  @override
  _TablaUsuariosState createState() => _TablaUsuariosState();
}

class _TablaUsuariosState extends State<TablaUsuarios> {
  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().loadUsers();
  }

  void _showRegisterUserForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: RegisterUserForm(
            onUserAdded: () {
              context.read<UserCubit>().loadUsers();
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return Card(
          color: const Color(0xFF212121),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Total de registros: ',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      '${state.users.length}',
                      style: TextStyle(color: Colors.white),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: _showRegisterUserForm,
                      icon: const Icon(Icons.add),
                      label: const Text('Añadir Usuario'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FiltrosScreen(),
                          ),
                        ).then((filters) {
                          if (filters != null) {
                            context
                                .read<UserCubit>()
                                .loadUsers(filters: filters);
                          }
                        });
                      },
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
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 8),
                        ),
                        onSubmitted: (value) {
                          context
                              .read<UserCubit>()
                              .loadUsers(filters: {'search': value});
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: state.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
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
                                  'Nombre Completo',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Fecha de Creación',
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
                            rows: state.users.map((user) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 16,
                                          child: Text(user['username'][0]
                                              .toUpperCase()),
                                          backgroundColor: Colors.deepPurple,
                                        ),
                                        const SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              user['username'],
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              user['email'],
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
                                    _buildRoleChip(user['role']),
                                  ),
                                  DataCell(
                                    Text(
                                      user['full_name'],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      user['created_at'],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  DataCell(
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                              Icons.remove_red_eye_rounded,
                                              color: Colors.grey,
                                              size: 20),
                                          onPressed: () {
                                            GoRouter.of(context).go(
                                                '/admin/user/${user['id']}');
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.grey, size: 20),
                                          onPressed: () async {
                                            await ApiService()
                                                .deleteUser(user['id']);
                                            context
                                                .read<UserCubit>()
                                                .loadUsers();
                                          },
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
                              );
                            }).toList(),
                          ),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRoleChip(String role) {
    Color color;
    switch (role.toLowerCase()) {
      case 'admin':
        color = Colors.red;
        break;
      case 'artist':
        color = Colors.blue;
        break;
      case 'listener':
        color = Colors.green;
        break;
      case 'moderator':
        color = Colors.orange;
        break;
      default:
        color = Colors.grey;
    }

    return Chip(
      label: Text(
        role,
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
