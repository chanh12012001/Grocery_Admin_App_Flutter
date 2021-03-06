import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:grocery_admin_app_flutter/services/sidebar.dart';
import 'package:grocery_admin_app_flutter/widgets/vendor/vendor_datatable_widget.dart';

class VendorScreen extends StatefulWidget {
  static const String id = 'vendor-screen';
  @override
  _VendorScreenState createState() => _VendorScreenState();
}

class _VendorScreenState extends State<VendorScreen> {
  SideBarWidget _sideBar = SideBarWidget();


  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black54,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'Grocery App Dashboard',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      sideBar: _sideBar.sideBarMenus(context, VendorScreen.id),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quản lý người bán hàng',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
              Text('Quản lý tất cả các hoạt động của người bán hàng'),
              Divider(thickness: 5,),
              VendorDataTable(),
              Divider(thickness: 5,),
            ],
          ),
        ),
      ),
    );
  }
}
