import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

abstract class VisibilityAwareState<T extends StatefulWidget> extends State<T> // ignore: prefer_mixin
    with
        WidgetsBindingObserver,
        _StackChangedListener {
  VisibilityAwareState({debugPrintsEnabled = false});

  static final Set<String> _widgetStack = {};
  static final Map<String, int> _widgetStackTimestamps = {};

  static final Set<_StackChangedListener> _listeners = {};

  bool _isWidgetRemoved = false;

  WidgetVisibility? _widgetVisibility;

  static bool _addToStack(String widgetName) {
    final bool result = _widgetStack.add(widgetName);
    if (result) {
      _widgetStackTimestamps[widgetName] = DateTime.now().millisecondsSinceEpoch;
      for (final listener in _listeners) {
        listener._onAddToStack(widgetName);
      }
    }
    return result;
  }

  static bool _removeFromStack(String widgetName) {
    final bool result = _widgetStack.remove(widgetName);
    if (result) {
      _widgetStackTimestamps.remove(widgetName);
      for (final listener in _listeners) {
        listener._onRemoveFromStack();
      }
    }
    return result;
  }

  @override
  void _onAddToStack(String widgetName) {
    if (_widgetVisibility != WidgetVisibility.invisible &&
        runtimeType.toString() != widgetName &&
        !_wasAddedTogetherWith(widgetName)) {
      _onVisibilityChanged(WidgetVisibility.invisible);
    }
  }

  @override
  void _onRemoveFromStack() {
    if (_widgetStack.isNotEmpty &&
        (runtimeType.toString() == _widgetStack.last || _wasAddedTogetherWith(_widgetStack.last))) {
      _onVisibilityChanged(WidgetVisibility.visible);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_onWidgetLoaded);
    WidgetsBinding.instance.addObserver(this);
  }

  void _onWidgetLoaded(_) {
    _listeners.add(this);
    WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) {
      if (!_isWidgetRemoved && _addToStack(runtimeType.toString())) {
        _onVisibilityChanged(WidgetVisibility.visible);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _isWidgetRemoved = true;
    _listeners.remove(this);
    _removeFromStack(runtimeType.toString());
    _onVisibilityChanged(WidgetVisibility.gone);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      _onVisibilityChanged(WidgetVisibility.invisible);
    } else if (state == AppLifecycleState.paused) {
      _onVisibilityChanged(WidgetVisibility.invisible);
    } else if (state == AppLifecycleState.resumed) {
      if (_widgetStack.isNotEmpty &&
          (runtimeType.toString() == _widgetStack.last || _wasAddedTogetherWith(_widgetStack.last))) {
        _onVisibilityChanged(WidgetVisibility.visible);
      }
    }
  }

  bool _wasAddedTogetherWith(String otherWidgetsName) {
    final int? timeOtherWasAdded = _widgetStackTimestamps[otherWidgetsName];
    final int? timeAdded = _widgetStackTimestamps[runtimeType.toString()];
    if (timeOtherWasAdded == null || timeAdded == null) {
      return false;
    }

    final int diff = (timeAdded > timeOtherWasAdded) ? timeAdded - timeOtherWasAdded : timeOtherWasAdded - timeAdded;

    if (diff < 50) {
      return true;
    }
    return false;
  }

  void _onVisibilityChanged(WidgetVisibility visibility) {
    if (_widgetVisibility != visibility) {
      _widgetVisibility = visibility;
      onVisibilityChanged(visibility);
    }
  }

  void onVisibilityChanged(WidgetVisibility visibility) {}

  bool isVisible() {
    return _widgetVisibility == WidgetVisibility.visible;
  }

  void finish() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      SystemNavigator.pop();
    }
  }
}

enum WidgetVisibility { visible, invisible, gone }

mixin _StackChangedListener {
  void _onAddToStack(String widgetName);

  void _onRemoveFromStack();
}
