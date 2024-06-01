// import 'package:flutter/material.dart';
// import '/core/app_colors.dart';

// Widget customTextField(
//     {required TextEditingController controller,
//     required String hintText,
//     required bool obscureText}) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 20),
//     child: TextFormField(
//       controller: controller,
//       decoration: InputDecoration(
//         fillColor: AppColors.secondColor.withOpacity(0.2),
//         filled: true,
//         hintText: hintText,
//         border: OutlineInputBorder(
//           borderSide: const BorderSide(
//             color: AppColors.primaryColor,
//           ),
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//     ),
//   );
// }
import 'package:flutter/material.dart';

Widget customTextField({
  required TextEditingController controller,
  required String hintText,
  bool obscureText = false,
  bool isPassword = false,
  VoidCallback? togglePasswordVisibility,
}) {
  return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: togglePasswordVisibility,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ));
}
