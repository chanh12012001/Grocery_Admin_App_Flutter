import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grocery_admin_app_flutter/screens/home_screen.dart';
import 'package:grocery_admin_app_flutter/services/firebase_services.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login-screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final _formKey = GlobalKey<FormState>();
  FirebaseServices _services = FirebaseServices();
  var _usernameTextController = TextEditingController();
  var _passwordTextController = TextEditingController();



  @override
  Widget build(BuildContext context) {

    ArsProgressDialog progressDialog = ArsProgressDialog(
        context,
        blur: 2,
        backgroundColor: Color(0x33000000).withOpacity(.3),
        animationDuration: Duration(milliseconds: 500)
    );

    _login({username, password}) async{
      progressDialog.show();
      _services.getAdminCredentials(username).then((value) async {
        if (value.exists){
          if (value['username'] == username) {
            if (value['password'] == password) {
              try{
                UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
                if (userCredential != null) {
                  progressDialog.dismiss();
                  Navigator.pushReplacementNamed(context, HomeScreen.id);
                }
              } catch(e) {
                progressDialog.dismiss();
                _services.showMyDialog(
                    context: context,
                    title: 'Đăng nhập',
                    message: '${e.toString()}',
                );
              }
              return;
            }
            progressDialog.dismiss();
            _services.showMyDialog(
                context: context,
                title: 'Mật khẩu không chính xác',
                message: 'Mật khẩu không tồn tại. Vui lòng thử lại.'
            );
            return;
          }
          progressDialog.dismiss();
          _services.showMyDialog(
              context: context,
              title: 'Tài khoản không hợp lệ',
              message: 'Tài khoản không tồn tại. Vui lòng thử lại'
          );
        }
        progressDialog.dismiss();
        _services.showMyDialog(
            context: context,
            title: 'Tài khoản không hợp lệ',
            message: 'Tài khoản không đúng. Vui lòng thử lại'
        );
      });
    }


    return Scaffold(
        body: FutureBuilder(
          // Initialize FlutterFire:
          future: _initialization,
          builder: (context, snapshot) {
            // Check for errors
            if (snapshot.hasError) {
              return Center(
                child: Text('Kết nối thất bại'),
              );
            }

            // Once complete, show your application
            if (snapshot.connectionState == ConnectionState.done) {
              return Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xff6f8be5),
                          Colors.white,
                        ],
                        stops: [1.0, 1.0],
                        begin: Alignment.topCenter,
                        end: Alignment(0.0, 0.0),
                      )
                  ),
                  child: Center(
                    child: Container(
                      width: 300,
                      height: 450,
                      child: Card(
                        elevation: 6,
                        shape: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  child: Column(
                                    children: [
                                      Image.asset('images/logo.png',width: 150, height: 150,),
                                      Text(
                                        'GROCERY APP ADMIN',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 20,
                                        ),
                                      ),
                                      SizedBox(height: 20,),
                                      TextFormField(
                                        controller: _usernameTextController,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Vui lòng nhập tên tài khoản';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                            labelText: 'Tên đăng nhập',
                                            prefixIcon: Icon(Icons.person),
                                            contentPadding: EdgeInsets.only(left: 20, right: 20),
                                            border: OutlineInputBorder(),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Theme.of(context).primaryColor,
                                                  width: 2,
                                                )
                                            )
                                        ),
                                      ),
                                      SizedBox(height: 20,),
                                      TextFormField(
                                        controller: _passwordTextController,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Vui lòng nhập mật khẩu';
                                          }
                                          if (value.length < 6) {
                                            return 'Mật khẩu quá ngắn';
                                          }
                                          return null;
                                        },
                                        obscureText: false,
                                        decoration: InputDecoration(
                                            labelText: 'Mật khẩu',
                                            prefixIcon: Icon(Icons.vpn_key_rounded),
                                            contentPadding: EdgeInsets.only(left: 20, right: 20),
                                            border: OutlineInputBorder(),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Theme.of(context).primaryColor,
                                                  width: 2,
                                                )
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20,),
                                Row(
                                  children: [
                                    Expanded(
                                      child: FlatButton(
                                        onPressed: () {
                                          if (_formKey.currentState.validate()) {
                                            _login(
                                              username: _usernameTextController.text,
                                              password: _passwordTextController.text,
                                            );
                                          }
                                        },
                                        color: Theme.of(context).primaryColor,
                                        child: Text(
                                          'Đăng nhập',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10,),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
              );
            }

            // Otherwise, show something whilst waiting for initialization to complete
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        )
    );
  }
}