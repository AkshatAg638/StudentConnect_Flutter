import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentconnect/Utils/utils.dart';
import 'package:studentconnect/constants/colors.dart';
import 'package:studentconnect/constants/fonts.dart';
import 'package:studentconnect/data/databse/database_functions.dart';
import 'package:studentconnect/injection/database.dart';
import 'package:studentconnect/widgets/text.dart';
import 'package:studentconnect/widgets/workspace/header.dart';

class DocumentationScreen extends StatelessWidget {
  const DocumentationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String projectId = Get.arguments;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextEditingController titleController = TextEditingController();
    TextEditingController contentController = TextEditingController();
    var project = locator<Database>;

    return header(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back_ios)),
              Expanded(
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.symmetric(
                    vertical: Get.height * 0.02,
                  ),
                  child: text(
                    title: 'Project Documentation',
                    fontSize: Get.width * 0.05,
                    fontWeight: AppFonts.semiBold,
                    color: AppColors.black,
                    align: TextAlign.start,
                  ),
                ),
              ),
            ],
          ),
          // Title field
          TextFormField(
            controller: titleController,
            decoration: InputDecoration(
              hintText: "Document Title",
              hintStyle: const TextStyle(
                color: AppColors.grey,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  width * 0.03,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(width * 0.03),
                borderSide: BorderSide(
                  color: AppColors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(width * 0.03),
                borderSide: BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
            ),
          ),
          SizedBox(height: height * 0.01),
          // Content field
          TextFormField(
            controller: contentController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Document content (meeting notes, requirements, etc.)",
              hintStyle: const TextStyle(
                color: AppColors.grey,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  width * 0.03,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(width * 0.03),
                borderSide: BorderSide(
                  color: AppColors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(width * 0.03),
                borderSide: BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
            ),
          ),
          SizedBox(height: height * 0.01),
          // Add button
          SizedBox(
            width: Get.width,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.workspaceGradientColor1[2],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Get.width * 0.03),
                ),
                padding: EdgeInsets.symmetric(vertical: height * 0.015),
              ),
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    contentController.text.isNotEmpty) {
                  project().addDocumentation(
                    projectId: projectId,
                    title: titleController.text,
                    content: contentController.text,
                  );
                  titleController.clear();
                  contentController.clear();
                  Utils.showtoast("Documentation added");
                } else {
                  Utils.showtoast("Please fill in both title and content");
                }
              },
              icon: Icon(Icons.add_circle_outline, color: AppColors.white),
              label: text(
                title: 'Add Document',
                fontSize: Get.width * 0.04,
                fontWeight: AppFonts.semiBold,
                color: AppColors.white,
                align: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: height * 0.02),
          text(
            title: "All Documents",
            fontSize: width * 0.05,
            fontWeight: AppFonts.bold,
            color: AppColors.black,
            align: TextAlign.start,
          ),
          SizedBox(height: height * 0.01),
          // Documents list
          Expanded(
            child: StreamBuilder(
              stream: project().getDocumentation(projectId: projectId),
              builder: (context, snapshot) {
                if (!snapshot.hasData ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.description_outlined,
                            size: width * 0.15,
                            color: AppColors.grey.withOpacity(0.5),
                          ),
                          SizedBox(height: height * 0.02),
                          text(
                            title: "No documentation yet",
                            fontSize: width * 0.045,
                            fontWeight: AppFonts.medium,
                            color: AppColors.grey,
                            align: TextAlign.center,
                          ),
                          SizedBox(height: height * 0.01),
                          text(
                            title:
                                "Add meeting notes, requirements,\nor project specs above",
                            fontSize: width * 0.035,
                            fontWeight: AppFonts.normal,
                            color: AppColors.grey,
                            align: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot doc = snapshot.data!.docs[index];
                        Timestamp? timestamp = doc['createdAt'] as Timestamp?;
                        String dateStr = '';
                        if (timestamp != null) {
                          DateTime date = timestamp.toDate();
                          dateStr =
                              "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
                        }
                        return Container(
                          margin: EdgeInsets.symmetric(
                            vertical: height * 0.008,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            border: Border.all(
                              width: 1,
                              color: AppColors.grey.withOpacity(0.3),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.grey.withOpacity(0.15),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(
                              width * 0.03,
                            ),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(width * 0.03),
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: AppColors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        Get.width * 0.02,
                                      ),
                                    ),
                                    elevation: 0.0,
                                    title: text(
                                      title: "Delete Document",
                                      fontSize: Get.width * 0.065,
                                      fontWeight: AppFonts.bold,
                                      color: AppColors.black,
                                      align: TextAlign.center,
                                    ),
                                    actions: List.generate(
                                      2,
                                      (index) => ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0.0,
                                          backgroundColor: AppColors
                                              .workspaceGradientColor1[index]
                                              .withOpacity(0.3),
                                        ),
                                        onPressed: () async {
                                          if (index == 0) {
                                            Get.back();
                                          } else {
                                            Get.back();
                                            Utils.showtoast(
                                                "Document has been deleted");
                                            project().deleteDocumentation(
                                              projectId: projectId,
                                              docId: doc.id,
                                            );
                                          }
                                        },
                                        child: text(
                                          title: ["Cancel", "Delete"][index],
                                          fontSize: Get.width * 0.04,
                                          fontWeight: AppFonts.semiBold,
                                          color: AppColors.black,
                                          align: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    content: Container(
                                      decoration: const BoxDecoration(
                                        color: AppColors.white,
                                      ),
                                      child: text(
                                        title:
                                            "Are you sure you want to delete this document?",
                                        fontSize: Get.width * 0.04,
                                        fontWeight: AppFonts.regular,
                                        color: AppColors.grey,
                                        align: TextAlign.start,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.all(width * 0.04),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.description_outlined,
                                        color:
                                            AppColors.workspaceGradientColor1[2],
                                        size: width * 0.05,
                                      ),
                                      SizedBox(width: width * 0.02),
                                      Expanded(
                                        child: text(
                                          title: doc['title'],
                                          fontSize: width * 0.042,
                                          fontWeight: AppFonts.semiBold,
                                          color: AppColors.black,
                                          align: TextAlign.start,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height * 0.008),
                                  text(
                                    title: doc['content'],
                                    fontSize: width * 0.035,
                                    fontWeight: AppFonts.regular,
                                    color: AppColors.black,
                                    align: TextAlign.start,
                                  ),
                                  SizedBox(height: height * 0.008),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      text(
                                        title: "By: ${doc['author']}",
                                        fontSize: width * 0.03,
                                        fontWeight: AppFonts.normal,
                                        color: AppColors.grey,
                                        align: TextAlign.start,
                                      ),
                                      text(
                                        title: dateStr,
                                        fontSize: width * 0.03,
                                        fontWeight: AppFonts.normal,
                                        color: AppColors.grey,
                                        align: TextAlign.end,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
