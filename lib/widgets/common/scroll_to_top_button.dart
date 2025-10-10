import 'package:flutter/material.dart';

class ScrollToTopButton extends StatefulWidget {
  const ScrollToTopButton({
    super.key,
    required this.scrollController,
    this.showThreshold = 200.0,
    this.heroTag,
  });

  final ScrollController scrollController;
  final double showThreshold;
  final Object? heroTag;

  @override
  State<ScrollToTopButton> createState() => _ScrollToTopButtonState();
}

class _ScrollToTopButtonState extends State<ScrollToTopButton> {
  OverlayEntry? _overlayEntry;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    _removeOverlay();
    super.dispose();
  }

  void _onScroll() {
    final shouldShow = widget.scrollController.hasClients &&
                      widget.scrollController.offset > widget.showThreshold;
    
    if (shouldShow && !_isVisible) {
      _showOverlay();
    } else if (!shouldShow && _isVisible) {
      _removeOverlay();
    }
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;
    
    _isVisible = true;
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 80 + MediaQuery.of(context).padding.bottom,
        right: 16,
        child: Material(
          type: MaterialType.transparency,
          child: AnimatedScale(
            scale: _isVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: FloatingActionButton(
              mini: true,
              elevation: 3.0,
              heroTag: widget.heroTag ?? "scrollToTop_${widget.scrollController.hashCode}",
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              onPressed: () {
                if (widget.scrollController.hasClients) {
                  widget.scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                }
              },
              child: const Icon(Icons.keyboard_arrow_up, size: 20),
            ),
          ),
        ),
      ),
    );
    
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      _isVisible = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink(); // 실제 위젯은 Overlay에 표시
  }
}