import 'dart:html';
import 'package:firebase/firebase.dart' as fb;
import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:grocery_admin_app_flutter/services/firebase_services.dart';

class CategoryCreateWidget extends StatefulWidget {
  @override
  _CategoryCreateWidgetState createState() => _CategoryCreateWidgetState();
}

class _CategoryCreateWidgetState extends State<CategoryCreateWidget> {

  FirebaseServices _services = FirebaseServices();
  var _fileNameTextController = TextEditingController();
  var _categoryNameTextController = TextEditingController();
  bool  _visible = false;
  bool _imageSelected = true;
  String _url;

  @override
  Widget build(BuildContext context) {

    ArsProgressDialog progressDialog = ArsProgressDialog(
        context,
        blur: 2,
        backgroundColor: Color(0x33000000).withOpacity(.3),
        animationDuration: Duration(milliseconds: 500)
    );

    return Container(
      color: Colors.grey,
      width: MediaQuery.of(context).size.width,
      height: 80,
      child: Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: Row(
          children: [

            Visibility(
              visible: _visible,
              child: Container(
                child: Row(
                  children: [
                    SizedBox(
                      width: 200,
                      height: 30,
                      child: TextField(
                        controller: _categoryNameTextController,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Không có tên category đưa ra',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.only(left: 20)
                        ),
                      ),
                    ),
                    AbsorbPointer(
                      absorbing: true,
                      child: SizedBox(
                        width: 200,
                        height: 30,
                        child: TextField(
                          controller: _fileNameTextController,
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Không có hình ảnh được chọn',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.only(left: 20)
                          ),
                        ),
                      ),
                    ),
                    FlatButton(
                      child: Text('Upload Hình ảnh', style: TextStyle(color: Colors.white),),
                      onPressed: () {
                        uploadStorage();
                      },
                      color: Colors.black54,
                    ),
                    SizedBox(width: 10,),
                    AbsorbPointer(
                      absorbing: _imageSelected,
                      child: FlatButton(
                        child: Text('Lưu category mới', style: TextStyle(color: Colors.white),),
                        onPressed: () {
                          if (_categoryNameTextController.text.isEmpty){
                            return _services.showMyDialog(
                              context: context,
                              title: 'Thêm category mới',
                              message: 'Tên category mới không được đưa ra'
                            );
                          }
                          progressDialog.show();
                          _services.uploadCategoryImageToDb(_url, _categoryNameTextController.text).then((downloadUrl) {
                            if (downloadUrl!=null){
                              progressDialog.dismiss();
                              _services.showMyDialog(
                                title: 'Category mới',
                                message: 'Lưu Category mới thành công',
                                context: context,
                              );
                            }
                          });
                          _categoryNameTextController.clear();
                          _fileNameTextController.clear();
                        },
                        color: _imageSelected ? Colors.black12 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: _visible ? false : true,
              child: FlatButton(
                color: Colors.black54,
                child: Text('Thêm mới Category', style: TextStyle(color: Colors.white),),
                onPressed: () {
                  setState(() {
                    _visible = true;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void uploadImage({@required Function(File file) onSelected}) {
    InputElement uploadInput = FileUploadInputElement()..accept = 'image/*';
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

  void uploadStorage() {
    final dateTime = DateTime.now();
    final path = 'categoryImage/$dateTime';
    uploadImage(onSelected: (file){
      if (file!=null){
        setState(() {
          _fileNameTextController.text = file.name;
          _imageSelected = false;
          _url = path;
        });
        fb.storage().refFromURL('gs://flutter-grocery-app-6f618.appspot.com').child(path).put(file);
      }
    });
  }
}
