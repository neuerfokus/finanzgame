// ignore_for_file: avoid_print
import 'dart:io';

void main() {
  final data = File('coverage/lcov.info').readAsStringSync();
  final files = data.split(RegExp(r'\nSF:'));
  var total = 0;
  var hit = 0;
  final fileStats = <String>[];

  for (final f in files) {
    final allMatches = RegExp(r'DA:\d+,(\d+)').allMatches(f).toList();
    final fTotal = allMatches.length;
    final fHit = allMatches.where((m) => m.group(1) != '0').length;
    total += fTotal;
    hit += fHit;

    final name = f.split('\n').first.trim();
    if ((name.contains('domain') || name.contains('core')) && fTotal > 0) {
      fileStats.add(
          '  $name: $fHit/$fTotal = ${(fHit / fTotal * 100).toStringAsFixed(1)}%');
    }
  }

  print('Coverage by file (domain + core):');
  for (final s in fileStats) {
    print(s);
  }
  if (total > 0) {
    print(
        '\nOVERALL: $hit/$total = ${(hit / total * 100).toStringAsFixed(1)}%');
  } else {
    print('No coverage data found.');
  }
}
