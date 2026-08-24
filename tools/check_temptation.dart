// ignore_for_file: avoid_print
import 'dart:math';

void main() {
  const salt = 'temptation';
  final saltHash = salt.codeUnits.fold(0, (prev, cu) => prev * 31 + cu);
  print('Salt hash: $saltHash');
  for (var d = 0; d < 50; d++) {
    final rng = Random(d ^ saltHash);
    final val = rng.nextDouble();
    print('day $d: ${val.toStringAsFixed(4)} fires=${val < 0.08}');
  }
}
