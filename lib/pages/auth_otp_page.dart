import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nimbus/main.dart';
import 'package:nimbus/pages/dashboard_page.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class AuthOTPPage extends StatefulWidget {
  AuthOTPPage({
    Key key,
    @required this.mobileNumber,
  }) : assert(mobileNumber != null),super(key: key);

  final String mobileNumber;
  @override
  _AuthOTPPageState createState() => _AuthOTPPageState();
}

class _AuthOTPPageState extends State<AuthOTPPage> {
  final TextEditingController inputController = TextEditingController();

  String message;
  String verificationId;

  bool isValid;

  @override
  void initState() {
    isValid = false;
    super.initState();
    verifyPhoneNumber();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          showForm(),
        ],
      ),
      floatingActionButton: showConfirmButton(),
    );
  }

  Widget showForm() {
    return new Container(
      padding: EdgeInsets.all(16.0),
      child: new ListView(
        shrinkWrap: true,
        children: <Widget>[
          showBackButton(),
          showLeadingMessage(),
          showInput(),
        ],
      ),
    );
  }

  Widget showBackButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: Align(
          alignment: Alignment(-1.0, 0.0),
          child: SizedBox(
            height: 40.0,
            width: 40.0,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () { Navigator.pop(context); },
            ),
          ),
        ));
  }

  Widget showLeadingMessage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      child: new Text.rich(
        TextSpan(
          children: <TextSpan>[
            TextSpan(text: 'Enter the 6-digit code sent to:\n', style: TextStyle(fontStyle: FontStyle.normal)),
            TextSpan(text: widget.mobileNumber, style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold)),
          ],
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget showInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: inputController,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(0.0),
          hintText: "000000",
          counterText: "",
          border: OutlineInputBorder(
            gapPadding: 0.0,
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(
              style: BorderStyle.none,
              width: 0.0,
            ),
          ),
        ),
        autofocus: true,
        autovalidate: false,
        autocorrect: false,
        maxLengthEnforced: true,
        maxLength: 6,
        maxLines: 1,
        style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly
        ],
        onChanged: (text) {
          validate();
        },
      ),
    );
  }

  Widget showConfirmButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: SizedBox(
          height: 30.0,
          child: new FlatButton(
            color: Colors.transparent,
            textColor: (isValid ? Colors.blue : Colors.grey),
            child: new Text('Confirm', style: new TextStyle(
              fontSize: 20.0,
            )),
            onPressed: () { signInWithPhoneNumber(); },
          ),
        ));
  }

  Future<void> verifyPhoneNumber() async {

    final PhoneVerificationCompleted verificationCompleted = (AuthCredential phoneAuthCredential) {
      print("PhoneVerificationFailed verificationId = ${phoneAuthCredential.toString()}");
      _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        this.message = 'Received phone auth credential: $phoneAuthCredential';
      });
    };

    final PhoneVerificationFailed verificationFailed = (AuthException authException) {
      print("PhoneVerificationFailed message = ${authException.message.toString()}");
      setState(() {
        message =
        'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}';
      });
    };

    final PhoneCodeSent codeSent = (String verificationId, [int forceResendingToken]) {
      print("PhoneCodeSent verificationId = ${verificationId}");
      this.verificationId = verificationId;
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout = (String verificationId) {
      print("PhoneCodeAutoRetrievalTimeout verificationId = ${verificationId}");
      this.verificationId = verificationId;
    };

    await _auth.verifyPhoneNumber(
        phoneNumber: widget.mobileNumber,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  Future<void> signInWithPhoneNumber() async {
    print("mobile = ${widget.mobileNumber}, verificationId = ${this.verificationId}, smsCode = ${this.inputController.text}");
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: this.verificationId,
      smsCode: this.inputController.text.toString(),
    );
    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
//    final FirebaseUser currentUser = await _auth.currentUser();
//    assert(user.uid == currentUser.uid);
    if (user != null) {
      this.message = 'Successfully signed in, uid: ' + user.uid;
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MyApp(),
          ), (Route<dynamic> route) => false
      );
    } else {
      this.message = 'Sign in failed';
    }
//    setState(() {
//
//    });
  }

  Future<void> validate() async {
    if (inputController.text.length >= 6) {
      setState(() {
        isValid = true;
      });
    } else {
      setState(() {
        isValid = false;
      });
    }
  }

}