import 'dart:io';

void main() async {
  print('Enter the name of the text file in this folder to read');
  String? inp = stdin.readLineSync();

  if (inp == null) {
    print('Enter a file name please!');
  }

  try {
    File f = File(inp!);
    List<String> lines = f.readAsLinesSync();
    String fname = inp.substring(0, inp.length - 4) + '2.txt';
    File out = await File('.\\$fname').create();

    int count = 1;

    for (String s in lines) {
      out = await out.writeAsString('$count: $s\n', mode: FileMode.append);
      count++;
    }

    print('New file has been made and edited.');
  } on Exception {
    print('That file does not exist in this folder!');
    return;
  }
}
