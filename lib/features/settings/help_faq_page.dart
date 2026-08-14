import 'package:flutter/material.dart';
import '../../core/utils/responsive.dart';

const Color primaryBlue = Color(0xFF1769FF);
const Color darkBlue = Color(0xFF14244A);

class HelpFaqPage extends StatelessWidget {
  const HelpFaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),

      // ================= APP BAR =================

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: darkBlue,
            size: Responsive.font(context, 6),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Text(
          "Help & FAQ",
          style: TextStyle(
            color: darkBlue,
            fontSize: Responsive.font(context, 5.65),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ================= BODY =================

      body: ListView(
        padding: EdgeInsets.fromLTRB(
          Responsive.w(context, 16 / 390),
          Responsive.h(context, 20 / 844),
          Responsive.w(context, 16 / 390),
          Responsive.h(context, 30 / 844),
        ),

        children: [

          // ================= FAQ TITLE =================

          Text(
            "Frequently Asked Questions",
            style: TextStyle(
              color: primaryBlue,
              fontSize: Responsive.font(context, 3.85),
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(
            height: Responsive.h(context, 12 / 844),
          ),

          // ================= FAQ 1 =================

          _faq(
            context,
            "What is TraceIt?",
            "TraceIt is a smart finding system that helps you "
                "locate and keep track of your important belongings "
                "using the TraceIt device and mobile application.",
          ),

          // ================= FAQ 2 =================

          _faq(
            context,
            "How do I find my item?",
            "Open TraceIt and use the finding feature to trigger "
                "the connected device. The device can produce a sound "
                "to help you locate your item nearby.",
          ),

          // ================= FAQ 3 =================

          _faq(
            context,
            "What happens if my item is nearby?",
            "When the TraceIt device is within connection range, "
                "you can trigger the device from the app and use its "
                "sound to locate your belongings.",
          ),

          // ================= FAQ 4 =================

          _faq(
            context,
            "Does TraceIt need Bluetooth?",
            "Yes. Bluetooth is used to communicate between the "
                "TraceIt mobile application and the connected tracker "
                "device.",
          ),

          // ================= FAQ 5 =================

          _faq(
            context,
            "Can I manage app permissions?",
            "Yes. Go to Settings → Permission Management to "
                "manage the permissions required by TraceIt.",
          ),

          // ================= FAQ 6 =================

          _faq(
            context,
            "How can I contact support?",
            "If you need additional assistance, use the Contact "
                "Support option available in the Settings section.",
          ),

          SizedBox(
            height: Responsive.h(context, 20 / 844),
          ),

          // ================= FOOTER =================

          Center(
            child: Text(
              "TraceIt • Never lose what matters.",
              style: TextStyle(
                color: Colors.grey,
                fontSize: Responsive.font(context, 3.08),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= FAQ CARD =================

  static Widget _faq(
    BuildContext context,
    String question,
    String answer,
  ) {
    return Container(
      margin: EdgeInsets.only(
        bottom: Responsive.h(context, 12 / 844),
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(
          Responsive.radius(context, 16),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.06),
            blurRadius: Responsive.w(context, 10 / 390),
            offset: Offset(
              0,
              Responsive.h(context, 3 / 844),
            ),
          ),
        ],
      ),

      child: ExpansionTile(
        iconColor: primaryBlue,
        collapsedIconColor: primaryBlue,

        tilePadding: EdgeInsets.symmetric(
          horizontal: Responsive.w(context, 16 / 390),
        ),

        childrenPadding: EdgeInsets.zero,

        title: Text(
          question,
          style: TextStyle(
            color: darkBlue,
            fontSize: Responsive.font(context, 3.85),
            fontWeight: FontWeight.w600,
          ),
        ),

        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              Responsive.w(context, 16 / 390),
              0,
              Responsive.w(context, 16 / 390),
              Responsive.h(context, 16 / 844),
            ),

            child: Align(
              alignment: Alignment.centerLeft,

              child: Text(
                answer,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: Responsive.font(context, 3.33),
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}