import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class MaskDetectionPage extends StatefulWidget {
  const MaskDetectionPage({super.key});

  @override
  State<MaskDetectionPage> createState() => _MaskDetectionPageState();
}

class _MaskDetectionPageState extends State<MaskDetectionPage> {
  CameraController? _cameraController;
  bool _isDetecting = false;
  String _result = 'No mask detected';

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    _cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
    );

    await _cameraController?.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mask Detection'),
        backgroundColor: Colors.blueAccent,
      ),
      body: _cameraController == null || !_cameraController!.value.isInitialized
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          CameraPreview(_cameraController!),
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Detection Result',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _result,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  _result = _isDetecting ? 'No mask detected' : 'Mask detected';
                  _isDetecting = !_isDetecting;
                });
              },
              child: Icon(
                _isDetecting ? Icons.cancel : Icons.check_circle,
                color: Colors.white,
              ),
              backgroundColor: _isDetecting ? Colors.red : Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}