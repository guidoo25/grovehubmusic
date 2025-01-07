import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grovehubmusic/config/enviroments.dart';

class UploadChoiceScreen extends StatelessWidget {
  final String songId;
  const UploadChoiceScreen({super.key, required this.songId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Escoge opcion de subida'),
      ),
      body: Row(
        children: [
          Expanded(
            child: _buildUploadOption(
              context,
              title: 'Subir Normalmente',
              description: 'Sube tu canción sin asistencia de IA',
              icon: Icons.upload_file,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1A1A1A),
                  Color(0xFF0D0D0D),
                ],
              ),
              onTap: () {
                GoRouter.of(context).go('/update/file', extra: songId);
              },
            ),
          ),
          Expanded(
            child: _buildAIUploadOption(context, songId),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadOption(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: Colors.white),
            SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIUploadOption(BuildContext context, String songId) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF00C853),
            Color(0xFF009624),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Subir con IA',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Deja que la IA te ayude a crear tu canción',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          SizedBox(height: 10),
          Text(
            'Solo para suscriptores Pro',
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: Colors.redAccent,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPhotoWidget('${Enviroments.imageurl}/ai_image_1.jpg'),
              _buildPhotoWidget('${Enviroments.imageurl}/ai_image_2.jpg'),
              _buildPhotoWidget('${Enviroments.imageurl}/ai_image_3.jpg'),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Navigate to AI upload screen
              // TODO: Implement navigation
              GoRouter.of(context).go('/update/ia', extra: songId);
            },
            child: Text(
              'Elegir Subida con IA',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoWidget(String imagePath) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          imagePath,
          fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[800],
              child: Icon(Icons.error, color: Colors.white60),
            );
          },
        ),
      ),
    );
  }
}
