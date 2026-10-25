import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:studentconnect/Utils/utils.dart';
import 'package:studentconnect/bloc/addMemberToProject/addMemberBloc.dart';
import 'package:studentconnect/bloc/addMemberToProject/addMemberstates.dart';
import 'package:studentconnect/bloc/addMemberToProject/addmemberevents.dart';
import 'package:studentconnect/bloc/removeMemberFromProjectBloc/removeMember_bloc.dart';
import 'package:studentconnect/bloc/removeMemberFromProjectBloc/removeMember_events.dart';
import 'package:studentconnect/bloc/removeMemberFromProjectBloc/removeMember_states.dart';
import 'package:studentconnect/constants/colors.dart';
import 'package:studentconnect/constants/fonts.dart';
import 'package:studentconnect/data/databse/database_functions.dart';
import 'package:studentconnect/injection/database.dart';
import 'package:studentconnect/widgets/text.dart';
import 'package:studentconnect/widgets/workspace/header.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({super.key});

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  late final TextEditingController emailController;
  final project = locator<Database>;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AddMemberToProjectBloc, AddMemberToProjectStates>(
          listener: (context, state) {
            if (state is MemberAddedToProjectState) {
              Utils.showSnackBar(state.message);
            } else if (state is AddErrorState) {
              Utils.showSnackBar(state.message);
            }
          },
        ),
        BlocListener<RemoveMemberFromProjectBloc, RemoveMemberFromProjectStates>(
          listener: (context, state) {
            if (state is MemberRemovedFromProjectState) {
              Utils.showSnackBar(state.message);
            } else if (state is ErrorState) {
              Utils.showSnackBar(state.message);
            }
          },
        ),
      ],
      child: header(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.symmetric(
                      vertical: Get.height * 0.02,
                    ),
                    child: text(
                      title: 'Add Members',
                      fontSize: Get.width * 0.05,
                      fontWeight: AppFonts.semiBold,
                      color: AppColors.black,
                      align: TextAlign.start,
                    ),
                  ),
                ),
              ],
            ),
            TextFormField(
              controller: emailController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              autofillHints: const [AutofillHints.email],
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    if (emailController.text.trim().isNotEmpty) {
                      BlocProvider.of<AddMemberToProjectBloc>(context).add(
                          AddMemberToProject(
                              memberEmail: emailController.text.trim()));
                      emailController.clear();
                    }
                  },
                  icon: const Icon(Icons.person_add_alt_1_outlined),
                ),
                hintText: "i.e: student@university.edu",
                hintStyle: TextStyle(
                  color: AppColors.grey,
                  fontSize: Get.width * 0.04,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Get.width * 0.03),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Get.width * 0.03),
                ),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(top: Get.height * 0.02),
              child: text(
                title: 'Added Members',
                fontSize: Get.width * 0.035,
                fontWeight: AppFonts.semiBold,
                color: AppColors.grey,
                align: TextAlign.start,
              ),
            ),
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                stream: project().getMembersOfProject(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData && snapshot.data != null) {
                    DocumentSnapshot snap = snapshot.data!;
                    List<dynamic> emails = [];
                    try {
                      emails = snap.get('email') ?? [];
                    } catch (_) {}

                    return emails.isNotEmpty
                        ? ListView.builder(
                            padding: EdgeInsets.only(
                              top: Get.height * 0.02,
                            ),
                            physics: const BouncingScrollPhysics(),
                            itemCount: emails.length,
                            itemBuilder: (context, index) {
                              String memberEmail = emails[index].toString();
                              return ListTile(
                                title: text(
                                  title: memberEmail,
                                  fontSize: Get.width * 0.04,
                                  fontWeight: AppFonts.regular,
                                  color: AppColors.black,
                                  align: TextAlign.start,
                                ),
                                leading: SizedBox(
                                  width: Get.width * 0.1,
                                  height: Get.height * 0.1,
                                  child: StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('User')
                                        .where('email', isEqualTo: memberEmail)
                                        .snapshots(),
                                    builder: (context, userSnap) {
                                      String? photoUrl;
                                      if (userSnap.hasData &&
                                          userSnap.data!.docs.isNotEmpty) {
                                        try {
                                          photoUrl = userSnap
                                              .data!.docs[0].get('photoUrl');
                                        } catch (_) {}
                                      }

                                      return CircleAvatar(
                                        backgroundColor: AppColors
                                            .workspaceGradientColor1[0]
                                            .withOpacity(0.2),
                                        child: ClipOval(
                                          child: (photoUrl != null &&
                                                  photoUrl.isNotEmpty)
                                              ? CachedNetworkImage(
                                                  imageUrl: photoUrl,
                                                  errorWidget:
                                                      (context, url, err) =>
                                                          const Icon(
                                                              Icons.person,
                                                              color: AppColors
                                                                  .black),
                                                  placeholder:
                                                      (context, url) =>
                                                          const Icon(
                                                              Icons.person,
                                                              color: AppColors
                                                                  .grey),
                                                )
                                              : const Icon(Icons.person,
                                                  color: AppColors.black),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    BlocProvider.of<
                                                RemoveMemberFromProjectBloc>(
                                            context)
                                        .add(RemoveMemberFromProject(
                                            memberEmail: memberEmail));
                                  },
                                  icon: const Icon(
                                    Icons.cancel_outlined,
                                    color: AppColors.grey,
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: text(
                              title: "No Member Added to Display",
                              fontSize: Get.width * 0.04,
                              fontWeight: AppFonts.semiBold,
                              color: AppColors.black,
                              align: TextAlign.center,
                            ),
                          );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            Container(
              width: Get.width,
              padding: EdgeInsets.symmetric(
                vertical: Get.height * 0.01,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.workspaceGradientColor1[2],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Get.width * 0.03),
                  ),
                ),
                onPressed: () {
                  if (emailController.text.trim().isNotEmpty) {
                    BlocProvider.of<AddMemberToProjectBloc>(context).add(
                        AddMemberToProject(
                            memberEmail: emailController.text.trim()));
                    emailController.clear();
                  }
                },
                child: text(
                  title: 'Add',
                  fontSize: Get.width * 0.04,
                  fontWeight: AppFonts.semiBold,
                  color: AppColors.white,
                  align: TextAlign.start,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
