import 'dart:math';
const MIN_DB_VALUE = -60.0;
double convertRMSTodBFullScale(double rms) {
  double db = 20 * log(rms / 32768) / ln10;
  print(db);
  return db.isFinite ? max(MIN_DB_VALUE, db) : MIN_DB_VALUE;
}
