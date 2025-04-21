import 'package:ar_object_flutter_app/model/ar_object.dart';
import 'package:ar_object_flutter_app/model/shop_card_model.dart';
import 'package:ar_object_flutter_app/screens/ar_object_screen.dart';
import 'package:ar_object_flutter_app/utils/colors.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<ShopCardModel> mycard = [
    ShopCardModel(Icons.apartment, 'Rat', false, ARObjects.rat, false),
    ShopCardModel(Icons.home, 'Chicken', false, ARObjects.chicken, true),
    ShopCardModel(Icons.home, 'Myth', false, ARObjects.myth, true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Let's shopping!",
              style: TextStyle(fontSize: 24, color: AppColors.black54),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: mycard
                    .map(
                      (e) => InkWell(
                        onTap: () => onTap(e),
                        child: Card(
                          color: e.isActive ? AppColors.mainColor : null,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                e.icon,
                                size: 50,
                                color: e.isActive
                                    ? AppColors.white
                                    : AppColors.mainColor,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                e.title,
                                style: TextStyle(
                                    color: e.isActive
                                        ? AppColors.white
                                        : AppColors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          )
        ],
      ),
    );
  }

  void onTap(ShopCardModel e) {
    setState(() {
      e.isActive = !e.isActive;
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ARObjectsScreen(
                  object: e.object,
                  isLocal: e.isLocal,
                ))).then((value) {
      setState(() {
        e.isActive = !e.isActive;
      });
    });
  }
}
