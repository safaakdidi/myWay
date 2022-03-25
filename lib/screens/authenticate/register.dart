import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ppp/common/theme_helper.dart';
import 'package:ppp/screens/authenticate/authenticate.dart';
import 'package:ppp/screens/widgets/header_widget.dart';
class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey=GlobalKey<FormState>();
  bool checkboxValue=false;
  final _firstNameController=TextEditingController();
  final _lastNameController=TextEditingController();
  final _emailController=TextEditingController();
  final _phoneNumberController=TextEditingController();
  final _passwordController=TextEditingController();
  final _comfirmPasswordController=TextEditingController();

  var loading =false;
  void  _handleSignUpError(FirebaseAuthException e){
    var message='';
    switch (e.code){
      case 'email-already-in-use':
        message='This email is already in use';
        break;
      case 'invalid-email':
        message='The email you entered wad invalid';
        break;
      case 'operation-not-allowed':
        message='This operation is not allowed';
        break;
      case 'weak-password':
        message='The password you entered is too weak';
        break;
      default:
        message='An unknown error occurred';

    }
    showDialog(context: context, builder: (context){
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        title: Text(
          'Sign Up failed',
        ),
        content: Text(message),
        actions: [
          TextButton(onPressed: (){
            Navigator.of(context).pop();
          }, child: Text(
            'OK',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).accentColor,
            ),
          )

          )
        ],

      );
    });

  }
  _signUp() async{
    setState(() {
      loading=true;

    });

    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
      await FirebaseFirestore.instance.collection('users').add({
        'email':_emailController.text,
        'firstName':_firstNameController.text,
        'lastName':_lastNameController.text,

      });
      showDialog(context: context, builder: (context){
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          title: Text(
            'Sign Up succeeded',
          ),
          content: Text('Your account was created , you acn now log in'),
          actions: [
            TextButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: Text(
              'OK',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).accentColor,
              ),
            )

            )
          ],

        );
      });
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => Authenticate()
          ),
              (Route<dynamic> route) => false
      );
    }on FirebaseAuthException catch(e){
      _handleSignUpError(e);
      setState(() {
        loading=false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {




    return Scaffold(
      backgroundColor: Colors.white,
      body:SingleChildScrollView(
        child: Stack(
          children: [
            Container(
            height:150,
              child: HeaderWidget(150,false,Icons.person_add_alt_1_rounded),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(25, 50, 25, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        GestureDetector(
                          child: Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                      width: 5, color: Colors.white),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 20,
                                      offset: const Offset(5, 5),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.grey.shade300,
                                  size: 80.0,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(80, 80, 0, 0),
                                child: Icon(
                                  Icons.add_circle,
                                  color: Colors.grey.shade700,
                                  size: 25.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30,),
                        Container(
                          child: TextFormField(
                            controller: _firstNameController,
                            decoration: Themehelper().textInputDecoration('First Name', 'Enter your first name'),
                            validator: (val) {
                              if (val!.trim().isEmpty || val==null ) {
                                return "Please enter your First Name";
                              }
                              return null;
                            },
                          ),
                          decoration: Themehelper().inputBoxDecorationShaddow(),

                        ),
                        SizedBox(height: 30,),
                        Container(
                          child: TextFormField(
                            controller: _lastNameController,

                            decoration: Themehelper().textInputDecoration('Last Name', 'Enter your last name'),
                            validator: (val) {
                              if (val!.trim().isEmpty || val==null ) {
                                return "Please enter your Last Name";
                              }
                              return null;
                            },
                          ),
                          decoration: Themehelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: TextFormField(
                            controller: _emailController,

                            decoration: Themehelper().textInputDecoration("E-mail address", "Enter your email"),
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) {
                              if(val!.trim().isEmpty || val==null ){
                                return "Please enter your Email";
                              }
                              if(!(val.isEmpty) && !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(val)){
                                return "Enter a valid email address";
                              }
                              return null;
                            },
                          ),
                          decoration: Themehelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: TextFormField(
                            controller: _phoneNumberController,

                            decoration: Themehelper().textInputDecoration(
                                "Mobile Number",
                                "Enter your mobile number"),
                            keyboardType: TextInputType.phone,
                            validator: (val) {
                              if(val!.isEmpty || val==null ){
                                return "Please enter your Mobile Number";
                              }
                              if(!(val.trim().isEmpty || val==null ) && !RegExp(r"^(\d+)*$").hasMatch(val)){
                                return "Enter a valid phone number";
                              }
                              return null;
                            },
                          ),
                          decoration: Themehelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: TextFormField(
                            controller: _passwordController,

                            obscureText: true,
                            decoration: Themehelper().textInputDecoration(
                                "Password*", "Enter your password"),
                            validator: (val) {
                              if (val!.trim().isEmpty || val==null ) {
                                return "Please enter your password";
                              }
                              return null;
                            },
                          ),
                          decoration: Themehelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: TextFormField(
                            controller: _comfirmPasswordController,

                            obscureText: true,
                            decoration: Themehelper().textInputDecoration(
                                "Comfirm Password*", "Enter your password"),
                            validator: (val) {
                              if (val!.trim().isEmpty || val==null ) {
                                return "Please enter your password";
                              }
                              if(_passwordController.text!=_comfirmPasswordController.text){
                                return "Paswords don't match";
                              }
                              return null;
                            },
                          ),
                          decoration: Themehelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 15.0),
                        FormField<bool>(
                          builder: (state) {
                            return Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Checkbox(
                                        value: checkboxValue,
                                        onChanged: (bool? value) {

                                            checkboxValue = value!;
                                            state.didChange(value);

                                        }),
                                    Text("I accept all terms and conditions.", style: TextStyle(color: Colors.grey),),
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    state.errorText ?? '',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(color: Theme.of(context).errorColor,fontSize: 12,),
                                  ),
                                ),
                              ],
                            );
                          },
                          validator: (value) {
                            if (!checkboxValue) {
                              return 'You need to accept terms and conditions';
                            } else {
                              return null;
                             }
                          },
                        ),
                        SizedBox(height: 20.0),
                        if(loading)
                          Container(
                            child: CircularProgressIndicator(

                              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor.withOpacity(0.4)),
                            ),

                          ),
                        if(!loading)
                        Container(
                          decoration: Themehelper().buttonBoxDecoration(context),
                          child: ElevatedButton(
                            style: Themehelper().buttonStyle(),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: Text(
                                "Sign Up".toUpperCase(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _signUp();

                              }
                            },
                          ),
                        ),
                        SizedBox(height: 30.0),
                        Text("Or create account using social media",  style: TextStyle(color: Colors.grey),),
                        SizedBox(height: 25.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              child: FaIcon(
                                FontAwesomeIcons.googlePlus, size: 35,
                                color: HexColor("#EC2D2F"),),
                              onTap: () {
                                setState(() {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Themehelper().alartDialog("Google Plus","You tap on GooglePlus social icon.",context);
                                    },
                                  );
                                });
                              },
                            ),
                            SizedBox(width: 30.0,),
                            GestureDetector(
                              child: Container(
                                padding: EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(width: 5, color: HexColor("#40ABF0")),
                                  color: HexColor("#40ABF0"),
                                ),
                                child: FaIcon(
                                  FontAwesomeIcons.twitter, size: 23,
                                  color: HexColor("#FFFFFF"),),
                              ),
                              onTap: () {
                                setState(() {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Themehelper().alartDialog("Twitter","You tap on Twitter social icon.",context);
                                    },
                                  );
                                });
                              },
                            ),
                            SizedBox(width: 30.0,),
                            GestureDetector(
                              child: FaIcon(
                                FontAwesomeIcons.facebook, size: 35,
                                color: HexColor("#3E529C"),),
                              onTap: () {
                                setState(() {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Themehelper().alartDialog("Facebook",
                                          "You tap on Facebook social icon.",
                                          context);
                                    },
                                  );
                                });
                              },
                            ),
                          ],
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
    );
  }

}
