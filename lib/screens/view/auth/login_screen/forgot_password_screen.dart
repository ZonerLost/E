import 'package:edwardb/config/assets/assets.dart';
import 'package:edwardb/config/constant/colors.dart';
import 'package:edwardb/controllers/auth_controller/auth_controller.dart';
import 'package:edwardb/screens/custom/custom_button/custom_button.dart';
import 'package:edwardb/screens/custom/custom_text/custom_text.dart';
import 'package:edwardb/screens/custom/custom_text_from_field/custom_text_from_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatelessWidget {
   ForgotPasswordScreen({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(

      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                      48.verticalSpace,
                
                 Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0.1.sw),
                        child: Image.asset(AppAssets.bannerImage),
                      ),
                      48.verticalSpace,
                      EdwardbText(
                        'Forgot password ',
                        fontSize: 26,
                        
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        textAlign: TextAlign.center,
                      ),
                      // 48.verticalSpace,
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 28.0),
                      //   child: Column(
                      //     children: [
                      //       EdwardbText(
                      //         'An email will be sent once you update password ',
                      //         fontSize: 26,
                              
                      //         fontWeight: FontWeight.normal,
                      //         color: Colors.black,
                      //         textAlign: TextAlign.center,
                      //       ),
                      //       EdwardbText(
                      //         'there then change it in the app as well in this page',
                      //         fontSize: 26,
                      //         fontWeight: FontWeight.normal,
                      //         color: Colors.black,
                      //         textAlign: TextAlign.center,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      48.verticalSpace,
                      EdwardbTextField(
                      controller: controller.emailController,
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the required field';
                        }
                        if(!GetUtils.isEmail(value)){
                          return "Enter Valid Email ";
                        }
                        return null;
                      },
                    ),
                      48.verticalSpace,
            
                    Obx(() {
            
                        if(controller.isEmailFound.value){
                          return  EdwardbTextField(
                      controller: controller.passwordController,
                      hintText: 'New Password',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter required field';
                        }
                        return null;
                      },
                    );
                        }
                      return SizedBox.shrink();
            
                    }),
            
                      48.verticalSpace,
            
            
                    Obx( () { 
                      
                     return EdwardbButton(label: "Search For Account" , 
                      backgroundColor: controller.checkingForEmail.value
                            ? Colors.grey
                            : kPrimaryColor,
                    onPressed: controller.checkingForEmail.value ? (){} : ()async{
                     if(!_formKey.currentState!.validate()){
                      return ;
                     }
                      await controller.checkEmail(controller.emailController.text.trim());
                      
                    }); })
            
              ],
            ),
          ),
        ),
      ),
    );
  }
}