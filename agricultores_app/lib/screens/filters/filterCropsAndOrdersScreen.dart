import 'package:agricultores_app/widgets/cultivos_orders/supplyDropdown.dart';
import 'package:agricultores_app/widgets/general/divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FilterCropsAndOrdersScreen extends StatefulWidget {

  FilterCropsAndOrdersScreen({this.title, this.role});

  final title;
  final role;

  @override
  _FilterCropsAndOrdersScreenState createState() => _FilterCropsAndOrdersScreenState(title: this.title);
}

class _FilterCropsAndOrdersScreenState extends State<FilterCropsAndOrdersScreen> {

  _FilterCropsAndOrdersScreenState({this.title, this.role});

  final title;
  final _formKey = new GlobalKey<FormState>();
  final role;
  
  int departmentID;
  int regionID;
  int supplyID;

  updateSupplyID(newValue) {
    setState(() {
      this.supplyID = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    return Scaffold(
      appBar: AppBar(title: Text(this.title),),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
              child: Form(
                key: this._formKey,
                child: Column(
                  children: [
                    SupplyDropdown(
                      supplyID: this.supplyID,
                      updateSupply: this.updateSupplyID,
                    ),
                    CosechaDivider(),
                  ],
                )
              )
            )
          )
        ]
      )
    );
  }
}