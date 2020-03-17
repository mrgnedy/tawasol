import 'package:auto_route/auto_route_annotations.dart';
import 'package:tawasool/presentation/mainPage.dart';
import 'package:tawasool/presentation/ui/auth/login.dart';
import 'package:tawasool/presentation/ui/new_event.dart';
import 'package:tawasool/presentation/ui/on_board.dart';
@MaterialAutoRouter()
class $Router {
  @initial
  OnBoard onBoard; 
  MainPage mainPage;
  LoginPage loginPage;
  AddEvent addEvent;
}