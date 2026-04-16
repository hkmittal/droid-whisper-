enum LocalWhisperModel {
  tiny('tiny', 'Tiny', 'Fastest, lowest accuracy', 75 * 1024 * 1024), // ~75MB
  base('base', 'Base', 'Fast, decent accuracy', 142 * 1024 * 1024), // ~142MB
  small('small', 'Small', 'Good balance', 466 * 1024 * 1024), // ~466MB
  medium('medium', 'Medium', 'High accuracy, requires 3GB RAM', 1.5 * 1024 * 1024 * 1024), // ~1.5GB
  largeV1('large-v1', 'Large V1', 'Very high accuracy, requires 8GB RAM', 2.9 * 1024 * 1024 * 1024); // ~2.9GB

  const LocalWhisperModel(this.id, this.displayName, this.description, this.estimatedSizeBytes);

  final String id;
  final String displayName;
  final String description;
  final double estimatedSizeBytes;

  String get estimatedSizeString {
    if (estimatedSizeBytes >= 1024 * 1024 * 1024) {
      return '${(estimatedSizeBytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
    return '${(estimatedSizeBytes / (1024 * 1024)).toStringAsFixed(0)} MB';
  }

  static LocalWhisperModel fromId(String? id) {
    return LocalWhisperModel.values.firstWhere(
      (m) => m.id == id,
      orElse: () => LocalWhisperModel.base,
    );
  }
}
