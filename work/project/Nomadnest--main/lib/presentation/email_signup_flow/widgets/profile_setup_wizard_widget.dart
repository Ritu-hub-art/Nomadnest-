import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/custom_image_widget.dart';

class ProfileSetupWizardWidget extends StatefulWidget {
  final TextEditingController displayNameController;
  final TextEditingController bioController;
  final XFile? profileImage;
  final String? selectedCity;
  final List<String> selectedLanguages;
  final List<String> availableLanguages;
  final List<String> popularCities;
  final CameraController? cameraController;
  final bool isCameraInitialized;
  final ImagePicker imagePicker;
  final Function(XFile) onImageSelected;
  final Function(String) onCityChanged;
  final Function(List<String>) onLanguagesChanged;
  final VoidCallback onComplete;

  const ProfileSetupWizardWidget({
    super.key,
    required this.displayNameController,
    required this.bioController,
    required this.profileImage,
    required this.selectedCity,
    required this.selectedLanguages,
    required this.availableLanguages,
    required this.popularCities,
    required this.cameraController,
    required this.isCameraInitialized,
    required this.imagePicker,
    required this.onImageSelected,
    required this.onCityChanged,
    required this.onLanguagesChanged,
    required this.onComplete,
  });

  @override
  State<ProfileSetupWizardWidget> createState() =>
      _ProfileSetupWizardWidgetState();
}

class _ProfileSetupWizardWidgetState extends State<ProfileSetupWizardWidget> {
  bool _showCameraView = false;

