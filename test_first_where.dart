void main() {
  List<dynamic> list = [
    {'email': 'hello'},
  ];

  var result = list.firstWhere(
    (u) => u is Map && u['email'] == 'world',
    orElse: () => null,
  );

  print("Result: $result");
}
