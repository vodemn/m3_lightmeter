import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';

class ExpandableSectionListItem extends StatefulWidget {
  final String title;
  final VoidCallback onTitleTap;
  final VoidCallback onExpand;
  final List<IconButton> actions;
  final List<Widget> children;

  const ExpandableSectionListItem({
    required this.title,
    required this.onTitleTap,
    required this.onExpand,
    required this.actions,
    required this.children,
    super.key,
  });

  static ExpandableSectionListItemState of(BuildContext context) {
    return context.findAncestorStateOfType<ExpandableSectionListItemState>()!;
  }

  @override
  State<ExpandableSectionListItem> createState() => ExpandableSectionListItemState();
}

class ExpandableSectionListItemState extends State<ExpandableSectionListItem> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: Dimens.durationM,
    vsync: this,
  );
  bool get _expanded => _controller.isCompleted;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimens.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: Dimens.paddingM),
              title: Row(
                children: [
                  _AnimatedNameLeading(controller: _controller),
                  const SizedBox(width: Dimens.grid8),
                  Flexible(
                    child: Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              trailing: _AnimatedArrowButton(
                controller: _controller,
                onPressed: () => _expanded ? collapse() : expand(),
              ),
              onTap: () => _expanded ? widget.onTitleTap() : expand(),
            ),
            _AnimatedContent(
              controller: _controller,
              actions: widget.actions,
              children: widget.children,
            ),
          ],
        ),
      ),
    );
  }

  void expand() {
    widget.onExpand();
    _controller.forward();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Future.delayed(_controller.duration!).then((_) {
        Scrollable.ensureVisible(
          context,
          alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
          duration: _controller.duration!,
        );
      });
    });
  }

  void collapse() {
    _controller.reverse();
  }
}

class _AnimatedNameLeading extends AnimatedWidget {
  const _AnimatedNameLeading({required AnimationController controller}) : super(listenable: controller);

  Animation<double> get _progress => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: _progress.value * Dimens.grid8),
      child: Icon(
        Icons.edit_outlined,
        size: _progress.value * Dimens.grid24,
      ),
    );
  }
}

class _AnimatedArrowButton extends AnimatedWidget {
  final VoidCallback onPressed;

  const _AnimatedArrowButton({
    required AnimationController controller,
    required this.onPressed,
  }) : super(listenable: controller);

  Animation<double> get _progress => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Transform.rotate(
        angle: _progress.value * pi,
        child: const Icon(Icons.keyboard_arrow_down_outlined),
      ),
      tooltip: _progress.value == 0 ? S.of(context).tooltipExpand : S.of(context).tooltipCollapse,
    );
  }
}

class _AnimatedContent extends AnimatedWidget {
  final List<IconButton> actions;
  final List<Widget> children;

  const _AnimatedContent({
    required AnimationController controller,
    required this.actions,
    required this.children,
  }) : super(listenable: controller);

  Animation<double> get _progress => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    return SizedOverflowBox(
      alignment: Alignment.topCenter,
      size: Size(
        double.maxFinite,
        _progress.value * Dimens.grid56 * (children.length + 1),
      ),
      // https://github.com/gskinnerTeam/flutter-folio/pull/62
      child: Opacity(
        opacity: _progress.value,
        child: Column(
          children: [
            ...children,
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: Dimens.paddingM),
              trailing: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: actions,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
