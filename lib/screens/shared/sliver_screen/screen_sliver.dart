import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/utils/text_height.dart';

class SliverScreen extends StatelessWidget {
  final Widget title;
  final List<Widget> appBarActions;
  final PreferredSizeWidget? bottom;
  final List<Widget> slivers;

  const SliverScreen({
    required this.title,
    this.appBarActions = const [],
    this.bottom,
    required this.slivers,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: CustomScrollView(
          slivers: <Widget>[
            _AppBar(
              title: title,
              appBarActions: appBarActions,
              bottom: bottom,
            ),
            ...slivers,
          ],
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  final Widget title;
  final List<Widget> appBarActions;
  final PreferredSizeWidget? bottom;

  const _AppBar({
    required this.title,
    this.appBarActions = const [],
    this.bottom,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar.large(
      automaticallyImplyLeading: false,
      expandedHeight: Dimens.sliverAppBarExpandedHeight + (bottom?.preferredSize.height ?? 0.0),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: const EdgeInsets.symmetric(horizontal: Dimens.paddingM),
        title: DefaultTextStyle(
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Theme.of(context).colorScheme.onSurface),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          child: _Title(
            actionsCount: appBarActions.length + (Navigator.of(context).canPop() ? 1 : 0),
            bottomSize: bottom?.preferredSize.height ?? 0.0,
            child: title,
          ),
        ),
      ),
      bottom: bottom,
      actions: [
        ...appBarActions,
        if (Navigator.of(context).canPop())
          IconButton(
            onPressed: Navigator.of(context).pop,
            icon: const Icon(Icons.close_outlined),
            tooltip: S.of(context).tooltipClose,
          ),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  final Widget child;
  final int actionsCount;
  final double bottomSize;
  final double actionsPadding;

  const _Title({
    required this.actionsCount,
    required this.bottomSize,
    required this.child,
  }) : actionsPadding = Dimens.grid48 * actionsCount - Dimens.paddingM;

  @override
  Widget build(BuildContext context) {
    final settings = context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>()!;
    final extentScale =
        ((settings.maxExtent - settings.currentExtent) / (settings.maxExtent - settings.minExtent)).clamp(0.0, 1.0);
    final titleScale = Tween<double>(begin: 1.5, end: 1.0).transform(extentScale);
    final maxFromTextToAppbar = settings.maxExtent - settings.minExtent - Dimens.paddingM;
    final currentFromTextToAppbar = settings.currentExtent - settings.minExtent - Dimens.paddingM;
    final actionsPaddingScale = (1 - currentFromTextToAppbar / maxFromTextToAppbar).clamp(0.0, 1.0);

    return LayoutBuilder(
      builder: (context, constraints) => Padding(
        padding: EdgeInsets.only(bottom: (Dimens.paddingM * (1 - actionsPaddingScale) + bottomSize) / titleScale),
        child: SizedBox(
          height: DefaultTextStyle.of(context).style.lineHeight * 2,
          width: constraints.maxWidth - (actionsPadding * actionsPaddingScale) / titleScale,
          child: Align(
            alignment: FractionalOffset(0.0, 0.5 + 0.5 * (1 - extentScale)),
            child: child,
          ),
        ),
      ),
    );
  }
}
