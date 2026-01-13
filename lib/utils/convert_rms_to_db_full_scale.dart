import 'dart:math';
const MIN_DB_VALUE = -60.0;
const MAX_DB_VALUE = 0.0;
double convertRMSTodBFullScale(double rms) {
  double db = min(20 * log(rms / 32768) / ln10, MAX_DB_VALUE);
  return db.isFinite ? max(MIN_DB_VALUE, db) : MIN_DB_VALUE;
}
