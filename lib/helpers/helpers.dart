/// This will generate a random id based on the current time
int generateID() {

  final date = DateTime.now();
  final secondsNow = date.year*31104000+date.month*2592000+date.day*86400+date.hour*3600+date.minute*60+date.second+date.microsecond;

  return secondsNow - 62832762060;
}
