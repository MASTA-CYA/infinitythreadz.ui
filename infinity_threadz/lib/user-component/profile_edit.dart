import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:infinity_threadz/camera-component/widgets/camera.dart';
import 'package:infinity_threadz/user-component/models/user_model.dart';
import 'package:infinity_threadz/common/widgets/appbar.dart';
import 'package:infinity_threadz/common/widgets/form/button.dart';
import 'package:infinity_threadz/user-component/widgets/profile_image.dart';
import 'package:infinity_threadz/common/widgets/form/textfields.dart';
import 'package:email_validator/email_validator.dart';

class EditProfilePage extends StatefulWidget {
  final User user;
  const EditProfilePage({
    super.key,
    required this.user,
  });

  @override
  State<StatefulWidget> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final String title = 'Edit';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => ThemeSwitchingArea(
        child: Builder(
          builder: (context) => Scaffold(
            appBar: AppBarWidget(title: title),
            body: buildUserForm(),
          ),
        ),
      );

  Widget buildUserForm() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        physics: const BouncingScrollPhysics(),
        children: [
          buildImage(),
          const SizedBox(height: 24),
          buildName(),
          const SizedBox(height: 24),
          buildEmail(),
          const SizedBox(height: 24),
          buildPhone(),
          const SizedBox(height: 24),
          buildAbout(),
          const SizedBox(height: 24),
          Center(child: buildSaveButton(context)),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget buildImage() {
    return ProfileWidget(
      imagePath: widget.user.image,
      isEdit: true,
      onClicked: () => startCamera(context),
    );
  }

  Widget buildName() {
    return TextFieldWidget(
      label: 'Full Name',
      text: widget.user.name,
      onChanged: (name) {
        widget.user.name = name;
      },
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a valid name';
        }

        return null;
      },
    );
  }

  Widget buildEmail() {
    return TextFieldWidget(
      label: 'Email',
      text: widget.user.email,
      onChanged: (email) {
        widget.user.email = email;
      },
      validator: (value) => EmailValidator.validate(value ?? '')
          ? null
          : 'Please enter a valid email',
    );
  }

  Widget buildPhone() {
    return TextFieldWidget(
      label: 'Phone',
      text: widget.user.phone,
      onChanged: (phone) {
        widget.user.phone = phone;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a valid phone number';
        }
        return null;
      },
    );
  }

  Widget buildAbout() {
    return TextFieldWidget(
      label: 'About',
      text: widget.user.aboutMeDescription,
      maxLines: 3,
      onChanged: (about) {
        widget.user.aboutMeDescription = about;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }

  Widget buildSaveButton(BuildContext context) {
    return ButtonWidget(
      text: 'Save',
      onClicked: () async {
        if (!_formKey.currentState!.validate()) {
          return;
        }
        _formKey.currentState!.save();

        // Demo build: edits are applied to the in-memory user.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              'Successfully Updated',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );

        SchedulerBinding.instance.addPostFrameCallback(
          (_) {
            if (mounted) {
              Navigator.pop(context);
            }
          },
        );
      },
    );
  }

  Future<void> startCamera(BuildContext context) async {
    try {
      final cameras = await availableCameras();
      if (!context.mounted) {
        return;
      }
      if (cameras.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No camera found on this device.')),
        );
        return;
      }

      // Prefer the front camera for a profile picture.
      final camera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      final result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CameraWidget(camera: camera),
        ),
      );
      if (result is XFile && mounted) {
        setState(() => widget.user.image = result.path);
      }
    } on CameraException catch (e) {
      debugPrint('Camera error ${e.code}: ${e.description}');
    }
  }
}
