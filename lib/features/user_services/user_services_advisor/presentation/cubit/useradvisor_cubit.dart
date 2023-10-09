import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wedge/core/entities/user_services_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/user_services/generic_domain/generic_usecases/get_advisor_plugin.dart';

part 'useradvisor_state.dart';

class UseradvisorCubit extends Cubit<UseradvisorState> {
  final GetUserAdvisorUsecase getUserAdvisorUsecase;

  UseradvisorCubit(this.getUserAdvisorUsecase) : super(UseradvisorInitial());

  getAdvisors(Map<String, dynamic> body, String urlParameters,
      RecordsEntity recordsEntity) async {
    emit(UseradvisorLoading());
    final result =
        getUserAdvisorUsecase({"body": body, "paramerters": urlParameters});
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          getAdvisors(body, urlParameters, recordsEntity);
        } else {
          emit(UseradvisorError(error: l.displayErrorMessage()));
        }
      }, (r) {
        emit(UseradvisorLoaded(
          userAdvisor: r,
        ));
      });
    });
  }

  List<String> refactorTemplate(
      TemplatesEntity? templatesEntity, List<Map<String, dynamic>> data) {
    List<String> template = [];
    if (templatesEntity != null) {
      data.forEach((element) {
        String temp = "";
        element.forEach((key, value) {
          if (templatesEntity.template.contains("{item.${key}}")) {
            if (temp.isEmpty) {
              temp = templatesEntity.template
                  .replaceAll("{item.${key}}", value ?? "");
            } else {
              temp =
                  temp.replaceAll("{item.${key}}", value ?? ""); // {item.title}
            }
          }
        });
        template.add(temp);
      });
    }
    return template;
  }
}
