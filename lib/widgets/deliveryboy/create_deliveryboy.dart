import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:grocery_admin_app_flutter/services/firebase_services.dart';

class CreateNewBoyWidget extends StatefulWidget {
  @override
  _CreateNewBoyWidgetState createState() => _CreateNewBoyWidgetState();
}

class _CreateNewBoyWidgetState extends State<CreateNewBoyWidget> {

  FirebaseServices _services = FirebaseServices();
  var emailText = TextEditingController();
  var passwordText = TextEditingController();
  bool _visible = false;

  @override
  Widget build(BuildContext context) {

    ArsProgressDialog progressDialog = ArsProgressDialog(
        context,
        blur: 2,
        backgroundColor: Color(0x33000000).withOpacity(.3),
        animationDuration: Duration(milliseconds: 500)
    );

    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.grey,
      height: 80,
      child: Row(
        children: [
          Visibility(
            visible: _visible ? false : true,
            child: Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Container(
                child: FlatButton(
                  child: Text(
                    'Tạo mới Delivery Boy',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    setState(() {
                      _visible = true;
                    });
                  },
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          Visibility(
            visible: _visible,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Container(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 200,
                        height: 30,
                        child: TextField(
                          //todo: Eamil validator
                          controller: emailText,
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Email ID',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.only(left: 20)
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      SizedBox(
                        width: 200,
                        height: 30,
                        child: TextField(
                          controller: passwordText,
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Password',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.only(left: 20)
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      FlatButton(
                        child: Text('Lưu', style: TextStyle(color: Colors.white),),
                        onPressed: () {
                          if (emailText.text.isEmpty){
                            return _services.showMyDialog(
                                context: context,
                                title: 'Email ID',
                                message: 'Vui lòng nhập Email'
                            );
                          }
                          if (passwordText.text.isEmpty){
                            return _services.showMyDialog(
                                context: context,
                                title: 'Mật khẩu',
                                message: 'Vui lòng nhập mật khẩu'
                            );
                          }
                          if (passwordText.text.length < 6){
                            return _services.showMyDialog(
                                context: context,
                                title: 'Mật khẩu',
                                message: 'Mật khẩu quá ngắn (Tối da 6 ký tự)'
                            );
                          }
                          progressDialog.show();
                          _services.saveDeliveryBoys(emailText.text, passwordText.text).whenComplete((){
                            emailText.clear();
                            passwordText.clear();
                            progressDialog.dismiss();
                            _services.showMyDialog(
                              context: context,
                              title: 'Lưu Delivery Boy',
                              message: 'Lưu thành công'
                            );
                          });
                        },
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
