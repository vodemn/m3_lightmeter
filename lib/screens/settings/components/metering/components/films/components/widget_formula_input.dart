import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lightmeter/res/dimens.dart';

class FormulaInput extends StatefulWidget {
  const FormulaInput({super.key});

  @override
  State<FormulaInput> createState() => _FormulaInputState();
}

class _FormulaInputState extends State<FormulaInput> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextFormField(
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('x')),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                _Button(
                  title: '()',
                  onTap: () {},
                ),
                _buttonsDivider,
                _Button(
                  title: 'ln',
                  onTap: () {},
                ),
                _buttonsDivider,
                _Button(
                  title: 'lg',
                  onTap: () {},
                ),
                _buttonsDivider,
                _Button(
                  title: '^',
                  onTap: () {},
                ),
              ],
            ),
            Row(
              children: [
                _Button(
                  title: '7',
                  onTap: () {},
                ),
                _buttonsDivider,
                _Button(
                  title: '8',
                  onTap: () {},
                ),
                _buttonsDivider,
                _Button(
                  title: '9',
                  onTap: () {},
                ),
                _buttonsDivider,
                _Button(
                  title: '^',
                  onTap: () {},
                ),
              ],
            ),
            Row(
              children: [
                _Button(
                  title: '4',
                  onTap: () {},
                ),
                _buttonsDivider,
                _Button(
                  title: '5',
                  onTap: () {},
                ),
                _buttonsDivider,
                _Button(
                  title: '6',
                  onTap: () {},
                ),
                _buttonsDivider,
                _Button(
                  title: '^',
                  onTap: () {},
                ),
              ],
            ),
            Row(
              children: [
                _Button(
                  title: '1',
                  onTap: () {},
                ),
                _buttonsDivider,
                _Button(
                  title: '2',
                  onTap: () {},
                ),
                _buttonsDivider,
                _Button(
                  title: '3',
                  onTap: () {},
                ),
                _buttonsDivider,
                _Button(
                  title: '^',
                  onTap: () {},
                ),
              ],
            ),
            Row(
              children: [
                _Button(
                  title: '0',
                  onTap: () {},
                ),
                _Button(
                  title: '.',
                  onTap: () {},
                ),
                _Button(
                  title: '<',
                  onTap: () {},
                ),
                _Button(
                  title: '^',
                  onTap: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _Button({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        height: Dimens.grid48,
        decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          shape: const StadiumBorder(),
        ),
        child: Text(title),
      ),
    );
  }
}

const _buttonsDivider = SizedBox(width: Dimens.grid8, height: Dimens.grid8);
