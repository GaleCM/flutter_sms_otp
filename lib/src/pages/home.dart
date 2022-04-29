import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sms_otp/src/pages/otp.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:sms/sms.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key key, this.code}) : super(key: key);
  final String code;
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  TextEditingController phoneNumberController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  SmsSender sender = new SmsSender();

  @override
  void initState() {
    super.initState();
    phoneNumberController = TextEditingController();
  }

  void toastValidation(Color color, String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  bool isEmptyController(String asignature) {
    if (phoneNumberController.text.isEmpty) {
      return true;
    } else {
      sender.sendSms(new SmsMessage(phoneNumberController.text,
          '<#>Hello there! ${widget.code} $asignature'));
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFFF1F4F8),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Align(
          alignment: AlignmentDirectional(0, 1),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(15, 60, 15, 15),
                  child: Image.asset(
                    'assets/images/home.jpg',
                    width: 390,
                    height: 500,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 240,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        color: Color(0x3600000F),
                        offset: Offset(0, -1),
                      )
                    ],
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
                              child: Text('Get a verification code',
                                  style: TextStyle(
                                    fontFamily: 'Outfit',
                                    color: Color(0xFF0F1113),
                                    fontSize: 24,
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextFormField(
                                  controller: phoneNumberController,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelText: 'Enter your number',
                                    labelStyle: TextStyle(
                                        fontFamily: 'Outfit',
                                        color: Color(0xFF57636C),
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal),
                                    hintStyle: TextStyle(
                                        fontFamily: 'Lexend Deca',
                                        color: Color(0xFF95A1AC),
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFFE0E3E7),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFFE0E3E7),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding:
                                        EdgeInsetsDirectional.fromSTEB(
                                            16, 24, 0, 24),
                                  ),
                                  style: TextStyle(
                                      fontFamily: 'Outfit',
                                      color: Color(0xFF0F1113),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal)),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 12, 20, 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            RaisedButton(
                              onPressed: () async {
                                final asignature =
                                    await SmsAutoFill().getAppSignature;

                                !isEmptyController(asignature)
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return OtpWidget(
                                                phone:
                                                    phoneNumberController.text,
                                                code: widget.code);
                                          },
                                        ),
                                      )
                                    : toastValidation(
                                        Colors.red, "Phone number is empty");
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 20),
                                child: Text('Send SMS',
                                    style: TextStyle(
                                      fontFamily: 'Lexend Deca',
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                              elevation: 3,
                              color: Color(0xFF4B39EF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ],
                        ),
                      ),
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
