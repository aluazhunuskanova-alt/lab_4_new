import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrPage extends StatefulWidget {
  const QrPage({super.key});

  @override
  State<QrPage> createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  String _lastCode = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: MobileScanner(
            onDetect: (capture) {
              final barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                final code = barcodes.first.rawValue ?? '';
                if (code.isNotEmpty && code != _lastCode) {
                  setState(() {
                    _lastCode = code;
                  });
                }
              }
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: Text(
              _lastCode.isEmpty ? 'Scan a QR code' : 'Last code: $_lastCode',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
