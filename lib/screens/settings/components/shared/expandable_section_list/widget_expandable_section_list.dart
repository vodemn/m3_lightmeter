import 'package:flutter/material.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/settings/components/shared/expandable_section_list/components/expandable_section_list_item/widget_expandable_section_list_item.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

typedef _WidgetBuilder<W, T extends Identifiable> = W Function(BuildContext context, T value);

class ExpandableSectionList<T extends Identifiable> extends StatefulWidget {
  final List<T> values;
  final VoidCallback onSectionTitleTap;
  final _WidgetBuilder<List<Widget>, T> contentBuilder;
  final _WidgetBuilder<List<IconButton>, T> actionsBuilder;

  const ExpandableSectionList({
    required this.values,
    required this.onSectionTitleTap,
    required this.contentBuilder,
    required this.actionsBuilder,
    super.key,
  });

  @override
  State<ExpandableSectionList> createState() => _ExpandableSectionListState<T>();
}

class _ExpandableSectionListState<T extends Identifiable> extends State<ExpandableSectionList<T>> {
  final Map<String, GlobalKey<ExpandableSectionListItemState>> keysMap = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateProfilesKeys();
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final item = widget.values[index];
          return Padding(
            padding: EdgeInsets.fromLTRB(
              Dimens.paddingM,
              index == 0 ? Dimens.paddingM : 0,
              Dimens.paddingM,
              Dimens.paddingM,
            ),
            child: ExpandableSectionListItem(
              key: keysMap[item.id],
              title: item.name,
              onTitleTap: widget.onSectionTitleTap,
              onExpand: () => _keepExpandedAt(index),
              actions: widget.actionsBuilder(context, item),
              children: widget.contentBuilder(context, item),
            ),
          );
        },
        childCount: widget.values.length,
      ),
    );
  }

  void _keepExpandedAt(int index) {
    keysMap.values.toList().getRange(0, index).forEach((element) {
      element.currentState?.collapse();
    });
    keysMap.values.toList().getRange(index + 1, keysMap.length).forEach((element) {
      element.currentState?.collapse();
    });
  }

  void _updateProfilesKeys() {
    if (widget.values.length > keysMap.length) {
      // item added
      final List<String> idsToAdd = [];
      for (final item in widget.values) {
        if (!keysMap.keys.contains(item.id)) idsToAdd.add(item.id);
      }
      for (final id in idsToAdd) {
        keysMap[id] = GlobalKey<ExpandableSectionListItemState>(debugLabel: id);
      }
      idsToAdd.clear();
    } else if (widget.values.length < keysMap.length) {
      // item deleted
      final List<String> idsToDelete = [];
      for (final id in keysMap.keys) {
        if (!widget.values.any((p) => p.id == id)) idsToDelete.add(id);
      }
      idsToDelete.forEach(keysMap.remove);
      idsToDelete.clear();
    } else {
      // item updated, no need to updated keys
    }
  }
}
