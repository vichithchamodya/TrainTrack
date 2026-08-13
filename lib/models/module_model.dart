class ModuleModel {
  final String moduleName;
  final String moduleVideo;
  final String moduleNote;

  ModuleModel({
    required this.moduleName,
    required this.moduleVideo,
    required this.moduleNote,
  });

  factory ModuleModel.fromJson(Map<String, dynamic> data) {
    return ModuleModel(
      moduleName: data["moduleName"] ?? "",
      moduleVideo: data["moduleVideo"] ?? "",
      moduleNote: data["moduleNote"] ?? "",
    );
  }
}
