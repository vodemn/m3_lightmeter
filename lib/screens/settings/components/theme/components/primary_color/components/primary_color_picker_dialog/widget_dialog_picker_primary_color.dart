import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/theme_provider.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/shared/filled_circle/widget_circle_filled.dart';

class PrimaryColorDialogPicker extends StatefulWidget {
  const PrimaryColorDialogPicker({super.key});

  @override
  State<PrimaryColorDialogPicker> createState() => _PrimaryColorDialogPickerState();
}

class _PrimaryColorDialogPickerState extends State<PrimaryColorDialogPicker> {
  late Color _selected = Theme.of(context).primaryColor;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.palette),
      titlePadding: Dimens.dialogIconTitlePadding,
      title: Text(S.of(context).choosePrimaryColor),
      content: SizedBox(
          height: Dimens.grid48,
          width: double.maxFinite,
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                child: Row(
                  children: List.generate(
                    ThemeProvider.primaryColorsList.length,
                    (index) {
                      final color = ThemeProvider.primaryColorsList[index];
                      return Padding(
                        padding: EdgeInsets.only(left: index == 0 ? 0 : Dimens.paddingS),
                        child: _SelectableColorItem(
                          color: color,
                          selected: color.value == _selected.value,
                          onTap: () {
                            setState(() {
                              _selected = color;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _Cutout(),
                  RotatedBox(
                    quarterTurns: 2,
                    child: _Cutout(),
                  ),
                ],
              ),
            ],
          ),),
      actionsPadding: Dimens.dialogActionsPadding,
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: Text(S.of(context).cancel),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(_selected);
          },
          child: Text(S.of(context).save),
        ),
      ],
    );
  }
}

class _SelectableColorItem extends StatefulWidget {
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  _SelectableColorItem({
    required this.color,
    required this.selected,
    required this.onTap,
  }) : super(key: ValueKey(color));

  @override
  State<_SelectableColorItem> createState() => _SelectableColorItemState();
}

class _SelectableColorItemState extends State<_SelectableColorItem> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.selected) {
        Scrollable.ensureVisible(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: FilledCircle(
        size: Dimens.grid48,
        color: widget.color,
        child: AnimatedSwitcher(
          duration: Dimens.durationS,
          child: widget.selected
              ? Icon(
                  Icons.check,
                  color: ThemeData.estimateBrightnessForColor(widget.color) == Brightness.light
                      ? Colors.black
                      : Colors.white,
                )
              : null,
        ),
      ),
    );
  }
}

class _Cutout extends StatelessWidget {
  const _Cutout();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimens.grid48,
      width: Dimens.grid24,
      child: ClipPath(
        clipper: const _CutoutClipper(),
        child: Material(
          color: Theme.of(context).dialogTheme.backgroundColor,
          surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
          elevation: Theme.of(context).dialogTheme.elevation!,
          shadowColor: Colors.transparent,
        ),
      ),
    );
  }
}

class _CutoutClipper extends CustomClipper<Path> {
  const _CutoutClipper();

  @override
  Path getClip(Size size) {
    final path = Path();
    final radius = size.height / 2;
    path.lineTo(radius, 0);
    path.arcToPoint(
      Offset(radius, size.height),
      radius: Radius.circular(radius),
      rotation: 180,
      clockwise: false,
    );
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => false;
}
