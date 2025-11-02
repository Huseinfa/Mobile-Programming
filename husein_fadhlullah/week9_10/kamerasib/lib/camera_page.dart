import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class CameraPage extends StatefulWidget {
  final List<CameraDescription>? cameras;
  const CameraPage({super.key, this.cameras});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isCameraReady = false;
  int _selectedCameraIdx = 0;
  String? _lastImagePath;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    _cameras = widget.cameras ?? await availableCameras();
    if (_cameras == null || _cameras!.isEmpty) return;
    _selectedCameraIdx = _selectedCameraIdx.clamp(0, _cameras!.length - 1);
    _controller = CameraController(_cameras![_selectedCameraIdx], ResolutionPreset.high);
    try {
      await _controller!.initialize();
    } catch (e) {
      // ignore errors for now; camera package handles permissions/errors
    }
    if (!mounted) return;
    setState(() {
      _isCameraReady = _controller!.value.isInitialized;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _switchCamera() async {
    if (_cameras == null || _cameras!.length < 2) return;
    _selectedCameraIdx = (_selectedCameraIdx + 1) % _cameras!.length;
    await _controller?.dispose();
    _controller = CameraController(_cameras![_selectedCameraIdx], ResolutionPreset.high);
    try {
      await _controller!.initialize();
    } catch (e) {}
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    try {
      final XFile raw = await _controller!.takePicture();
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String ext = p.extension(raw.path);
      final String fileName = 'IMG_${DateTime.now().millisecondsSinceEpoch}$ext';
      final String savedPath = p.join(appDocDir.path, fileName);
      await File(raw.path).copy(savedPath);
      setState(() {
        _lastImagePath = savedPath;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saved to: $savedPath')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error taking picture: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraReady || _controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Page'),
        actions: [
          if (_cameras != null && _cameras!.length > 1)
            IconButton(
              icon: const Icon(Icons.switch_camera),
              onPressed: _switchCamera,
              tooltip: 'Switch camera',
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: CameraPreview(_controller!)),
          Container(
            padding: const EdgeInsets.all(8),
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _lastImagePath ?? 'No photo taken yet',
                    style: const TextStyle(fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: _takePicture,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}