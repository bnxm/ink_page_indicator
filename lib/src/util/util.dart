export 'pressure_path.dart';

// ignore_for_file: public_member_api_docs

// Shrink animation values inside a specified range.
//
// E.g. lower = 0.2, upper = 0.4 and progress = 0.3 would return 0.5.
double interval(double lower, double upper, double progress) {
  assert(lower <= upper);

  if (progress > upper) return 1.0;
  if (progress < lower) return 0.0;

  return ((progress - lower) / (upper - lower)).clamp(0.0, 1.0);
}