  void _showImagePickerOptions() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).cardColor,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) => Container(
            padding: EdgeInsets.all(4.w),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2))),
              SizedBox(height: 3.h),
              Text('Add Profile Photo',
                  style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface)),
              SizedBox(height: 3.h),
              Row(children: [
                Expanded(
                    child: _buildImageOption('Camera', 'camera_alt', () {
                  Navigator.pop(context);
                  if (widget.isCameraInitialized) {
                    setState(() {
                      _showCameraView = true;
                    });
                  }
                })),
                SizedBox(width: 4.w),
                Expanded(
                    child: _buildImageOption('Gallery', 'photo_library', () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                })),
              ]),
              SizedBox(height: 2.h),
            ])));
  }

  Widget _buildImageOption(String title, String iconName, VoidCallback onTap) {
    return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.2))),
            child: Column(children: [
              CustomIconWidget(
                  iconName: iconName,
                  color: Theme.of(context).colorScheme.primary,
                  size: 8.w),
              SizedBox(height: 2.h),
              Text(title,
                  style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface)),
            ])));
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await widget.imagePicker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1024,
          maxHeight: 1024,
          imageQuality: 85);

      if (image != null) {
        widget.onImageSelected(image);
      }
    } catch (e) {
      // Handle gallery error silently
    }
  }

  Future<void> _capturePhoto() async {
    if (widget.cameraController == null ||
        !widget.cameraController!.value.isInitialized) return;

    try {
      final XFile photo = await widget.cameraController!.takePicture();
      widget.onImageSelected(photo);
      setState(() {
        _showCameraView = false;
      });
    } catch (e) {
      // Handle capture error silently
    }
  }

  Widget _buildCameraView() {
    if (!widget.isCameraInitialized || widget.cameraController == null) {
      return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
              backgroundColor: Colors.black,
              leading: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => setState(() => _showCameraView = false))),
          body: const Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => setState(() => _showCameraView = false)),
            title: Text('Take Photo',
                style: GoogleFonts.inter(
                    color: Colors.white, fontWeight: FontWeight.w500))),
        body: Stack(children: [
          Positioned.fill(child: CameraPreview(widget.cameraController!)),
          Positioned(
              bottom: 8.h,
              left: 0,
              right: 0,
              child: Center(
                  child: GestureDetector(
                      onTap: _capturePhoto,
                      child: Container(
                          width: 20.w,
                          height: 20.w,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border:
                                  Border.all(color: Colors.white, width: 4)),
                          child: Container(
                              margin: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white)))))),
        ]));
  }

  void _showCityPicker() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).cardColor,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) => Container(
            height: 70.h,
            padding: EdgeInsets.all(4.w),
            child: Column(children: [
              Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2))),
              SizedBox(height: 3.h),
              Text('Select Home City',
                  style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface)),
              SizedBox(height: 3.h),
              Expanded(
                  child: ListView.builder(
                      itemCount: widget.popularCities.length,
                      itemBuilder: (context, index) {
                        final city = widget.popularCities[index];
                        final isSelected = city == widget.selectedCity;

                        return ListTile(
                            title: Text(city,
                                style: GoogleFonts.inter(
                                    fontSize: 16.sp,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurface)),
                            trailing: isSelected
                                ? CustomIconWidget(
                                    iconName: 'check_circle',
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    size: 24)
                                : null,
                            onTap: () {
                              widget.onCityChanged(city);
                              Navigator.pop(context);
                            });
                      })),
            ])));
  }

  void _showLanguagePicker() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).cardColor,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) => Container(
            height: 70.h,
            padding: EdgeInsets.all(4.w),
            child: Column(children: [
              Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2))),
              SizedBox(height: 3.h),
              Text('Select Languages',
                  style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface)),
              SizedBox(height: 3.h),
              Expanded(
                  child: ListView.builder(
                      itemCount: widget.availableLanguages.length,
                      itemBuilder: (context, index) {
                        final language = widget.availableLanguages[index];
                        final isSelected =
                            widget.selectedLanguages.contains(language);

                        return CheckboxListTile(
                            title: Text(language,
                                style: GoogleFonts.inter(
                                    fontSize: 16.sp,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface)),
                            value: isSelected,
                            activeColor: Theme.of(context).colorScheme.primary,
                            onChanged: (bool? value) {
                              List<String> newLanguages =
                                  List.from(widget.selectedLanguages);
                              if (value == true) {
                                newLanguages.add(language);
                              } else {
                                newLanguages.remove(language);
                              }
                              widget.onLanguagesChanged(newLanguages);
                            });
                      })),
              SizedBox(height: 2.h),
              SizedBox(
                  width: double.infinity,
                  height: 6.h,
                  child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: Text('Done',
                          style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.w600)))),
            ])));
  }

  void _handleComplete() {
    if (widget.displayNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('Please enter a display name', style: GoogleFonts.inter()),
          backgroundColor: Theme.of(context).colorScheme.error));
      return;
    }

    widget.onComplete();
  }

  void _skipForNow() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                backgroundColor: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                title: Text('Skip Profile Setup?',
                    style: GoogleFonts.inter(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface)),
                content: Text(
                    'Incomplete profiles may have reduced visibility to other users. You can always complete this later in settings.',
                    style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Continue Setup',
                          style: GoogleFonts.inter(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w500))),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        widget.onComplete();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest),
                      child: Text('Skip for Now',
                          style: GoogleFonts.inter(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w500))),
                ]));
  }

  @override
  Widget build(BuildContext context) {
    if (_showCameraView) {
      return _buildCameraView();
    }

    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 4.h),

                  Text('Set Up Your Profile',
                      style: GoogleFonts.inter(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onSurface)),

                  SizedBox(height: 1.h),

                  Text('Help other nomads get to know you',
                      style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant)),

                  SizedBox(height: 4.h),

                  // Profile photo section
                  GestureDetector(
                      onTap: _showImagePickerOptions,
                      child: Container(
                          width: 30.w,
                          height: 30.w,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                              border: Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2)),
                          child: widget.profileImage == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                      CustomIconWidget(
                                          iconName: 'add_a_photo',
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          size: 8.w),
                                      SizedBox(height: 1.h),
                                      Text('Add Photo',
                                          style: GoogleFonts.inter(
                                              fontSize: 12.sp,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontWeight: FontWeight.w500)),
                                    ])
                              : ClipOval(
                                  child: kIsWeb
                                      ? Image.network(widget.profileImage!.path,
                                          width: 30.w,
                                          height: 30.w,
                                          fit: BoxFit.cover)
                                      : CustomImageWidget(
                                          imageUrl: widget.profileImage!.path,
                                          width: 30.w,
                                          height: 30.w,
                                          fit: BoxFit.cover)))),
                  SizedBox(height: 4.h),

                  // Display name field
                  TextField(
                      controller: widget.displayNameController,
                      decoration: InputDecoration(
                          labelText: 'Display Name *',
                          hintText: 'How should people call you?',
                          prefixIcon: const CustomIconWidget(
                              iconName: 'person', size: 24),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2))),
                      style: GoogleFonts.inter()),

                  SizedBox(height: 3.h),

                  // Bio field
                  TextField(
                      controller: widget.bioController,
                      maxLines: 3,
                      maxLength: 160,
                      decoration: InputDecoration(
                          labelText: 'Bio (Optional)',
                          hintText: 'Tell others about yourself...',
                          prefixIcon: const Padding(
                              padding: EdgeInsets.only(bottom: 60),
                              child:
                                  CustomIconWidget(iconName: 'edit', size: 24)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2))),
                      style: GoogleFonts.inter()),

                  SizedBox(height: 3.h),

                  // Home city selector
                  GestureDetector(
                      onTap: _showCityPicker,
                      child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 2.h),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).colorScheme.outline),
                              borderRadius: BorderRadius.circular(12)),
                          child: Row(children: [
                            const CustomIconWidget(
                                iconName: 'location_city', size: 24),
                            SizedBox(width: 3.w),
                            Expanded(
                                child: Text(
                                    widget.selectedCity ?? 'Select Home City',
                                    style: GoogleFonts.inter(
                                        fontSize: 16.sp,
                                        color: widget.selectedCity != null
                                            ? Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                            : Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant))),
                            const CustomIconWidget(
                                iconName: 'expand_more', size: 24),
                          ]))),

                  SizedBox(height: 3.h),

                  // Languages selector
                  GestureDetector(
                      onTap: _showLanguagePicker,
                      child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 2.h),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).colorScheme.outline),
                              borderRadius: BorderRadius.circular(12)),
                          child: Row(children: [
                            const CustomIconWidget(
                                iconName: 'translate', size: 24),
                            SizedBox(width: 3.w),
                            Expanded(
                                child: Text(
                                    widget.selectedLanguages.isEmpty
                                        ? 'Select Languages You Speak'
                                        : widget.selectedLanguages.join(', '),
                                    style: GoogleFonts.inter(
                                        fontSize: 16.sp,
                                        color:
                                            widget.selectedLanguages.isNotEmpty
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis)),
                            const CustomIconWidget(
                                iconName: 'expand_more', size: 24),
                          ]))),

                  SizedBox(height: 4.h),

                  // Complete setup button
                  SizedBox(
                      width: double.infinity,
                      height: 6.h,
                      child: ElevatedButton(
                          onPressed: _handleComplete,
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          child: Text('Complete Setup',
                              style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: FontWeight.w600)))),

                  SizedBox(height: 2.h),

                  // Skip for now button
                  TextButton(
                      onPressed: _skipForNow,
                      child: Text('Skip for now',
                          style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              fontWeight: FontWeight.w500))),

                  SizedBox(height: 2.h),
                ])));
  }
}