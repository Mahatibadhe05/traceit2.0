import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/utils/responsive.dart';
import '../ble/ble_scan_screen.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/device_model.dart';

const Color _blue = Color(0xFF2563EB);
const Color _blueDark = Color(0xFF1D4ED8);
const Color _textDark = Color(0xFF17233B);
const Color _textGrey = Color(0xFF667085);
const Color _border = Color(0xFFE5EAF2);
const Color _softBlue = Color(0xFFF8FAFF);

class AddDeviceScreen extends StatefulWidget {
  final List<DeviceModel> savedDevices;

  const AddDeviceScreen({
    super.key,
    required this.savedDevices,
  });

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final TextEditingController nameController = TextEditingController();
  Map<String, dynamic>? selectedBleDevice;
  File? _deviceImage;
  int _currentStep = 0;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _selectCharm();
    });
  }

  Future<void> _selectCharm() async {
    final device = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => BleScanScreen(
          savedDevices: widget.savedDevices,
        ),
      ),
    );

    if (!mounted) return;

    if (device == null) {
      Navigator.pop(context);
      return;
    }

    setState(() {
      selectedBleDevice = device;
      _currentStep = 1;
    });
  }

  // ---- UNCHANGED LOGIC ----
  Future<void> _pickImage() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              const SizedBox(height: 8),
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: _blue),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context, ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: _blue),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context, ImageSource.gallery);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    if (source == null) return;

    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _deviceImage = File(image.path);
      });
    }
  }
  // ---- END UNCHANGED LOGIC ----

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFEFF4FF),
              Color(0xFFF6F8FC),
            ],
            stops: [0.0, 0.25],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.w(context, 0.045),
              vertical: Responsive.h(context, 0.01),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Responsive.h(context, 0.015)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: _textDark,
                      ),
                      iconSize: 18,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Set Up Device',
                      style: TextStyle(
                        color: _textDark,
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Padding(
                  padding: EdgeInsets.only(left: 48),
                  child: Text(
                    'Give your tracker a name and image.',
                    style: TextStyle(
                      color: _textGrey,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: Responsive.h(context, 0.03)),
                Expanded(
                  child: SingleChildScrollView(
                    child: _buildDeviceDetailsPage(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addDevice() {
    final name = nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a device name'),
        ),
      );
      return;
    }

    if (_deviceImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add a photo of your device'),
        ),
      );
      return;
    }

    if (selectedBleDevice == null) {
      setState(() {
        _currentStep = 0;
      });
      return;
    }

    Navigator.pop(
      context,
      {
        "name": name,
        "bleId": selectedBleDevice!["id"],
        "rssi": selectedBleDevice!["rssi"],
        "imagePath": _deviceImage!.path,
      },
    );
  }

  Widget _buildCharmPage(BuildContext context) {
    return Column(
      children: [
        if (selectedBleDevice == null)
          SizedBox(
            width: double.infinity,
            height: Responsive.h(context, 0.065),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(
                  colors: [_blue, _blueDark],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _blue.withValues(alpha: 0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  splashColor: Colors.white.withValues(alpha: 0.24),
                  highlightColor: Colors.white.withValues(alpha: 0.12),
                  onTap: () async {
                    final device = await Navigator.push<Map<String, dynamic>>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BleScanScreen(
                          savedDevices: widget.savedDevices,
                        ),
                      ),
                    );

                    if (device != null && mounted) {
                      setState(() {
                        selectedBleDevice = device;
                        _currentStep = 1;
                      });
                    }
                  },
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bluetooth,
                          color: Colors.white,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Connect Device',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDeviceDetailsPage(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(Responsive.w(context, 0.045)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionLabel('Device Name'),
              const SizedBox(height: 8),
              TextField(
                controller: nameController,
                style: const TextStyle(
                  color: _textDark,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'e.g. Keys',
                  hintStyle: TextStyle(
                    color: const Color(0xFF98A2B3),
                    fontSize: Responsive.font(context, 3.2),
                  ),
                  prefixIcon: const Icon(
                    Icons.edit_outlined,
                    color: Color(0xFF98A2B3),
                    size: 20,
                  ),
                  filled: true,
                  fillColor: _softBlue,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: Responsive.w(context, 0.04),
                    vertical: Responsive.h(context, 0.018),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: _border, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: _border, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: _blue, width: 1.4),
                  ),
                ),
              ),
              SizedBox(height: Responsive.h(context, 0.026)),
              _sectionLabel('Device Image'),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: Responsive.h(context, 0.16),
                  decoration: BoxDecoration(
                    color: _softBlue,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _border,
                      width: 1.2,
                    ),
                  ),
                  child: _deviceImage == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: _blue.withValues(alpha: 0.15),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.add_a_photo_outlined,
                                size: Responsive.w(context, 0.08),
                                color: _blue,
                              ),
                            ),
                            SizedBox(height: Responsive.h(context, 0.012)),
                            const Text(
                              "Add a photo",
                              style: TextStyle(
                                color: _textDark,
                                fontWeight: FontWeight.w600,
                                fontSize: 13.5,
                              ),
                            ),
                            SizedBox(height: Responsive.h(context, 0.004)),
                            Text(
                              "Tap to take a photo or choose from gallery",
                              style: TextStyle(
                                color: _textGrey,
                                fontSize: Responsive.font(context, 0.03),
                              ),
                            ),
                          ],
                        )
                      : Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.file(
                                _deviceImage!,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: Responsive.h(context, 0.025)),
        Container(
          padding: EdgeInsets.all(Responsive.w(context, 0.04)),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFBBF7D0),
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
              SizedBox(width: Responsive.w(context, 0.03)),
              const Expanded(
                child: Text(
                  'Charm Connected',
                  style: TextStyle(
                    color: Color(0xFF15803D),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton(
                onPressed: _selectCharm,
                child: const Text(
                  "Change",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: Responsive.h(context, 0.025)),
        SizedBox(
          width: double.infinity,
          height: Responsive.h(context, 0.065),
          child: ElevatedButton(
            onPressed: _addDevice,
            style: ElevatedButton.styleFrom(
              backgroundColor: _blue,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Add Device',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ---- small helper, purely visual ----
  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF344054),
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}