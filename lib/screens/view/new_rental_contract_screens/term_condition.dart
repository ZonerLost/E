import 'package:edwardb/config/constant/colors.dart';
import 'package:edwardb/config/helper/card_number_formatter.dart';
import 'package:edwardb/config/helper/cvc_formatter.dart';
import 'package:edwardb/config/utils/utils.dart';
import 'package:edwardb/controllers/new_rental_contract_controller/new_rental_contract_controller.dart';
import 'package:edwardb/screens/custom/custom_button/custom_button.dart';
import 'package:edwardb/screens/custom/custom_text_from_field/custom_text_from_field.dart';
import 'package:edwardb/screens/view/new_rental_contract_screens/new_rental_contract_driver_photo_screen.dart';
import 'package:flutter/material.dart';
import 'package:edwardb/screens/custom/custom_text/custom_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';

// ignore: must_be_immutable
class TermCondition extends StatefulWidget {
  const TermCondition({super.key});

  @override
  State<TermCondition> createState() => _TermConditionState();
}

class _TermConditionState extends State<TermCondition> {
  RxBool isChecked_1 = false.obs;

  RxBool isChecked_2 = false.obs;

  RxBool isChecked_3 = false.obs;

  RxBool isChecked_4 = false.obs;
  final formKey = GlobalKey<FormState>();
  final controller = Get.find<NewRentalContractController>();


