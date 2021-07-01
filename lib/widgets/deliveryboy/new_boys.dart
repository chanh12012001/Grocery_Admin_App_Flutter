import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:grocery_admin_app_flutter/services/firebase_services.dart';

class NewBoys extends StatefulWidget {
  @override
  _NewBoysState createState() => _NewBoysState();
}

class _NewBoysState extends State<NewBoys> {

  bool status = false;
  FirebaseServices _services = FirebaseServices();

  @override
  Widget build(BuildContext context) {

    return Container(
      child: StreamBuilder(
        stream: _services.boys.where('accVerified', isEqualTo: false).snapshots(),
        builder: (context, snapshot){
          if (snapshot.hasError){
            return Text('Đã xảy ra lỗi');
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          QuerySnapshot snap = snapshot.data;

          if (snap.size == 0){
            return Center(child: Text('No New Delivery boys to list'),);
          }
          return SingleChildScrollView(
            child: DataTable(
              showBottomBorder: true,
              dataRowHeight: 60,
              headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
              columns: <DataColumn>[
                DataColumn(label: Expanded(child: Text('Hình ảnh'))),
                DataColumn(label: Text('Tên')),
                DataColumn(label: Text('Email')),
                DataColumn(label: Expanded(child: Text('Số điện thoại'))),
                DataColumn(label: Text('Địa chỉ')),
                DataColumn(label: Text('Hoạt động')),
              ],
              rows: _boysList(snapshot.data, context),
            ),
          );
        },
      ),
    );
  }

  List<DataRow>_boysList(QuerySnapshot snapshot, context){

    List<DataRow> newList = snapshot.docs.map((DocumentSnapshot document){
      if (document != null){
        return DataRow(
          cells: [
            DataCell(
              Container(
                width: 60,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: document['imageUrl'] == '' ? Icon(Icons.person, size: 40,) : Image.network(document['imageUrl'], fit: BoxFit.contain,),
                ),
              ),
            ),
            DataCell(
                Text(document['name'])
            ),
            DataCell(
                Text(document['email'])
            ),
            DataCell(
               Text(document['mobile'])
            ),
            DataCell(
                Text(document['address'])
            ),
            DataCell(
              document['mobile'] == '' ? Text('Chưa đăng kí') :
              FlutterSwitch(
                activeText: "Approved",
                inactiveText: "Not Approved",
                value: document['accVerified'],
                valueFontSize: 10.0,
                width: 110,
                borderRadius: 30.0,
                showOnOff: true,
                onToggle: (val) {
                  _services.updateBoyStatus(id: document.id, context: context, status: true);
                },
              ),
            )
          ],
        );
      }
    }).toList();
    return newList;
  }
}
