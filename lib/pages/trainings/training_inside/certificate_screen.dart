import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:traintrack/models/certificate_template.dart';
import 'package:traintrack/models/user_model.dart';
import 'package:traintrack/services/certificate_service.dart';

class CertificateScreen extends StatelessWidget {
  final String trainingName;
  final CertificateTemplate? template;
  final DateTime completedAt;

  const CertificateScreen({
    super.key,
    required this.trainingName,
    required this.template,
    required this.completedAt,
  });

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserModel?>();
    final certificate = template ?? const CertificateTemplate();
    final recipient = user?.username.trim().isNotEmpty == true
        ? user!.username
        : user?.email ?? "Learner";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Certificate"),
        actions: [
          IconButton(
            tooltip: "Download or share PDF",
            icon: const Icon(Icons.download),
            onPressed: () async {
              await _sharePdf(context, certificate, recipient);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _CertificatePreview(
              template: certificate,
              recipientName: recipient,
              trainingName: trainingName,
              completedAt: completedAt,
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _sharePdf(context, certificate, recipient),
                icon: const Icon(Icons.download),
                label: const Text("DOWNLOAD PDF"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sharePdf(
    BuildContext context,
    CertificateTemplate certificate,
    String recipient,
  ) async {
    try {
      final bytes = await _buildPdf(certificate, recipient);
      final file = XFile.fromData(
        bytes,
        name: _fileName(trainingName),
        mimeType: "application/pdf",
      );
      await SharePlus.instance.share(
        ShareParams(files: [file], text: "Certificate for $trainingName"),
      );
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Unable to create PDF: $error")));
      }
    }
  }

  Future<Uint8List> _buildPdf(
    CertificateTemplate certificate,
    String recipient,
  ) {
    return CertificateService.buildPdf(
      template: certificate,
      recipientName: recipient,
      trainingName: trainingName,
      completedAt: completedAt,
    );
  }

  String _fileName(String value) {
    final safeName = value.trim().replaceAll(RegExp(r"[^a-zA-Z0-9]+"), "_");
    return "${safeName.isEmpty ? "certificate" : safeName}_certificate.pdf";
  }
}

class _CertificatePreview extends StatelessWidget {
  final CertificateTemplate template;
  final String recipientName;
  final String trainingName;
  final DateTime completedAt;

  const _CertificatePreview({
    required this.template,
    required this.recipientName,
    required this.trainingName,
    required this.completedAt,
  });

  @override
  Widget build(BuildContext context) {
    final accent = _color(template.accentColor, Colors.teal);
    final secondary = _color(template.secondaryColor, Colors.orange);
    final sealColor = _color(template.sealColor, Colors.red);

    return AspectRatio(
      aspectRatio: 1.414,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          border: template.borderStyle == "none"
              ? null
              : Border.all(
                  color: accent,
                  width: template.borderStyle == "double" ? 4 : 2,
                ),
          boxShadow: const [
            BoxShadow(color: Color(0x22000000), blurRadius: 12),
          ],
        ),
        child: Stack(
          children: [
            if (template.showWatermark)
              Center(
                child: Opacity(
                  opacity: 0.05,
                  child: FittedBox(
                    child: Text(
                      "TRAINTRACK",
                      style: TextStyle(
                        color: accent,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    template.showLogo
                        ? Image.asset(
                            "assets/images/logo.png",
                            width: 42,
                            height: 42,
                            errorBuilder: (_, _, _) =>
                                const SizedBox(width: 42),
                          )
                        : const SizedBox(width: 42),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            template.credentialLabel,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: secondary,
                              fontSize: 9,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          FittedBox(
                            child: Text(
                              template.title,
                              style: TextStyle(
                                color: accent,
                                fontSize: template.layout == "minimal"
                                    ? 22
                                    : 27,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    template.showSeal
                        ? _seal(sealColor)
                        : const SizedBox(width: 42),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      template.subtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 10),
                    ),
                    const SizedBox(height: 5),
                    FittedBox(
                      child: Text(
                        recipientName,
                        style: TextStyle(
                          color: accent,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      template.completionText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 9),
                    ),
                    const SizedBox(height: 4),
                    FittedBox(
                      child: Text(
                        trainingName,
                        style: TextStyle(
                          color: secondary,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        Container(width: 88, height: 1, color: Colors.grey),
                        const SizedBox(height: 3),
                        Text(
                          template.signatureName,
                          style: const TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          template.issuerName,
                          style: const TextStyle(fontSize: 7),
                        ),
                      ],
                    ),
                    Flexible(
                      child: Text(
                        template.footerText,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: accent, fontSize: 7),
                      ),
                    ),
                    Text(
                      "Issued ${_issueDate()}",
                      style: const TextStyle(fontSize: 7),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _seal(Color color) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        template.sealStyle == "shield" ? "VALID" : "CERTIFIED",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color,
          fontSize: 6,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _issueDate() {
    if (template.issueDate.trim().isNotEmpty) return template.issueDate;
    return "${completedAt.day.toString().padLeft(2, '0')}/${completedAt.month.toString().padLeft(2, '0')}/${completedAt.year}";
  }

  Color _color(String value, Color fallback) {
    final normalized = value.replaceFirst("#", "");
    final parsed = int.tryParse(normalized, radix: 16);
    if (parsed == null) return fallback;
    if (normalized.length == 6) return Color(0xFF000000 | parsed);
    if (normalized.length == 8) return Color(parsed);
    return fallback;
  }
}
