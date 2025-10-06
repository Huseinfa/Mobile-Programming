import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/lyrics_model.dart';
import 'services/audio_service.dart';

void main() {
  runApp(const LyricsApp());
}

class LyricsApp extends StatelessWidget {
  const LyricsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'I\'m Still Standing - Lyrics',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF404040),  // Gray to match theme
          brightness: Brightness.dark,
        ),
      ),
      home: const LyricsHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LyricsHomePage extends StatefulWidget {
  const LyricsHomePage({super.key});

  @override
  State<LyricsHomePage> createState() => _LyricsHomePageState();
}

class _LyricsHomePageState extends State<LyricsHomePage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;
  
  bool _showLyrics = false;
  Song? _currentSong;
  final AudioService _audioService = AudioService();
  
  // Interactive vinyl spinning variables
  double _currentRotation = 0.0;
  double _velocity = 0.0;
  bool _isUserInteracting = false;

  Future<void> _loadSong() async {
    try {
      final song = await LyricsRepository.loadSong();
      setState(() {
        _currentSong = song;
      });
    } catch (e) {
      print('Error loading song: $e');
    }
  }



  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _rotationController = AnimationController(
      duration: const Duration(seconds: 12),  // Elegant, smooth rotation - 12 seconds per full rotation
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _rotationController.repeat();
    _pulseController.repeat(reverse: true);
    
    // Initialize audio service and load song data
    _audioService.initialize();
    _loadSong();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _rotationController.dispose();
    _pulseController.dispose();
    _audioService.dispose();
    super.dispose();
  }

  void _showLyricsPage() {
    setState(() {
      _showLyrics = true;
    });
    _fadeController.forward();
  }

  void _applyMomentum() {
    // Create momentum animation that gradually slows down
    if (_velocity > 0.1) {
      final momentumController = AnimationController(
        duration: Duration(milliseconds: (1000 * _velocity).clamp(500, 3000).toInt()),
        vsync: this,
      );
      
      final momentumAnimation = Tween<double>(
        begin: 0.0,
        end: _velocity * 10,
      ).animate(CurvedAnimation(
        parent: momentumController,
        curve: Curves.decelerate,
      ));

      momentumAnimation.addListener(() {
        if (!_isUserInteracting) {
          setState(() {
            _currentRotation += momentumAnimation.value * 0.01;
          });
        }
      });

      momentumAnimation.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          momentumController.dispose();
          _velocity = 0.0;
          // Resume automatic spinning if not interacting
          if (!_isUserInteracting) {
            _rotationController.repeat();
          }
        }
      });

      momentumController.forward();
    } else {
      // Resume automatic spinning immediately if velocity is low
      _rotationController.repeat();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF000000),  // Pure black
              Color(0xFF1A1A1A),  // Dark gray
              Color(0xFF2D2D2D),  // Medium gray
              Color(0xFF404040),  // Light gray
            ],
          ),
        ),
        child: _showLyrics ? _buildLyricsPage() : _buildWelcomePage(),
      ),
      bottomNavigationBar: _buildBottomPlayer(),
    );
  }

  Widget _buildWelcomePage() {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
          // Interactive spinning vinyl record
          GestureDetector(
            onPanStart: (details) {
              _isUserInteracting = true;
              _rotationController.stop();
            },
            onPanUpdate: (details) {
              setState(() {
                // Calculate rotation based on drag movement
                _velocity = details.delta.distance * 0.02;
                _currentRotation += details.delta.distance * 0.01;
              });
            },
            onPanEnd: (details) {
              _isUserInteracting = false;
              // Apply momentum and gradually slow down
              _applyMomentum();
            },
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.transparent,
                  ],
                  stops: const [0.8, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: AnimatedBuilder(
                animation: _isUserInteracting ? AlwaysStoppedAnimation(0.0) : _rotationAnimation,
                builder: (context, child) {
                  final rotationAngle = _isUserInteracting 
                    ? _currentRotation 
                    : _rotationAnimation.value * 2 * 3.14159;
                  
                  return Transform.rotate(
                    angle: rotationAngle,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const RadialGradient(
                          colors: [
                            Color(0xFF0A0A0A),  // Deep black center
                            Color(0xFF1A1A1A),  // Dark inner
                            Color(0xFF2A2A2A),  // Medium gray
                            Color(0xFF1A1A1A),  // Ring shadow
                            Color(0xFF3A3A3A),  // Lighter edge
                            Color(0xFF0A0A0A),  // Black rim
                          ],
                          stops: [0.0, 0.2, 0.4, 0.6, 0.85, 1.0],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.8),
                            blurRadius: 30,
                            spreadRadius: 5,
                            offset: const Offset(0, 10),
                          ),
                          BoxShadow(
                            color: Colors.white.withOpacity(0.05),
                            blurRadius: 60,
                            spreadRadius: 15,
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Subtle vinyl grooves with gradient effect
                          for (int i = 1; i <= 8; i++)
                            Container(
                              width: 30.0 + (i * 18.0),
                              height: 30.0 + (i * 18.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.05),
                                  width: 0.3,
                                ),
                              ),
                            ),
                          // Premium center label with metallic effect
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const RadialGradient(
                                colors: [
                                  Color(0xFF4A4A4A),  // Metallic center
                                  Color(0xFF2A2A2A),  // Darker edge
                                  Color(0xFF1A1A1A),  // Shadow
                                ],
                                stops: [0.0, 0.7, 1.0],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(-2, -2),
                                ),
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 8,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF6A6A6A),
                                      Color(0xFF3A3A3A),
                                    ],
                                  ),
                                ),
                                child: const Icon(
                                  Icons.music_note,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                          // Vinyl needle/stylus in the center that rotates with record
                          Transform.rotate(
                            angle: 0, // Pointing straight up from center
                            child: Container(
                              width: 2,
                              height: 200, // Half of 200px vinyl diameter
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1),
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFF8A8A8A), // Metallic silver
                                    Color(0xFF5A5A5A), // Darker metal
                                    Color(0xFF3A3A3A), // Shadow base
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.4),
                                    blurRadius: 3,
                                    offset: const Offset(0, 0),
                                  ),
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.6),
                                    blurRadius: 2,
                                    offset: const Offset(1, 1),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Premium center hole with depth
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const RadialGradient(
                                colors: [
                                  Color(0xFF000000),
                                  Color(0xFF1A1A1A),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.8),
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 40),
          
          // Animated title
          DefaultTextStyle(
            style: GoogleFonts.playfairDisplay(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  _currentSong?.title ?? 'I\'m Still Standing',
                  speed: const Duration(milliseconds: 200),
                ),
              ],
              totalRepeatCount: 1,
            ),
          ),
          const SizedBox(height: 10),
          
          // Artist name
          Text(
            'by ${_currentSong?.artist ?? 'Elton John'}',
            style: GoogleFonts.openSans(
              fontSize: 18,
              color: Colors.white70,
              fontStyle: FontStyle.italic,
            ),
          ),
          
          // Album and year info
          if (_currentSong != null) ...[
            const SizedBox(height: 8),
            Text(
              _currentSong!.albumAndYear,
              style: GoogleFonts.openSans(
                fontSize: 14,
                color: Colors.white60,
              ),
            ),
          ],
          const SizedBox(height: 60),
          
          // Animated button
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: ElevatedButton(
                  onPressed: _showLyricsPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: const BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.music_note),
                      const SizedBox(width: 10),
                      Text(
                        'View Lyrics',
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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
    );
  }

  Widget _buildLyricsPage() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            floating: false,
            pinned: true,
            backgroundColor: Colors.black87,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                _currentSong?.title ?? 'I\'m Still Standing',
                style: GoogleFonts.playfairDisplay(
                  fontWeight: FontWeight.bold,
                  shadows: [
                    const Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
              centerTitle: true,
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF000000),  // Pure black
                      Colors.transparent,
                    ],
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.music_note,
                    size: 80,
                    color: Colors.white30,
                  ),
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                setState(() {
                  _showLyrics = false;
                });
                _fadeController.reset();
              },
            ),
          ),
          if (_currentSong != null) ...[
            StreamBuilder<Duration>(
              stream: _audioService.positionStream,
              builder: (context, snapshot) {
                final currentPosition = snapshot.data ?? Duration.zero;
                final currentTimeInSeconds = currentPosition.inSeconds;
                final currentSection = _currentSong!.getCurrentSection(currentTimeInSeconds);
                
                return SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, sectionIndex) {
                        final section = _currentSong!.lyrics[sectionIndex];
                        final isCurrentSection = currentSection == section;
                        final isPastSection = currentTimeInSeconds > section.startTime;
                        
                        return Column(
                          children: [
                            // Section Header (Verse, Chorus, etc.)
                            if (section.type != 'verse' || sectionIndex == 0) ...[
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 20),
                                child: Text(
                                  section.type.toUpperCase(),
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: isCurrentSection 
                                        ? Colors.white.withOpacity(0.9)
                                        : Colors.white.withOpacity(0.4),
                                    letterSpacing: 2,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                            // Section Lines
                            ...section.lines.asMap().entries.map((entry) {
                              final lineIndex = entry.key;
                              final lineText = entry.value;
                              
                              // Estimate current line based on time within section
                              final timeInSection = currentTimeInSeconds - section.startTime;
                              final estimatedCurrentLineIndex = isCurrentSection 
                                  ? (timeInSection / 4).floor().clamp(0, section.lines.length - 1)
                                  : -1;
                              
                              final isCurrentLine = isCurrentSection && lineIndex == estimatedCurrentLineIndex;
                              final isPastLine = isPastSection || (isCurrentSection && lineIndex < estimatedCurrentLineIndex);
                              
                              double opacity;
                              double fontSize;
                              FontWeight fontWeight;
                              Color textColor;
                              
                              if (isCurrentLine) {
                                // Current line: bright, large, bold
                                opacity = 1.0;
                                fontSize = 22;
                                fontWeight = FontWeight.bold;
                                textColor = Colors.white;
                              } else if (isPastLine) {
                                // Past lines: dimmed, smaller
                                opacity = 0.4;
                                fontSize = 16;
                                fontWeight = FontWeight.normal;
                                textColor = Colors.white70;
                              } else {
                                // Future lines: medium opacity
                                opacity = 0.6;
                                fontSize = 18;
                                fontWeight = FontWeight.w300;
                                textColor = Colors.white60;
                              }
                              
                              return TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0.0, end: 1.0),
                                duration: Duration(milliseconds: 300 + (lineIndex * 100)),
                                builder: (context, animationValue, child) {
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 800),
                                    curve: Curves.easeInOut,
                                    margin: EdgeInsets.only(
                                      bottom: isCurrentLine ? 16 : 8,
                                      left: 20,
                                      right: 20,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: isCurrentLine ? 12 : 6,
                                      horizontal: isCurrentLine ? 20 : 10,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: isCurrentLine 
                                          ? Colors.white.withOpacity(0.1)
                                          : Colors.transparent,
                                      border: isCurrentLine 
                                          ? Border.all(
                                              color: Colors.white.withOpacity(0.3),
                                              width: 1,
                                            )
                                          : null,
                                      boxShadow: isCurrentLine 
                                          ? [
                                              BoxShadow(
                                                color: Colors.white.withOpacity(0.1),
                                                blurRadius: 20,
                                                spreadRadius: 5,
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: Transform.translate(
                                      offset: Offset(30 * (1 - animationValue), 0),
                                      child: Opacity(
                                        opacity: animationValue * opacity,
                                        child: lineText.isEmpty
                                            ? const SizedBox(height: 16)
                                            : AnimatedDefaultTextStyle(
                                                duration: const Duration(milliseconds: 800),
                                                style: GoogleFonts.openSans(
                                                  fontSize: fontSize,
                                                  height: 1.4,
                                                  color: textColor,
                                                  fontWeight: fontWeight,
                                                  shadows: isCurrentLine ? [
                                                    Shadow(
                                                      offset: const Offset(0, 1),
                                                      blurRadius: 3,
                                                      color: Colors.black.withOpacity(0.5),
                                                    ),
                                                  ] : null,
                                                ),
                                                child: Text(
                                                  lineText,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                            const SizedBox(height: 30), // Spacing between sections
                          ],
                        );
                      },
                      childCount: _currentSong!.lyrics.length,
                    ),
                  ),
                );
              },
            ),
          ] else ...[
            const SliverPadding(
              padding: EdgeInsets.all(20),
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            ),
          ],
          const SliverPadding(
            padding: EdgeInsets.only(bottom: 50),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: Text(
                  '♪ ♫ ♪ ♫ ♪',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white54,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPlayer() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1A1A1A),
            Color(0xFF000000),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            // Progress Bar
            StreamBuilder<Duration>(
              stream: _audioService.positionStream,
              builder: (context, positionSnapshot) {
                return StreamBuilder<Duration>(
                  stream: _audioService.durationStream,
                  builder: (context, durationSnapshot) {
                    final position = positionSnapshot.data ?? Duration.zero;
                    final duration = durationSnapshot.data ?? Duration.zero;
                    final progress = duration.inMilliseconds > 0 
                        ? position.inMilliseconds / duration.inMilliseconds 
                        : 0.0;
                    
                    return Column(
                      children: [
                        // Progress Bar
                        Container(
                          height: 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: Colors.white.withOpacity(0.3),
                          ),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Time Display
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _audioService.formatDuration(position),
                              style: GoogleFonts.openSans(
                                fontSize: 12,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              _audioService.formatDuration(duration),
                              style: GoogleFonts.openSans(
                                fontSize: 12,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 15),
            // Controls Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Song Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentSong?.title ?? 'I\'m Still Standing',
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _currentSong?.artist ?? 'Elton John',
                        style: GoogleFonts.openSans(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Play Button
                StreamBuilder<PlayerState>(
                  stream: _audioService.playerStateStream,
                  builder: (context, snapshot) {
                    final playerState = snapshot.data ?? PlayerState.stopped;
                    final isPlaying = playerState == PlayerState.playing;
                    final isLoading = playerState == PlayerState.loading;
                    
                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: isLoading ? null : () async {
                          await _audioService.togglePlayPause();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.2),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(15),
                          shape: const CircleBorder(),
                          elevation: 5,
                        ),
                        child: isLoading 
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                              size: 32,
                            ),
                      ),
                    );
                  },
                ),
                // Spacer for balance
                const SizedBox(width: 60),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
