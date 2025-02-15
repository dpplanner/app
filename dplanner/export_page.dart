import 'dart:io';

const String basePath = 'lib_new/app/ui/pages';
const String outputFilePath = '$basePath/pages.dart';

void main() {
  generatePagesDart(); // 최초 실행

  print('🔍 파일 변경 감지 중...');

  Directory(basePath).watch(recursive: true).listen((event) {
    if (event.path.endsWith('bindings.dart') || event.path.endsWith('page.dart')) {
      print('🔄 파일 변경 감지: ${event.path}');
      generatePagesDart();
    }
  });
}

void generatePagesDart() {
  var dir = Directory(basePath);
  if (!dir.existsSync()) {
    print('❌ Error: $basePath 디렉토리가 존재하지 않습니다.');
    return;
  }

  var files = dir
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) =>
  file.path.endsWith('bindings.dart') || file.path.endsWith('page.dart'));

  var buffer = StringBuffer();
  for (var file in files) {
    var relativePath = file.path.replaceFirst('$basePath/', '');
    buffer.writeln("export '$relativePath';");
  }

  File(outputFilePath).writeAsStringSync(buffer.toString());
  print('✅ pages.dart 업데이트 완료! (${files.length}개 파일 export)');
}