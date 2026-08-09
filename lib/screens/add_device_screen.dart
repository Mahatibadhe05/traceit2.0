import 'package:flutter/material.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;

    // Keeps the content comfortable on both small and large phones.
    final horizontalPadding = screenWidth < 360 ? 16.0 : 20.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Add New Device',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(horizontalPadding),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: screenWidth < 360 ? 20 : 30,
              ),

              // Device icon
              Center(
                child: Container(
                  width: screenWidth < 360 ? 70 : 80,
                  height: screenWidth < 360 ? 70 : 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C63FF).withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.devices,
                    size: screenWidth < 360 ? 32 : 38,
                    color: const Color(0xFF6C63FF),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Text(
                'Add a new device',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth < 360 ? 20 : 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Enter a name for the device you want to track.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                ),
              ),

              const SizedBox(height: 30),

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
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Color(0xFF6C63FF),
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: screenWidth < 360 ? 48 : 52,

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
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),

                  child: const Text(
                    'Add Device',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: screenWidth < 360 ? 20 : 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}