import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';

class SliverScreen extends StatelessWidget {
  final Widget title;
  final List<Widget> appBarActions;
  final List<Widget> slivers;

  const SliverScreen({
    required this.title,
    this.appBarActions = const [],
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
            SliverAppBar.large(
              automaticallyImplyLeading: false,
              expandedHeight: Dimens.sliverAppBarExpandedHeight,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                titlePadding: const EdgeInsets.symmetric(horizontal: Dimens.paddingM),
                title: DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(color: Theme.of(context).colorScheme.onSurface),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  child: _Title(
                    actionsCount: appBarActions.length + (Navigator.of(context).canPop() ? 1 : 0),
                    child: title,
                  ),
                ),
              ),
              actions: [
                ...appBarActions,
                if (Navigator.of(context).canPop())
                  IconButton(
                    onPressed: Navigator.of(context).pop,
                    icon: const Icon(Icons.close_outlined),
                    tooltip: S.of(context).tooltipClose,
                  ),
              ],
            ),
            ...slivers,
          ],
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final Widget child;
  final int actionsCount;
  final double actionsPadding;

  const _Title({
    required this.actionsCount,
    required this.child,
  }) : actionsPadding = Dimens.grid48 * actionsCount - Dimens.paddingM;

  @override
  Widget build(BuildContext context) {
    final settings = context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>()!;
    final titleScale = _titleScale(settings);
    final maxFromTextToAppbar = settings.maxExtent - settings.minExtent - Dimens.paddingM;
    final currentFromTextToAppbar = settings.currentExtent - settings.minExtent - Dimens.paddingM;
    final actionsPaddingScale = (1 - currentFromTextToAppbar / maxFromTextToAppbar).clamp(0.0, 1.0);

    return LayoutBuilder(
      builder: (context, constraints) => SizedBox(
        height: settings.minExtent - MediaQuery.paddingOf(context).top,
        width: constraints.maxWidth - (actionsPadding * actionsPaddingScale) / titleScale,
        child: Align(
          alignment: Alignment.centerLeft,
          child: child,
        ),
      ),
    );
  }

  double _titleScale(FlexibleSpaceBarSettings s) {
    final extentScale = ((s.maxExtent - s.currentExtent) / (s.maxExtent - s.minExtent)).clamp(0.0, 1.0);
    return Tween<double>(begin: 1.5, end: 1.0).transform(extentScale);
  }
}
