import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intervu_ai/controllers/auth_controller.dart';
import 'package:intervu_ai/controllers/home_controller.dart';
import 'package:intervu_ai/core/utils/routes.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          title: 'IntervuAi',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: .fromSeed(seedColor: Colors.deepPurple),
          ),
          initialBinding: BindingsBuilder(() {
            Get.put(HomeController(), permanent: true);
            Get.put(AuthController(), permanent: true);
          }),
          initialRoute: '/',
          getPages: AppRoutes.pages,
        );
      },
    );
  }
}
