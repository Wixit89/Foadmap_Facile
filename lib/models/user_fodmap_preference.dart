class UserFodmapPreference {
  final String fodmapType;
  final String? manualStatus; // 'tolerated', 'caution', 'sensitive', null = auto
  final DateTime? lastModified;

  UserFodmapPreference({
    required this.fodmapType,
    this.manualStatus,
    this.lastModified,
  });

  Map<String, dynamic> toMap() {
    return {
      'fodmapType': fodmapType,
      'manualStatus': manualStatus,
      'lastModified': lastModified?.toIso8601String(),
    };
  }

  factory UserFodmapPreference.fromMap(Map<String, dynamic> map) {
    return UserFodmapPreference(
      fodmapType: map['fodmapType'] as String,
      manualStatus: map['manualStatus'] as String?,
      lastModified: map['lastModified'] != null 
          ? DateTime.parse(map['lastModified'] as String)
          : null,
    );
  }

  bool get isManual => manualStatus != null;
  bool get isAutomatic => manualStatus == null;
}




