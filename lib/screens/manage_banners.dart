import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:grocery_admin_app_flutter/services/sidebar.dart';
import 'package:grocery_admin_app_flutter/widgets/banner/banner_upload_widget.dart';
import 'package:grocery_admin_app_flutter/widgets/banner/banner_widget.dart';

class BannerScreen extends StatelessWidget {
  static const String id = 'banner-screen';



  @override
  Widget build(BuildContext context) {

    SideBarWidget _sideBar = SideBarWidget();


    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black54,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Grocery App Dashboard',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      sideBar: _sideBar.sideBarMenus(context, BannerScreen.id),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quản lý hình ảnh quảng cáo',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
              Text('Thêm / Xóa hình ảnh quảng cáo màn hình chính'),
              Divider(thickness: 5,),
              //Banners
              BannerWidget(),
              Divider(thickness: 5,),
              BannerUploadWidget(),
            ],
          ),
        ),
      ),
    );
  }

}
