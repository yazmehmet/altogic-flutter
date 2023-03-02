part of altogic;

/// Altogic navigator observer to track route changes and get the current
/// route's context.
///
/// When [AltogicState] wraps the Application (MaterialApp, CupertinoApp,
/// etc.), [AltogicState]'s context does not contain a Router. Therefore, the
/// static Navigator.of method will not find a Navigator and will throw an
/// error.
class AltogicNavigatorObserver extends NavigatorObserver with ChangeNotifier {
  AltogicNavigatorObserver._();

  static final AltogicNavigatorObserver _instance =
      AltogicNavigatorObserver._();

  factory AltogicNavigatorObserver() => _instance;

  final Completer<BuildContext?> _contextCompleter = Completer();

  Future<BuildContext> ensureContext() async {
    if (_context != null) {
      return context!;
    }
    await _contextCompleter.future;
    assert(
        _context != null,
        'Context is not available. Use navigatorObserver in your '
        'MaterialApp and if you are using the context in '
        'application initialization, use ensureContext() ');
    return context!;
  }

  /// Current route's context
  BuildContext? _context;

  BuildContext? get context => _context;

  set _setContext(BuildContext? value) {
    if (_context != value) {
      _context = value;
      if (!_contextCompleter.isCompleted) {
        _contextCompleter.complete(value);
      }
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _setContext = route.navigator?.context;
    notifyListeners();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _setContext = route.navigator?.context;
    notifyListeners();
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _setContext = route.navigator?.context;
    notifyListeners();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _setContext = newRoute?.navigator?.context;
    notifyListeners();
  }
}
