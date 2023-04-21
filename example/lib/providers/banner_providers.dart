import 'package:flutter/material.dart';

/*Nota.- importantisimo actualiza solo donde haya Consumer<BannerProvider>( y no todo el el arbol de widgets)
1. isBannerShow es el obs y Consumer<BannerProvider> el Obx.
2. BannerProvider seria: el GetxController. Solo que el manejo de estados se deberia hacer en los StateFullWidget

3. Tambien BannerProvider puede tener muchas otra propiedades!! 
Para que tenga efecto en los Consumer<BannerProvider>(... utilizar notifyListeners();*/

class BannerProvider extends ChangeNotifier {
  bool _isBannerShow = false;
  bool get isBannerShow => _isBannerShow;
  set isBannerShow(bool value) {
    _isBannerShow = value;
    notifyListeners();
  }
}
