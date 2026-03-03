import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_v2/tflite_v2.dart';

List<CameraDescription>? cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(
    const MaterialApp(home: CameraScreen(), debugShowCheckedModeBanner: false),
  );
}

// ==========================================
// TELA 1: CÂMERA
// ==========================================
class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  bool _isTakingPicture = false;

  @override
  void initState() {
    super.initState();
    _loadModel();
    _initCamera();
  }

  // Carrega o modelo apenas uma vez ao abrir o app
  Future<void> _loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  void _initCamera() {
    if (cameras == null || cameras!.isEmpty) return;

    _cameraController = CameraController(
      cameras![0],
      ResolutionPreset.high,
      enableAudio: false,
    );

    _cameraController!.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  Future<void> _captureAndNavigate() async {
    if (_isTakingPicture ||
        _cameraController == null ||
        !_cameraController!.value.isInitialized)
      return;

    setState(() {
      _isTakingPicture = true;
    });

    try {
      // Tira a foto
      final XFile picture = await _cameraController!.takePicture();

      if (mounted) {
        // Navega para a tela de resultados, passando o caminho da imagem
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(imagePath: picture.path),
          ),
        );
      }
    } catch (e) {
      debugPrint("Erro ao capturar foto: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isTakingPicture = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    Tflite.close(); // Fecha o modelo ao fechar o app
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fundo preto para as bordas da câmera
      appBar: AppBar(
        title: const Text('Escanear Objeto'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child:
            _cameraController != null && _cameraController!.value.isInitialized
            // AspectRatio garante que a proporção original do sensor não distorça
            ? AspectRatio(
                aspectRatio: 1 / _cameraController!.value.aspectRatio,
                child: CameraPreview(_cameraController!),
              )
            : const CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isTakingPicture ? null : _captureAndNavigate,
        icon: _isTakingPicture
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.camera_alt),
        label: Text(_isTakingPicture ? 'Capturando...' : 'Escanear'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

// ==========================================
// TELA 2: RESULTADO
// ==========================================
class ResultScreen extends StatefulWidget {
  final String imagePath;

  const ResultScreen({super.key, required this.imagePath});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  List<dynamic>? _recognitions;

  @override
  void initState() {
    super.initState();
    _classifyImage(); // Inicia a classificação assim que a tela abre
  }

  Future<void> _classifyImage() async {
    try {
      var recognitions = await Tflite.runModelOnImage(
        path: widget.imagePath,
        imageMean: 127.5,
        imageStd: 127.5,
        numResults: 3,
        threshold: 0.0,
      );

      if (mounted) {
        setState(() {
          _recognitions = recognitions;
        });
      }
    } catch (e) {
      debugPrint("Erro na classificação: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado da Análise'),
        // Botão padrão de voltar no canto esquerdo
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Área da Imagem Congelada
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              color: Colors.black,
              // BoxFit.contain exibe a imagem inteira mantendo a proporção real
              child: Image.file(File(widget.imagePath), fit: BoxFit.contain),
            ),
          ),

          // Área do Ranking
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              color: Colors.white,
              child: _recognitions == null
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text(
                            "Processando imagem...",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        const Text(
                          "Ranking de Classes",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _recognitions!.length,
                            itemBuilder: (context, index) {
                              var result = _recognitions![index];
                              String label = result['label'];
                              double confidence = result['confidence'];

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          label,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "${(confidence * 100).toStringAsFixed(1)}%",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    LinearProgressIndicator(
                                      value: confidence,
                                      minHeight: 12,
                                      backgroundColor: Colors.grey[300],
                                      color: confidence > 0.5
                                          ? Colors.green
                                          : Colors.blue,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
      // Botão para Novo Scan
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.refresh),
        label: const Text('Novo Scan'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
