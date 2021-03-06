import 'dart:html';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:grocery_admin_app_flutter/services/firebase_services.dart';


class BannerUploadWidget extends StatefulWidget {
  @override
  _BannerUploadWidgetState createState() => _BannerUploadWidgetState();
}

class _BannerUploadWidgetState extends State<BannerUploadWidget> {

  FirebaseServices _services = FirebaseServices();
  var _fileNameTextController = TextEditingController();
  bool _visible = false;
  bool _imageSelected = true;
  String _url;

  @override
  Widget build(BuildContext context) {

    ArsProgressDialog progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0xFF84c225).withOpacity(.3),
        animationDuration: Duration(
          milliseconds: 500,
        ),
    );


    return Container(
      color: Colors.grey,
      width: MediaQuery.of(context).size.width,
      height: 80,
      child: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Row(
          children: [
            Visibility(
              visible: _visible,
              child: Container(
                child: Row(
                  children: [
                    AbsorbPointer(
                      absorbing: true,
                      child: SizedBox(
                          width: 300,
                          height: 30,
                          child: TextField(
                            controller: _fileNameTextController,
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 1),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Không có hình ảnh nào được chọn',
                                border: OutlineInputBorder(),
                                contentPadding:
                                EdgeInsets.only(left: 20)),
                          )
                      ),
                    ),
                    FlatButton(
                      child: Text(
                        'Tải ảnh lên',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        uploadStorage();
                      },
                      color: Colors.black54,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    AbsorbPointer(
                      absorbing: _imageSelected,
                      child: FlatButton(
                        child: Text(
                          'Lưu ảnh',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          progressDialog.show();
                          _services.uploadBannerImageToDb(_url).then((downloadUrl) {
                            if(downloadUrl != null){
                              progressDialog.dismiss();
                              _services.showMyDialog(
                                  title: 'Ảnh quảng cáo mới',
                                  message: 'Lưu ảnh quảng cáo thành công',
                                  context: context
                              );
                            }
                          });
                        },
                        color: _imageSelected ? Colors.black12 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: _visible ?false : true,
              child: FlatButton(
                color: Colors.black54,
                child: Text('Thêm ảnh quảng cáo mới',
                    style: TextStyle(color: Colors.white)),
                onPressed: () {
                  setState(() {
                    _visible = true;
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }


  //----------------upload image form device---------------------
  void uploadImage({@required Function(File file) onSelected}) {
    InputElement uploadInput = FileUploadInputElement()
      ..accept = 'image/*'; //Chỉ tải ảnh lên
    uploadInput.click();
    uploadInput.onChange.listen((event) {
      final file = uploadInput.files.first;
      final reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) {
        onSelected(file);
      });
    });
  }
  //----------------upload image form device---------------------


  //----------upload selected image to Firebase storage--------------
  void uploadStorage() {
    final dateTime = DateTime.now();
    final path = 'bannerImage/$dateTime';
    uploadImage(onSelected: (file) {
      if (file != null) {
        setState(() {
          _fileNameTextController.text = file.name;
          _imageSelected=false;
          _url = path;
        });
        fb.storage()
            .refFromURL('gs://flutter-grocery-app-6f618.appspot.com')
            .child(path).put(file);
      }
    });
  }
  //----------upload selected image to Firebase storage--------------

}
