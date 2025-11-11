class Attachment {
  final int attachmentId;
  final String kind; // 'image' | 'pdf'
  final String fileUrl; // absolute URL (signed)
  final DateTime? uploadedAt;

  Attachment({
    required this.attachmentId,
    required this.kind,
    required this.fileUrl,
    this.uploadedAt,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      attachmentId: (json['attachment_id'] as num).toInt(),
      kind: json['kind'] as String,
      fileUrl: json['file_url'] as String,
      uploadedAt: json['uploaded_at'] != null
          ? DateTime.tryParse(json['uploaded_at'] as String)
          : null,
    );
  }
}

