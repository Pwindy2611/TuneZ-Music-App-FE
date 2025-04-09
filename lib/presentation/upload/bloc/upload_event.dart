import 'dart:io';

abstract class UploadEvent {}

class UploadMusic extends UploadEvent {
  final String name;
  final String artist;
  final String duration;
  final List<Map<String, String>> genres;
  final File musicFile;
  final File imgFile;

  UploadMusic({
    required this.name,
    required this.artist,
    required this.duration,
    required this.genres,
    required this.musicFile,
    required this.imgFile,
  });
} 