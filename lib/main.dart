import 'package:camera/camera.dart';
import 'all_file.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'all_file.dart';
Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await appController.getLoginData();
  appController.cameras = await availableCameras();
  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GetMaterialApp(
      color: ThemeConfig.background2,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: ThemeConfig.fontFamily,
        backgroundColor:ThemeConfig.background2,
        textTheme: GoogleFonts.tinosTextTheme(textTheme).copyWith(
          headline1: GoogleFonts.tinos(
              textStyle: TextStyle(
                  color: ThemeConfig.textColor,
                  fontSize: ThemeConfig.headerSize,
                  fontWeight: FontWeight.bold,
                  height: 1.5
              )
          ),
          bodyText1: GoogleFonts.tinos(
              textStyle: TextStyle(
                  fontSize: ThemeConfig.defaultSize,
                  color: ThemeConfig.textColor,
                  height: 1.5
              )
          ),
          bodyText2: GoogleFonts.tinos(
              textStyle: TextStyle(
                  fontSize: ThemeConfig.defaultSize,
                  color: ThemeConfig.textColor,
                  height: 1.5
              )
          ),
        ),
      ),
      title: AppConfig.APP_NAME,
      initialRoute: '/',
      initialBinding: InitialScreenBindings(),
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/home', page: () => const HomeScreen()),
      ],
    );
  }
}