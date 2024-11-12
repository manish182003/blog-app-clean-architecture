import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/pages/login_page.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SingUpPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => SingUpPage(),
      );
  const SingUpPage({super.key});

  @override
  State<SingUpPage> createState() => _SingUpPageState();
}

class _SingUpPageState extends State<SingUpPage> {
  final formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              showFloatingSnackBar(context, state.message);
            } else if (state is AuthSuccess) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                LoginPage.route(),
                (route) => false,
              );
            }
          },
          builder: (context, state) {
            if (state is Authloading) {
              return const Loader();
            }
            return SingleChildScrollView(
              child: Form(
                key: formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sign Up.',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    AuthField(
                      hintText: 'Name',
                      controller: nameController,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    AuthField(
                      hintText: 'Email',
                      controller: emailController,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    AuthField(
                      hintText: 'Password',
                      controller: passwordController,
                      isObsecureText: true,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    AuthGradientButton(
                      buttonText: 'Sign Up',
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          context.read<AuthBloc>().add(
                                AuthSignUp(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                  name: nameController.text.trim(),
                                ),
                              );
                          emailController.text = '';
                          passwordController.text = '';
                          nameController.text = '';
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, LoginPage.route());
                      },
                      child: RichText(
                        text: TextSpan(
                            text: 'Already have an account? ',
                            style: Theme.of(context).textTheme.titleMedium,
                            children: [
                              TextSpan(
                                text: 'Sign In',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: AppPallete.gradient2,
                                      fontWeight: FontWeight.bold,
                                    ),
                              )
                            ]),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
