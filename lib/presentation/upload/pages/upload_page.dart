import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tunezmusic/presentation/upload/bloc/upload_bloc.dart';
import 'package:tunezmusic/presentation/upload/bloc/upload_event.dart';
import 'package:tunezmusic/presentation/upload/bloc/upload_state.dart';
import 'package:tunezmusic/presentation/upload/bloc/genres_bloc.dart';
import 'package:tunezmusic/presentation/upload/bloc/genres_event.dart';
import 'package:tunezmusic/presentation/upload/bloc/genres_state.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _genresController = TextEditingController(text: 'Pop');
  File? _musicFile;
  File? _imgFile;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  String _artistName = '';
  String? _selectedGenreId;
  String? _selectedGenreName;
  String _duration = '150';

  @override
  void initState() {
    super.initState();
    _loadArtistName();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );
    _animationController.forward();
    context.read<GenresBloc>().add(FetchGenres());
  }

  Future<void> _loadArtistName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _artistName = prefs.getString('userName') ?? '';
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _genresController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _pickMusic() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = File(result.files.single.path!);
        setState(() {
          _musicFile = file;
        });

        debugPrint('Selected file path: ${file.path}');

        // Tạo MediaItem cho file audio
        final mediaItem = MediaItem(
          id: file.path,
          title: file.path.split('/').last,
          artist: 'Unknown',
          duration: null,
        );

        // Tạo AudioSource với MediaItem
        final audioSource = AudioSource.uri(
          Uri.file(file.path),
          tag: mediaItem,
        );

        // Tạo AudioPlayer và tải file
        final player = AudioPlayer();
        try {
          await player.setAudioSource(audioSource);
          
          // Lấy duration
          final duration = await player.duration;
          if (duration != null) {
            setState(() {
              _duration = duration.inSeconds.toString();
              debugPrint('Duration updated: $_duration seconds');
            });
          } else {
            debugPrint('Could not get duration');
          }
        } catch (e) {
          debugPrint('Error setting audio source: $e');
        } finally {
          await player.dispose();
        }
      }
    } catch (e) {
      debugPrint('Error picking music: $e');
    }
  }

  Future<void> _pickImage() async {
    final result = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (result != null) {
      setState(() {
        _imgFile = File(result.path);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_musicFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng chọn file nhạc')),
        );
        return;
      }
      if (_imgFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng chọn ảnh bìa')),
        );
        return;
      }
      if (_selectedGenreId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng chọn thể loại')),
        );
        return;
      }

      // Create genres list with selected genre
      List<Map<String, String>> genresList = [
        {
          "id": _selectedGenreId!,
          "name": _selectedGenreName!,
        }
      ];

      context.read<UploadBloc>().add(
        UploadMusic(
          name: _nameController.text,
          artist: _artistName,
          duration: _duration,
          genres: genresList,
          musicFile: _musicFile!,
          imgFile: _imgFile!,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UploadBloc, UploadState>(
      listener: (context, state) {
        if (state is UploadSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Upload thành công!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else if (state is UploadError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'Upload Nhạc',
              style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildImagePreview(),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _nameController,
                        label: 'Tên bài hát',
                        icon: Icons.music_note,
                      ),
                      const SizedBox(height: 16),
                      _buildGenreDropdown(),
                      const SizedBox(height: 24),
                      _buildFilePicker(
                        onPressed: _pickMusic,
                        icon: Icons.audio_file,
                        label: 'Chọn file nhạc',
                        file: _musicFile,
                      ),
                      if (_musicFile != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Thời lượng: ${_duration} giây',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      _buildFilePicker(
                        onPressed: _pickImage,
                        icon: Icons.image,
                        label: 'Chọn ảnh bìa',
                        file: _imgFile,
                      ),
                      const SizedBox(height: 32),
                      BlocBuilder<UploadBloc, UploadState>(
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: state is UploadLoading ? null : _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: state is UploadLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                    ),
                                  )
                                : const Text(
                                    'Upload',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: _imgFile != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                _imgFile!,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image,
                    size: 50,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Chưa có ảnh bìa',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập $label';
        }
        return null;
      },
    );
  }

  Widget _buildFilePicker({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    File? file,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.1),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
      ),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              file != null ? file.path.split('/').last : label,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (file != null)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  if (label.contains('nhạc')) {
                    _musicFile = null;
                  } else {
                    _imgFile = null;
                  }
                });
              },
            ),
        ],
      ),
    );
  }

  Widget _buildGenreDropdown() {
    return BlocBuilder<GenresBloc, GenresState>(
      builder: (context, state) {
        if (state is GenresLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GenresError) {
          return Text(
            state.message,
            style: const TextStyle(color: Colors.red),
          );
        } else if (state is GenresLoaded) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedGenreId,
                isExpanded: true,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                dropdownColor: Colors.black,
                style: const TextStyle(color: Colors.white),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
                hint: Row(
                  children: [
                    const Icon(Icons.category, color: Colors.white70),
                    const SizedBox(width: 12),
                    Text(
                      'Chọn thể loại',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                items: state.genres.map<DropdownMenuItem<String>>((genre) {
                  return DropdownMenuItem<String>(
                    value: genre['id'],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        genre['name'],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedGenreId = newValue;
                      _selectedGenreName = state.genres
                          .firstWhere((genre) => genre['id'] == newValue)['name'];
                    });
                  }
                },
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
} 