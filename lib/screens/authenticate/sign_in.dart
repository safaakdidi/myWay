import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ppp/common/theme_helper.dart';
import 'package:ppp/screens/authenticate/forget_password_page.dart';
import 'package:ppp/screens/authenticate/register.dart';
import 'package:ppp/screens/home/home_page.dart';

import '../widgets/header_widget.dart';
class SignIn extends StatefulWidget {


  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final _emailController=TextEditingController();
  final _passwordController=TextEditingController();
  bool isLoggingin=false;
  //login with facebook
  void _logInWithFacebook()async {

  }

  //login 3adiya
  _logIn()async {
    setState(() {
      isLoggingin=true;
    });
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Home()));
    }on FirebaseAuthException catch(e){
      var message='';
        switch (e.code){
          case 'invalid-email':
            message='The email you entered wad invalid';
            break;
          case 'user-disabled':
            message='The user you tried to sign into is disabled';
            break;
          case 'user-not-found':
            message='The user you tried to sign into is not found';
            break;
          case 'wrong-password':
            message='Incorrect password';
            break;

        }

        showDialog(context: context, builder: (context){
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            title: Text(
              'Sign in failed',
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
    }finally{
      setState(() {
        isLoggingin=false;
      });
    }
  }
double _headerHeight=250;
Key _formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: _headerHeight,
              child: HeaderWidget(_headerHeight, true, Icons.login_rounded),
            ),
            SafeArea(
              child:Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  children: [
                    Text(
                      'Hello',
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                Text(
                  'Sign in into your account',
                  style: TextStyle(
                    color: Colors.grey
                  ),
                ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            child: TextField(
                              controller: _emailController,
                              decoration: Themehelper().textInputDecoration('Email', 'Enter your email',),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            decoration: Themehelper().inputBoxDecorationShaddow() ,
                          ),
                          SizedBox(height: 30.0,),
                          Container(
                            child: TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: Themehelper().textInputDecoration('Password', 'Enter your password'),
                            ),
                            decoration: Themehelper().inputBoxDecorationShaddow(),
                          ),
                          SizedBox(height: 15.0,),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPasswordPage()),);
                              },
                              child: Text(
                                'Forgot your password?',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),

                          ),
                          if(!isLoggingin)
                          Container(
                            decoration: Themehelper().buttonBoxDecoration(context),
                            child: ElevatedButton(
                              style: Themehelper().buttonStyle(),
                              onPressed: () {
                                ///5idma mta3 log in;
                                _logIn();
                              },
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                child: Text(
                                  'Sign In'.toUpperCase(),
                                   style:TextStyle(
                                     fontSize: 20,
                                     fontWeight: FontWeight.bold,color: Colors.white
                                   )
                              ),
                            )


                          ),
                          ),
                          if(isLoggingin)
                            Container(
                              child: CircularProgressIndicator(

                                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor.withOpacity(0.4)),
                              ),

                            ),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                            child: Text.rich(
                               TextSpan(
                                 children: [
                                   TextSpan(text: 'Don\t have an account ?'),
                                    TextSpan(
                                       text:' Create',
                                     recognizer: TapGestureRecognizer()
                                       ..onTap=(){
                                         Navigator.push(context, MaterialPageRoute(builder: (context)=>RegistrationPage()));
                                       },
                                       style:TextStyle(
                                       fontWeight:FontWeight.bold,color: Theme.of(context).accentColor
                                   ),


                                   )
                                 ]
                               )
                            ),


                          ),
                          SizedBox(height: 10.0),
                          Text("Or sign in using social media",  style: TextStyle(color: Colors.grey),),
                          SizedBox(height: 15.0),
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
                                 _logInWithFacebook();
                                },
                              ),
                            ],
                          ),
                        ],

                      ),
                    )
                  ],
                ),
              ) ,
            )
            ]

        ),
      )
    );
  }
}
