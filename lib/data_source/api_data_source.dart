import 'dart:developer';
import 'dart:io';

abstract class ApiDataSource {
  void connect(void Function(String? data, bool isLoading) callback);
}

class ApiDataSourceImpl implements ApiDataSource {
  @override
  void connect(void Function(String? data, bool isLoading) callback) async {
    try {
      callback(null, true);
      final socket = await Socket.connect('10.10.30.65', 8080,timeout: Duration(seconds: 5));

      socket.listen((a) {
        final data = String.fromCharCodes(a);

        callback(data, false);
      }, onDone: () {
        callback(null,false);
        socket.destroy();
        log('OnDone Socket,', name: 'Call OnDoneSocket');
      }, onError: (e) {
        callback(null, false);
        socket.destroy();
        log(e.toString(), name: 'Error Socket');
      });
    } catch (e) {
      callback(null, false);

      log(e.toString(), name: 'Error connect to Socket');
    }
  }
}
