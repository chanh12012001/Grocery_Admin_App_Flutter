import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase/firebase.dart' as db;
import 'package:flutter/material.dart';

class FirebaseServices {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference banners = FirebaseFirestore.instance.collection('slider');
  CollectionReference vendors = FirebaseFirestore.instance.collection('vendors');
  CollectionReference category = FirebaseFirestore.instance.collection('category');
  CollectionReference boys = FirebaseFirestore.instance.collection('boys');
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<DocumentSnapshot> getAdminCredentials(id) {
    var result = FirebaseFirestore.instance.collection('Admin').doc(id).get();
    return result;
  }

  //-------------------Upload and delete Banner to DB-------------------
  Future<String> uploadBannerImageToDb(String url) async {
    String downloadUrl = await storage.ref(url).getDownloadURL();
    if (downloadUrl != null) {
      firestore.collection('slider').add({
        'image' : downloadUrl,
      });
    }
    return downloadUrl;
  }

  deleteBannerImageFromDb(id) async {
    firestore.collection('slider').doc(id).delete();
  }
  //-------------------Upload and delete Banner to DB-------------------



  //-------------------Update Vendor-------------------------
  updateVendorStatus({id, status}) async {
    vendors.doc(id).update({'accVerified': status ? false : true});
  }

  updateTopPickedVendor({id, status}) async {
    vendors.doc(id).update({'isTopPicked': status ? false : true});
  }
  //-------------------Update Vendor-------------------------



  //----------------upload Category Image To Db-------------------
  Future<String> uploadCategoryImageToDb(String url, catName) async {
    var dowloadUrl = await db
        .storage()
        .refFromURL('gs://flutter-grocery-app-6f618.appspot.com')
        .child(url)
        .getDownloadURL();
    if (dowloadUrl != null) {
      firestore.collection('category').doc(catName).set({
        'image': dowloadUrl.toString(),
        'name': catName.toString(),
      });
    }
  }
  //----------------upload Category Image To Db-------------------


  //----------------save new a Deliver Boy-------------------
  Future<void> saveDeliverBoys(email, password) async {
    boys.doc(email).set({
      'accVerified': false,
      'address': '',
      'email': email,
      'imageUrl': '',
      'location': GeoPoint(0, 0),
      'mobile': '',
      'name': '',
      'password': password,
      'uid': ''
    });
  }
  //----------------save new a Deliver Boy-------------------



  //-----------------update delivery boy approved status--------------
  updateBoyStatus({id, context, status}) {
    ArsProgressDialog progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0xFF84c225).withOpacity(.3),
        animationDuration: Duration(milliseconds: 500));
    progressDialog.show();
    // Create a reference to the document the transaction will use
    DocumentReference documentReference =
    FirebaseFirestore.instance.collection('boys').doc(id);

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      // Get the document
      DocumentSnapshot snapshot = await transaction.get(documentReference);

      if (!snapshot.exists) {
        throw Exception("Người dùng không tồn tại!");
      }

      // Update the follower count based on the current count
      // Note: this could be done without a transaction
      // by updating the population using FieldValue.increment()

      // Perform an update on the document
      transaction.update(documentReference, {'accVerified': status});
    }).then((value) {
      progressDialog.dismiss();
      showMyDialog(
          title: 'Trạng thái người giao hàng',
          message: status == true
              ? "Đã phê duyệt trạng thái phê duyệt của người giao hàng."
              : "Chưa phê duyệt trạng thái phê duyệt của người giao hàng.",
          context: context);
    }).catchError((error) => showMyDialog(
      context: context,
      title: 'Trạng thái người giao hàng',
      message: "Cập nhật trạng thái giao hàng thất bại: $error",
    ));
  }
  //-----------------update delivery boy approved status--------------



  //-----------------dialog confirm delete Banner -------------------
  Future<void> confirmDeleteDialog({title, message, context, id}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, //người dùng phải nhấn vào button
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                deleteBannerImageFromDb(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  //-----------------dialog confirm delete Banner -------------------



  //-------------------------Show dialog------------------------------
  Future<void> showMyDialog({title, message, context}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, //người dùng phải nhấn vào button
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
//-------------------------Show dialog------------------------------

}
