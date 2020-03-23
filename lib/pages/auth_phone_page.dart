import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nimbus/pages/auth_otp_page.dart';

class AuthPhonePage extends StatefulWidget {
  AuthPhonePage({Key key}) : super(key: key);

  @override
  AuthPhonePageState createState() => AuthPhonePageState();
}

class AuthPhonePageState extends State<AuthPhonePage> {
  final TextEditingController inputController = TextEditingController();

  bool isValid;

  @override
  void initState() {
    isValid = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          showForm(),
        ],
      ),
      floatingActionButton: showContinueButton(),
    );
  }

  Widget showForm() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showBanner(),
              showLeadingMessage(),
              showInput(),
            ],
          ),
        );
  }

  Widget showBanner() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/flutter-256.png'),
        ),
      ),
    );
  }

  Widget showLeadingMessage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
      child: new Text.rich(
        TextSpan(
          children: <TextSpan>[
            TextSpan(text: 'Halo!\n', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            TextSpan(text: 'Enter your mobile number to continue.', style: TextStyle(fontStyle: FontStyle.normal)),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget showInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: inputController,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10.0),
          counterText: "",
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            borderSide: BorderSide(width: 0.0, style: BorderStyle.none),
          ),
          prefix: Container(
            padding: EdgeInsets.all(4.0),
            child: Text(
              "+65",
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        autofocus: true,
        autovalidate: true,
        autocorrect: false,
        maxLengthEnforced: true,
        maxLength: 15,
        maxLines: 1,
        style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly
        ],
        onChanged: (text) {
          validate();
        },
      ),
    );
  }

  Widget showContinueButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: SizedBox(
          height: 30.0,
          child: new FlatButton(
            color: Colors.transparent,
            textColor: (isValid ? Colors.blue : Colors.grey),
            child: new Text('Continue', style: new TextStyle(
              fontSize: 20.0,
            )),
            onPressed: () { validateAndContinue(); },
          ),
        ));
  }

  Future<void> validate() async {
    if (inputController.text.length >= 8 && inputController.text.length <= 12) {
      setState(() {
        isValid = true;
      });
    } else {
      setState(() {
        isValid = false;
      });
    }
  }

  void validateAndContinue() {
    if (isValid) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AuthOTPPage(
                  mobileNumber: "+65${inputController.text}",
                ),
          ));
    }
  }
}

