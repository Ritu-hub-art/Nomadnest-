import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/custom_icon_widget.dart';

class LanguageCurrencyWidget extends StatelessWidget {
  final Map<String, dynamic> userSettings;
  final Function(String, dynamic) onSettingChanged;

  const LanguageCurrencyWidget({
    super.key,
    required this.userSettings,
    required this.onSettingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Container(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'language',
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Language & Currency',
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Divider(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            thickness: 1,
            height: 1,
          ),

          // Language setting
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
            leading: const CustomIconWidget(
              iconName: 'translate',
              size: 24,
            ),
            title: Text(
              'Language',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              userSettings['language'] ?? 'English',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: const CustomIconWidget(
              iconName: 'chevron_right',
              size: 20,
            ),
            onTap: () => _showLanguageDialog(context),
            minTileHeight: 6.h,
          ),

          // Currency setting
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
            leading: const CustomIconWidget(
              iconName: 'attach_money',
              size: 24,
            ),
            title: Text(
              'Currency',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              _getCurrencyDisplayName(userSettings['currency'] ?? 'USD'),
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: const CustomIconWidget(
              iconName: 'chevron_right',
              size: 20,
            ),
            onTap: () => _showCurrencyDialog(context),
            minTileHeight: 6.h,
          ),

          // Region setting
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
            leading: const CustomIconWidget(
              iconName: 'public',
              size: 24,
            ),
            title: Text(
              'Region',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              userSettings['region'] ?? 'United States',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: const CustomIconWidget(
              iconName: 'chevron_right',
              size: 20,
            ),
            onTap: () => _showRegionDialog(context),
            minTileHeight: 6.h,
          ),

          // Date format
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
            leading: const CustomIconWidget(
              iconName: 'calendar_today',
              size: 24,
            ),
            title: Text(
              'Date Format',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              userSettings['dateFormat'] ?? 'MM/DD/YYYY',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: const CustomIconWidget(
              iconName: 'chevron_right',
              size: 20,
            ),
            onTap: () => _showDateFormatDialog(context),
            minTileHeight: 6.h,
          ),

          // Time format
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
            leading: const CustomIconWidget(
              iconName: 'access_time',
              size: 24,
            ),
            title: Text(
              'Time Format',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              userSettings['timeFormat'] ?? '12-hour',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: const CustomIconWidget(
              iconName: 'chevron_right',
              size: 20,
            ),
            onTap: () => _showTimeFormatDialog(context),
            minTileHeight: 6.h,
          ),
        ],
      ),
    );
  }

  String _getCurrencyDisplayName(String currencyCode) {
    final currencies = {
      'USD': 'US Dollar (\$)',
      'EUR': 'Euro (€)',
      'GBP': 'British Pound (£)',
      'JPY': 'Japanese Yen (¥)',
      'CAD': 'Canadian Dollar (C\$)',
      'AUD': 'Australian Dollar (A\$)',
      'CHF': 'Swiss Franc (CHF)',
      'CNY': 'Chinese Yuan (¥)',
      'INR': 'Indian Rupee (₹)',
      'MXN': 'Mexican Peso (\$)',
    };
    return currencies[currencyCode] ?? currencyCode;
  }

  void _showLanguageDialog(BuildContext context) {
    final languages = [
      {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
      {'code': 'es', 'name': 'Español', 'flag': '🇪🇸'},
      {'code': 'fr', 'name': 'Français', 'flag': '🇫🇷'},
      {'code': 'de', 'name': 'Deutsch', 'flag': '🇩🇪'},
      {'code': 'it', 'name': 'Italiano', 'flag': '🇮🇹'},
      {'code': 'pt', 'name': 'Português', 'flag': '🇵🇹'},
      {'code': 'ja', 'name': '日本語', 'flag': '🇯🇵'},
      {'code': 'ko', 'name': '한국어', 'flag': '🇰🇷'},
      {'code': 'zh', 'name': '中文', 'flag': '🇨🇳'},
      {'code': 'ar', 'name': 'العربية', 'flag': '🇸🇦'},
    ];

    String selectedLanguage = userSettings['language'] ?? 'English';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Select Language',
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 50.h,
            child: ListView.builder(
              itemCount: languages.length,
              itemBuilder: (context, index) {
                final language = languages[index];
                final isSelected = language['name'] == selectedLanguage;

                return ListTile(
                  leading: Text(
                    language['flag']!,
                    style: const TextStyle(fontSize: 24),
                  ),
                  title: Text(
                    language['name']!,
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  trailing: isSelected
                      ? CustomIconWidget(
                          iconName: 'check_circle',
                          color: Theme.of(context).colorScheme.primary,
                          size: 24,
                        )
                      : null,
                  onTap: () =>
                      setState(() => selectedLanguage = language['name']!),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                onSettingChanged('language', selectedLanguage);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                'Save',
                style: GoogleFonts.inter(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCurrencyDialog(BuildContext context) {
    final currencies = [
      'USD',
      'EUR',
      'GBP',
      'JPY',
      'CAD',
      'AUD',
      'CHF',
      'CNY',
      'INR',
      'MXN'
    ];

    String selectedCurrency = userSettings['currency'] ?? 'USD';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Select Currency',
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: currencies.length,
              itemBuilder: (context, index) {
                final currency = currencies[index];
                final isSelected = currency == selectedCurrency;

                return ListTile(
                  title: Text(
                    _getCurrencyDisplayName(currency),
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  trailing: isSelected
                      ? CustomIconWidget(
                          iconName: 'check_circle',
                          color: Theme.of(context).colorScheme.primary,
                          size: 24,
                        )
                      : null,
                  onTap: () => setState(() => selectedCurrency = currency),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                onSettingChanged('currency', selectedCurrency);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                'Save',
                style: GoogleFonts.inter(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRegionDialog(BuildContext context) {
    final regions = [
      'United States',
      'Canada',
      'United Kingdom',
      'Germany',
      'France',
      'Spain',
      'Italy',
      'Japan',
      'Australia',
      'Brazil',
      'Mexico',
      'India'
    ];

    String selectedRegion = userSettings['region'] ?? 'United States';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Select Region',
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 40.h,
            child: ListView.builder(
              itemCount: regions.length,
              itemBuilder: (context, index) {
                final region = regions[index];
                final isSelected = region == selectedRegion;

                return ListTile(
                  title: Text(
                    region,
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  trailing: isSelected
                      ? CustomIconWidget(
                          iconName: 'check_circle',
                          color: Theme.of(context).colorScheme.primary,
                          size: 24,
                        )
                      : null,
                  onTap: () => setState(() => selectedRegion = region),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                onSettingChanged('region', selectedRegion);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                'Save',
                style: GoogleFonts.inter(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDateFormatDialog(BuildContext context) {
    final dateFormats = [
      'MM/DD/YYYY',
      'DD/MM/YYYY',
      'YYYY-MM-DD',
      'DD-MM-YYYY'
    ];

    String selectedFormat = userSettings['dateFormat'] ?? 'MM/DD/YYYY';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Date Format',
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: dateFormats.map((format) {
              final isSelected = format == selectedFormat;
              return RadioListTile<String>(
                title: Text(
                  format,
                  style: GoogleFonts.inter(fontSize: 16.sp),
                ),
                value: format,
                groupValue: selectedFormat,
                onChanged: (value) => setState(() => selectedFormat = value!),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                onSettingChanged('dateFormat', selectedFormat);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                'Save',
                style: GoogleFonts.inter(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTimeFormatDialog(BuildContext context) {
    String selectedFormat = userSettings['timeFormat'] ?? '12-hour';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Time Format',
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: Text('12-hour (3:30 PM)', style: GoogleFonts.inter()),
                value: '12-hour',
                groupValue: selectedFormat,
                onChanged: (value) => setState(() => selectedFormat = value!),
              ),
              RadioListTile<String>(
                title: Text('24-hour (15:30)', style: GoogleFonts.inter()),
                value: '24-hour',
                groupValue: selectedFormat,
                onChanged: (value) => setState(() => selectedFormat = value!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                onSettingChanged('timeFormat', selectedFormat);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                'Save',
                style: GoogleFonts.inter(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
