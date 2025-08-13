
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_widget.dart';
import '../../login_screen/widgets/custom_text_field.dart';

class ProfileWizardWidget extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController bioController;
  final String? selectedPhoto;
  final List<String> selectedLanguages;
  final String? selectedLocation;
  final Function(String?) onPhotoSelected;
  final Function(List<String>) onLanguagesChanged;
  final Function(String?) onLocationChanged;
  final VoidCallback onContinue;

  const ProfileWizardWidget({
    Key? key,
    required this.nameController,
    required this.bioController,
    required this.selectedPhoto,
    required this.selectedLanguages,
    required this.selectedLocation,
    required this.onPhotoSelected,
    required this.onLanguagesChanged,
    required this.onLocationChanged,
    required this.onContinue,
  }) : super(key: key);

  @override
  State<ProfileWizardWidget> createState() => _ProfileWizardWidgetState();
}

class _ProfileWizardWidgetState extends State<ProfileWizardWidget> {
  final _formKey = GlobalKey<FormState>();

  // Sample data
  final List<String> _availableLanguages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Italian',
    'Portuguese',
    'Mandarin',
    'Japanese',
    'Korean',
    'Arabic',
    'Russian',
    'Dutch'
  ];

  final List<String> _popularLocations = [
    'New York, USA',
    'London, UK',
    'Paris, France',
    'Tokyo, Japan',
    'Berlin, Germany',
    'Barcelona, Spain',
    'Rome, Italy',
    'Amsterdam, Netherlands',
    'Bangkok, Thailand',
    'Sydney, Australia',
    'Toronto, Canada',
    'Dubai, UAE'
  ];

  void _showLanguageSelector() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
            height: 70.h,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20))),
            child: Column(children: [
              Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.only(top: 2.h, bottom: 3.h),
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2))),
              Text('Select Languages',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w600)),
              SizedBox(height: 2.h),
              Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      itemCount: _availableLanguages.length,
                      itemBuilder: (context, index) {
                        final language = _availableLanguages[index];
                        final isSelected =
                            widget.selectedLanguages.contains(language);

                        return CheckboxListTile(
                            title: Text(language,
                                style: Theme.of(context).textTheme.bodyLarge),
                            value: isSelected,
                            onChanged: (selected) {
                              final newLanguages =
                                  List<String>.from(widget.selectedLanguages);
                              if (selected == true) {
                                newLanguages.add(language);
                              } else {
                                newLanguages.remove(language);
                              }
                              widget.onLanguagesChanged(newLanguages);
                            },
                            activeColor: Theme.of(context).colorScheme.primary,
                            checkColor:
                                Theme.of(context).colorScheme.onPrimary);
                      })),
              Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(4.w),
                  child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: Text('Done',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: FontWeight.w600)))),
            ])));
  }

  void _showLocationSelector() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
            height: 70.h,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20))),
            child: Column(children: [
              Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.only(top: 2.h, bottom: 3.h),
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2))),
              Text('Select Location',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w600)),
              SizedBox(height: 2.h),
              Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      itemCount: _popularLocations.length,
                      itemBuilder: (context, index) {
                        final location = _popularLocations[index];
                        final isSelected = widget.selectedLocation == location;

                        return ListTile(
                            title: Text(location,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                        color: isSelected
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                            : Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w400)),
                            trailing: isSelected
                                ? Icon(Icons.check_circle,
                                    color:
                                        Theme.of(context).colorScheme.primary)
                                : null,
                            onTap: () {
                              widget.onLocationChanged(location);
                              Navigator.pop(context);
                            });
                      })),
            ])));
  }

  void _selectPhoto() async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text('Add Profile Photo'),
                content: Text(
                    'Photo selection will be available soon. You can add a photo later from your profile settings.'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('OK')),
                ]));
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  bool get _isFormValid {
    return widget.nameController.text.trim().isNotEmpty &&
        widget.selectedLanguages.isNotEmpty &&
        widget.selectedLocation != null;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(height: 2.h),

              // Header
              Text('Complete Your Profile',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface)),

              SizedBox(height: 1.h),

              Text('Help other travelers get to know you',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),

              SizedBox(height: 4.h),

              Form(
                  key: _formKey,
                  child: Column(children: [
                    // Profile photo section
                    Center(
                        child: Column(children: [
                      GestureDetector(
                          onTap: _selectPhoto,
                          child: Container(
                              width: 25.w,
                              height: 25.w,
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                      .withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withValues(alpha: 0.3),
                                      width: 2)),
                              child: widget.selectedPhoto != null
                                  ? ClipOval(
                                      child: CustomImageWidget(
                                          imageUrl: widget.selectedPhoto!,
                                          width: 25.w,
                                          height: 25.w,
                                          fit: BoxFit.cover))
                                  : Icon(Icons.add_a_photo,
                                      size: 8.w,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary))),
                      SizedBox(height: 1.h),
                      Text('Add Photo',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w500)),
                    ])),

                    SizedBox(height: 4.h),

                    // Name field
                    CustomTextField(
                        label: 'Full Name',
                        hint: 'Enter your full name',
                        iconName: 'person',
                        controller: widget.nameController,
                        validator: _validateName),

                    SizedBox(height: 3.h),

                    // Bio field
                    CustomTextField(
                        label: 'Bio (Optional)',
                        hint:
                            'Tell us about yourself, your interests, travel style...',
                        iconName: 'edit',
                        controller: widget.bioController),

                    SizedBox(height: 3.h),

                    // Languages selector
                    GestureDetector(
                        onTap: _showLanguageSelector,
                        child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                    width: 1),
                                borderRadius: BorderRadius.circular(12)),
                            child: Row(children: [
                              Icon(Icons.language,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant),
                              SizedBox(width: 4.w),
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                    Text('Languages',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium
                                            ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant)),
                                    if (widget.selectedLanguages.isNotEmpty)
                                      Text(widget.selectedLanguages.join(', '),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis)
                                    else
                                      Text('Select languages you speak',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurfaceVariant
                                                      .withValues(alpha: 0.6))),
                                  ])),
                              Icon(Icons.arrow_drop_down,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant),
                            ]))),

                    SizedBox(height: 3.h),

                    // Location selector
                    GestureDetector(
                        onTap: _showLocationSelector,
                        child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                    width: 1),
                                borderRadius: BorderRadius.circular(12)),
                            child: Row(children: [
                              Icon(Icons.location_on,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant),
                              SizedBox(width: 4.w),
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                    Text('Location',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium
                                            ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant)),
                                    Text(
                                        widget.selectedLocation ??
                                            'Select your current location',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                                color:
                                                    widget.selectedLocation !=
                                                            null
                                                        ? Theme.of(context)
                                                            .colorScheme
                                                            .onSurface
                                                        : Theme.of(context)
                                                            .colorScheme
                                                            .onSurfaceVariant
                                                            .withValues(
                                                                alpha: 0.6))),
                                  ])),
                              Icon(Icons.arrow_drop_down,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant),
                            ]))),

                    SizedBox(height: 6.h),

                    // Continue button
                    SizedBox(
                        width: double.infinity,
                        height: 6.h,
                        child: ElevatedButton(
                            onPressed: _isFormValid ? widget.onContinue : null,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: _isFormValid
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context)
                                        .colorScheme
                                        .outline
                                        .withValues(alpha: 0.3),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            child: Text('Continue to Verification',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                        color: _isFormValid
                                            ? Theme.of(context)
                                                .colorScheme
                                                .onPrimary
                                            : Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant
                                                .withValues(alpha: 0.5),
                                        fontWeight: FontWeight.w600)))),
                  ])),

              SizedBox(height: 4.h),
            ])));
  }
}
