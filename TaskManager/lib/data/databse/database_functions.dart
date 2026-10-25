import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:studentconnect/controllers/project_controller.dart';
import 'package:studentconnect/data/Authentications/google_signin.dart';
import 'package:studentconnect/notification/notification_services.dart';

class Database {
  final projectController = Get.put(ProjectController());
  NotificationServices noti = NotificationServices();
  Database();
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  int _projectId = 0;
  int generateProjectNo() {
    _projectId = Random().nextInt(560000);
    return _projectId;
  }

  Future<bool> addWorkspace(
      {required String projectName,
      required String projectDescription,
      required List<String> email,
      required String creationDate}) async {
    int projectId = generateProjectNo();
    String creatorEmail = Auth.currentUser?.email ?? '';

    await firestore.collection('Project').doc(projectId.toString()).set(
      {
        "projectId": projectId,
        "projectName": projectName,
        "projectDescription": projectDescription,
        "email": email,
        "projectCreatedBy": creatorEmail,
        "createdOn": creationDate
      },
      SetOptions(merge: true),
    );

    return true;
  }

  Stream<QuerySnapshot> getCreatedProjects() {
    String email = Auth.currentUser?.email ?? '';
    return firestore
        .collection('Project')
        .where('projectCreatedBy', isEqualTo: email)
        .snapshots();
  }

  Future<bool> addTaskToProject({
    required String task,
    required String description,
    required String date,
    required String time,
    required List<String> members,
  }) async {
    await firestore
        .collection('Tasks')
        .doc(projectController.projectId.string)
        .set({
      'projectId': projectController.projectId.string,
    });

    await firestore
        .collection('Tasks')
        .doc(projectController.projectId.string)
        .collection('projectTasks')
        .doc()
        .set(
      {
        'taskName': task,
        'description': description,
        'deadlineDate': date,
        'deadlineTime': time,
        'Members': members,
        'projectName': projectController.projectName.string,
        'status': 'none',
      },
      SetOptions(merge: true),
    );

    return true;
  }

  Stream<QuerySnapshot> getAllProjects() {
    String email = Auth.currentUser?.email ?? '';
    return firestore
        .collection('Project')
        .where(Filter.or(
            Filter("email", arrayContains: email),
            Filter('projectCreatedBy', isEqualTo: email)))
        .snapshots();
  }

  Stream<QuerySnapshot> getTasksAsPerStatus({required String taskStatus}) {
    String currentUserEmail = Auth.currentUser?.email ?? '';
    return firestore
        .collectionGroup('projectTasks')
        .where(
          'Members',
          arrayContains: currentUserEmail,
        )
        .where('status', isEqualTo: taskStatus)
        .snapshots();
  }

  Future<bool> updateTaskStatus(
      {required String taskName, required String changeStatusTo}) async {
    String email = Auth.currentUser?.email ?? '';
    QuerySnapshot snap = await firestore
        .collectionGroup('projectTasks')
        .where('taskName', isEqualTo: taskName)
        .where('Members', arrayContains: email)
        .get();

    if (snap.docs.isNotEmpty) {
      await snap.docs[0].reference.update({'status': changeStatusTo});
      return true;
    }
    return false;
  }

  Future<double?> getProgress({required String id}) async {
    AggregateQuerySnapshot allDocs = await firestore
        .collection('Tasks')
        .doc(id.toString())
        .collection('projectTasks')
        .count()
        .get();
    AggregateQuerySnapshot completed = await firestore
        .collection('Tasks')
        .doc(id)
        .collection('projectTasks')
        .where('status', isEqualTo: 'Completed')
        .count()
        .get();
    
    int total = allDocs.count ?? 0;
    int done = completed.count ?? 0;
    if (total == 0) {
      return 0.0;
    }
    return done / total;
  }

  Future<bool> removeMemberToProject({required String email}) async {
    await firestore
        .collection('Project')
        .doc(projectController.projectId.string)
        .update({
      'email': FieldValue.arrayRemove([email])
    });

    return true;
  }

  Future<bool> addMemberToProject({required String email}) async {
    await firestore
        .collection('Project')
        .doc(projectController.projectId.string)
        .update({
      'email': FieldValue.arrayUnion([email])
    });

    return true;
  }

  Stream<DocumentSnapshot> getMembersOfProject() {
    return firestore
        .collection('Project')
        .doc(projectController.projectId.string)
        .snapshots();
  }

  Stream<QuerySnapshot> getUserDetail() {
    return firestore
        .collection('User')
        .where('email', isEqualTo: projectController.projectCreatedBy.value)
        .snapshots();
  }

  Future<void> sendDeadlineReminder() async {
    if (Auth.currentUser == null) return;
    DateTime today = DateTime.now();

    QuerySnapshot snap = await firestore
        .collectionGroup('projectTasks')
        .where('Members', arrayContains: Auth.currentUser!.email)
        .where('status', isNotEqualTo: 'Completed')
        .where('deadlineDate',
            isEqualTo: "${today.day}/${today.month}/${today.year}")
        .get();
    if (snap.docs.isNotEmpty) {
      for (int i = 0; i < snap.docs.length; i++) {
        DocumentSnapshot doc = snap.docs[i];
        String projectName = doc['projectName'] ?? 'Project';
        String taskName = doc['taskName'] ?? 'Task';
        await noti.sendFCM(projectName: projectName);
        await saveNotifications(
          title: 'Deadline Today: $projectName',
          body: 'Task "$taskName" is due today!',
        );
      }
    }
  }

  Future<void> saveNotifications({
    required String title,
    required String body,
  }) async {
    if (Auth.currentUser == null) return;
    DateTime today = DateTime.now();
    await firestore.collection('Notifications').doc().set({
      'title': title,
      'body': body,
      'receiveDate': "${today.day}/${today.month}/${today.year}",
      'receiveTo': Auth.currentUser!.uid
    });
  }

  Future<bool> addComments(
      {required String id, required String comment}) async {
    if (Auth.currentUser == null || comment.trim().isEmpty) return false;
    await FirebaseFirestore.instance.collection('Comments').doc(id).set({
      'taskId': id,
    });
    await FirebaseFirestore.instance
        .collection('Comments')
        .doc(id)
        .collection('taskComments')
        .doc()
        .set({
      'comment': comment.trim(),
      'author': Auth.currentUser!.displayName ?? 'Student',
      'time': DateTime.now(),
    });

    return true;
  }

  Stream<QuerySnapshot> getComments({required String id}) {
    return FirebaseFirestore.instance
        .collection('Comments')
        .doc(id)
        .collection('taskComments')
        .orderBy('time', descending: true)
        .snapshots();
  }

  // Project Documentation methods

  Future<bool> addDocumentation({
    required String projectId,
    required String title,
    required String content,
  }) async {
    await firestore
        .collection('Documentation')
        .doc(projectId)
        .set({'projectId': projectId});

    await firestore
        .collection('Documentation')
        .doc(projectId)
        .collection('docs')
        .doc()
        .set({
      'title': title,
      'content': content,
      'author': Auth.currentUser!.displayName ?? 'Unknown',
      'authorEmail': Auth.currentUser!.email,
      'createdAt': DateTime.now(),
    });

    return true;
  }

  Stream<QuerySnapshot> getDocumentation({required String projectId}) {
    return firestore
        .collection('Documentation')
        .doc(projectId)
        .collection('docs')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<bool> deleteDocumentation({
    required String projectId,
    required String docId,
  }) async {
    await firestore
        .collection('Documentation')
        .doc(projectId)
        .collection('docs')
        .doc(docId)
        .delete();

    return true;
  }
}
