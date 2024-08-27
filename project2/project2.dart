void main() {
  print('func1: Increasing order for 1, 2, 3');
  print(func1(1, 2, 3));
  print('func1: Increasing order for 7, 8, 4');
  print(func1(7, 8, 4));
  print('-----------------------');
  print('func2: Source = "Hello", target = "World"');
  print(func2(target: 'World', source: 'Hello'));
  print('func2: Source = "e", target = "eeeee"');
  print(func2(source: 'e', target: 'eeeee'));
  print('-----------------------');
  print('func3: Full name = "John Daversa"');
  Record r = func3(fullName: 'John Daversa');
  print(r.toString());
  print('-----------------------');
  print('func4: String = "Hello World!, defaults');
  print(func4('Hello World!'));
  print('func4: String = "Hello World!, reversed = true');
  print(func4('Hello World!', reverse: true));
  print(
      'func4: String = "hello world! i am a lower case sentence, capitalize = true');
  print(func4('hello world! i am a lower case sentence', capitalize: true));
  print('-----------------------');
  print('func5: List = ["Hello", "World!"], function is an uppercase function');
  List<String> lis = ['Hello', 'World!'];
  List<String> ret = func5(lis, (p0) => p0.toUpperCase());
  for (String s in ret) print(s);
  print('-----------------------');
}

bool func1(int a, int b, int c) {
  return a <= b && b <= c;
}

int func2({required String source, required String target}) {
  int count = 0;
  for (String c in source.split('')) {
    if (!target.contains(c)) count++;
  }
  return count;
}

Record func3({required String fullName}) {
  ({String firstName, String lastName}) r =
      (firstName: fullName.split(' ')[0], lastName: fullName.split(' ')[1]);
  return r;
}

String func4(String s, {bool capitalize = false, bool reverse = false}) {
  String ret = s;
  if (capitalize) ret = ret.substring(0, 1).toUpperCase() + ret.substring(1);
  if (reverse) ret = ret.split('').reversed.join();
  return ret;
}

List<String> func5(List<String> lis, String Function(String) func) {
  List<String> ret = List<String>.filled(lis.length, '');
  for (int i = 0; i < lis.length; i++) {
    ret[i] = func(lis[i]);
  }
  return ret;
}
