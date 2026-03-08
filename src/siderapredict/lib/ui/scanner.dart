import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  List<CameraDescription> _cameras = [];
  FlashMode _flashMode = FlashMode.auto;
  int _backCameraIdx = 0;
  int _flashStep = 0;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    if (_cameras.isEmpty) return;
    _backCameraIdx = _cameras.indexWhere(
      (c) => c.lensDirection == CameraLensDirection.back,
    );
    if (_backCameraIdx == -1) _backCameraIdx = 0;
    _controller?.dispose();
    _controller = CameraController(
      _cameras[_backCameraIdx],
      ResolutionPreset.max,
      enableAudio: false,
    );
    _initializeControllerFuture = _controller!.initialize().then((_) async {
      await _controller!.setFlashMode(_flashMode);
    });
    setState(() {});
  }

  void _toggleFlash() async {
    if (_controller == null) return;
    _flashStep = (_flashStep + 1) % 4;
    FlashMode newMode;
    switch (_flashStep) {
      case 0:
        newMode = FlashMode.auto;
        break;
      case 1:
        newMode = FlashMode.always;
        break;
      case 2:
        newMode = FlashMode.off;
        break;
      case 3:
      default:
        newMode = FlashMode.torch;
        break;
    }
    await _controller!.setFlashMode(newMode);
    setState(() {
      _flashMode = newMode;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  IconData _getFlashIcon() {
    switch (_flashMode) {
      case FlashMode.auto:
        return Icons.flash_auto;
      case FlashMode.always:
        return Icons.flash_on;
      case FlashMode.torch:
        return Icons.highlight;
      case FlashMode.off:
        return Icons.flash_off;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: _controller != null && _initializeControllerFuture != null
                ? FutureBuilder<void>(
                    future: _initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        final previewSize = _controller!.value.previewSize;

                        if (previewSize != null) {
                          final isPortrait =
                              MediaQuery.of(context).orientation ==
                              Orientation.portrait;
                          final previewWidth = isPortrait
                              ? previewSize.height
                              : previewSize.width;
                          final previewHeight = isPortrait
                              ? previewSize.width
                              : previewSize.height;

                          return SizedBox.expand(
                            child: FittedBox(
                              fit: BoxFit.cover,
                              clipBehavior: Clip.hardEdge,
                              child: SizedBox(
                                width: previewWidth,
                                height: previewHeight,
                                child: CameraPreview(_controller!),
                              ),
                            ),
                          );
                        } else {
                          return CameraPreview(_controller!);
                        }
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.red,
                          ),
                        );
                      }
                    },
                  )
                : const Center(
                    child: CircularProgressIndicator(
                      color: Colors.red,
                    ),
                  ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 32,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Botão de flash
                  FloatingActionButton(
                    heroTag: 'flash',
                    backgroundColor: Colors.white,
                    onPressed: _toggleFlash,
                    child: Icon(_getFlashIcon(), color: Colors.red),
                  ),
                  // Botão escanear peça
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          onPressed: () {},
                          child: const Text(
                            'ESCANEAR PEÇA',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Removido botão de virar câmera
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
