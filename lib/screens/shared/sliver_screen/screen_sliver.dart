import 'package:flutter/material.dart';
import 'package:lightmeter/res/dimens.dart';

class SliverScreen extends StatelessWidget {
  final String title;
  final List<Widget> appBarActions;
  final List<Widget> slivers;

  const SliverScreen({
    required this.title,
    required this.appBarActions,
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
              expandedHeight: Dimens.grid168,
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
              actions: appBarActions,
            ),
            ...slivers,
            SliverToBoxAdapter(child: SizedBox(height: MediaQuery.of(context).padding.bottom)),
          ],
        ),
      ),
    );
  }
}
