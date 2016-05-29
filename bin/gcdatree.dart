library gcov.bin.gcnotree;

import 'package:args/args.dart';
import 'package:gcov/gcov/gcda/reader/reader.dart';
import 'package:gcov/gcov/writerFile.dart';

ArgParser lFlags;

void printUsage() {
  print("Usage:");
  List<String> lLines = lFlags.usage.split("\n");

  for(String cLine in lLines) {
    print("\t"+cLine);
  }
}

int main(List<String> aArgs) {
  lFlags = new ArgParser()
    ..addOption('gcda', abbr: 'g', help: 'GCDA file to parse')
    ..addOption('func', abbr: 'f', help: 'When specified, it only shows specified functions.',
        splitCommas: true, allowMultiple: true)
    ..addOption('no-func', abbr: 'n', help: 'When specified, it hides specified functions.',
        splitCommas: true, allowMultiple: true);

  ArgResults lResults;

  try {
    lResults = lFlags.parse(aArgs);
  } on FormatException catch(e) {
    print(e);
    print("\n");
    printUsage();
    return 1;
  }

  if(!lResults.options.contains("gcda")) {
    printUsage();
    return 1;
  }

  Set<String> lShow = new Set<String>();
  if(lResults["func"] is List<String>) {
    lShow = (lResults["func"] as List).toSet();
  }

  Set<String> lHide = new Set<String>();
  if(lResults["no-func"] is List<String>) {
    lHide = (lResults["no-func"] as List).toSet();
  }

  GcovReadHelperFile lHelper = new GcovReadHelperFile(false, lResults["gcda"]);
  GcdaReader lReader = new GcdaReader(false, lHelper);

  //TODO GcnoProgram lProg = lReader.parse();
  lReader.parse();

  //TODO print(lProg.print(aShowOnly: lShow, aHide: lHide));

  return 0;
}