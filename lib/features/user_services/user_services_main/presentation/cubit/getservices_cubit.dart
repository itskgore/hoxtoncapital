import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wedge/core/entities/user_services_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/user_services/generic_domain/generic_usecases/get_plugins.dart';

part 'getservices_state.dart';

class GetservicesCubit extends Cubit<GetservicesState> {
  GetPlugins getPlugins;

  GetservicesCubit({required this.getPlugins}) : super(GetservicesInitial());

  getData({required bool shouldLoad}) {
    if (shouldLoad) {
      emit(GetservicesLoding());
    }
    final result = getPlugins(NoParams());
    result.then((value) => value.fold((error) {
          if (error is TokenExpired) {
            getData(shouldLoad: shouldLoad);
          } else {
            emit(GetservicesError());
          }
        }, (r) {
          emit(GetservicesLoaded(data: r));
        }));
  }
}
