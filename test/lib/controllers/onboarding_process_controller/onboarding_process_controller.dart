import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/enum/service_type.dart';

class OnboardingProcessController extends GetxController {
  ///
  /// ===== EDUCATION ======
  ///
  RxBool currentlyEnrolled = false.obs;

  ///
  /// ===== REVIEW EDUCATION ======
  ///

  /// Dummy data
  RxList<Education> educationList = <Education>[
    Education(
      degree: 'Bachelor of Science in Computer Science',
      institution: 'University of Technology',
      startDate: '2015-08-01',
      endDate: '2019-05-15',
    ),
    Education(
      degree: 'Master of Science in Software Engineering',
      institution: 'Tech University',
      startDate: '2020-08-01',
      endDate: '2022-05-15',
    ),
    Education(
      degree: 'Bachelor of Science in Computer Science',
      institution: 'University of Technology',
      startDate: '2015-08-01',
      endDate: '2019-05-15',
    ),
  ].obs;

  ///
  /// ===== WORK Experience ======
  ///
  RxBool currentlyWorking = false.obs;

  ///
  /// ===== SKILL & COMPETENCIES  ======
  ///
  RxList<String> skillsList = <String>[
    'Photographer',
    'Editor',
    'Videographer',
    'Photshoot',
  ].obs;

  RxList<String> recommendedSkillsList = <String>[
    'Portrait Photography',
    'Wedding',
    'Product Photography',
    'Sports',
  ].obs;

  Rx<ServiceType> serviceType = ServiceType.inPerson.obs;
}

/// ============================================================================
///
/// DUMMY MODEL
///
class Education {
  String degree;
  String institution;
  String startDate;
  String endDate;

  Education({
    required this.degree,
    required this.institution,
    required this.startDate,
    required this.endDate,
  });
}
