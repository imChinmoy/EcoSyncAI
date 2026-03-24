class Either<L, R> {
  final L? _left;
  final R? _right;

  const Either._({L? left, R? right}) : _left = left, _right = right;

  const Either.left(L left) : this._(left: left);
  const Either.right(R right) : this._(right: right);

  bool get isLeft => _left != null;
  bool get isRight => _right != null;

  L get leftValue {
    if (_left == null) {
      throw StateError('Either does not contain a Left value.');
    }
    return _left as L;
  }

  R get rightValue {
    if (_right == null) {
      throw StateError('Either does not contain a Right value.');
    }
    return _right as R;
  }

  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight) {
    if (isLeft) return onLeft(leftValue);
    return onRight(rightValue);
  }
}
