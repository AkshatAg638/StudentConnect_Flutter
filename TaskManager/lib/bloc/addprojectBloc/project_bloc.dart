import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studentconnect/bloc/addprojectBloc/project_events.dart';
import 'package:studentconnect/bloc/addprojectBloc/project_states.dart';
import 'package:studentconnect/data/Authentications/google_signin.dart';
import 'package:studentconnect/data/databse/database_functions.dart';
import 'package:studentconnect/data/email/email_sending.dart';
import 'package:studentconnect/injection/database.dart';

class ProjectBloc extends Bloc<ProjectEvents, ProjectStates> {
  var addProject = locator<Database>;

  ProjectBloc() : super(InitialState()) {
    on<AddProject>((event, emit) async {
      String name = event.projectName.trim();
      String desc = event.projectDescription.trim();

      if (name.isEmpty || desc.isEmpty) {
        emit(ErrorState("Please enter Project Name and Description"));
        return;
      }

      String userEmail = Auth.currentUser?.email ?? 'student@connect.edu';
      List<String> allMembers = List<String>.from(event.memberEmail);
      if (!allMembers.contains(userEmail)) {
        allMembers.add(userEmail);
      }

      if (event.memberEmail.isNotEmpty) {
        try {
          SendEmail.sendEmail(
            email: event.memberEmail,
            subject: name,
            projectName: name,
          );
        } catch (_) {}
      }

      bool added = await addProject().addWorkspace(
          email: allMembers,
          projectDescription: desc,
          projectName: name,
          creationDate: event.creationDate);

      if (added) {
        emit(ProjectAdded("Project has been created Successfully"));
      } else {
        emit(ErrorState("Project is not created: Try Again"));
      }
    });
  }
}
