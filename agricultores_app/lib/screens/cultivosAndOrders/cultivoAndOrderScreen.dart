import 'package:agricultores_app/widgets/cultivos_orders/cultivoOrder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;

class CultivoAndOrderScreen extends StatefulWidget {
  final int cultivoId;
  final String titulo;
  final String role;
  final bool isMyCultivoOrOrder;
  final bool invertRole;

  const CultivoAndOrderScreen({
    Key key,
    @required this.cultivoId,
    @required this.titulo,
    @required this.role,
    @required this.isMyCultivoOrOrder,
    @required this.invertRole,
  }) : super(key: key);

  @override
  _CultivoAndOrderScreenState createState() => _CultivoAndOrderScreenState(
        cultivoId,
        titulo,
        role,
        isMyCultivoOrOrder,
        invertRole,
      );
}

class _CultivoAndOrderScreenState extends State<CultivoAndOrderScreen> {
  final int pubOrOrderId;
  final String titulo;
  final role;
  final bool isMyCultivoOrOrder;
  final bool invertRole;

  _CultivoAndOrderScreenState(
    this.pubOrOrderId,
    this.titulo,
    this.role,
    this.isMyCultivoOrOrder,
    this.invertRole,
  );

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );

    bool roleActual = this.role == 'ag' && !invertRole;

    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CultivoOrder(
                pubOrOrderId: pubOrOrderId,
                isMyCultivoOrOrder: isMyCultivoOrOrder,
                roleActual: roleActual,
                role: role,
                titulo: titulo,
              )
            ],
          ),
        ),
      ),
    );
  }
}
