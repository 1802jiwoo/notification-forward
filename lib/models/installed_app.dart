import 'dart:typed_data';

class InstalledApp {
  final String packageName;
  final String appName;
  final Uint8List icon;

  InstalledApp({
    required this.packageName,
    required this.appName,
    required this.icon,
  });

  // android 에서 값을 받아와야해서 변환용
  factory InstalledApp.fromMap(Map<Object?, Object?> map) => InstalledApp(
    packageName: map['packageName'].toString(),
    appName: map['appName'].toString(),
    icon: map['icon'] as Uint8List,
  );

  // 대상 앱 갱신시 같은 객체로 인식을 못하기 때문에 packageName 으로 확인
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InstalledApp && other.packageName == packageName);

  @override
  int get hashCode => packageName.hashCode;
}
