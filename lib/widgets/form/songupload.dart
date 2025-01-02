import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:grovehubmusic/cubit/SongUploadCubit.dart';

class SongUploadForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SongUploadCubit, SongUploadState>(
      builder: (context, state) {
        return Container(
          color: const Color(0xFF1D1D1D),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header with upload progress
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D2D2D),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.upload_file, color: Colors.white54),
                      const SizedBox(width: 12),
                      Text(
                        '${state.isUploading ? "Uploading..." : "0%"} de subidas usado',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                        ),
                        child: const Text('Sube pistas sin límite'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Title and format info
                const Text(
                  'Sube tus archivos de audio.',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Para obtener la mejor calidad, utiliza WAV, FLAC, AIFF o ALAC. El tamaño máximo del archivo es de 4 GB sin comprimir.',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 24),

                // Upload type selector
                SegmentedButton<UploadType>(
                  segments: const [
                    ButtonSegment(
                      value: UploadType.song,
                      label: Text('Canción'),
                      icon: Icon(Icons.music_note),
                    ),
                    ButtonSegment(
                      value: UploadType.album,
                      label: Text('Álbum'),
                      icon: Icon(Icons.album),
                    ),
                  ],
                  selected: {state.uploadType},
                  onSelectionChanged: (Set<UploadType> newSelection) {
                    context
                        .read<SongUploadCubit>()
                        .setUploadType(newSelection.first);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return const Color(0xFFF50);
                        }
                        return const Color(0xFF2D2D2D);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Drop zone
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white24,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        size: 64,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Arrastra y suelta archivos de audio para empezar.',
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: state.isUploading
                            ? null
                            : () async {
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles(
                                  type: FileType.audio,
                                  allowMultiple: false,
                                  withData: true, // Important for web support
                                );

                                if (result != null && result.files.isNotEmpty) {
                                  final file = result.files.first;
                                  context.read<SongUploadCubit>().setFileData(
                                        fileName: file.name,
                                        fileBytes: file.bytes!,
                                      );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2D2D2D),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        child: Text(state.fileName != null
                            ? 'Cambiar archivo'
                            : 'Elegir archivos'),
                      ),
                    ],
                  ),
                ),

                // File info and upload button
                if (state.fileName != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D2D2D),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Archivo seleccionado: ${state.fileName}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: (state.fileName != null &&
                                    !state.isUploading)
                                ? () =>
                                    context.read<SongUploadCubit>().uploadFile()
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF50),
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: state.isUploading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.black),
                                    ),
                                  )
                                : Text(
                                    'Subir ${state.uploadType == UploadType.song ? 'Canción' : 'Álbum'}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Status messages
                if (state.errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: Text(
                      state.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
                if (state.uploadSuccess) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                    ),
                    child: const Text(
                      'Subida exitosa!',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
