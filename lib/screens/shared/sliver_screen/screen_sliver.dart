import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';

class SliverScreen extends StatelessWidget {
  final String title;
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
            SliverAppBar(
              pinned: true,
              automaticallyImplyLeading: false,
              expandedHeight: Dimens.sliverAppBarExpandedHeight,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                titlePadding: const EdgeInsets.all(Dimens.paddingM),
                title: Text(
                  title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: Dimens.grid24,
                  ),
                ),
              ),
              actions: [
                ...appBarActions,
                if (Navigator.of(context).canPop())
                  IconButton(
                    onPressed: Navigator.of(context).pop,
                    icon: const Icon(Icons.close),
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
