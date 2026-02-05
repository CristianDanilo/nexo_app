import 'package:get/get.dart';
import '../modules/login/login_view.dart';
import '../modules/login/login_controller.dart';
import '../modules/home/home_view.dart';    
import '../modules/home/home_controller.dart'; 
import '../modules/home/details_view.dart';

class AppPages {
  static const initial = '/login';

  static final routes = [
    GetPage(
      name: '/login',
      page: () => const LoginView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<LoginController>(() => LoginController());
      }),
    ),
    // AGREGA ESTA RUTA:
    GetPage(
      name: '/home',
      page: () => const HomeView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<HomeController>(() => HomeController());
      }),
    ),
    GetPage(
  name: '/details',
  page: () => const DetailsView(),
),
  ];
}