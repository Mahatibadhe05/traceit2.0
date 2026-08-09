import 'package:flutter/material.dart';
import '../utils/responsive.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({super.key});

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final nameController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Add New Device',
          style: TextStyle(
            fontSize: Responsive.font(context, 6),
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E293B),
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(
            Responsive.w(context, 0.05),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: Responsive.h(context, 0.03),
              ),

              Center(
                child: Container(
                  width: Responsive.w(context, 0.2),
                  height: Responsive.w(context, 0.2),

                  decoration: BoxDecoration(
                    color: const Color(0xFF6C63FF)
                        .withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),

                  child: Icon(
                    Icons.devices,
                    size: Responsive.w(context, 0.09),
                    color: const Color(0xFF6C63FF),
                  ),
                ),
              ),

              SizedBox(
                height: Responsive.h(context, 0.025),
              ),

              Text(
                'Add a new device',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Responsive.font(context, 5.5),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
              ),

              SizedBox(
                height: Responsive.h(context, 0.01),
              ),

              Text(
                'Enter a name for the device you want to track.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Responsive.font(context, 3.5),
                  color: const Color(0xFF64748B),
                ),
              ),

              SizedBox(
                height: Responsive.h(context, 0.03),
              ),

              TextField(
                controller: nameController,
                textInputAction: TextInputAction.done,

                decoration: InputDecoration(
                  labelText: 'Device Name',
                  hintText: 'e.g. Watch',
                  prefixIcon: const Icon(Icons.devices),

                  filled: true,
                  fillColor: Colors.white,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      Responsive.radius(context, 0.035),
                    ),
                    borderSide: BorderSide.none,
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      Responsive.radius(context, 0.035),
                    ),
                    borderSide: BorderSide.none,
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      Responsive.radius(context, 0.035),
                    ),
                    borderSide: const BorderSide(
                      color: Color(0xFF6C63FF),
                      width: 2,
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: Responsive.h(context, 0.025),
              ),

              SizedBox(
                width: double.infinity,
                height: Responsive.h(context, 0.065),

                child: ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();

                    if (name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please enter a device name',
                          ),
                        ),
                      );
                      return;
                    }

                    Navigator.pop(context, name);
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    foregroundColor: Colors.white,
                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        Responsive.radius(context, 0.035),
                      ),
                    ),
                  ),

                  child: Text(
                    'Add Device',
                    style: TextStyle(
                      fontSize: Responsive.font(context, 3.8),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}