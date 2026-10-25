import 'package:flutter_test/flutter_test.dart';
import 'package:studentconnect/constants/colors.dart';
import 'package:studentconnect/constants/labels.dart';
import 'package:studentconnect/routes/routes.dart';

void main() {
  group('StudentConnect App Tests', () {
    test('App routes are properly defined', () {
      expect(AppRoutes.main, '/main');
      expect(AppRoutes.user, '/');
      expect(AppRoutes.home, '/home');
      expect(AppRoutes.addWorkspace, '/addWorkspace');
      expect(AppRoutes.workSpaceDetail, '/workspacedetail');
      expect(AppRoutes.documentation, '/documentation');
      expect(AppRoutes.comment, '/Comment');
    });

    test('Design tokens and labels are configured', () {
      expect(AppColors.workspaceGradientColor1.isNotEmpty, true);
      expect(AppColors.workspaceGradientColor2.isNotEmpty, true);
      expect(AppLabels.homePageTabName, ['Assigned', 'InProgress', 'Complete']);
      expect(AppLabels.projectDetailButtonLabel.contains('View Docs'), true);
    });
  });
}
