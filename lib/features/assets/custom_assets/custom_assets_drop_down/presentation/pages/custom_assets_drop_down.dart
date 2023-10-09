import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedge/core/utils/wedge_circular_progress_indicator.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/core/widgets/dropdown/wedge_custom_dropdown.dart';
import 'package:wedge/features/assets/custom_assets/custom_assets_drop_down/presentation/cubit/custom_asset_drop_down_cubit.dart';

class CustomAssetsDropDown extends StatefulWidget {
  String type;
  final Function getData;

  CustomAssetsDropDown({Key? key, required this.type, required this.getData})
      : super(key: key);

  @override
  _CustomAssetsDropDownState createState() => _CustomAssetsDropDownState();
}

class _CustomAssetsDropDownState extends State<CustomAssetsDropDown> {
  List<dynamic> _assetCategories = [];
  String? _type = "";

  @override
  void initState() {
    context.read<CustomAssetDropDownCubit>().getCustomAssetsDropDownData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomAssetDropDownCubit, CustomAssetDropDownState>(
      listener: (context, state) {
        if (state is CustomAssetDropDownError) {
          showSnackBar(context: context, title: state.errorMsg);
        }
      },
      builder: (context, state) {
        if (state is CustomAssetDropDownLoading) {
          return buildCircularProgressIndicator();
        } else if (state is CustomAssetDropDownLoaded) {
          _assetCategories = state.data;
          if (_type!.isEmpty) {
            if (widget.type.isNotEmpty) {
              final data = _assetCategories
                  .where((element) => element['id'] == widget.type)
                  .toList();
              _type = data[0]['name'];
            } else {
              _type = _assetCategories[0]['name'];
            }
          }
          return Container(
              height: 53.0,
              child: WedgeCustomDropDown(
                items: _assetCategories,
                value: _type!,
                onChanged: (_) {
                  setState(() {
                    _type = _;
                  });
                  final data = _assetCategories
                      .where((element) => element['name'] == _)
                      .toList();
                  widget.getData(data[0]['id']);
                  // widget.getData(_);
                },
                mapValue: 'name',
              ));
        } else {
          return Container();
        }
      },
    );
  }
}
