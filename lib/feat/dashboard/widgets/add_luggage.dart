import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/core/spacing.dart';

import 'package:opket/feat/fare_by_options/fare_cubit.dart';

class AddLuggage extends StatefulWidget {
  const AddLuggage({super.key});

  @override
  State<AddLuggage> createState() => _AddLuggageState();
}

class _AddLuggageState extends State<AddLuggage> {
  bool luggageEnabled = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.all(0),
      onPressed: () {},
      icon: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Yukim bor",
            style: TextStyle(fontFamily: 'WorkSans', fontSize: 16),
          ),
          SizedBox(width: AppSpacing.sm),
          CupertinoSwitch(
            value: luggageEnabled,
            onChanged: (value) {
              setState(() {
                luggageEnabled = !luggageEnabled;
              });
              context.read<FareCubit>().toggleService("bagaj");
            },
          ),
        ],
      ),
    );
  }
}
