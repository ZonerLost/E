import 'package:freelance_market/screens/view/main/main.dart';

import '../../screens/view/auth/creat_account_screen/create_account_screen.dart';
import '../../screens/view/auth/login_screen/login_screen.dart';
import '../../screens/view/availability_screen/availability_screen.dart';
import '../../screens/view/choose_your_role_screen/choose_your_role_screen.dart';
import '../../screens/view/contact_details_screen/contact_details_screen.dart';
import '../../screens/view/educational_background_screens/educational_background_screen/educational_background_screen.dart';
import '../../screens/view/educational_background_screens/review_education_screen/review_education_screen.dart';
import '../../screens/view/preferred_service_type_screen/preferred_service_type_screen.dart';
import '../../screens/view/skills_competencies_screen/skills_competencies_screen.dart';
import '../../screens/view/work_experience_screen/work_experience_screen.dart';
import 'routes_names.dart';
import 'package:get/route_manager.dart';
import '../../screens/splash_service/splash_screen.dart';

class AppRoutes {
  static appRoutes() => [
    GetPage(name: RouteName.splashScreen, page: () => SplashScreen()),

    ///
    /// Auth
    ///
    GetPage(name: RouteName.loginScreen, page: () => LoginScreen()),
    GetPage(
      name: RouteName.createAccountScreen,
      page: () => CreateAccountScreen(),
    ),

    ///
    ///  Onboarding Process - Job Seeker Profile
    ///
    GetPage(
      name: RouteName.chooseYourRoleScreen,
      page: () => const ChooseYourRoleScreen(),
    ),

    GetPage(
      name: RouteName.contactDetailsScreen,
      page: () => const ContactDetailsScreen(),
    ),

    GetPage(
      name: RouteName.educationalBackgroundScreen,
      page: () => const EducationalBackgroundScreen(),
    ),

    GetPage(
      name: RouteName.reviewEducationScreen,
      page: () => const ReviewEducationScreen(),
    ),

    GetPage(
      name: RouteName.workExperienceScreen,
      page: () => const WorkExperienceScreen(),
    ),

    GetPage(
      name: RouteName.skillsCompetenciesScreen,
      page: () => const SkillsCompetenciesScreen(),
    ),

    GetPage(
      name: RouteName.preferredServiceTypeScreen,
      page: () => const PreferredServiceTypeScreen(),
    ),

    GetPage(
      name: RouteName.availabilityScreen,
      page: () => const AvailabilityScreen(),
    ),

    ///
    /// Home/Validations/Succes Messages/Reporting
    ///
    GetPage(
      name: RouteName.freelanceSideMainScreen,
      page: () => const FreelanceSideMain(),
    ),
  ];
}
