import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  static const routeName = '/history';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text('History'),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 12.w, top: 12.h, right: 12.w),
        child: Container(),
      ),
    );
  }
}
