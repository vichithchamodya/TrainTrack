import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:traintrack/models/certificate_template.dart';

class CertificateService {
  static Future<Uint8List> buildPdf({
    required CertificateTemplate template,
    required String recipientName,
    required String trainingName,
    required DateTime completedAt,
  }) async {
    final document = pw.Document();
    final logo = template.showLogo ? await _loadAssetImage() : null;
    final accent = _color(template.accentColor, PdfColors.teal);
    final secondary = _color(template.secondaryColor, PdfColors.orange);
    final sealColor = _color(template.sealColor, PdfColors.red);
    final titleSize = template.layout == "minimal" ? 28.0 : 34.0;

    document.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(28),
        build: (context) {
          return pw.Container(
            decoration: _border(template, accent),
            padding: const pw.EdgeInsets.all(24),
            child: pw.Stack(
              children: [
                if (template.showWatermark)
                  pw.Center(
                    child: pw.Opacity(
                      opacity: 0.045,
                      child: pw.Text(
                        "TRAINTRACK",
                        style: pw.TextStyle(
                          fontSize: 68,
                          fontWeight: pw.FontWeight.bold,
                          color: accent,
                        ),
                      ),
                    ),
                  ),
                pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        logo == null
                            ? pw.SizedBox(width: 64)
                            : pw.Image(logo, width: 64, height: 64),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Text(
                              template.credentialLabel,
                              style: pw.TextStyle(
                                color: secondary,
                                fontSize: 10,
                                letterSpacing: 2,
                              ),
                            ),
                            pw.SizedBox(height: 10),
                            pw.Text(
                              template.title,
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                color: accent,
                                fontSize: titleSize,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        template.showSeal
                            ? _seal(template, sealColor)
                            : pw.SizedBox(width: 64),
                      ],
                    ),
                    pw.Column(
                      children: [
                        pw.Text(
                          template.subtitle,
                          style: const pw.TextStyle(fontSize: 15),
                          textAlign: pw.TextAlign.center,
                        ),
                        pw.SizedBox(height: 12),
                        pw.Text(
                          recipientName,
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            color: accent,
                            fontSize: 36,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 12),
                        pw.Text(
                          template.completionText,
                          style: const pw.TextStyle(fontSize: 14),
                          textAlign: pw.TextAlign.center,
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text(
                          trainingName,
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontSize: 22,
                            fontWeight: pw.FontWeight.bold,
                            color: secondary,
                          ),
                        ),
                      ],
                    ),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        _signature(template, completedAt),
                        pw.Text(
                          template.footerText,
                          style: pw.TextStyle(color: accent, fontSize: 9),
                        ),
                        pw.Text(
                          "Issued ${_issueDate(template, completedAt)}",
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    return document.save();
  }

  static pw.BoxDecoration _border(
    CertificateTemplate template,
    PdfColor accent,
  ) {
    if (template.borderStyle == "none") return const pw.BoxDecoration();
    return pw.BoxDecoration(
      border: pw.Border.all(
        color: accent,
        width: template.borderStyle == "double" ? 3 : 1.5,
      ),
    );
  }

  static pw.Widget _seal(CertificateTemplate template, PdfColor color) {
    final label = template.sealStyle == "shield"
        ? "VALID"
        : template.sealStyle == "laurel"
        ? "HONOR"
        : "CERTIFIED";
    return pw.Container(
      width: 64,
      height: 64,
      decoration: pw.BoxDecoration(
        shape: pw.BoxShape.circle,
        border: pw.Border.all(color: color, width: 2),
      ),
      alignment: pw.Alignment.center,
      child: pw.Text(
        label,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          color: color,
          fontSize: 8,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  static pw.Widget _signature(CertificateTemplate template, DateTime date) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Container(width: 130, height: 1, color: PdfColors.grey600),
        pw.SizedBox(height: 5),
        pw.Text(
          template.signatureType == "text"
              ? template.signatureName
              : template.signatureName,
          style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
        ),
        pw.Text(template.issuerName, style: const pw.TextStyle(fontSize: 9)),
      ],
    );
  }

  static String _issueDate(CertificateTemplate template, DateTime date) {
    if (template.issueDate.trim().isNotEmpty) return template.issueDate;
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  static PdfColor _color(String value, PdfColor fallback) {
    final normalized = value.replaceFirst("#", "");
    final parsed = int.tryParse(normalized, radix: 16);
    if (parsed == null) return fallback;
    if (normalized.length == 6) {
      return PdfColor.fromInt(0xFF000000 | parsed);
    }
    if (normalized.length == 8) return PdfColor.fromInt(parsed);
    return fallback;
  }

  static Future<pw.MemoryImage?> _loadAssetImage() async {
    try {
      final data = await rootBundle.load("assets/images/logo.png");
      return pw.MemoryImage(data.buffer.asUint8List());
    } catch (_) {
      return null;
    }
  }
}
