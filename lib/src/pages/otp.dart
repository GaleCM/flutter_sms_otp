import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:otp/otp.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sms/sms.dart';

class OtpWidget extends StatefulWidget {
  const OtpWidget({Key key, this.phone, this.code}) : super(key: key);

  final String phone;
  final String code;
  @override
  _OtpWidgetState createState() => _OtpWidgetState();
}

class _OtpWidgetState extends State<OtpWidget> with CodeAutoFill {
  TextEditingController textControllerOTP = TextEditingController();
  SmsSender sender = new SmsSender();
  String textOTP;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void codeUpdated() {
    setState(() {
      textControllerOTP.text = widget.code;
    });
  }

  @override
  void initState() {
    textOTP = widget.code;

    super.initState();
    listenForCode();
  }

  @override
  void dispose() {
    super.dispose();
    textControllerOTP.dispose();
  }

  void smsData(String codeOtpNew) async {
    final asignature = await SmsAutoFill().getAppSignature;
    sender.sendSms(new SmsMessage(
        widget.phone, '<#>Hello there! ${codeOtpNew} $asignature'));
  }

  void toastValidation(Color color, String user) {
    Fluttertoast.showToast(
        msg: user,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFFF1F4F8),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 1,
          decoration: BoxDecoration(),
          child: Align(
            alignment: AlignmentDirectional(0, 1),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(15, 60, 15, 15),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/otp.jpg',
                          width: 380,
                          height: 440,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 350,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0),
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Text('Phone Number Verification',
                                  style: TextStyle(
                                    fontFamily: 'Outfit',
                                    color: Color(0xFF0F1113),
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Text(
                                  'Enter the code sent to +506 ' + widget.phone,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.normal,
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: PinCodeTextField(
                                appContext: context,
                                pastedTextStyle: TextStyle(
                                  color: Colors.green.shade600,
                                  fontWeight: FontWeight.bold,
                                ),
                                length: 6,
                                obscureText: false,
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(5),
                                  fieldHeight: 50,
                                  fieldWidth: 40,
                                  activeFillColor: Colors.white,
                                ),
                                cursorColor: Colors.black,
                                animationDuration:
                                    const Duration(milliseconds: 300),
                                enableActiveFill: true,
                                controller: textControllerOTP,
                                keyboardType: TextInputType.number,
                                boxShadows: const [
                                  BoxShadow(
                                    offset: Offset(0, 1),
                                    color: Colors.black12,
                                    blurRadius: 10,
                                  )
                                ],
                                onCompleted: (v) {
                                  debugPrint("Completed");
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(20, 12, 140, 15),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text('Didn\'t receive the code ?',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontFamily: 'Outfit',
                                    color: Color(0xFF57636C),
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                  )),
                            ),
                            RaisedButton(
                              onPressed: () async {
                                final codeResend = OTP.generateTOTPCodeString(
                                    'JBSWY3DPEHPK3PXP',
                                    DateTime.now().millisecondsSinceEpoch);

                                setState(() {
                                  textControllerOTP.text = "";
                                  textOTP = codeResend;
                                });

                                smsData(codeResend);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 20),
                                child: Text('RESEND',
                                    style: TextStyle(
                                      fontFamily: 'Lexend Deca',
                                      color: Color(0xFF4B39EF),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    )),
                              ),
                              elevation: 0,
                              color: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ],
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {
                          if (textOTP.length == 6 &&
                              textOTP == textControllerOTP.text) {
                            toastValidation(Colors.green, "OTP Verified!!");
                          } else {
                            toastValidation(Colors.red, "Invalid OTP");
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 17),
                          child: Text('VERIFY',
                              style: TextStyle(
                                fontFamily: 'Lexend Deca',
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        elevation: 0,
                        color: Color(0xFF4B39EF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
