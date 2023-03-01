class NavigationState {
  final int currentIndex;
  const NavigationState({
    required this.currentIndex,
  });

  NavigationState copyWith({
    int? currentIndex,
  }) {
    return NavigationState(
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  String toString() => 'NavigationState(currentIndex: $currentIndex)';
}
