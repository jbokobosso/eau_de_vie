import 'package:eau_de_vie/constants/file_assets.dart';
import 'package:eau_de_vie/constants/globals.dart';
import 'package:eau_de_vie/constants/routes.dart';
import 'package:eau_de_vie/providers/auth_provider.dart';
import 'package:eau_de_vie/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneVerificationPage extends StatefulWidget {
  const PhoneVerificationPage({Key? key}) : super(key: key);

  @override
  _PhoneVerificationPageState createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {

  PhoneNumber _phoneNumberInput = PhoneNumber(countryISOCode: 'TG', countryCode: '+228', number: 'XX');
  String _errorMessage = "";
  bool _isBusy = false;
  double formHeightScale = 0.2;
  double topCurvedHeightScale = 0.3;
  double textInputSpacingScale = 0.2;
  bool _isObscure = true;
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();

  setObscure() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    Provider.of<AuthProvider>(context, listen: false).errorMessage = "";
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  _setBusy(bool value) {
    setState(() {
      _isBusy = value;
    });
  }

  _setErrorMessage(String message) {
    setState(() {
      _errorMessage = message;
    });
  }

  Future<bool> _phoneAlreadyVerified() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(Globals.S_phoneAlreadyVerified) ?? false;
  }

  Future<void> _onPhoneNumbmer() async {
    _setBusy(true);
    _setErrorMessage("");
    bool isValid = _registerFormKey.currentState!.validate();
    if(!isValid) return;
    if(await _phoneAlreadyVerified()) {
      Navigator.of(context).pushNamedAndRemoveUntil(RouteNames.home, (route) => false);
    } else {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _phoneNumberInput.completeNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          _setBusy(false);
          Utils.showToast("Verification completed.");
        },
        verificationFailed: (FirebaseAuthException e) {
          _setBusy(false);
          Utils.showToast(e.code);
        },
        codeSent: (String verificationId, int? resendToken) {
          _setBusy(false);
          Navigator.pushNamed(context, RouteNames.otp, arguments: {
            'phoneNumber': _phoneNumberInput.completeNumber,
            'verificationId': verificationId,
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Consumer<AuthProvider>(
          builder: (context, authProvider, child) => Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(FileAssets.menuBanner),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Form(
                        key: _registerFormKey,
                        child: Column(
                          children: [
                            // authProvider.errorMessage != ""
                            //     ? Text(authProvider.errorMessage, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),)
                            //     : Container(),
                            const SizedBox(height: 30.0),
                            IntlPhoneField(
                              decoration: const InputDecoration(
                                labelText: 'Téléphone',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(),
                                ),
                              ),
                              initialCountryCode: 'TG',
                              onChanged: (PhoneNumber phone) {
                                _phoneNumberInput = phone;
                              },
                              validator: (PhoneNumber? phoneNumber) {
                                if(phoneNumber == null) return null;
                                if(phoneNumber.completeNumber.length < 12) return "Numéro invalide";
                              },
                            ),
                            const SizedBox(height: 30.0),
                            const SizedBox(height: 20.0),
                          ],
                        )
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _onPhoneNumbmer,
                    child: const Text('Vérifier'),
                  )
                ],
              ),
              _isBusy == true ? const Center(child: CircularProgressIndicator()) : Container()
            ],
          )
      ),
    );
  }
}
