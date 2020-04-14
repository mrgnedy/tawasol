import 'package:auto_route/auto_route_annotations.dart';
import 'package:tawasool/presentation/mainPage.dart';
import 'package:tawasool/presentation/map.dart';
import 'package:tawasool/presentation/ui/auth/login.dart';
import 'package:tawasool/presentation/ui/auth/notification.dart';
import 'package:tawasool/presentation/ui/auth/verify.dart';
import 'package:tawasool/presentation/ui/drawerPages/about_page.dart';
import 'package:tawasool/presentation/ui/drawerPages/contact_us.dart';
import 'package:tawasool/presentation/ui/drawerPages/my_occasions.dart';
import 'package:tawasool/presentation/ui/drawerPages/profile_page.dart';
import 'package:tawasool/presentation/ui/new_event.dart';
import 'package:tawasool/presentation/ui/occasion_details.dart';
import 'package:tawasool/presentation/ui/on_board.dart';

@MaterialAutoRouter()
class $Router {
  @initial
  OnBoard onBoard;
  @CupertinoRoute(maintainState: true)
  MainPage mainPage;
  @CupertinoRoute(maintainState: true)
  LoginPage loginPage;
  @CupertinoRoute(maintainState: true)
  AddEvent addEvent;
  @CupertinoRoute(maintainState: true)
  Map map;
  @CupertinoRoute(maintainState: true)
  ProfilePage profilePage;
  @CupertinoRoute(maintainState: true)
  ContactUsPage contactUsPage;
  @CupertinoRoute(maintainState: true)
  OccasionDetails occasionDetails;
  @CupertinoRoute(maintainState: true)
  MyOccasions myOccasions;
  @CupertinoRoute(maintainState: true)
  NotificationPage notificationPage;
  @CupertinoRoute(maintainState: true)
  AboutPage aboutPage;
  VerifyUserScreen verifyUserScreen;
}
