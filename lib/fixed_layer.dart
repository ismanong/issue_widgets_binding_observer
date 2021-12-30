import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:issue_widgets_binding_observer/update_version_dialog.dart';

class FixedLayer extends StatefulWidget {
  final Widget? child;
  const FixedLayer({Key? key, required this.child})
      : assert(child != null),
        super(key: key);
  @override
  State<FixedLayer> createState() => FixedLayerState();
}

class FixedLayerState extends State<FixedLayer> {
  static final FixedLayerState singleton = FixedLayerState._internal();
  factory FixedLayerState() => singleton;
  FixedLayerState._internal();

  void _getPopupData() async {
    Future.delayed(Duration(milliseconds: 1000), () {
      addDialog(
        UpdateVersionPopup(),
      );
    });
  }

  late OverlayEntry _overlayEntry;
  Widget? _activePopupWidget;
  final PriorityQueue<Widget> _popupQueue = PriorityQueue<Widget>((a, b) => 1);

  void closeDialog() {
    _popupQueue.removeFirst();
    if (_popupQueue.isNotEmpty) {
      _activePopupWidget = _popupQueue.first;
    } else {
      _activePopupWidget = null;
    }
    _buildDialog();
  }

  void addDialog(Widget popupWidget) {
    _popupQueue.add(popupWidget);
    if (_activePopupWidget == null) {
      _activePopupWidget = popupWidget;
      _buildDialog();
    }
  }

  void _buildDialog() {
    _overlayEntry.markNeedsBuild();
  }

  @override
  void initState() {
    super.initState();
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => _activePopupWidget ?? Container(),
    );
    _getPopupData();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Overlay(
        initialEntries: [
          OverlayEntry(
            builder: (BuildContext context) => widget.child ?? Container(),
          ),
          _overlayEntry,
        ],
      ),
    );
  }
}
