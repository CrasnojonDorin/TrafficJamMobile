import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traffic_jam_mobile/controller/map_controller.dart';
import 'package:traffic_jam_mobile/presentation/recources/bar.dart';

class LoginDialog extends StatefulWidget {
  const LoginDialog({super.key});

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  final DraggableScrollableController _controller =
      DraggableScrollableController();

  final TrafficController _trafficController = Get.find();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        controller: _controller,
        maxChildSize: 0.33,
        minChildSize: 0.1,
        initialChildSize: 0.33,
        builder: (ctx, ctr) => Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    BarWidget(),
                    SizedBox(
                      height: 20,
                    ),
                    Obx(() =>(_trafficController.isLoading.value)
                        ? CircularProgressIndicator()
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: (!_trafficController.isError.value)
                                      ? Colors.green
                                      : Colors.red),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text((!_trafficController.isError.value)
                                ? 'Online'
                                : 'Offline'),
                            if (_trafficController.isError.value)
                              SizedBox(
                                width: 4,
                              ),
                            if (_trafficController.isError.value)
                              InkWell(
                                onTap: () {
                                  _trafficController.connect();
                                },
                                child: Positioned(
                                  left: 20,
                                  top: 20,
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.blue),
                                    child: Text(
                                      'reconnect',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        )),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Name'),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'phone'),
                    ),
                    SizedBox(height: 16)
                  ],
                ),
              ),
            ));
  }
}
