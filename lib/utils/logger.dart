import 'dart:io';
import 'package:logger/logger.dart';

/// 로그 메시지를 파일에 기록하는 커스텀 로그 출력 클래스
class FileOutput extends LogOutput {
  final File file;

  /// 지정된 로그 파일로 [FileOutput] 인스턴스를 생성합니다.
  ///
  /// [file] 로그를 기록할 파일을 지정합니다.
  FileOutput(this.file);

  /// 로그 출력을 지정된 파일에 기록합니다.
  ///
  /// 각 로그 라인은 파일에 새 줄 문자와 함께 추가됩니다.
  /// 이 메서드는 Logger가 로그 메시지를 기록할 때 호출됩니다.
  ///
  /// [event] 출력할 로그 이벤트입니다.
  @override
  void output(OutputEvent event) {
    for (var line in event.lines) {
      file.writeAsStringSync('${line}\n', mode: FileMode.append, flush: true);
    }
  }
}

/// 로그 파일 경로를 설정하는 함수
File getLogFile() {
  final logDirectory = Directory('logs');
  final logFile = File('${logDirectory.path}/app.log');
  return logFile;
}

/// 콘솔과 파일 모두에 로그를 기록하는 [Logger] 인스턴스를 반환합니다.
///
/// 로그 파일은 'logs/app.log'로 지정됩니다. Logger는 [ConsoleOutput]을 사용하여
/// 콘솔에 로그를 출력하고, [FileOutput]을 사용하여 파일에 로그를 기록합니다.
///
/// 반환되는 [Logger] 인스턴스는 콘솔과 파일에 로그를 출력합니다.
Logger getLogger() {
  var logFile = getLogFile();
  return Logger(
    output: MultiOutput([ConsoleOutput(), FileOutput(logFile)]),
  );
}
