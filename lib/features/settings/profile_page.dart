import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/utils/responsive.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // ============================================================
  // FIREBASE
  // ============================================================

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // ============================================================
  // PROFILE DATA
  // ============================================================

  String userName = 'Loading...';
  String userEmail = 'Loading...';

  bool _loadingProfile = true;

  // ============================================================
  // COLORS
  // ============================================================

  final Color primaryBlue = const Color(0xFF1565FF);
  final Color lightBlue = const Color(0xFFEAF2FF);
  final Color textDark = const Color(0xFF172B4D);
  final Color textGrey = const Color(0xFF6B7280);

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // ============================================================
  // LOAD PROFILE FROM FIREBASE
  // ============================================================

  Future<void> _loadProfile() async {
    final User? user = _auth.currentUser;

    if (user == null) {
      if (!mounted) return;

      setState(() {
        userName = 'User';
        userEmail = '';
        _loadingProfile = false;
      });

      return;
    }

    try {
      // ----------------------------------------------------------
      // EMAIL COMES FROM FIREBASE AUTH
      // ----------------------------------------------------------

      final String email = user.email ?? '';

      // ----------------------------------------------------------
      // NAME COMES FROM FIRESTORE
      //
      // users/{authenticated UID}
      // ----------------------------------------------------------

      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore
              .collection('users')
              .doc(user.uid)
              .get();

      String name = '';

      if (snapshot.exists) {
        final Map<String, dynamic>? data =
            snapshot.data();

        if (data != null) {
          name = data['name']?.toString().trim() ?? '';
        }
      }

      // ----------------------------------------------------------
      // FALLBACK TO FIREBASE AUTH DISPLAY NAME
      // ----------------------------------------------------------

      if (name.isEmpty) {
        name = user.displayName?.trim() ?? '';
      }

      // ----------------------------------------------------------
      // FINAL FALLBACK
      // ----------------------------------------------------------

      if (name.isEmpty) {
        name = 'User';
      }

      if (!mounted) return;

      setState(() {
        userName = name;
        userEmail = email;
        _loadingProfile = false;
      });
    } on FirebaseException catch (e) {
      debugPrint(
        'Error loading profile: ${e.code} - ${e.message}',
      );

      if (!mounted) return;

      // Even if Firestore fails, still show Auth email.
      setState(() {
        userName =
            user.displayName?.trim().isNotEmpty == true
                ? user.displayName!.trim()
                : 'User';

        userEmail = user.email ?? '';
        _loadingProfile = false;
      });
    } catch (e) {
      debugPrint('Error loading profile: $e');

      if (!mounted) return;

      setState(() {
        userName = 'User';
        userEmail = user.email ?? '';
        _loadingProfile = false;
      });
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FC),
        elevation: 0,
        scrolledUnderElevation: 0,

        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: textDark,
            size: Responsive.w(
              context,
              24 / 390,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),

        title: Text(
          'Profile',
          style: TextStyle(
            color: textDark,
            fontSize: Responsive.font(
              context,
              20 * 100 / 390,
            ),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: _loadingProfile
          ? Center(
              child: CircularProgressIndicator(
                color: primaryBlue,
              ),
            )
          : RefreshIndicator(
              color: primaryBlue,
              onRefresh: _loadProfile,

              child: SingleChildScrollView(
                physics:
                    const AlwaysScrollableScrollPhysics(),

                padding: EdgeInsets.fromLTRB(
                  Responsive.w(context, 20 / 390),
                  Responsive.h(context, 10 / 844),
                  Responsive.w(context, 20 / 390),
                  Responsive.h(context, 30 / 844),
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    // ====================================================
                    // PROFILE HEADER
                    // ====================================================

                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height:
                                Responsive.h(
                              context,
                              8 / 844,
                            ),
                          ),

                          Container(
                            width:
                                Responsive.w(
                              context,
                              92 / 390,
                            ),
                            height:
                                Responsive.w(
                              context,
                              92 / 390,
                            ),

                            decoration:
                                BoxDecoration(
                              color: lightBlue,
                              shape: BoxShape.circle,
                            ),

                            child: Icon(
                              Icons.person,
                              size:
                                  Responsive.w(
                                context,
                                52 / 390,
                              ),
                              color: primaryBlue,
                            ),
                          ),

                          SizedBox(
                            height:
                                Responsive.h(
                              context,
                              14 / 844,
                            ),
                          ),

                          Text(
                            userName,
                            textAlign:
                                TextAlign.center,

                            style: TextStyle(
                              color: textDark,
                              fontSize:
                                  Responsive.font(
                                context,
                                21 * 100 / 390,
                              ),
                              fontWeight:
                                  FontWeight.w700,
                            ),
                          ),

                          SizedBox(
                            height:
                                Responsive.h(
                              context,
                              5 / 844,
                            ),
                          ),

                          Text(
                            userEmail,
                            textAlign:
                                TextAlign.center,

                            style: TextStyle(
                              color: textGrey,
                              fontSize:
                                  Responsive.font(
                                context,
                                14 * 100 / 390,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height:
                          Responsive.h(
                        context,
                        30 / 844,
                      ),
                    ),

                    // ====================================================
                    // PERSONAL INFORMATION
                    // ====================================================

                    _sectionTitle(
                      context,
                      'Personal Information',
                    ),

                    SizedBox(
                      height:
                          Responsive.h(
                        context,
                        8 / 844,
                      ),
                    ),

                    _profileCard(
                      context,

                      children: [
                        _profileRow(
                          context,
                          icon:
                              Icons.person_outline,
                          title: 'Name',
                          subtitle: userName,
                          onTap: _editName,
                        ),

                        _divider(context),

                        _profileRow(
                          context,
                          icon:
                              Icons.email_outlined,
                          title: 'Email',
                          subtitle: userEmail,
                          onTap: _editEmail,
                        ),
                      ],
                    ),

                    SizedBox(
                      height:
                          Responsive.h(
                        context,
                        24 / 844,
                      ),
                    ),

                    // ====================================================
                    // ACCOUNT
                    // ====================================================

                    _sectionTitle(
                      context,
                      'Account',
                    ),

                    SizedBox(
                      height:
                          Responsive.h(
                        context,
                        8 / 844,
                      ),
                    ),

                    _profileCard(
                      context,

                      children: [
                        _profileRow(
                          context,
                          icon:
                              Icons.lock_outline,
                          title:
                              'Change Password',
                          subtitle:
                              'Update your account password',
                          onTap:
                              _changePassword,
                        ),
                      ],
                    ),

                    SizedBox(
                      height:
                          Responsive.h(
                        context,
                        24 / 844,
                      ),
                    ),

                    // ====================================================
                    // ABOUT
                    // ====================================================

                    _sectionTitle(
                      context,
                      'About',
                    ),

                    SizedBox(
                      height:
                          Responsive.h(
                        context,
                        8 / 844,
                      ),
                    ),

                    _profileCard(
                      context,

                      children: [
                        _profileRow(
                          context,
                          icon:
                              Icons.info_outline,
                          title:
                              'About TraceIt',
                          subtitle:
                              'Version 1.0.0',
                          onTap:
                              _showAbout,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _sectionTitle(
    BuildContext context,
    String title,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        left:
            Responsive.w(
          context,
          4 / 390,
        ),
      ),

      child: Text(
        title,

        style: TextStyle(
          color: primaryBlue,

          fontSize:
              Responsive.font(
            context,
            14 * 100 / 390,
          ),

          fontWeight:
              FontWeight.w700,
        ),
      ),
    );
  }

  // ============================================================
  // PROFILE CARD
  // ============================================================

  Widget _profileCard(
    BuildContext context, {
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          Responsive.radius(
            context,
            18,
          ),
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(
              alpha: 0.04,
            ),

            blurRadius:
                Responsive.w(
              context,
              10 / 390,
            ),

            offset: Offset(
              0,
              Responsive.h(
                context,
                3 / 844,
              ),
            ),
          ),
        ],
      ),

      child: Column(
        children: children,
      ),
    );
  }

  // ============================================================
  // PROFILE ROW
  // ============================================================

  Widget _profileRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius:
          BorderRadius.circular(
        Responsive.radius(
          context,
          18,
        ),
      ),

      child: Padding(
        padding:
            EdgeInsets.symmetric(
          horizontal:
              Responsive.w(
            context,
            16 / 390,
          ),

          vertical:
              Responsive.h(
            context,
            15 / 844,
          ),
        ),

        child: Row(
          children: [
            Container(
              width:
                  Responsive.w(
                context,
                42 / 390,
              ),

              height:
                  Responsive.w(
                context,
                42 / 390,
              ),

              decoration:
                  BoxDecoration(
                color: lightBlue,

                borderRadius:
                    BorderRadius.circular(
                  Responsive.radius(
                    context,
                    12,
                  ),
                ),
              ),

              child: Icon(
                icon,

                color:
                    primaryBlue,

                size:
                    Responsive.w(
                  context,
                  22 / 390,
                ),
              ),
            ),

            SizedBox(
              width:
                  Responsive.w(
                context,
                14 / 390,
              ),
            ),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Text(
                    title,

                    style: TextStyle(
                      color: textDark,

                      fontSize:
                          Responsive.font(
                        context,
                        15 * 100 / 390,
                      ),

                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),

                  SizedBox(
                    height:
                        Responsive.h(
                      context,
                      4 / 844,
                    ),
                  ),

                  Text(
                    subtitle,

                    maxLines: 2,

                    overflow:
                        TextOverflow.ellipsis,

                    style: TextStyle(
                      color: textGrey,

                      fontSize:
                          Responsive.font(
                        context,
                        13 * 100 / 390,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              width:
                  Responsive.w(
                context,
                6 / 390,
              ),
            ),

            Icon(
              Icons.chevron_right,

              color:
                  primaryBlue,

              size:
                  Responsive.w(
                context,
                23 / 390,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // DIVIDER
  // ============================================================

  Widget _divider(
    BuildContext context,
  ) {
    return Divider(
      height:
          Responsive.h(
        context,
        1 / 844,
      ),

      thickness:
          Responsive.h(
        context,
        0.7 / 844,
      ),

      indent:
          Responsive.w(
        context,
        72 / 390,
      ),

      endIndent: 0,
    );
  }

  // ============================================================
  // EDIT NAME
  // ============================================================

  Future<void> _editName() async {
    final String? newName =
        await showDialog<String>(
      context: context,

      barrierDismissible: true,

      builder: (dialogContext) {
        return _EditTextDialog(
          title: 'Edit Name',

          initialValue:
              userName == 'User'
                  ? ''
                  : userName,

          hintText: 'Your name',

          primaryBlue:
              primaryBlue,
        );
      },
    );

    if (!mounted) return;

    if (newName == null ||
        newName.trim().isEmpty) {
      return;
    }

    final User? user =
        _auth.currentUser;

    if (user == null) {
      _showMessage(
        'You are not logged in.',
      );
      return;
    }

    final String trimmedName =
        newName.trim();

    try {
      // ----------------------------------------------------------
      // UPDATE FIRESTORE
      // users/{uid}
      // ----------------------------------------------------------

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(
        {
          'uid': user.uid,
          'name': trimmedName,
          'email': user.email ?? userEmail,
          'updatedAt':
              FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      // ----------------------------------------------------------
      // ALSO UPDATE FIREBASE AUTH DISPLAY NAME
      // ----------------------------------------------------------

      await user.updateDisplayName(
        trimmedName,
      );

      if (!mounted) return;

      setState(() {
        userName = trimmedName;
      });

      _showMessage(
        'Name updated successfully.',
      );
    } on FirebaseException catch (e) {
      if (!mounted) return;

      _showMessage(
        e.message ??
            'Unable to update name.',
      );
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'Unable to update name.',
      );
    }
  }

  // ============================================================
  // EDIT EMAIL
  // ============================================================

  Future<void> _editEmail() async {
    final String? newEmail =
        await showDialog<String>(
      context: context,

      barrierDismissible: true,

      builder: (dialogContext) {
        return _EditTextDialog(
          title: 'Edit Email',

          initialValue:
              userEmail,

          hintText:
              'Enter your email',

          keyboardType:
              TextInputType.emailAddress,

          primaryBlue:
              primaryBlue,
        );
      },
    );

    if (!mounted) return;

    if (newEmail == null ||
        newEmail.trim().isEmpty) {
      return;
    }

    final String trimmedEmail =
        newEmail.trim();

    if (!trimmedEmail.contains('@')) {
      _showMessage(
        'Please enter a valid email address.',
      );
      return;
    }

    final User? user =
        _auth.currentUser;

    if (user == null) {
      _showMessage(
        'You are not logged in.',
      );
      return;
    }

    // ----------------------------------------------------------
    // EMAIL CHANGES REQUIRE FIREBASE AUTHENTICATION.
    //
    // Firebase may reject this if the user's login is not recent.
    // We intentionally do NOT just change the UI or Firestore,
    // because that would make the profile email inconsistent
    // with Firebase Authentication.
    // ----------------------------------------------------------

    if (trimmedEmail ==
        (user.email ?? '')) {
      return;
    }

    try {
      await user.verifyBeforeUpdateEmail(
        trimmedEmail,
      );

      if (!mounted) return;

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(
        {
          'email': trimmedEmail,
          'updatedAt':
              FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      if (!mounted) return;

      setState(() {
        userEmail = trimmedEmail;
      });

      _showMessage(
        'Verification email sent to $trimmedEmail.',
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String message;

      switch (e.code) {
        case 'requires-recent-login':
          message =
              'Please log in again before changing your email.';
          break;

        case 'email-already-in-use':
          message =
              'That email is already being used by another account.';
          break;

        case 'invalid-email':
          message =
              'Please enter a valid email address.';
          break;

        default:
          message =
              e.message ??
              'Unable to change email.';
      }

      _showMessage(message);
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'Unable to change email.',
      );
    }
  }

  // ============================================================
  // CHANGE PASSWORD
  // ============================================================

  Future<void> _changePassword() async {
    final bool? result =
        await showDialog<bool>(
      context: context,

      barrierDismissible: true,

      builder: (dialogContext) {
        return _ChangePasswordDialog(
          primaryBlue:
              primaryBlue,
        );
      },
    );

    if (!mounted) return;

    if (result == true) {
      _showMessage(
        'Password updated successfully.',
      );
    }
  }

  // ============================================================
  // ABOUT
  // ============================================================

  void _showAbout() {
    showDialog(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor:
              Colors.white,

          surfaceTintColor:
              Colors.white,

          insetPadding:
              EdgeInsets.symmetric(
            horizontal:
                Responsive.w(
              context,
              24 / 390,
            ),

            vertical:
                Responsive.h(
              context,
              24 / 844,
            ),
          ),

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              Responsive.radius(
                context,
                22,
              ),
            ),
          ),

          title: Text(
            'About TraceIt',

            style: TextStyle(
              color: primaryBlue,

              fontSize:
                  Responsive.font(
                context,
                20 * 100 / 390,
              ),

              fontWeight:
                  FontWeight.w700,
            ),
          ),

          content: Column(
            mainAxisSize:
                MainAxisSize.min,

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Text(
                'TraceIt',

                style: TextStyle(
                  fontSize:
                      Responsive.font(
                    context,
                    20 * 100 / 390,
                  ),

                  fontWeight:
                      FontWeight.w700,
                ),
              ),

              SizedBox(
                height:
                    Responsive.h(
                  context,
                  6 / 844,
                ),
              ),

              Text(
                'Smart Finder & Safety App',

                style: TextStyle(
                  fontSize:
                      Responsive.font(
                    context,
                    14 * 100 / 390,
                  ),
                ),
              ),

              SizedBox(
                height:
                    Responsive.h(
                  context,
                  14 / 844,
                ),
              ),

              Text(
                'Version 1.0.0',

                style: TextStyle(
                  fontSize:
                      Responsive.font(
                    context,
                    14 * 100 / 390,
                  ),
                ),
              ),

              SizedBox(
                height:
                    Responsive.h(
                  context,
                  12 / 844,
                ),
              ),

              Text(
                'TraceIt helps you locate and '
                'protect your important belongings '
                'using smart tracking and safety '
                'features.',

                style: TextStyle(
                  fontSize:
                      Responsive.font(
                    context,
                    14 * 100 / 390,
                  ),

                  height: 1.5,
                ),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop();
              },

              child: Text(
                'Close',

                style: TextStyle(
                  color: primaryBlue,

                  fontSize:
                      Responsive.font(
                    context,
                    14 * 100 / 390,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(
    String message,
  ) {
    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        content:
            Text(message),

        backgroundColor:
            primaryBlue,
      ),
    );
  }
}

// ==================================================================
// EDIT TEXT DIALOG
// ==================================================================

class _EditTextDialog
    extends StatefulWidget {
  final String title;
  final String initialValue;
  final String hintText;
  final TextInputType? keyboardType;
  final Color primaryBlue;

  const _EditTextDialog({
    required this.title,
    required this.initialValue,
    required this.hintText,
    required this.primaryBlue,
    this.keyboardType,
  });

  @override
  State<_EditTextDialog> createState() =>
      _EditTextDialogState();
}

class _EditTextDialogState
    extends State<_EditTextDialog> {
  late final TextEditingController
      _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        TextEditingController(
      text: widget.initialValue,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final String value =
        _controller.text.trim();

    if (value.isEmpty) {
      return;
    }

    Navigator.of(context).pop(value);
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return AlertDialog(
      backgroundColor:
          Colors.white,

      surfaceTintColor:
          Colors.white,

      insetPadding:
          EdgeInsets.symmetric(
        horizontal:
            Responsive.w(
          context,
          24 / 390,
        ),

        vertical:
            Responsive.h(
          context,
          24 / 844,
        ),
      ),

      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(
          Responsive.radius(
            context,
            22,
          ),
        ),
      ),

      title: Text(
        widget.title,

        style: TextStyle(
          color:
              widget.primaryBlue,

          fontSize:
              Responsive.font(
            context,
            22 * 100 / 390,
          ),

          fontWeight:
              FontWeight.w700,
        ),
      ),

      content:
          SingleChildScrollView(
        child: TextField(
          controller:
              _controller,

          autofocus: true,

          keyboardType:
              widget.keyboardType,

          cursorColor:
              widget.primaryBlue,

          style: TextStyle(
            color:
                Colors.black87,

            fontSize:
                Responsive.font(
              context,
              16 * 100 / 390,
            ),
          ),

          decoration:
              InputDecoration(
            hintText:
                widget.hintText,

            hintStyle:
                TextStyle(
              color:
                  Colors.grey.shade500,

              fontSize:
                  Responsive.font(
                context,
                16 * 100 / 390,
              ),
            ),

            filled: true,

            fillColor:
                const Color(
              0xFFF7F9FC,
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
                  BorderSide(
                color:
                    Colors.grey.shade300,
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
                  BorderSide(
                color:
                    widget.primaryBlue,

                width:
                    Responsive.w(
                  context,
                  2 / 390,
                ),
              ),
            ),
          ),

          onSubmitted:
              (_) => _save(),
        ),
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(
              context,
            ).pop();
          },

          child: Text(
            'Cancel',

            style: TextStyle(
              color:
                  widget.primaryBlue,

              fontSize:
                  Responsive.font(
                context,
                14 * 100 / 390,
              ),

              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ),

        ElevatedButton(
          style:
              ElevatedButton.styleFrom(
            backgroundColor:
                widget.primaryBlue,

            foregroundColor:
                Colors.white,

            elevation: 0,

            padding:
                EdgeInsets.symmetric(
              horizontal:
                  Responsive.w(
                context,
                16 / 390,
              ),

              vertical:
                  Responsive.h(
                context,
                10 / 844,
              ),
            ),

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

          onPressed:
              _save,

          child: Text(
            'Save',

            style: TextStyle(
              fontSize:
                  Responsive.font(
                context,
                14 * 100 / 390,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ==================================================================
// CHANGE PASSWORD DIALOG
// ==================================================================

class _ChangePasswordDialog
    extends StatefulWidget {
  final Color primaryBlue;

  const _ChangePasswordDialog({
    required this.primaryBlue,
  });

  @override
  State<_ChangePasswordDialog> createState() =>
      _ChangePasswordDialogState();
}

class _ChangePasswordDialogState
    extends State<_ChangePasswordDialog> {
  late final TextEditingController
      _currentPasswordController;

  late final TextEditingController
      _newPasswordController;

  late final TextEditingController
      _confirmPasswordController;

  bool _hideCurrentPassword = true;
  bool _hideNewPassword = true;
  bool _hideConfirmPassword = true;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _currentPasswordController =
        TextEditingController();

    _newPasswordController =
        TextEditingController();

    _confirmPasswordController =
        TextEditingController();
  }

  @override
  void dispose() {
    _currentPasswordController
        .dispose();

    _newPasswordController
        .dispose();

    _confirmPasswordController
        .dispose();

    super.dispose();
  }

  // ================================================================
  // SAVE PASSWORD
  // ================================================================

  Future<void> _save() async {
    final String currentPassword =
        _currentPasswordController
            .text
            .trim();

    final String newPassword =
        _newPasswordController
            .text
            .trim();

    final String confirmPassword =
        _confirmPasswordController
            .text
            .trim();

    // --------------------------------------------------------------
    // VALIDATION
    // --------------------------------------------------------------

    if (currentPassword.isEmpty) {
      _showError(
        'Please enter your current password.',
      );
      return;
    }

    if (newPassword.isEmpty) {
      _showError(
        'Please enter a new password.',
      );
      return;
    }

    if (confirmPassword.isEmpty) {
      _showError(
        'Please confirm your new password.',
      );
      return;
    }

    if (newPassword != confirmPassword) {
      _showError(
        'New passwords do not match.',
      );
      return;
    }

    if (newPassword.length < 6) {
      _showError(
        'New password must be at least 6 characters.',
      );
      return;
    }

    if (currentPassword ==
        newPassword) {
      _showError(
        'New password must be different from your current password.',
      );
      return;
    }

    // --------------------------------------------------------------
    // CURRENT USER
    // --------------------------------------------------------------

    final User? user =
        FirebaseAuth.instance.currentUser;

    if (user == null) {
      _showError(
        'No authenticated user found. Please log in again.',
      );
      return;
    }

    final String? email =
        user.email;

    if (email == null ||
        email.isEmpty) {
      _showError(
        'Your account does not have a valid email address.',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // ------------------------------------------------------------
      // STEP 1
      // VERIFY CURRENT PASSWORD
      // ------------------------------------------------------------

      final AuthCredential credential =
          EmailAuthProvider.credential(
        email: email,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(
        credential,
      );

      // ------------------------------------------------------------
      // STEP 2
      // CHANGE PASSWORD
      // ------------------------------------------------------------

      await user.updatePassword(
        newPassword,
      );

      if (!mounted) return;

      Navigator.of(
        context,
      ).pop(true);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String message;

      switch (e.code) {
        case 'wrong-password':
        case 'invalid-credential':
          message =
              'Current password is incorrect.';
          break;

        case 'too-many-requests':
          message =
              'Too many attempts. Please try again later.';
          break;

        case 'weak-password':
          message =
              'The new password is too weak.';
          break;

        case 'requires-recent-login':
          message =
              'Please log in again before changing your password.';
          break;

        case 'network-request-failed':
          message =
              'Network error. Please check your internet connection.';
          break;

        default:
          message =
              e.message ??
              'Unable to change password.';
      }

      setState(() {
        _isLoading = false;
      });

      _showError(message);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      _showError(
        'Something went wrong. Please try again.',
      );
    }
  }

  // ================================================================
  // ERROR
  // ================================================================

  void _showError(
    String message,
  ) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        content:
            Text(message),
      ),
    );
  }

  // ================================================================
  // PASSWORD FIELD
  // ================================================================

  Widget _passwordField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,

      obscureText:
          obscureText,

      cursorColor:
          widget.primaryBlue,

      style: TextStyle(
        color:
            Colors.black87,

        fontSize:
            Responsive.font(
          context,
          16 * 100 / 390,
        ),
      ),

      decoration:
          InputDecoration(
        labelText:
            label,

        labelStyle:
            TextStyle(
          color:
              Colors.grey.shade600,

          fontSize:
              Responsive.font(
            context,
            14 * 100 / 390,
          ),
        ),

        suffixIcon:
            IconButton(
          onPressed:
              onToggle,

          icon: Icon(
            obscureText
                ? Icons
                    .visibility_off_outlined
                : Icons
                    .visibility_outlined,

            color:
                Colors.grey.shade600,
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
              BorderSide(
            color:
                widget.primaryBlue,

            width:
                Responsive.w(
              context,
              2 / 390,
            ),
          ),
        ),

        border:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            Responsive.radius(
              context,
              14,
            ),
          ),
        ),
      ),
    );
  }

  // ================================================================
  // BUILD
  // ================================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return AlertDialog(
      backgroundColor:
          Colors.white,

      surfaceTintColor:
          Colors.white,

      insetPadding:
          EdgeInsets.symmetric(
        horizontal:
            Responsive.w(
          context,
          24 / 390,
        ),

        vertical:
            Responsive.h(
          context,
          24 / 844,
        ),
      ),

      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(
          Responsive.radius(
            context,
            22,
          ),
        ),
      ),

      title: Text(
        'Change Password',

        style: TextStyle(
          color:
              widget.primaryBlue,

          fontSize:
              Responsive.font(
            context,
            22 * 100 / 390,
          ),

          fontWeight:
              FontWeight.w700,
        ),
      ),

      content:
          SingleChildScrollView(
        child: Column(
          mainAxisSize:
              MainAxisSize.min,

          children: [
            // --------------------------------------------------------
            // CURRENT PASSWORD
            // --------------------------------------------------------

            _passwordField(
              context: context,

              controller:
                  _currentPasswordController,

              label:
                  'Current password',

              obscureText:
                  _hideCurrentPassword,

              onToggle: () {
                setState(() {
                  _hideCurrentPassword =
                      !_hideCurrentPassword;
                });
              },
            ),

            SizedBox(
              height:
                  Responsive.h(
                context,
                14 / 844,
              ),
            ),

            // --------------------------------------------------------
            // NEW PASSWORD
            // --------------------------------------------------------

            _passwordField(
              context: context,

              controller:
                  _newPasswordController,

              label:
                  'New password',

              obscureText:
                  _hideNewPassword,

              onToggle: () {
                setState(() {
                  _hideNewPassword =
                      !_hideNewPassword;
                });
              },
            ),

            SizedBox(
              height:
                  Responsive.h(
                context,
                14 / 844,
              ),
            ),

            // --------------------------------------------------------
            // CONFIRM PASSWORD
            // --------------------------------------------------------

            _passwordField(
              context: context,

              controller:
                  _confirmPasswordController,

              label:
                  'Confirm new password',

              obscureText:
                  _hideConfirmPassword,

              onToggle: () {
                setState(() {
                  _hideConfirmPassword =
                      !_hideConfirmPassword;
                });
              },
            ),
          ],
        ),
      ),

      actions: [
        // ----------------------------------------------------------
        // CANCEL
        // ----------------------------------------------------------

        TextButton(
          onPressed:
              _isLoading
                  ? null
                  : () {
                      Navigator.of(
                        context,
                      ).pop(false);
                    },

          child: Text(
            'Cancel',

            style: TextStyle(
              color:
                  widget.primaryBlue,

              fontSize:
                  Responsive.font(
                context,
                14 * 100 / 390,
              ),

              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ),

        // ----------------------------------------------------------
        // SAVE
        // ----------------------------------------------------------

        ElevatedButton(
          style:
              ElevatedButton.styleFrom(
            backgroundColor:
                widget.primaryBlue,

            foregroundColor:
                Colors.white,

            elevation: 0,

            padding:
                EdgeInsets.symmetric(
              horizontal:
                  Responsive.w(
                context,
                16 / 390,
              ),

              vertical:
                  Responsive.h(
                context,
                10 / 844,
              ),
            ),

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

          onPressed:
              _isLoading
                  ? null
                  : _save,

          child:
              _isLoading
                  ? SizedBox(
                      width:
                          Responsive.w(
                        context,
                        18 / 390,
                      ),

                      height:
                          Responsive.w(
                        context,
                        18 / 390,
                      ),

                      child:
                          const CircularProgressIndicator(
                        strokeWidth: 2,
                        color:
                            Colors.white,
                      ),
                    )
                  : Text(
                      'Save',

                      style:
                          TextStyle(
                        fontSize:
                            Responsive.font(
                          context,
                          14 * 100 / 390,
                        ),
                      ),
                    ),
        ),
      ],
    );
  }
}