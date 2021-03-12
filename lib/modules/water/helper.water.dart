import 'package:utm_vinculacion/modules/water/provider.water.dart';

Future<void> restoreProgressCallback() async {

  final waterModel = new WaterProvider();

  await waterModel.restoreProgress();
}