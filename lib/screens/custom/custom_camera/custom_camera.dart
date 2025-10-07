import 'dart:io';
import 'package:edwardb/config/constant/colors.dart';
import 'package:edwardb/config/extensions/media_query_extension.dart';
import 'package:edwardb/screens/custom/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;



class CameraScreen extends StatefulWidget {
  final bool useFrontCamera; // true = front, false = back

  const CameraScreen({super.key, required this.useFrontCamera});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late List<CameraDescription> cameras;
  CameraController? controller;
  bool isCameraReady = false;
  XFile? capturedFile;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    cameras = await availableCameras();
    CameraDescription selectedCamera = cameras.firstWhere(
      (camera) => widget.useFrontCamera
          ? camera.lensDirection == CameraLensDirection.front
          : camera.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    controller = CameraController(
      selectedCamera,
      ResolutionPreset.max, // maximize quality
    );

    await controller!.initialize();
    if (!mounted) return;
    setState(() {
      isCameraReady = true;
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
Future<void> takePicture() async {
  if (!controller!.value.isInitialized) return;
  try {
    final file = await controller!.takePicture();

    // Load image using 'image' package
    final bytes = await File(file.path).readAsBytes();
    img.Image? original = img.decodeImage(bytes);

    if (original != null) {
      int cropWidth, cropHeight, cropX, cropY;

      if (widget.useFrontCamera) {
        // Circle crop -> we'll crop a square around the circle
        cropWidth = (original.width * 0.6).toInt(); // match your overlay radius
        cropHeight = cropWidth;
        cropX = (original.width - cropWidth) ~/ 2;
        cropY = (original.height - cropHeight) ~/ 2;
      } else {
        // Rectangle crop -> match your overlay rectangle
        cropWidth = (original.width * 0.9).toInt();
        cropHeight = (original.height * 0.4).toInt();
        cropX = (original.width - cropWidth) ~/ 2;
        cropY = (original.height - cropHeight) ~/ 2;
      }

      img.Image cropped = img.copyCrop(original, x:  cropX, y:  cropY, width:  cropWidth, height:  cropHeight);

      // Save the cropped image
      final croppedFile = File(file.path)..writeAsBytesSync(img.encodeJpg(cropped));

      setState(() {
        capturedFile = XFile(croppedFile.path);
      });
    }

  } catch (e) {
    print(e);
  }
}

  @override
  Widget build(BuildContext context) {
    if (!isCameraReady) return Center(child: CircularProgressIndicator());

    // Show preview if a picture is captured
    if (capturedFile != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          height: context.screenHeight ,
          width: context.screenWidth,


          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                if(!widget.useFrontCamera)
               Padding(
                 padding: const EdgeInsets.all(12.0),
                 child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                   child: SizedBox(
                    height: context.screenHeight * 0.4 - 30,
                    width: context.screenWidth,
                     child: Image.file(
                        File(capturedFile!.path),
                        fit: BoxFit.fill,
                      
                                   ),
                   ),
                 ),
               ) else 
               Padding(
                 padding: const EdgeInsets.all(12.0),
                 child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                   child: Container(
                    height: context.screenHeight * 0.6,
                    width: context.screenWidth,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle
                    ),
                     child: Image.file(
                        File(capturedFile!.path),
                        fit: BoxFit.fill,
                      
                                   ),
                   ),
                 ),
               ),
                30.verticalSpace,

                EdwardbText( widget.useFrontCamera ?  "Confirm Driver Photo" : "Confirm License Photo", fontWeight: FontWeight.bold,
                fontSize: 30,
                ),

                30.verticalSpace,

              Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
            
                        setState(() {
                          capturedFile = null;
                        });
                      
                    },
                    child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: kPrimaryColor, 
                              shape: BoxShape.circle
                          ),
                        child: Icon(Icons.refresh, color: Colors.white,),
                      ),
                  ),

                    GestureDetector(
                    onTap: (){
            
                        Get.back(result: capturedFile!.path); 
                      
                    },
                    child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.green, 
                              shape: BoxShape.circle
                          ),
                        child: Icon(Icons.check, color: Colors.white,),
                      ),
                  ),
                  
                 
                ],
              ),
            ],
          ),
        ),
      );
    }

    // Camera preview with overlay
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              height: widget.useFrontCamera ? context.screenHeight * 0.7 : context.screenHeight,
              width: context.screenWidth,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CameraPreview(controller!),
                  ),
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: OverlayPainter(isFront: widget.useFrontCamera),
                      ),
                    ),
                  ),
                  
                ],
              ),
            ),
          ),
         Container(
          color: Colors.black,
          height: context.screenHeight * 0.2,
          child: Center(
            child: GestureDetector(
              onTap: (){
                takePicture();
              },
              child: Image.asset("assets/images/camera_icon.png", 
              height: 80,
              width: 80,
              ),
            )))
          
        ],
      ),
    );
  }
}

class OverlayPainter extends CustomPainter {
  final bool isFront;

  OverlayPainter({required this.isFront});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    Path background = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    Path cutout;
    if (isFront) {
      double radius = size.width * 0.5;
      cutout = Path()
        ..addOval(Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: radius,
        ));
    } else {
      double rectWidth = size.width * 0.9;
      double rectHeight = size.height * 0.4;
      cutout = Path()
        ..addRect(Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2),
          width: rectWidth,
          height: rectHeight,
        ));
    }

    Path finalPath = Path.combine(PathOperation.difference, background, cutout);
    canvas.drawPath(finalPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
