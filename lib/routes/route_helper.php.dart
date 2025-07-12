import 'package:crud_practice_with_laravel/views/home_view.dart';
import 'package:crud_practice_with_laravel/views/login_view.dart';
import 'package:crud_practice_with_laravel/views/register_view.dart';
import 'package:crud_practice_with_laravel/views/root_page.dart';
import 'package:crud_practice_with_laravel/views/task_details_view.dart';
import 'package:get/get.dart';

class RouteHelper {
  static const String initial = "/";
  static const String login = '/login';
  static const String registration = '/registration';
  static const String home = '/home';
  static const String homeDetails = '/homeDetails';

  
  static List<GetPage> routes= [
    GetPage(name: initial, page: () => RootPage()),
    GetPage(name: registration, page: () => RegisterView()),
    GetPage(name: login, page: () => LoginView()),
    GetPage(name: home, page: ()=>HomeView()),
    GetPage(
      name: RouteHelper.homeDetails,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        return TaskEditDetailsView(
          task: args['task'],
          index: args['index'],
        );
      },
    ),
  ];
}