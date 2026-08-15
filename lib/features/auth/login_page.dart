import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/utils/responsive.dart';
import '../../services/auth_service.dart';
import '../../services/profile_service.dart';
import '../main/main_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // ==========================================================
  // LOGIN / SIGN UP
  // ==========================================================

  bool isLogin = true;

  final AuthService _authService = AuthService();
  final ProfileService _profileService = ProfileService();

  bool isLoading = false;

  // ==========================================================
  // PASSWORD VISIBILITY
  // ==========================================================

  bool hidePassword = true;
  bool hideConfirmPassword = true;

  // ==========================================================
  // TEXT CONTROLLERS
  // ==========================================================

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  // ==========================================================
  // COLORS
  // ==========================================================

  static const Color primaryBlue =
      Color(0xFF1976D2);

  static const Color darkBlue =
      Color(0xFF0D47A1);

  static const Color lightBlue =
      Color(0xFF42A5F5);

  static const Color background =
      Color(0xFFF5F9FF);

  static const Color lightSurface =
      Color(0xFFEEF5FF);

  static const Color darkText =
      Color(0xFF172033);

  static const Color secondaryText =
      Color(0xFF718096);

  static const Color border =
      Color(0xFFDCE7F5);

  // ==========================================================
  // DISPOSE
  // ==========================================================

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  // ==========================================================
  // SUBMIT FORM
  // ==========================================================

  Future<void> submitForm() async {
    final String name = nameController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    final String confirmPassword =
        confirmPasswordController.text.trim();

    // ----------------------------------------------------------
    // SIGN UP - NAME
    // ----------------------------------------------------------

    if (!isLogin) {
      if (name.isEmpty) {
        showMessage(
          'Please enter your name.',
        );

        return;
      }
    }

    // ----------------------------------------------------------
    // EMAIL
    // ----------------------------------------------------------

    if (email.isEmpty) {
      showMessage(
        'Please enter your email.',
      );

      return;
    }

    if (!email.contains('@')) {
      showMessage(
        'Please enter a valid email address.',
      );

      return;
    }

    // ----------------------------------------------------------
    // PASSWORD
    // ----------------------------------------------------------

    if (password.isEmpty) {
      showMessage(
        'Please enter your password.',
      );

      return;
    }

    if (password.length < 6) {
      showMessage(
        'Password must contain at least 6 characters.',
      );

      return;
    }

    // ----------------------------------------------------------
    // CONFIRM PASSWORD
    // ----------------------------------------------------------

    if (!isLogin) {
      if (confirmPassword.isEmpty) {
        showMessage(
          'Please re-enter your password.',
        );

        return;
      }

      if (password != confirmPassword) {
        showMessage(
          'Passwords do not match.',
        );

        return;
      }
    }

    // ----------------------------------------------------------
    // START LOADING
    // ----------------------------------------------------------

    setState(() {
      isLoading = true;
    });

    try {
      if (isLogin) {
        // ======================================================
        // LOGIN
        // ======================================================

        await _authService.login(
          email: email,
          password: password,
        );

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const MainScreen(),
          ),
        );
      } else {
        // ======================================================
        // SIGN UP
        // ======================================================

        final UserCredential credential =
            await _authService.signUp(
          email: email,
          password: password,
        );

        // Make sure Firebase returned a user.
        if (credential.user == null) {
          throw Exception(
            'Account was created, but the user could not be retrieved.',
          );
        }

        // Create users/{uid} in Firestore.
        await _profileService.createProfile(
          name: name,
          email: email,
        );

        if (!mounted) return;

        showMessage(
          'Account created successfully!',
        );

        // Switch back to Login.
        setState(() {
          isLogin = true;
          passwordController.clear();
          confirmPasswordController.clear();
        });
      }
    } on FirebaseAuthException catch (e) {
      showMessage(_getAuthErrorMessage(e));
    } catch (e) {
      showMessage(
        'Something went wrong. Please try again.',
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  String _getAuthErrorMessage(
    FirebaseAuthException e,
  ) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'An account already exists with this email.';

      case 'invalid-email':
        return 'Please enter a valid email address.';

      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';

      case 'user-not-found':
        return 'No account found with this email.';

      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';

      case 'user-disabled':
        return 'This account has been disabled.';

      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';

      case 'network-request-failed':
        return 'Network error. Check your internet connection.';

      default:
        return e.message ?? 'Authentication failed.';
    }
  }

  // ==========================================================
  // GOOGLE LOGIN
  // ==========================================================

  void googleLogin() {
    showMessage(
      'Google Login selected.',
    );
  }

  // ==========================================================
  // FORGOT PASSWORD
  // ==========================================================

  Future<void> forgotPassword() async {
    final String email = emailController.text.trim();

    if (email.isEmpty) {
      showMessage(
        'Enter your email first to reset your password.',
      );
      return;
    }

    if (!email.contains('@')) {
      showMessage(
        'Please enter a valid email address.',
      );
      return;
    }

    try {
      await _authService.resetPassword(
        email: email,
      );

      if (!mounted) return;

      showMessage(
        'Password reset email sent.',
      );
    } on FirebaseAuthException catch (e) {
      showMessage(_getAuthErrorMessage(e));
    } catch (e) {
      showMessage(
        'Unable to send password reset email.',
      );
    }
  }

  // ==========================================================
  // SHOW MESSAGE
  // ==========================================================

  void showMessage(
    String message,
  ) {
    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar();

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          message,
        ),

        behavior:
            SnackBarBehavior.floating,

        backgroundColor:
            const Color(0xFF263238),

        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(
            Responsive.radius(
              context,
              12,
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // MAIN BUILD
  // ==========================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          background,

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics:
                const BouncingScrollPhysics(),

            padding:
                EdgeInsets.symmetric(
              horizontal:
                  Responsive.w(
                context,
                0.055,
              ),

              vertical:
                  Responsive.h(
                context,
                0.025,
              ),
            ),

            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(
                maxWidth: 450,
              ),

              child:
                  buildLoginCard(context),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // MAIN CARD
  // ==========================================================

  Widget buildLoginCard(
    BuildContext context,
  ) {
    return Container(
      padding:
          EdgeInsets.all(
        Responsive.w(
          context,
          0.06,
        ),
      ),

      decoration:
          BoxDecoration(
        color:
            Colors.white,

        borderRadius:
            BorderRadius.circular(
          Responsive.radius(
            context,
            26,
          ),
        ),

        boxShadow: [
          BoxShadow(
            color:
                primaryBlue.withValues(
              alpha: 0.08,
            ),

            // Width scaling is more appropriate
            // for blur than radius scaling.
            blurRadius:
                Responsive.w(
              context,
              0.075,
            ),

            spreadRadius:
                0,

            offset:
                Offset(
              0,
              Responsive.h(
                context,
                0.012,
              ),
            ),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch,

        children: [

          // ==================================================
          // LOGO
          // ==================================================

          buildLogo(context),

          SizedBox(
            height:
                Responsive.h(
              context,
              0.02,
            ),
          ),

          // ==================================================
          // TITLE
          // ==================================================

          Text(
            isLogin
                ? 'Welcome Back!'
                : 'Create Account',

            textAlign:
                TextAlign.center,

            style:
                TextStyle(
              fontSize:
                  Responsive.font(
                context,
                6.2,
              ),

              fontWeight:
                  FontWeight.w700,

              color:
                  darkText,
            ),
          ),

          SizedBox(
            height:
                Responsive.h(
              context,
              0.008,
            ),
          ),

          // ==================================================
          // SUBTITLE
          // ==================================================

          Text(
            isLogin
                ? 'Log in to continue tracking your devices'
                : 'Create your TraceIt account',

            textAlign:
                TextAlign.center,

            style:
                TextStyle(
              fontSize:
                  Responsive.font(
                context,
                3.3,
              ),

              color:
                  secondaryText,

              height:
                  1.4,
            ),
          ),

          SizedBox(
            height:
                Responsive.h(
              context,
              0.03,
            ),
          ),

          // ==================================================
          // LOGIN / SIGN UP TABS
          // ==================================================

          buildAuthTabs(context),

          SizedBox(
            height:
                Responsive.h(
              context,
              0.03,
            ),
          ),

          // ==================================================
          // NAME - SIGN UP ONLY
          // ==========================================================

          if (!isLogin) ...[
            buildLabel(
              context,
              'Name',
            ),

            SizedBox(
              height:
                  Responsive.h(
                context,
                0.008,
              ),
            ),

            buildTextField(
              context,

              controller:
                  nameController,

              hint:
                  'Enter your name',

              icon:
                  Icons.person_outline,

              keyboardType:
                  TextInputType.name,
            ),

            SizedBox(
              height:
                  Responsive.h(
                context,
                0.022,
              ),
            ),
          ],

          // ==================================================
          // EMAIL
          // ==================================================

          buildLabel(
            context,
            'Email',
          ),

          SizedBox(
            height:
                Responsive.h(
              context,
              0.008,
            ),
          ),

          buildTextField(
            context,

            controller:
                emailController,

            hint:
                'Enter your email',

            icon:
                Icons.email_outlined,

            keyboardType:
                TextInputType.emailAddress,
          ),

          SizedBox(
            height:
                Responsive.h(
              context,
              0.022,
            ),
          ),

          // ==================================================
          // PASSWORD
          // ==================================================

          buildLabel(
            context,
            'Password',
          ),

          SizedBox(
            height:
                Responsive.h(
              context,
              0.008,
            ),
          ),

          buildTextField(
            context,

            controller:
                passwordController,

            hint:
                'Enter your password',

            icon:
                Icons.lock_outline,

            obscureText:
                hidePassword,

            suffixIcon:
                IconButton(
              onPressed: () {
                setState(() {
                  hidePassword =
                      !hidePassword;
                });
              },

              icon:
                  Icon(
                hidePassword
                    ? Icons
                        .visibility_off_outlined
                    : Icons
                        .visibility_outlined,

                size:
                    Responsive.w(
                  context,
                  0.055,
                ),

                color:
                    secondaryText,
              ),
            ),
          ),

          // ==================================================
          // FORGOT PASSWORD
          // ==================================================

          if (isLogin)
            Align(
              alignment:
                  Alignment.centerRight,

              child:
                  TextButton(
                onPressed:
                    forgotPassword,

                style:
                    TextButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(
                    horizontal:
                        Responsive.w(
                      context,
                      0.01,
                    ),

                    vertical:
                        Responsive.h(
                      context,
                      0.004,
                    ),
                  ),
                ),

                child:
                    Text(
                  'Forgot Password?',

                  style:
                      TextStyle(
                    fontSize:
                        Responsive.font(
                      context,
                      3.1,
                    ),

                    fontWeight:
                        FontWeight.w600,

                    color:
                        primaryBlue,
                  ),
                ),
              ),
            ),

          // ==================================================
          // CONFIRM PASSWORD
          // ==================================================

          if (!isLogin) ...[
            SizedBox(
              height:
                  Responsive.h(
                context,
                0.022,
              ),
            ),

            buildLabel(
              context,
              'Re-enter Password',
            ),

            SizedBox(
              height:
                  Responsive.h(
                context,
                0.008,
              ),
            ),

            buildTextField(
              context,

              controller:
                  confirmPasswordController,

              hint:
                  'Re-enter your password',

              icon:
                  Icons.lock_outline,

              obscureText:
                  hideConfirmPassword,

              suffixIcon:
                  IconButton(
                onPressed: () {
                  setState(() {
                    hideConfirmPassword =
                        !hideConfirmPassword;
                  });
                },

                icon:
                    Icon(
                  hideConfirmPassword
                      ? Icons
                          .visibility_off_outlined
                      : Icons
                          .visibility_outlined,

                  size:
                      Responsive.w(
                    context,
                    0.055,
                  ),

                  color:
                      secondaryText,
                ),
              ),
            ),
          ],

          SizedBox(
            height:
                Responsive.h(
              context,
              0.018,
            ),
          ),

          // ==================================================
          // MAIN BUTTON
          // ==================================================

          buildMainButton(context),

          SizedBox(
            height:
                Responsive.h(
              context,
              0.028,
            ),
          ),

          // ==================================================
          // OR DIVIDER
          // ==================================================

          buildDivider(context),

          SizedBox(
            height:
                Responsive.h(
              context,
              0.024,
            ),
          ),

          // ==================================================
          // GOOGLE BUTTON
          // ==================================================

          buildGoogleButton(context),

          SizedBox(
            height:
                Responsive.h(
              context,
              0.02,
            ),
          ),

          // ==================================================
          // BOTTOM TEXT
          // ==================================================

          buildBottomText(context),
        ],
      ),
    );
  }

  // ==========================================================
  // LOGO
  // ==========================================================

  Widget buildLogo(
    BuildContext context,
  ) {
    final double size =
        Responsive.w(
      context,
      0.19,
    );

    return Center(
      child:
          Container(
        width:
            size,

        height:
            size,

        decoration:
            BoxDecoration(
          gradient:
              const LinearGradient(
            begin:
                Alignment.topLeft,

            end:
                Alignment.bottomRight,

            colors: [
              lightBlue,
              primaryBlue,
              darkBlue,
            ],
          ),

          borderRadius:
              BorderRadius.circular(
            Responsive.radius(
              context,
              20,
            ),
          ),

          boxShadow: [
            BoxShadow(
              color:
                  primaryBlue.withValues(
                alpha: 0.25,
              ),

              // Width scaling is used for
              // the visual blur amount.
              blurRadius:
                  Responsive.w(
                context,
                0.05,
              ),

              offset:
                  Offset(
                0,
                Responsive.h(
                  context,
                  0.008,
                ),
              ),
            ),
          ],
        ),

        child:
            Icon(
          Icons.location_on_rounded,

          color:
              Colors.white,

          size:
              Responsive.w(
            context,
            0.095,
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // LOGIN / SIGN UP TABS
  // ==========================================================

  Widget buildAuthTabs(
    BuildContext context,
  ) {
    return Container(
      height:
          Responsive.h(
        context,
        0.065,
      ),

      padding:
          EdgeInsets.all(
        Responsive.w(
          context,
          0.01,
        ),
      ),

      decoration:
          BoxDecoration(
        color:
            lightSurface,

        borderRadius:
            BorderRadius.circular(
          Responsive.radius(
            context,
            15,
          ),
        ),
      ),

      child:
          Row(
        children: [

          Expanded(
            child:
                buildAuthTab(
              context,

              title:
                  'Log In',

              selected:
                  isLogin,

              onTap: () {
                setState(() {
                  isLogin =
                      true;
                });
              },
            ),
          ),

          Expanded(
            child:
                buildAuthTab(
              context,

              title:
                  'Sign Up',

              selected:
                  !isLogin,

              onTap: () {
                setState(() {
                  isLogin =
                      false;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // AUTH TAB
  // ==========================================================

  Widget buildAuthTab(
    BuildContext context, {

    required String title,

    required bool selected,

    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap:
          onTap,

      child:
          AnimatedContainer(
        duration:
            const Duration(
          milliseconds: 200,
        ),

        alignment:
            Alignment.center,

        decoration:
            BoxDecoration(
          color:
              selected
                  ? Colors.white
                  : Colors.transparent,

          borderRadius:
              BorderRadius.circular(
            Responsive.radius(
              context,
              12,
            ),
          ),

          boxShadow:
              selected
                  ? [
                      BoxShadow(
                        color:
                            primaryBlue
                                .withValues(
                          alpha: 0.10,
                        ),

                        blurRadius:
                            Responsive.w(
                          context,
                          0.02,
                        ),

                        offset:
                            Offset(
                          0,
                          Responsive.h(
                            context,
                            0.002,
                          ),
                        ),
                      ),
                    ]
                  : null,
        ),

        child:
            Text(
          title,

          style:
              TextStyle(
            fontSize:
                Responsive.font(
              context,
              3.5,
            ),

            fontWeight:
                FontWeight.w600,

            color:
                selected
                    ? primaryBlue
                    : const Color(
                        0xFF777B87,
                      ),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // LABEL
  // ==========================================================

  Widget buildLabel(
    BuildContext context,
    String text,
  ) {
    return Text(
      text,

      style:
          TextStyle(
        fontSize:
            Responsive.font(
          context,
          3.3,
        ),

        fontWeight:
            FontWeight.w600,

        color:
            const Color(
          0xFF252A36,
        ),
      ),
    );
  }

  // ==========================================================
  // TEXT FIELD
  // ==========================================================

  Widget buildTextField(
    BuildContext context, {

    required TextEditingController
        controller,

    required String hint,

    required IconData icon,

    bool obscureText =
        false,

    TextInputType?
        keyboardType,

    Widget? suffixIcon,
  }) {
    return TextField(
      controller:
          controller,

      obscureText:
          obscureText,

      keyboardType:
          keyboardType,

      textInputAction:
          TextInputAction.next,

      style:
          TextStyle(
        fontSize:
            Responsive.font(
          context,
          3.5,
        ),

        color:
            darkText,
      ),

      decoration:
          InputDecoration(
        hintText:
            hint,

        hintStyle:
            TextStyle(
          fontSize:
              Responsive.font(
            context,
            3.4,
          ),

          color:
              const Color(
            0xFF9AA6B5,
          ),
        ),

        prefixIcon:
            Icon(
          icon,

          size:
              Responsive.w(
            context,
            0.055,
          ),

          color:
              secondaryText,
        ),

        suffixIcon:
            suffixIcon,

        filled:
            true,

        fillColor:
            const Color(
          0xFFFAFCFF,
        ),

        contentPadding:
            EdgeInsets.symmetric(
          horizontal:
              Responsive.w(
            context,
            0.04,
          ),

          vertical:
              Responsive.h(
            context,
            0.018,
          ),
        ),

        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            Responsive.radius(
              context,
              14,
            ),
          ),

          borderSide:
              const BorderSide(
            color:
                border,
          ),
        ),

        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            Responsive.radius(
              context,
              14,
            ),
          ),

          borderSide:
              const BorderSide(
            color:
                primaryBlue,

            width:
                1.5,
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // MAIN BUTTON
  // ==========================================================

  Widget buildMainButton(
    BuildContext context,
  ) {
    return SizedBox(
      height:
          Responsive.h(
        context,
        0.065,
      ),

      child:
          DecoratedBox(
        decoration:
            BoxDecoration(
          gradient:
              const LinearGradient(
            begin:
                Alignment.centerLeft,

            end:
                Alignment.centerRight,

            colors: [
              lightBlue,
              primaryBlue,
              darkBlue,
            ],
          ),

          borderRadius:
              BorderRadius.circular(
            Responsive.radius(
              context,
              14,
            ),
          ),

          boxShadow: [
            BoxShadow(
              color:
                  primaryBlue.withValues(
                alpha: 0.25,
              ),

              blurRadius:
                  Responsive.w(
                context,
                0.036,
              ),

              offset:
                  Offset(
                0,
                Responsive.h(
                  context,
                  0.006,
                ),
              ),
            ),
          ],
        ),

        child:
            ElevatedButton(
          onPressed:
              isLoading ? null : submitForm,

          style:
              ElevatedButton.styleFrom(
            backgroundColor:
                Colors.transparent,

            foregroundColor:
                Colors.white,

            shadowColor:
                Colors.transparent,

            elevation:
                0,

            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(
                Responsive.radius(
                  context,
                  14,
                ),
              ),
            ),
          ),

          child: isLoading
              ? SizedBox(
                  width: Responsive.w(
                    context,
                    0.055,
                  ),
                  height: Responsive.w(
                    context,
                    0.055,
                  ),
                  child: const CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                )
              : Text(
                  isLogin
                      ? 'LOG IN'
                      : 'CREATE ACCOUNT',
                  style: TextStyle(
                    fontSize: Responsive.font(
                      context,
                      3.5,
                    ),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
        ),
      ),
    );
  }

  // ==========================================================
  // OR DIVIDER
  // ==========================================================

  Widget buildDivider(
    BuildContext context,
  ) {
    return Row(
      children: [

        const Expanded(
          child:
              Divider(
            color:
                Color(
              0xFFDCE7F5,
            ),
          ),
        ),

        Padding(
          padding:
              EdgeInsets.symmetric(
            horizontal:
                Responsive.w(
              context,
              0.035,
            ),
          ),

          child:
              Text(
            'OR',

            style:
                TextStyle(
              fontSize:
                  Responsive.font(
                context,
                3,
              ),

              fontWeight:
                  FontWeight.w500,

              color:
                  secondaryText,
            ),
          ),
        ),

        const Expanded(
          child:
              Divider(
            color:
                Color(
              0xFFDCE7F5,
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // GOOGLE BUTTON
  // ==========================================================

  Widget buildGoogleButton(
    BuildContext context,
  ) {
    return SizedBox(
      height:
          Responsive.h(
        context,
        0.065,
      ),

      child:
          OutlinedButton(
        onPressed:
            googleLogin,

        style:
            OutlinedButton.styleFrom(
          backgroundColor:
              Colors.white,

          side:
              const BorderSide(
            color:
                border,
          ),

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              Responsive.radius(
                context,
                14,
              ),
            ),
          ),
        ),

        child:
            Row(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            // =================================================
            // GOOGLE G
            // =================================================

            Text(
              'G',

              style:
                  TextStyle(
                fontSize:
                    Responsive.font(
                  context,
                  5.3,
                ),

                fontWeight:
                    FontWeight.w700,

                color:
                    const Color(
                  0xFF4285F4,
                ),
              ),
            ),

            SizedBox(
              width:
                  Responsive.w(
                context,
                0.025,
              ),
            ),

            Text(
              'Continue with Google',

              style:
                  TextStyle(
                fontSize:
                    Responsive.font(
                  context,
                  3.4,
                ),

                fontWeight:
                    FontWeight.w600,

                color:
                    darkText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // BOTTOM LOGIN / SIGN UP
  // ==========================================================

  Widget buildBottomText(
    BuildContext context,
  ) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.center,

      children: [

        Flexible(
          child:
              Text(
            isLogin
                ? "Don't have an account?"
                : 'Already have an account?',

            textAlign:
                TextAlign.center,

            style:
                TextStyle(
              fontSize:
                  Responsive.font(
                context,
                3.1,
              ),

              color:
                  secondaryText,
            ),
          ),
        ),

        TextButton(
          onPressed: () {
            setState(() {
              isLogin =
                  !isLogin;
            });
          },

          style:
              TextButton.styleFrom(
            padding:
                EdgeInsets.symmetric(
              horizontal:
                  Responsive.w(
                context,
                0.02,
              ),

              vertical:
                  Responsive.h(
                context,
                0.005,
              ),
            ),
          ),

          child:
              Text(
            isLogin
                ? 'Sign Up'
                : 'Log In',

            style:
                TextStyle(
              fontSize:
                  Responsive.font(
                context,
                3.1,
              ),

              fontWeight:
                  FontWeight.w700,

              color:
                  primaryBlue,
            ),
          ),
        ),
      ],
    );
  }
}