void main() {
  List<int> list = [1, 2, 3, 4, 5];
  final list2 = [...list];
  list2.add(6);
  print(list == list2);
}
