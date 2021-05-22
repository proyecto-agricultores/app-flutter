import 'package:agricultores_app/models/userModel.dart';
import 'package:agricultores_app/services/userFilterService.dart';
import 'package:agricultores_app/widgets/cultivos_orders/cultivoOrder.dart';
import 'package:agricultores_app/widgets/general/cosechaGreenButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;
import '../userProfileScreen.dart';

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
  bool isLoading = false;

  _CultivoAndOrderScreenState(
    this.pubOrOrderId,
    this.titulo,
    this.role,
    this.isMyCultivoOrOrder,
    this.invertRole,
  );

  Widget viewProfileButton(int userId) {
    return CosechaGreenButton(
      onPressed: this.isLoading
          ? null
          : () async {
              setState(() {
                isLoading = true;
              });
              User user = await UserFilterService.getUserById(userId);
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserProfileScreen(
                            id: user.id,
                            firstName: user.firstName,
                            lastName: user.lastName,
                            role: user.role,
                            profilePicture: user.profilePicture,
                            ubigeo: user.ubigeo,
                            phoneNumber: user.phoneNumber,
                            latitude: user.latitude,
                            longitude: user.longitude,
                          )));
              setState(() {
                isLoading = false;
              });
            },
      text: "Ver perfil",
      isLoading: false,
    );
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
              SizedBox(height: 30),
              CultivoOrder(
                pubOrOrderId: pubOrOrderId,
                isMyCultivoOrOrder: isMyCultivoOrOrder,
                roleActual: roleActual,
                role: role,
                titulo: titulo,
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
