import 'package:ecommerce_app_huma_volve/features/auth/sign_up/domain/entities/signup_request_entity.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/domain/use_cases/signup_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/presentation/view_model/signup_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupCubit extends Cubit<SignupStates> {
  final SignupUseCase signupUseCase;
  SignupCubit({required this.signupUseCase}) : super(SignupInitial());

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(SignupLoading());
    final result = await signupUseCase.invoke(
      SignupRequestEntity(email: email, name: name, password: password),
    );
    result.fold(
      (failure) => emit(SignupError(failure.failureMessage)),
      (signupEntity) => emit(SignupSuccess(signupEntity)),
    );
  }
}
