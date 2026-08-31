import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:studentconnect/bloc/HomePageTaskTabsBloc/bloc.dart';
import 'package:studentconnect/bloc/TaskBloc/task_bloc.dart';
import 'package:studentconnect/bloc/addMemberToProject/addMemberBloc.dart';
import 'package:studentconnect/bloc/addprojectBloc/project_bloc.dart';
import 'package:studentconnect/bloc/bottomNavBarBloc/bloc.dart';
import 'package:studentconnect/bloc/memberBloc/member_bloc.dart';
import 'package:studentconnect/bloc/removeMemberFromProjectBloc/removeMember_bloc.dart';
import 'package:studentconnect/bloc/userBloc/bloc.dart';
import 'package:studentconnect/routes/routes.dart';
import 'package:studentconnect/screens/Signup-in/user.dart';
import 'package:studentconnect/screens/addWorkspace/add_workspace.dart';
import 'package:studentconnect/screens/comments/comments_screen.dart';
import 'package:studentconnect/screens/documentation/documentation_screen.dart';
import 'package:studentconnect/screens/home_screen.dart';
import 'package:studentconnect/screens/main_screen.dart';
import 'package:studentconnect/screens/notification/notification.dart';
import 'package:studentconnect/screens/workspace/add_member_screen.dart';
import 'package:studentconnect/screens/workspace/add_task.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart'
    as GetTrasition;
import 'package:studentconnect/screens/workspace/all_workspace.dart';
import 'package:studentconnect/screens/workspace_detail_screen.dart';

class Pages {
  static List<GetPage<dynamic>> pages = [
    GetPage(
      name: AppRoutes.main,
      page: () => MultiBlocProvider(
        providers: [
          BlocProvider<NavBarBloc>(
            create: (context) => NavBarBloc(),
          ),
          BlocProvider<homePageTabBarBloc>(
            create: (context) => homePageTabBarBloc(),
          ),
          BlocProvider<LoginSignUpBloc>(
            create: (context) => LoginSignUpBloc(),
          ),
          BlocProvider<ProjectBloc>(
            create: (context) => ProjectBloc(),
          ),
          BlocProvider<MemberBloc>(
            create: (context) => MemberBloc(),
          ),
        ],
        child: MainScreen(),
      ),
      transition: GetTrasition.Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.user,
      page: () => BlocProvider(
        create: (context) => LoginSignUpBloc(),
        child: User(),
      ),
      transition: GetTrasition.Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => HomeScreen(),
      transition: GetTrasition.Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.addMember,
      page: () => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AddMemberToProjectBloc(),
          ),
          BlocProvider(
            create: (context) => RemoveMemberFromProjectBloc(),
          ),
        ],
        child: AddMemberScreen(),
      ),
      transition: GetTrasition.Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.addTask,
      page: () => MultiBlocProvider(
        providers: [
          BlocProvider<MemberBloc>(
            create: (context) => MemberBloc(),
          ),
          BlocProvider<TaskBloc>(
            create: (context) => TaskBloc(),
          ),
        ],
        child: AddTask(),
      ),
      transition: GetTrasition.Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.addWorkspce,
      page: () => AddWorkspace(),
      transition: GetTrasition.Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.notification,
      page: () => Notifications(),
      transition: GetTrasition.Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.workSpaceDetail,
      page: () => WorkspaceDetail(),
      transition: GetTrasition.Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.allWorkspace,
      page: () => AllWorkspace(),
      transition: GetTrasition.Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.comment,
      page: () => Comments(),
      transition: GetTrasition.Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.documentation,
      page: () => DocumentationScreen(),
      transition: GetTrasition.Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 500),
    ),
  ];
}
