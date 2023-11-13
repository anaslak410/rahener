// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';

// class PhoneNumVerification extends StatefulWidget {
//   const PhoneNumVerification({super.key});

//   @override
//   State<PhoneNumVerification> createState() => _PhoneNumVerificationState();
// }

// class _PhoneNumVerificationState extends State<PhoneNumVerification> {
//   // variables

//   final RoundedLoadingButtonController _btnController =
//       RoundedLoadingButtonController();
//   final AuthState authState = Get.find<AuthState>();
//   late StreamSubscription stream;

//   String _code = '';

//   int _smsResendAttemptsLeft = 3;
//   bool _resendEnabled = true;
//   int _secondsRemaining = 60;
//   Timer _timer = Timer(const Duration(seconds: 1), () {});

//   // functions

//   @override
//   void dispose() {
//     _timer.cancel();
//     stream.cancel();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     stream = authState.verifStream.listen((event) {
//       if (event == AuthCode.userVerified) {
//         _btnController.success();
//         context.router.pop();
//       }
//       // phone number verification errors
//       else {
//         if (event == AuthCode.wrongVerificationCode) {
//           _onWrongCode(context);
//         }
//       }
//     });
//     super.initState();
//   }

//   void _startTimer() {
//     _timer = Timer.periodic(const Duration(seconds: 1), (_) {
//       setState(() {
//         if (_secondsRemaining != 1) {
//           _resendEnabled = false;
//           _secondsRemaining--;
//         } else {
//           _timer.cancel();
//           _resendEnabled = true;
//           _secondsRemaining = 60;
//         }
//       });
//     });
//   }

//   void _onResendButtonPressed(context) {
//     setState(() {
//       authState.verifyPhoneNumber(context);
//     });
//     if (_smsResendAttemptsLeft == 0) {
//       return;
//     } else {
//       authState.verifyPhoneNumber(context);
//       _startTimer();
//       showTopSnackBar(
//         context,
//         CustomSnackBar.success(
//           icon: const Icon(Icons.check),
//           backgroundColor: Get.theme.primaryColor,
//           message: "${'check_your_phone'}\n${'verification_code_sent_again'}",
//         ),
//       );
//       setState(() {
//         _smsResendAttemptsLeft--;
//       });
//     }
//   }

//   void _onVerifyButtonPress() async {
//     if (_code.length < 6) {
//       _btnController.reset();
//       return;
//     } else {
//       _btnController.success();
//       authState.verifySmsCode(context, _code, widget.userType);
//     }
//   }

//   void _onWrongCode(BuildContext context) {
//     _btnController.reset();
//     showTopSnackBar(
//       context,
//       const CustomSnackBar.error(
//         icon: Icon(Icons.error),
//         message: "Wrong code",
//       ),
//     );
//   }

//   // UI

//   Widget _smsVerificationForm() {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).requestFocus(FocusNode());
//       },
//       child: SingleChildScrollView(
//         child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 15),
//             height: MediaQuery.of(context).size.height,
//             width: double.infinity,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const SizedBox(
//                   height: 50,
//                 ),
//                 Lottie.asset(
//                   ConstUtils.lottiePaperPlane,
//                   animate: true,
//                   height: 150,
//                   width: 150,
//                 ),
//                 const SizedBox(
//                   height: 60,
//                 ),
//                 Text(
//                   "verification_code",
//                   style: const TextStyle(
//                       fontSize: 22, fontWeight: FontWeight.w400),
//                 ),
//                 const SizedBox(
//                   height: 16,
//                 ),
//                 Text(
//                   "we_have_send_a_code_to_your_phone",
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(fontSize: 14, height: 1.5),
//                 ),
//                 const SizedBox(
//                   height: 48,
//                 ),

//                 // Verification Code Input
//                 Directionality(
//                   textDirection: TextDirection.ltr,
//                   child: VerificationCode(
//                     itemSize: 50,
//                     length: 6,
//                     fullBorder: true,
//                     underlineColor: Get.theme.primaryColor,
//                     underlineUnfocusedColor: Colors.transparent,
//                     onCompleted: (code) {
//                       setState(() {
//                         _code = replaceArabicNumber(code);
//                       });
//                     },
//                     textStyle: const TextStyle(fontSize: 25, height: 1.3),
//                     keyboardType: TextInputType.number,
//                     onEditing: (value) {},
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 48,
//                 ),
//                 _smsResendAttemptsLeft == 0
//                     ? const Text("Attempted to send sms too many times",
//                         style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.redAccent))
//                     : Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             "didn’t_receive_the_code",
//                             style: const TextStyle(
//                               fontSize: 16,
//                             ),
//                           ),
//                           _resendEnabled
//                               ? TextButton(
//                                   onPressed: () {
//                                     _onResendButtonPressed(context);
//                                   },
//                                   child: Text(
//                                     "resend",
//                                     style: TextStyle(
//                                         color: Theme.of(context).primaryColor,
//                                         fontSize: 17,
//                                         fontWeight: FontWeight.w400),
//                                   ))
//                               : Text("     ${"try_again_in"}$_secondsRemaining",
//                                   style: const TextStyle(
//                                       fontSize: 17,
//                                       fontWeight: FontWeight.w400)),
//                         ],
//                       ),
//                 const SizedBox(
//                   height: 30,
//                 ),
//                 SizedBox(
//                   width: double.infinity,
//                   height: 60,
//                   child: RoundedLoadingButton(
//                       height: 60,
//                       borderRadius: 20,
//                       color: Theme.of(context).primaryColor,
//                       controller: _btnController,
//                       onPressed: _onVerifyButtonPress,
//                       child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text('submit',
//                                 style: const TextStyle(
//                                     fontSize: 17, color: Colors.white)),
//                           ])),
//                 )
//               ],
//             )),
//       ),
//     );
//   }

//   // mobile

//   Widget _smsVerificationScreenMobile() {
//     return SafeArea(
//         top: false,
//         child: Scaffold(
//           backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//           body: _smsVerificationForm(),
//         ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _smsVerificationScreenMobile();
//   }
// }