  // final _nameController = TextEditingController();
  // final _initalController = TextEditingController();
  // final _cardNumberController = TextEditingController();
  // final _cvcCardController = TextEditingController();
  // final _expiryDateCardController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(), body: _body());
  }

  _appBar() {
    return AppBar(
      leading: GestureDetector(
        child: Icon(Icons.arrow_circle_left_outlined, size: 30.sp),
        onTap: () => Get.back(),
      ),
      title: EdwardbText(
        'Start New Rental Contract',
        fontWeight: FontWeight.w700,
        fontSize: 24,
      ),
      scrolledUnderElevation: 0,
    );
  }

  _body() {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EdwardbText(
                    'SIDE BY SIDE, ATV, MOTORCYCLE, SCOOTER',
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    maxLines: 50,
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 16.h),
                  EdwardbText(
                    'Xplore SXM NV, SXM RALLY TOURS Agreement Terms and Conditions and Release of Liability',
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    maxLines: 50,
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 24.h),
              
                  EdwardbText(
                    '1. Definitions.',
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    maxLines: 50,
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 8.h),
                  EdwardbText(
                    '"Agreement" means all terms and conditions found in this form. "You" or "your" means the person identified as the renter and/or the person signing this Agreement, any Authorized Driver and any person or organization to whom charges are billed by us at its or the renter\'s direction. All persons referred to as "you" or "your" are jointly and severally bound by this Agreement. "We," "our" or "us" means Xplore SXM NV or SXM Rally Tours NV. "Authorized Driver" means the renter and any additional driver listed by us in this Agreement, provided that each such person has a valid driver\'s license and is at least 18 years of age. "Vehicle" means Scooter/ATV/Side by Side, motorcycle or any other vehicle identified in this Agreement and any Vehicle we substitute for it, and all its tires, tools, accessories, equipment, keys and Vehicle Documents. "Loss of use" means loss of our ability to use the Vehicle for any purpose due to damage to it during this rental.',
                    fontSize: 20,
                    maxLines: 50,
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 16.h),
              
                  EdwardbText(
                    '2. Rental, Indemnity and Warranties.',
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    maxLines: 50,
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 8.h),
                  EdwardbText(
                    'This is a contract for the rental of the Vehicle. We may repossess the Vehicle at your expense without notice to you, if the Vehicle is abandoned or used in violation of law or this Agreement. You agree to indemnify us, defend us and hold us harmless from all claims, liability, costs and attorneys fees we incur resulting from, or arising out of, this rental and your use of the Vehicle. We make no warranties, express, implied or apparent, regarding the Vehicle, no warranty of merchantability and no warranty that the Vehicle is fit for a particular purpose.',
              
                    fontSize: 20,
                    maxLines: 50,
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 16.h),
              
                  EdwardbText(
                    '3. Condition and Return of Vehicle.',
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    maxLines: 50,
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 8.h),
                  EdwardbText(
                    'You must return the Vehicle to us in the same condition you received it, on the date and time specified in this Agreement, and in the same condition that you received it, except for ordinary wear. The Vehicle remains our property and failure to return it on the agreed date may constitute theft. If the Vehicle is not returned at the time agreed to and renter, charges will start to accrue until the Vehicle is returned.',
                    textAlign: TextAlign.justify,
                    fontSize: 20,
                    maxLines: 50,
                  ),
                  SizedBox(height: 16.h),
              
                  EdwardbText(
                    '4. Responsibility for Vehicle Damage or Loss; Reporting to Police.',
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    maxLines: 50,
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 8.h),
                  EdwardbText(
                    'You are responsible for all damage to or loss of the Vehicle, including the cost of repair, or the actual cash retail value of the Vehicle on the date of the loss if the Vehicle is not repairable or if we elect not to repair it, whether or not you are at fault. You are also responsible for Loss of Use, Diminution of the Vehicle\'s value caused by damage to it or repair of it, missing equipment, and a reasonable charge to cover our administrative expenses connected with any damage claim, as allowed by law. You must report all accidents or incidents of theft and vandalism to us and the police as soon as you discover them.',
                    textAlign: TextAlign.justify,
                    fontSize: 20,
                    maxLines: 50,
                  ),
                  SizedBox(height: 16.h),
                  EdwardbTextField(
                    controller: controller.contractName,
                    hintText: 'Name',
                  ),
              
                  SizedBox(height: 16.h),
              
                  EdwardbText(
                    'Enter signature using stylus or finger',
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    maxLines: 50,
                    textAlign: TextAlign.justify,
                  ), 
              
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Signature(
                      controller: controller.signatureControllerName,
                      height: 200.h,
                      backgroundColor: kWhiteColor,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  EdwardbText(
                    '5. Further responsibility.',
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    maxLines: 50,
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 8.h),
                  EdwardbText(
                    'You are further responsible for all damage or loss to the Vehicle which: (a) is caused by anyone who is not an Authorized Driver, or by anyone whose driving license is suspended or who are jurisdiction; (b) is caused by anyone under the influence of prescription or non-prescription drugs or alcohol; (c) occurs while you are using the Vehicle for any illegal purposes or for any illegal manner; (d) occurs when you are driving the Vehicle off-road or not on paved roads; (e) occurs while the Vehicle is used in furtherance of any illegal activity or any willful or wanton misconduct constitutes a violation of law, other than a minor traffic violation; (f) occurs while pushing or towing anything, or carrying persons or property for hire; (g) occurs during an organized or street racing event; (h) occurs while carrying dangerous or hazardous items or illegal material or used in transport of contraband or other illegal trade; (i) occurs when transporting more persons than the Vehicle has seat belts, or transporting children without approved child safety seats as required by law; (j) occurs when the odometer has been tampered with or disconnected; (k) occurs when the fluid levels are low, or it is otherwise reasonable to expect you to know that further operation would damage the Vehicle; (l) occurs as a result of your willful, wanton or reckless act; (l) occurs and you fail to summon the police to any Vehicle accident involving personal injury or property damage.',
                    textAlign: TextAlign.justify,
                    fontSize: 20,
                    maxLines: 50,
                  ),
                  SizedBox(height: 16.h),
              
                  EdwardbText(
                    '6. Insurance.',
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    maxLines: 50,
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 8.h),
                  EdwardbText(
                    'You are responsible for all damage or loss you cause to others. You agree to provide liability, collision and comprehensive insurance covering you, us and the Vehicle. Your insurance is primary to any insurance that we may provide. If we are required by law to provide liability insurance, we will provide a liability insurance policy(the "Policy") that is excess to any other available and collectible insurance with their primary, excess or contingent and any deductible on our "Policy" is your responsibility and we reserve the right to claim that deductible from your deposit directly if it covers, and the balance if any, can be taken by the method of payment provided to us, this agreement is authorization of that. The Policy would provide liability coverage with limits no higher than the minimum financial amounts required by St Maarten. You and we reject PIP, medical payments, no-fault and uninsured and under-insured motorist coverage, where permitted by law.',
                    textAlign: TextAlign.justify,
                    fontSize: 20,
                    maxLines: 50,
                  ),
                  SizedBox(height: 16.h),
              
                  EdwardbText(
                    '7. Charges.',
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    maxLines: 50,
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 8.h),
                  EdwardbText(
                    'You will pay us, or the appropriate government authorities, on demand all charges due us under this Agreement, including: (a) optional products and services you purchased; (b) any parking, traffic and toll fines, penalties, forfeitures, court costs, towing, storage and impound charges and other expenses involving the Vehicle assessed against us or the Vehicle; if you fail to pay a traffic toll or charge to the charging authority, you will pay us all fees owed to the charging authority plus our administrative fee of \$20 for each such charge; (c) all expenses we incur in locating and recovering the Vehicle if you fail to return it or if we elect to repossess the Vehicle under the terms of this Agreement; (d) all costs, including attorneys\' and post-judgement attorney fees, we incur collecting payment from you or otherwise enforcing our rights under this Agreement; (e) a 2% per month late payment fee, or the maximum amount allowed by law (if less than 2%), on all amounts past due; (f) \$25 or the maximum amount permitted by law whichever is greater, if you pay us with a check returned unpaid for any reason; and (g) a reasonable fee not to exceed \$150 to clean the Vehicle if returned substantially less clean than when rented. We and the riders will both inspect the Vehicles before the Vehicle is rented, and upon the return, or pickup of the Vehicles.',
                    textAlign: TextAlign.justify,
                    fontSize: 20,
                    maxLines: 50,
                  ),
                  SizedBox(height: 16.h),
                  EdwardbTextField(
                    controller: controller.initialController,
                    hintText: 'Initial Here',
                  ),
                  SizedBox(height: 16.h),
                  
                  EdwardbText(
                    'Enter signature using stylus or finger',
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    maxLines: 50,
                    textAlign: TextAlign.justify,
                  ), 
              
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Signature(
                      controller: controller.signatureControllerInital,
                      height: 200.h,
                      backgroundColor: kWhiteColor,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  EdwardbText(
                    '8. Deposit.',
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    maxLines: 50,
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 8.h),
                  EdwardbText(
                    'We may use your deposit to pay any amounts owed to us under this Agreement. You understand that you will remain liable for charges that exceed your deposit.',
                    textAlign: TextAlign.justify,
                    fontSize: 20,
                    maxLines: 50,
                  ),
                  SizedBox(height: 16.h),
              
                  EdwardbText(
                    '9. Your Property.',
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    maxLines: 50,
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 8.h),
                  EdwardbText(
                    'You release us, our agents and employees from all claims for loss of, or damage to, your personal property or that of any other person that we received, handled, or stored, or that was left or carried in or on the Vehicle or in any service or delivery vehicles, whether or not the loss or damage was caused by our negligence or was otherwise our responsibility.',
                    textAlign: TextAlign.justify,
                    fontSize: 20,
                    maxLines: 50,
                  ),
                  SizedBox(height: 16.h),
              
                  EdwardbText(
                    '10. ASSUMPTION OF RISK.',
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    maxLines: 50,
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 8.h),
                  EdwardbText(
                    'YOU UNDERSTAND THAT THERE ARE POSSIBLE RISKS TO YOURSELF AND OTHERS, INCLUDING THE RISK OF DEATH, SERIOUS BODILY INJURY, AND PROPERTY DAMAGE THAT MAY BE ASSOCIATED WITH OPERATING A VEHICLE! YOU ARE RESPONSIBLE FOR THE SAFETY OF YOURSELF AND ANY GUESTS YOU MAY HAVE ON THE VEHICLE.\n\nYOU HEREBY STATE, THAT TO THE BEST OF YOUR KNOWLEDGE, YOU ARE IN GOOD PHYSICAL AND MENTAL CONDITION, AND UNDERSTAND THE VEHICLE SAFETY PROCEDURES. YOU VOLUNTARILY ASSUME ALL RISK OF ACCIDENT OR DAMAGE TO YOUR PERSON OR PROPERTY WHICH MAY BE INCURRED FROM OR BE CONNECTED IN ANY MANNER WITH YOUR USE, OPERATION OR RENTAL OF THE VEHICLE AND ASSUME ALL RELATED COSTS.',
                    textAlign: TextAlign.justify,
                    fontSize: 20,
                    maxLines: 50,
                  ),
                  SizedBox(height: 16.h),
              
                  EdwardbText(
                    '11. RELEASE AND INDEMNIFICATION.',
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    maxLines: 50,
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 8.h),
                  EdwardbText(
                    'YOU HEREBY RELEASE US, OUR OFFICERS, DIRECTORS, EMPLOYEES, REPRESENTATIVES AND AGENTS, FROM ALL CLAIMS, DEMANDS, ACTIONS AND FROM ALL LIABILITY FOR DAMAGE, LOSS OR INJURY (OF WHATEVER KIND, NATURE OR DESCRIPTION) THAT MAY ARISE OUT OF, OR YOU MAY SUSTAIN, IN CONNECTION WITH YOUR USE, OPERATION, OR RENTAL OF THE VEHICLE.\n\nYOU FURTHER AGREE TO INDEMNIFY AND HOLD US HARMLESS, AS WELL AS OUR OFFICERS, DIRECTORS, EMPLOYEES, REPRESENTATIVES AND AGENTS, FROM ALL CLAIMS, DEMANDS, ACTIONS, CAUSES OF ACTION, INCLUDING ATTORNEY\'S FEES, EXPENSES AND COSTS, OF YOURSELF OR OF THIRD PARTIES OF WHATEVER KIND, NATURE OR DESCRIPTION, WHICH MAY ARISE OUT OF, OR IN ANY MANNER CONNECTED WITH, OR CAUSED BY YOUR USE OR BY YOUR GUESTS OR AGENTS, OR OPERATION OR RENTAL OF THE VEHICLE. THIS RELEASE AND INDEMNIFICATION SHALL BE BINDING UPON YOUR HEIRS, ADMINISTRATORS, EXECUTORS, AND ASSIGNS.',
                    textAlign: TextAlign.justify,
                    fontSize: 20,
                    maxLines: 50,
                  ),
                  SizedBox(height: 16.h),
              
                  EdwardbText('12. Modifications.', fontSize: 20, maxLines: 50),
                  SizedBox(height: 8.h),
                  EdwardbText(
                    'No term of this Agreement can be waived or modified except by a writing that we have signed. If you wish to extend the rental period, you must reserve the Vehicle again and be approved before riding it beyond the original agreed upon pickup date and time. This Agreement constitutes the entire agreement between you and us. All prior representations and agreements between you and us regarding this rental are void.',
                    textAlign: TextAlign.justify,
                    fontSize: 20,
                    maxLines: 50,
                  ),
                  SizedBox(height: 16.h),
              
                  EdwardbText(
                    '13. Miscellaneous.',
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    maxLines: 50,
                  ),
                  SizedBox(height: 8.h),
                  EdwardbText(
                    'A waiver by us of any breach of this Agreement is not a waiver of any additional breach or waiver of the performance of your obligations under this Agreement. Our acceptance of payment from you or our failure, refusal or neglect to exercise any of our rights under this Agreement does not constitute a waiver of any other provision of this Agreement. This Agreement and any dispute arising therefrom, as well as any dispute arising from your operation or use of the Vehicle, shall be determined by the courts in St. Maarten.\n\nUnless prohibited by law, you release us from any liability for consequential, special or punitive damages in connection with this rental or the reservation of a vehicle. If any provision of this Agreement is deemed void or unenforceable, the remaining provisions are valid and enforceable.',
                    textAlign: TextAlign.justify,
                    fontSize: 20,
                    maxLines: 50,
                  ),
                  SizedBox(height: 24.h),
              
                  EdwardbText(
                    'IMPORTANT!!!',
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    maxLines: 50,
                  ),
                  SizedBox(height: 8.h),
                  EdwardbText(
                    'THIS RELEASE OF LIABILITY IS A LEGAL DOCUMENT WITH LEGAL CONSEQUENCES. Please read this document carefully before you sign it. If you do not understand any provision of this Agreement, you should not sign the document until you obtain clarification of the provision you do not understand. You are encouraged to have this document reviewed by your legal representative or by any other advisor you may have before you sign this Agreement.\n\nBy signing this Release, I certify that I have read this Release and fully understand it and that I am not relying on any statements or representations made by the Released Parties.\n\nIf the participant is under the age of 18, the child\'s parent or legal guardian must read and sign the Minor Participation Addendum prior to the minor engaging in the activity.',
                    textAlign: TextAlign.justify,
                    fontSize: 20,
                    maxLines: 50,
                  ),
                  SizedBox(height: 40.h),
              
                  EdwardbText(
                    'Card details',
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                    maxLines: 3,
                  ),
                  SizedBox(height: 30.h),
              
                  Row(
                    spacing: 20,
                    children: [
                       Expanded(
                        child: EdwardbTextField(
                          controller: controller.cardNumber,
                          hintText: 'Card Number',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                //  LengthLimitingTextInputFormatter(19),
                 CardNumberInputFormatter()
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your card number';
                            }
                            if (value.length < 16) {
                              return 'Card number must be at least 16 digits';
                            }
                            return null;
                          },
                        ),
                      ),
                       Expanded(
                        child: EdwardbTextField(
                          controller: controller.cvcNumber,
                          hintText: 'CVV',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                //  LengthLimitingTextInputFormatter(19),
                 CvcInputFormatter()
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your cvv number';
                            }
                            if (value.length < 3) {
                              return 'Please enter your valid cvv';
                            }
                            
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
              
                   GestureDetector(
                     onTap: () async {
                       String date = await Utils.showDatePickerDialog(
                         context,
                       );
                      if (date.isNotEmpty) {
    // Split and keep only month/year
    final parts = date.split('/'); // ['7', '10', '2025']
    if (parts.length == 3) {
      final formatted = "${parts[1]}/${parts[2]}"; // "10/2025"
      controller.cardExpiry.text = formatted;
    }
  }
                     },
                     child: AbsorbPointer(
                       child: EdwardbTextField(
                         controller: controller.cardExpiry,
                         hintText: 'Date',
                         readOnly: true,
                         keyboardType: TextInputType.datetime,
                         validator: (value) {
                           if (value == null || value.isEmpty) {
                             return 'Please enter the date';
                           }
                          
                           return null;
                         },
                       ),
                     ),
                   ),
                     
                      
                  SizedBox(height: 40.h),
              
                  EdwardbText(
                    'Before continuing please confirm you understand the agreement',
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                    maxLines: 3,
                  ),
              
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // First checkbox
                            Obx(
                              () => CheckboxListTile(
                                value: isChecked_1.value,
                                onChanged: (bool? value) {
                                  isChecked_1.value = value ?? false;
                                },
                                title: EdwardbText(
                                  'I agree to the Terms & Conditions',
                                  fontSize: 16,
                                  maxLines: 3,
                                ),
                                controlAffinity: ListTileControlAffinity.leading,
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                activeColor: kPrimaryColor,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                                      
                            // Second checkbox
                            Obx(
                              () => CheckboxListTile(
                                value: isChecked_2.value,
                                onChanged: (bool? value) {
                                  isChecked_2.value = value ?? false;
                                },
                                title: EdwardbText(
                                  'I understand the damage policy',
                                  fontSize: 16,
                                  maxLines: 3,
                                ),
                                controlAffinity: ListTileControlAffinity.leading,
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                activeColor: kPrimaryColor,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                                      
                            // Third checkbox
                            Obx(
                              () => CheckboxListTile(
                                value: isChecked_3.value,
                                onChanged: (bool? value) {
                                  isChecked_3.value = value ?? false;
                                },
                                title: EdwardbText(
                                  'I agree to the late return penalty',
                                  fontSize: 16,
                                  maxLines: 3,
                                ),
                                controlAffinity: ListTileControlAffinity.leading,
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                      
                                activeColor: kPrimaryColor,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                                      
                            // Fourth checkbox
                            Obx(
                              () => CheckboxListTile(
                                value: isChecked_4.value,
                                onChanged: (bool? value) {
                                  isChecked_4.value = value ?? false;
                                },
                                title: EdwardbText(
                                  'I confirm the fuel refill clause',
                                  fontSize: 16,
                                  maxLines: 3,
                                ),
                                controlAffinity: ListTileControlAffinity.leading,
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                activeColor: kPrimaryColor,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           EdwardbText(
                    'Enter signature using stylus or finger',
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    maxLines: 50,
                    textAlign: TextAlign.justify,
                  ), 
              
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Signature(
                      controller: controller.signatureControllerCard,
                      height: 200.h,
                      backgroundColor: kWhiteColor,
                    ),
                  ),
                        ],
                      ))
                    ],
                  ),
                  SizedBox(height: 40.h),
                  EdwardbButton(
                    label: 'Next',
                    onPressed: () {
                      if(formKey.currentState!.validate()){
              
                      }
                      if (isChecked_1.value &&
                          isChecked_2.value &&
                          isChecked_3.value &&
                          isChecked_4.value) {
                        // Handle button press
                        Get.to(() => NewRentalContractDriverPhotoScreen());
                      } else {
                        Utils.showErrorSnackbar(
                          'Terms & Conditions',
                          'Please agree to all terms to proceed',
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
