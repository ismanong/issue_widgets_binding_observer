import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:issue_widgets_binding_observer/router/router_names.dart';

class AppRouterDelegate extends RouterDelegate<String>
    with PopNavigatorRouterDelegateMixin<String>, ChangeNotifier {
  static final AppRouterDelegate singleton = AppRouterDelegate._internal();
  factory AppRouterDelegate() => singleton;
  AppRouterDelegate._internal();

  final _stack = <String>[];

  @override
  String? get currentConfiguration => _stack.isNotEmpty ? _stack.last : null;

  @override
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Future<void> setNewRoutePath(String configuration) {
    if (configuration == "/") {
      _stack.clear();
    }
    if (_stack.isEmpty || configuration != _stack.last) {
      _stack.add(configuration);
      notifyListeners();
    }
    return SynchronousFuture<void>(null);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: _onPopPage,

      /// 构建路由堆栈
      pages: [
        for (final url in _stack)
          MaterialPage(
            name: url,
            arguments: null,
            child: createPage(url), // routerNames[url] as Widget
          )
      ],
    );
  }

  static AppRouterDelegate of(BuildContext context) {
    final delegate = Router.of(context).routerDelegate;
    assert(delegate is AppRouterDelegate, 'Delegate type must match');
    return delegate as AppRouterDelegate;
  }

  List<String> get stack => List.unmodifiable(_stack);

  void toName(String newRoute) {
    _stack.add(newRoute);
    notifyListeners();
  }

  void push(String newRoute) {
    if (newRoute == currentConfiguration) return;
    _stack.add(newRoute);
    notifyListeners();
  }

  void remove(String routeName) {
    _stack.remove(routeName);
    notifyListeners();
  }

  void pop() {
    _stack.remove(_stack.last);
    notifyListeners();
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    if (_stack.isNotEmpty) {
      if (_stack.last == route.settings.name) {
        _stack.remove(route.settings.name);
        notifyListeners();
      }
    }
    return route.didPop(result);
  }

  @override
  Future<void> setInitialRoutePath(String configuration) {
    return setNewRoutePath(configuration);
  }

  @override
  Future<bool> popRoute() {
    if (canPop()) {
      _stack.removeLast();
      notifyListeners();
      return SynchronousFuture<bool>(true);
    }

    return _doubleClickExit();
  }

  bool canPop() {
    return _stack.length > 1;
  }

  int _lastClickTime = 0;
  Future<bool> _doubleClickExit() {
    int now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastClickTime > 2000) {
      _lastClickTime = now;
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        const SnackBar(
          content: Text('Click again to exit the application！'),
          duration: Duration(milliseconds: 2000),
        ),
      );
      return SynchronousFuture<bool>(true);
    } else {
      return SynchronousFuture<bool>(false);
    }
  }
}
