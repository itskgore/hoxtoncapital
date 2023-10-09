import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedge/core/utils/wedge_circular_progress_indicator.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/features/account/third_party_access/domain/model/third_party_url_model.dart';
import 'package:wedge/features/account/third_party_access/presentation/cubit/third_party_cubit.dart';

import '../widget/widget_list_tile.dart';

class ThirdPartyAccessPage extends StatefulWidget {
  const ThirdPartyAccessPage({Key? key}) : super(key: key);

  @override
  State<ThirdPartyAccessPage> createState() => _ThirdPartyAccessPageState();
}

class _ThirdPartyAccessPageState extends State<ThirdPartyAccessPage> {
  @override
  void initState() {
    context.read<ThirdPartyCubit>().getThirdPartyAccessData(
        ThirdPartyUrlParams("thirdpartyAccessor", "view", {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: BlocConsumer<ThirdPartyCubit, ThirdPartyState>(
        listener: (context, state) {
          if (state is ThirdPartyError) {
            showSnackBar(context: context, title: state.errorMsg);
          }
        },
        builder: (context, state) {
          if (state is ThirdPartyLoading) {
            return Center(
              child: buildCircularProgressIndicator(width: 80),
            );
          } else if (state is ThirdPartyLoaded) {
            return ListView.builder(
                itemCount: state.thirdPartyAccessEntity.length,
                itemBuilder: (context, index) {
                  final data = state.thirdPartyAccessEntity[index];
                  return widgetListTile(
                    name: data.name,
                    role: data.role,
                    accessLevel: data.accessLevel,
                    email: data.email,
                  );
                });
          } else if (state is ThirdPartyError) {
            return Center(
                child: Text(
              state.errorMsg,
            ));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
