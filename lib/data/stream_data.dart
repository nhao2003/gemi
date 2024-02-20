enum StreamDataState {
  get,
  insert,
  update,
  delete,
}

class StreamData<T> {
  final StreamDataState state;
  final List<T> data;

  StreamData({
    required this.state,
    required this.data,
  });
}
