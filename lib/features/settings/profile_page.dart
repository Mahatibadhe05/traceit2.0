import 'package:flutter/material.dart';
import '../../core/utils/responsive.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // ============================================================
  // PROFILE DATA
  // ============================================================

  String userName = 'Your name';
  String userEmail = 'purva.ambre@example.com';

  final Color primaryBlue = const Color(0xFF1565FF);
  final Color lightBlue = const Color(0xFFEAF2FF);
  final Color textDark = const Color(0xFF172B4D);
  final Color textGrey = const Color(0xFF6B7280);

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
            size: Responsive.w(context, 24 / 390),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),

        title: Text(
          'Profile',
          style: TextStyle(
            color: textDark,
            fontSize: Responsive.font(context, 20 * 100 / 390),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          Responsive.w(context, 20 / 390),
          Responsive.h(context, 10 / 844),
          Responsive.w(context, 20 / 390),
          Responsive.h(context, 30 / 844),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ====================================================
            // PROFILE HEADER
            // ====================================================

            Center(
              child: Column(
                children: [
                  SizedBox(
                    height: Responsive.h(context, 8 / 844),
                  ),

                  Container(
                    width: Responsive.w(context, 92 / 390),
                    height: Responsive.w(context, 92 / 390),

                    decoration: BoxDecoration(
                      color: lightBlue,
                      shape: BoxShape.circle,
                    ),

                    child: Icon(
                      Icons.person,
                      size: Responsive.w(context, 52 / 390),
                      color: primaryBlue,
                    ),
                  ),

                  SizedBox(
                    height: Responsive.h(context, 14 / 844),
                  ),

                  Text(
                    userName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textDark,
                      fontSize: Responsive.font(
                        context,
                        21 * 100 / 390,
                      ),
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  SizedBox(
                    height: Responsive.h(context, 5 / 844),
                  ),

                  Text(
                    userEmail,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textGrey,
                      fontSize: Responsive.font(
                        context,
                        14 * 100 / 390,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: Responsive.h(context, 30 / 844),
            ),

            // ====================================================
            // PERSONAL INFORMATION
            // ====================================================

            _sectionTitle(
              context,
              'Personal Information',
            ),

            SizedBox(
              height: Responsive.h(context, 8 / 844),
            ),

            _profileCard(
              context,
              children: [
                _profileRow(
                  context,
                  icon: Icons.person_outline,
                  title: 'Name',
                  subtitle: userName,
                  onTap: _editName,
                ),

                _divider(context),

                _profileRow(
                  context,
                  icon: Icons.email_outlined,
                  title: 'Email',
                  subtitle: userEmail,
                  onTap: _editEmail,
                ),
              ],
            ),

            SizedBox(
              height: Responsive.h(context, 24 / 844),
            ),

            // ====================================================
            // ACCOUNT
            // ====================================================

            _sectionTitle(
              context,
              'Account',
            ),

            SizedBox(
              height: Responsive.h(context, 8 / 844),
            ),

            _profileCard(
              context,
              children: [
                _profileRow(
                  context,
                  icon: Icons.lock_outline,
                  title: 'Change Password',
                  subtitle: 'Update your account password',
                  onTap: _changePassword,
                ),
              ],
            ),

            SizedBox(
              height: Responsive.h(context, 24 / 844),
            ),

            // ====================================================
            // ABOUT
            // ====================================================

            _sectionTitle(
              context,
              'About',
            ),

            SizedBox(
              height: Responsive.h(context, 8 / 844),
            ),

            _profileCard(
              context,
              children: [
                _profileRow(
                  context,
                  icon: Icons.info_outline,
                  title: 'About TraceIt',
                  subtitle: 'Version 1.0.0',
                  onTap: _showAbout,
                ),
              ],
            ),
          ],
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
        left: Responsive.w(context, 4 / 390),
      ),

      child: Text(
        title,
        style: TextStyle(
          color: primaryBlue,
          fontSize: Responsive.font(
            context,
            14 * 100 / 390,
          ),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ============================================================
  // CARD
  // ============================================================

  Widget _profileCard(
    BuildContext context, {
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(
          Responsive.radius(context, 18),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: Responsive.w(context, 10 / 390),
            offset: Offset(
              0,
              Responsive.h(context, 3 / 844),
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

      borderRadius: BorderRadius.circular(
        Responsive.radius(context, 18),
      ),

      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.w(context, 16 / 390),
          vertical: Responsive.h(context, 15 / 844),
        ),

        child: Row(
          children: [
            Container(
              width: Responsive.w(context, 42 / 390),
              height: Responsive.w(context, 42 / 390),

              decoration: BoxDecoration(
                color: lightBlue,

                borderRadius: BorderRadius.circular(
                  Responsive.radius(context, 12),
                ),
              ),

              child: Icon(
                icon,
                color: primaryBlue,
                size: Responsive.w(context, 22 / 390),
              ),
            ),

            SizedBox(
              width: Responsive.w(context, 14 / 390),
            ),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textDark,
                      fontSize: Responsive.font(
                        context,
                        15 * 100 / 390,
                      ),
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(
                    height: Responsive.h(context, 4 / 844),
                  ),

                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textGrey,
                      fontSize: Responsive.font(
                        context,
                        13 * 100 / 390,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              width: Responsive.w(context, 6 / 390),
            ),

            Icon(
              Icons.chevron_right,
              color: primaryBlue,
              size: Responsive.w(context, 23 / 390),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // DIVIDER
  // ============================================================

  Widget _divider(BuildContext context) {
    return Divider(
      height: Responsive.h(context, 1 / 844),
      thickness: Responsive.h(context, 0.7 / 844),
      indent: Responsive.w(context, 72 / 390),
      endIndent: 0,
    );
  }

  // ============================================================
  // EDIT NAME
  // ============================================================

  Future<void> _editName() async {
    final String? newName = await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return _EditTextDialog(
          title: 'Edit Name',
          initialValue:
              userName == 'Your name' ? '' : userName,
          hintText: 'Your name',
          primaryBlue: primaryBlue,
        );
      },
    );

    if (!mounted) return;

    if (newName != null && newName.trim().isNotEmpty) {
      setState(() {
        userName = newName.trim();
      });
    }
  }

  // ============================================================
  // EDIT EMAIL
  // ============================================================

  Future<void> _editEmail() async {
    final String? newEmail = await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return _EditTextDialog(
          title: 'Edit Email',
          initialValue: userEmail,
          hintText: 'Enter your email',
          keyboardType: TextInputType.emailAddress,
          primaryBlue: primaryBlue,
        );
      },
    );

    if (!mounted) return;

    if (newEmail != null && newEmail.trim().isNotEmpty) {
      setState(() {
        userEmail = newEmail.trim();
      });
    }
  }

  // ============================================================
  // CHANGE PASSWORD
  // ============================================================

  Future<void> _changePassword() async {
    final bool? result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return _ChangePasswordDialog(
          primaryBlue: primaryBlue,
        );
      },
    );

    if (!mounted) return;

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Password updated successfully.',
          ),
          backgroundColor: primaryBlue,
        ),
      );
    }
  }

  // ============================================================
  // ABOUT TRACEIT
  // ============================================================

  void _showAbout() {
    showDialog(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,

          insetPadding: EdgeInsets.symmetric(
            horizontal: Responsive.w(context, 24 / 390),
            vertical: Responsive.h(context, 24 / 844),
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              Responsive.radius(context, 22),
            ),
          ),

          title: Text(
            'About TraceIt',
            style: TextStyle(
              color: primaryBlue,
              fontSize: Responsive.font(
                context,
                20 * 100 / 390,
              ),
              fontWeight: FontWeight.w700,
            ),
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                'TraceIt',
                style: TextStyle(
                  fontSize: Responsive.font(
                    context,
                    20 * 100 / 390,
                  ),
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(
                height: Responsive.h(context, 6 / 844),
              ),

              Text(
                'Smart Finder & Safety App',
                style: TextStyle(
                  fontSize: Responsive.font(
                    context,
                    14 * 100 / 390,
                  ),
                ),
              ),

              SizedBox(
                height: Responsive.h(context, 14 / 844),
              ),

              Text(
                'Version 1.0.0',
                style: TextStyle(
                  fontSize: Responsive.font(
                    context,
                    14 * 100 / 390,
                  ),
                ),
              ),

              SizedBox(
                height: Responsive.h(context, 12 / 844),
              ),

              Text(
                'TraceIt helps you locate and protect '
                'your important belongings using smart '
                'tracking and safety features.',
                style: TextStyle(
                  fontSize: Responsive.font(
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
                Navigator.of(dialogContext).pop();
              },

              child: Text(
                'Close',
                style: TextStyle(
                  color: primaryBlue,
                  fontSize: Responsive.font(
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
}

// ================================================================
// SAFE EDIT TEXT DIALOG
// ================================================================

class _EditTextDialog extends StatefulWidget {
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
  State<_EditTextDialog> createState() => _EditTextDialogState();
}

class _EditTextDialogState extends State<_EditTextDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(
      text: widget.initialValue,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final value = _controller.text.trim();

    if (value.isEmpty) {
      return;
    }

    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,

      insetPadding: EdgeInsets.symmetric(
        horizontal: Responsive.w(context, 24 / 390),
        vertical: Responsive.h(context, 24 / 844),
      ),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          Responsive.radius(context, 22),
        ),
      ),

      title: Text(
        widget.title,
        style: TextStyle(
          color: widget.primaryBlue,
          fontSize: Responsive.font(
            context,
            22 * 100 / 390,
          ),
          fontWeight: FontWeight.w700,
        ),
      ),

      content: SingleChildScrollView(
        child: TextField(
          controller: _controller,
          autofocus: true,
          keyboardType: widget.keyboardType,
          cursorColor: widget.primaryBlue,

          style: TextStyle(
            color: Colors.black87,
            fontSize: Responsive.font(
              context,
              16 * 100 / 390,
            ),
          ),

          decoration: InputDecoration(
            hintText: widget.hintText,

            hintStyle: TextStyle(
              color: Colors.grey.shade500,
              fontSize: Responsive.font(
                context,
                16 * 100 / 390,
              ),
            ),

            filled: true,
            fillColor: const Color(0xFFF7F9FC),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                Responsive.radius(context, 14),
              ),

              borderSide: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                Responsive.radius(context, 14),
              ),

              borderSide: BorderSide(
                color: widget.primaryBlue,
                width: Responsive.w(context, 2 / 390),
              ),
            ),
          ),

          onSubmitted: (_) => _save(),
        ),
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },

          child: Text(
            'Cancel',
            style: TextStyle(
              color: widget.primaryBlue,
              fontSize: Responsive.font(
                context,
                14 * 100 / 390,
              ),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.primaryBlue,
            foregroundColor: Colors.white,
            elevation: 0,

            padding: EdgeInsets.symmetric(
              horizontal: Responsive.w(context, 16 / 390),
              vertical: Responsive.h(context, 10 / 844),
            ),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                Responsive.radius(context, 12),
              ),
            ),
          ),

          onPressed: _save,

          child: Text(
            'Save',
            style: TextStyle(
              fontSize: Responsive.font(
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

// ================================================================
// SAFE CHANGE PASSWORD DIALOG
// ================================================================

class _ChangePasswordDialog extends StatefulWidget {
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
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmController;

  @override
  void initState() {
    super.initState();

    _passwordController = TextEditingController();
    _confirmController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _save() {
    final password = _passwordController.text.trim();
    final confirm = _confirmController.text.trim();

    if (password.isEmpty || confirm.isEmpty) {
      return;
    }

    if (password != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match.'),
        ),
      );

      return;
    }

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,

      insetPadding: EdgeInsets.symmetric(
        horizontal: Responsive.w(context, 24 / 390),
        vertical: Responsive.h(context, 24 / 844),
      ),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          Responsive.radius(context, 22),
        ),
      ),

      title: Text(
        'Change Password',
        style: TextStyle(
          color: widget.primaryBlue,
          fontSize: Responsive.font(
            context,
            22 * 100 / 390,
          ),
          fontWeight: FontWeight.w700,
        ),
      ),

      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _passwordController,
              obscureText: true,
              cursorColor: widget.primaryBlue,

              style: TextStyle(
                fontSize: Responsive.font(
                  context,
                  16 * 100 / 390,
                ),
              ),

              decoration: InputDecoration(
                labelText: 'New password',

                labelStyle: TextStyle(
                  fontSize: Responsive.font(
                    context,
                    14 * 100 / 390,
                  ),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    Responsive.radius(context, 14),
                  ),

                  borderSide: BorderSide(
                    color: widget.primaryBlue,
                    width: Responsive.w(context, 2 / 390),
                  ),
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    Responsive.radius(context, 14),
                  ),
                ),
              ),
            ),

            SizedBox(
              height: Responsive.h(context, 14 / 844),
            ),

            TextField(
              controller: _confirmController,
              obscureText: true,
              cursorColor: widget.primaryBlue,

              style: TextStyle(
                fontSize: Responsive.font(
                  context,
                  16 * 100 / 390,
                ),
              ),

              decoration: InputDecoration(
                labelText: 'Confirm password',

                labelStyle: TextStyle(
                  fontSize: Responsive.font(
                    context,
                    14 * 100 / 390,
                  ),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    Responsive.radius(context, 14),
                  ),

                  borderSide: BorderSide(
                    color: widget.primaryBlue,
                    width: Responsive.w(context, 2 / 390),
                  ),
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    Responsive.radius(context, 14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },

          child: Text(
            'Cancel',
            style: TextStyle(
              color: widget.primaryBlue,
              fontSize: Responsive.font(
                context,
                14 * 100 / 390,
              ),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.primaryBlue,
            foregroundColor: Colors.white,
            elevation: 0,

            padding: EdgeInsets.symmetric(
              horizontal: Responsive.w(context, 16 / 390),
              vertical: Responsive.h(context, 10 / 844),
            ),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                Responsive.radius(context, 12),
              ),
            ),
          ),

          onPressed: _save,

          child: Text(
            'Save',
            style: TextStyle(
              fontSize: Responsive.font(
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