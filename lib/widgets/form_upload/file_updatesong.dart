import 'package:flutter/material.dart';
import 'package:grovehubmusic/config/enviroments.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:convert';

class UpdateSongFormFile extends StatefulWidget {
  final String songId;

  const UpdateSongFormFile({Key? key, required this.songId}) : super(key: key);

  @override
  _UpdateSongFormState createState() => _UpdateSongFormState();
}

class _UpdateSongFormState extends State<UpdateSongFormFile> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _genreController = TextEditingController();
  File? _coverArtFile;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _genreController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        _coverArtFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      var uri = Uri.parse('${Enviroments.apiUrl}/api/songs/update-with-file');
      var request = http.MultipartRequest('POST', uri);

      request.fields['song_id'] = widget.songId;
      request.fields['title'] = _titleController.text;
      request.fields['description'] = _descriptionController.text;
      request.fields['genre'] = _genreController.text;

      if (_coverArtFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'coverArtFile',
          _coverArtFile!.path,
        ));
      }

      try {
        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          var jsonResponse = json.decode(response.body);
          if (jsonResponse['success']) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Song updated successfully')),
            );
            Navigator.of(context).pop();
          } else {
            throw Exception(jsonResponse['message']);
          }
        } else {
          throw Exception('Failed to update song');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Song'),
        backgroundColor: Colors.purple[900],
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.purple[900]!, Colors.blue[900]!],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Colors.white.withOpacity(0.9),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              labelText: 'Title',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a title';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _descriptionController,
                            decoration: InputDecoration(
                              labelText: 'Description',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            maxLines: 3,
                          ),
                          SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _genreController.text.isEmpty
                                ? null
                                : _genreController.text,
                            decoration: InputDecoration(
                              labelText: 'Genre',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            items: [
                              'Pop',
                              'Rock',
                              'Reggae',
                              'Indie',
                              'Jazz',
                              'Hip Hop',
                              'Clasica',
                              'Trap',
                              'Rap',
                            ]
                                .map((genre) => DropdownMenuItem<String>(
                                      value: genre,
                                      child: Text(genre),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _genreController.text = value!;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a genre';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _pickImage,
                            icon: Icon(Icons.image),
                            label: Text('Select Cover Art'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 24),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          if (_coverArtFile != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Image selected: ${_coverArtFile!.path.split('/').last}',
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('Update Song', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[900],
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
