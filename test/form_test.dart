import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_form_validation/bloc/bloc.dart';
import 'package:mockito/mockito.dart';

class MockLoginBloc extends Mock implements LoginBloc {}

void main() {
  MyFormBloc myFormBloc;
  MockLoginBloc loginBloc;

  setUp(() {
    loginBloc = MockLoginBloc();
    myFormBloc = MyFormBloc(loginBloc);
  });

  test('not dispatch login event when form is not valid', () async {
    final expectedResponse = [
      MyFormState.initial(),
    ];

    myFormBloc.dispatch(FormSubmitted());

    await expectLater(myFormBloc.state, emitsInOrder(expectedResponse));

    verifyNever(loginBloc.dispatch(true));
  });

  test('dispatch login event when form is valid', () async {
    final email = 'example@domain.com';
    final password = 'Aa12345678';
    final expectedResponse = [
      MyFormState.initial(),
      MyFormState(
          email: email,
          isEmailValid: true,
          password: '',
          isPasswordValid: false,
          formSubmittedSuccessfully: false),
      MyFormState(
          email: email,
          isEmailValid: true,
          password: password,
          isPasswordValid: true,
          formSubmittedSuccessfully: false),
    ];

    myFormBloc.dispatch(EmailChanged(email: email));
    myFormBloc.dispatch(PasswordChanged(password: password));
    await expectLater(myFormBloc.state, emitsInOrder(expectedResponse));

    myFormBloc.dispatch(FormSubmitted());

    // TODO: Why I need to expect the last state again?
    // TODO: why the last state is emitted?

    await expectLater(
        myFormBloc.state,
        emitsInOrder([
          MyFormState(
              email: email,
              isEmailValid: true,
              password: password,
              isPasswordValid: true,
              formSubmittedSuccessfully: false),
        ]));

    verify(loginBloc.dispatch(true)).called(1);
  });
}
