import 'package:flutter/material.dart';
import 'fixed_layer.dart';

class UpdateVersionPopup extends StatelessWidget
    with WidgetsBindingObserver {
  UpdateVersionPopup({Key? key}) : super(key: key) {
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  Future<bool> didPopRoute() async {
    FixedLayerState.singleton.closeDialog();
    WidgetsBinding.instance!.removeObserver(this);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      alignment: Alignment.center,
      child: Container(
        color: Colors.transparent,
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Container(
                color: Colors.white,
                height: 200,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                alignment: Alignment.center,
                child:
                Text('''
Click the Android back button, or slide the sidebar.

Expect: 
can intercept the back operation and the pop-up box is hidden.

Now: 
can't intercept properly and exit the app.
                '''),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
