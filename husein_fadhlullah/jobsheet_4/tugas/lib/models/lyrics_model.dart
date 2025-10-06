import 'dart:convert';
import 'package:flutter/services.dart';

class LyricsLine {
  final String text;
  final bool isHighlighted;

  LyricsLine({
    required this.text,
    this.isHighlighted = false,
  });
}

class LyricsSection {
  final String type;
  final int startTime;
  final List<String> lines;

  LyricsSection({
    required this.type,
    required this.startTime,
    required this.lines,
  });

  factory LyricsSection.fromJson(Map<String, dynamic> json) {
    return LyricsSection(
      type: json['type'] as String,
      startTime: json['startTime'] as int,
      lines: List<String>.from(json['lines'] as List),
    );
  }

  bool get isChorus => type == 'chorus';
  bool get isBridge => type == 'bridge';
  bool get isVerse => type == 'verse';
}

class Song {
  final String title;
  final String artist;
  final String album;
  final int year;
  final int duration;
  final List<LyricsSection> lyrics;

  Song({
    required this.title,
    required this.artist,
    required this.album,
    required this.year,
    required this.duration,
    required this.lyrics,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    var songData = json['song'] as Map<String, dynamic>;
    var lyricsJson = songData['lyrics'] as List;
    
    return Song(
      title: songData['title'] as String,
      artist: songData['artist'] as String,
      album: songData['album'] as String,
      year: songData['year'] as int,
      duration: songData['duration'] as int,
      lyrics: lyricsJson.map((lyric) => LyricsSection.fromJson(lyric)).toList(),
    );
  }

  List<LyricsLine> getAllLyricsLines() {
    List<LyricsLine> allLines = [];
    
    for (var section in lyrics) {
      for (var line in section.lines) {
        allLines.add(LyricsLine(
          text: line,
          isHighlighted: section.isChorus || section.isBridge,
        ));
      }
      // Add spacing between sections
      if (section != lyrics.last) {
        allLines.add(LyricsLine(text: ''));
      }
    }
    
    return allLines;
  }

  LyricsSection? getCurrentSection(int currentTimeInSeconds) {
    for (int i = lyrics.length - 1; i >= 0; i--) {
      if (currentTimeInSeconds >= lyrics[i].startTime) {
        return lyrics[i];
      }
    }
    return null;
  }

  String get fullArtistAndTitle => '$title - $artist';
  String get albumAndYear => '$album ($year)';
  String get durationFormatted {
    int minutes = duration ~/ 60;
    int seconds = duration % 60;
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }
}

class LyricsRepository {
  static Future<Song> loadSong() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/lyrics.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      return Song.fromJson(jsonData);
    } catch (e) {
      throw Exception('Failed to load lyrics: $e');
    }
  }
}