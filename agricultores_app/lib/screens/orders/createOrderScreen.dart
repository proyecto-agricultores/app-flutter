import 'package:agricultores_app/models/priceUnitModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:agricultores_app/models/supplyModel.dart';
import 'package:agricultores_app/services/supplyService.dart';
import 'package:agricultores_app/models/areaUnitModel.dart';

class CreateOrderScreen extends StatefulWidget {
  CreateOrderScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CreateOrderScreenState createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {

  int _selectedSupply;
  String _selectedAreaUnit = 'hm2';
  String _selectedPriceUnit = 'sac';
  static final TextInputFormatter floatNumbers =
      FilteringTextInputFormatter.allow(RegExp(r'[+-]?([0-9]*[.])?[0-9]+'));
  static final TextInputFormatter digitsOnly =
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));
  TextEditingController quantityController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();
  DateTime _sowingDate = DateTime.now();
  DateTime _harvestDate = DateTime.now();
  final _harvestDateController = new TextEditingController();
  bool _isLoading = false;

  final _formKey = new GlobalKey<FormState>();

  Widget _appBar() {
    return SliverAppBar(
      floating: true,
      snap: true,
      expandedHeight: MediaQuery.of(context).size.height * 0.1,
      backgroundColor: Colors.indigo,
      title: Text("Creando orden"),
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(60),
          bottomRight: Radius.circular(60),
        ),
      )
    );
  }

  Widget _supplyDropdown(List<Supply> supplies) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      child: DropdownButtonFormField(
        isExpanded: true,
        value: _selectedSupply,
        onChanged: (newValue) {
          setState(() {
            _selectedSupply = newValue;
          });
        },
        items: supplies.map((supply) {
          return DropdownMenuItem(
            child: new Text(
              supply.name,
              textAlign: TextAlign.center,
            ),
            value: supply.id,
          );
        }).toList(),
        decoration: new InputDecoration(
          labelText: "Insumo",
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        ),
      )
    );
  }

  Widget _quantityInput() {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Cultivo',
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          )
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 1,
              child: TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [floatNumbers],
                controller: quantityController,
                textAlign: TextAlign.center,
                validator: (value) {
                  return value.isEmpty ? 'Ingrese una cantidad' : null;
                },
                decoration: new InputDecoration(
                  //labelText: "Total",
                  contentPadding: EdgeInsets.zero
                ),
              )
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.05),
            Expanded(
              flex: 3,
              child: Container(
                child: DropdownButton(
                  isExpanded: true,
                  value: _selectedAreaUnit,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedAreaUnit = newValue;
                    });
                  },
                  items: AreaUnit.getAreaUnits().map((areaUnit) {
                    return DropdownMenuItem(
                      child: new Text(
                        areaUnit.fullName,
                        textAlign: TextAlign.center,
                      ),
                      value: areaUnit.abbreviation
                    );
                  }).toList(),
                ),
              )
            )
          ]
        )
      ]
    );
  }

  Widget _priceInput() {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Precio en nuevos soles (S/.)',
            style: TextStyle(
              fontWeight: FontWeight.bold
            )
          )
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 1,
              child: TextFormField(
                controller: priceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [digitsOnly],
                validator: (value) {
                  return value.isEmpty ? 'Ingrese el precio' : null;
                },
                decoration: new InputDecoration(
                )
              )
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.05),
            Expanded(
              flex: 3,
              child: Container(
                child: DropdownButton(
                  isExpanded: true,
                  value: _selectedPriceUnit,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedPriceUnit = newValue;
                    });
                  },
                  items: PriceUnit.getPriceUnits().map((priceUnit) {
                    return DropdownMenuItem(
                      child: new Text(
                        priceUnit.fullName,
                        textAlign: TextAlign.center,
                      ),
                      value: priceUnit.abbreviation
                    );
                  }).toList(),
                ),
              )
            )
          ],
        )
      ],
    );
  }

  Widget _nextButton() {
    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18)
      ),
      onPressed: () async {
        if (_formKey.currentState.validate() && this._selectedSupply != null) {
          setState(() {
            this._isLoading = true;
          });
        }
      },
      color: Colors.green[400],
      child: this._isLoading
        ? LinearProgressIndicator(
            minHeight: 5,
        )
        : Text(
            'Crear',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16
            )
        )
    );
  }

  Widget _loading() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      child: LinearProgressIndicator()
    );
  }

  Widget _renderMainWidget(AsyncSnapshot snapshot) {
    return CustomScrollView(
      slivers: [
        this._appBar(),
        SliverToBoxAdapter(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                      snapshot.hasData 
                      ? this._supplyDropdown(snapshot.data) 
                      : this._loading(),
                      this._quantityInput(),
                      this._priceInput(),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                      Divider(color: Colors.grey[800]),
                      this._calendarioChristian(),
                      Divider(color: Colors.grey[800]),
                      this._nextButton(),
                      this._cancelButton()
                    ]
                  )
                )
              )
            ],
          )
        )
      ]
    );
  }

  Widget _cancelButton() {
    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18)
      ),
      onPressed: () async {
        Navigator.pop(context);
      },
      color: Colors.red[400],
      child: this._isLoading
        ? LinearProgressIndicator(
            minHeight: 5,
        )
        : Text(
            'Cancelar',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16
            )
        )
    );
  }

  _selectDate(BuildContext context, DateTime selectedDate,
      TextEditingController _dateController) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate)
      setState(
        () {
          selectedDate = picked;
          var date =
              "${picked.toLocal().day}-${picked.toLocal().month}-${picked.toLocal().year}";
          _dateController.text = date;
        },
      );
  }

  Widget _calendarioChristian() {
    return GestureDetector(
      onTap: () => _selectDate(
        context,
        _harvestDate,
        _harvestDateController,
      ),
      child: AbsorbPointer(
        child: TextFormField(
          // onSaved: (val) {
          //   task.date = selectedHarvestDate;
          // },
          controller: _harvestDateController,
          decoration: InputDecoration(
            labelText: "Fecha de Cosecha",
            icon: Icon(Icons.calendar_today),
          ),
          validator: (value) {
            if (value.isEmpty)
              return "Please enter a date for your task";
            return null;
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(),
      body: FutureBuilder(
        future: SupplyService.getSupplies(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text('has error');
          } else {
            return this._renderMainWidget(snapshot);
          }
        },
      )
    );
  }
}