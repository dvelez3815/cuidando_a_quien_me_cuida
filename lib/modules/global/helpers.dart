import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

/// This will generate a random id based on the current time
int generateID() {

  final date = DateTime.now();
  final secondsNow = date.year*31104000+date.month*2592000+date.day*86400+date.hour*3600+date.minute*60+date.second+date.microsecond;

  return secondsNow - 62832762060;
}

/// It Checks if there is any internet connection like wifi or mobile data
Future<bool> isInternet() async {
  final connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) return await DataConnectionChecker().hasConnection;
  if (connectivityResult == ConnectivityResult.wifi) return await DataConnectionChecker().hasConnection;
  
  return false;
}
