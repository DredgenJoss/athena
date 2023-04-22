import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrWidget extends StatefulWidget {
  final String payId;
  const QrWidget({super.key, required this.payId});

  @override
  QrWidgetState createState() => QrWidgetState();
}

class QrWidgetState extends State<QrWidget> {
  @override
  Widget build(BuildContext context) {
    return QrImage(
      data: widget.payId,
      size: 280,
      embeddedImageStyle: QrEmbeddedImageStyle(
        size: const Size(
          100,
          100,
        ),
      ),
    );
  }
}
