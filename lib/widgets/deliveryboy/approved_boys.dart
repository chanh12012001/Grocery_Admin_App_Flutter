import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:grocery_admin_app_flutter/services/firebase_services.dart';

class ApprovedBoys extends StatefulWidget {
  @override
  _ApprovedBoysState createState() => _ApprovedBoysState();
}

class _ApprovedBoysState extends State<ApprovedBoys> {

  bool status = false;
  FirebaseServices _services  = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: _services.boys.where('accVerified',isEqualTo: true).snapshots(),
        builder: (context,snapshot){
          if(snapshot.hasError){
            return Text('Đã xảy ra sự cố');
          }
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }

          QuerySnapshot snap = snapshot.data;

          if(snap.size==0){
            return Center(child: Text('Không có người giao hàng nào trong danh sách được chấp nhận'),);
          }
          return SingleChildScrollView(
            child: DataTable(
              showBottomBorder: true,
              dataRowHeight: 60,
              headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
              columns: <DataColumn>[
                DataColumn(label: Expanded(child: Text('Hình ảnh')),),
                DataColumn(label: Text('Tên'),),
                DataColumn(label: Text('Email'),),
                DataColumn(label: Text('SĐT'),),
                DataColumn(label: Text('Địa chỉ'),),
                DataColumn(label: Text('Hoạt động'),),
                //DataColumn(label: Text('Actions'),),
              ],
              rows: _boysList(snapshot.data,context),
            ),
          ) ;
        },
      ),
    );
  }

  List<DataRow>_boysList(QuerySnapshot snapshot,context){
    List<DataRow> newList = snapshot.docs.map((DocumentSnapshot document){
      if(document != null){
        return DataRow(
            cells: [
              DataCell(
                  Container(
                    width: 60,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(document['imageUrl'],fit: BoxFit.contain,),
                    ),)
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
                FlutterSwitch(
                  activeText: "Đã chấp nhận",
                  inactiveText: "Chưa chấp nhận",
                  value: document['accVerified'],
                  valueFontSize: 10.0,
                  width: 110,
                  borderRadius: 30.0,
                  showOnOff: true,
                  onToggle: (val) {
                    _services.updateBoyStatus(
                      id: document.id,
                      context: context,
                      status: false,
                    );
                  },
                ),
              )
            ]
        );
      }
    }).toList();
    return newList;
  }
}
