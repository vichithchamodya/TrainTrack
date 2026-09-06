class CertificateTemplate {
  final String layout;
  final String borderStyle;
  final String motif;
  final String title;
  final String subtitle;
  final String completionText;
  final String issuerName;
  final String signatureName;
  final String signatureType;
  final String issueDate;
  final String accentColor;
  final String secondaryColor;
  final String credentialLabel;
  final String footerText;
  final bool showSeal;
  final String sealStyle;
  final String sealColor;
  final bool showLogo;
  final bool showWatermark;
  final String signatureUrl;

  const CertificateTemplate({
    this.layout = "classic",
    this.borderStyle = "double",
    this.motif = "ribbon",
    this.title = "Certificate of Completion",
    this.subtitle = "This certificate is proudly presented to",
    this.completionText = "for successfully completing this training program",
    this.issuerName = "TrainTrack Academy",
    this.signatureName = "Training Director",
    this.signatureType = "digital",
    this.issueDate = "",
    this.accentColor = "#1cadb3",
    this.secondaryColor = "#fd8a13",
    this.credentialLabel = "Professional credential",
    this.footerText = "TrainTrack Learning & Development",
    this.showSeal = true,
    this.sealStyle = "classic",
    this.sealColor = "#c62828",
    this.showLogo = true,
    this.showWatermark = true,
    this.signatureUrl = "",
  });

  factory CertificateTemplate.fromMap(Map<String, dynamic> data) {
    String stringValue(String key, String fallback) {
      final value = data[key];
      return value is String && value.isNotEmpty ? value : fallback;
    }

    return CertificateTemplate(
      layout: stringValue("layout", "classic"),
      borderStyle: stringValue("borderStyle", "double"),
      motif: stringValue("motif", "ribbon"),
      title: stringValue("title", "Certificate of Completion"),
      subtitle: stringValue(
        "subtitle",
        "This certificate is proudly presented to",
      ),
      completionText: stringValue(
        "completionText",
        "for successfully completing this training program",
      ),
      issuerName: stringValue("issuerName", "TrainTrack Academy"),
      signatureName: stringValue("signatureName", "Training Director"),
      signatureType: stringValue("signatureType", "digital"),
      issueDate: stringValue("issueDate", ""),
      accentColor: stringValue("accentColor", "#1cadb3"),
      secondaryColor: stringValue("secondaryColor", "#fd8a13"),
      credentialLabel: stringValue(
        "credentialLabel",
        "Professional credential",
      ),
      footerText: stringValue(
        "footerText",
        "TrainTrack Learning & Development",
      ),
      showSeal: data["showSeal"] != false,
      sealStyle: stringValue("sealStyle", "classic"),
      sealColor: stringValue("sealColor", "#c62828"),
      showLogo: data["showLogo"] != false,
      showWatermark: data["showWatermark"] != false,
      signatureUrl: stringValue("signatureUrl", ""),
    );
  }
}
