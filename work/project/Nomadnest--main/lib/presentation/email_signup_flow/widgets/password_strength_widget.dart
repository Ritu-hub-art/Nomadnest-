import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/custom_icon_widget.dart';

class PasswordStrengthWidget extends StatefulWidget {
  final String password;
  final Function(String) onStrengthChanged;

  const PasswordStrengthWidget({
    super.key,
    required this.password,
    required this.onStrengthChanged,
  });

  @override
  State<PasswordStrengthWidget> createState() => _PasswordStrengthWidgetState();
}

class _PasswordStrengthWidgetState extends State<PasswordStrengthWidget> {
  String _strength = 'weak';
  Color _strengthColor = Colors.red;
  double _strengthValue = 0.0;

  @override
  void initState() {
    super.initState();
    _calculateStrength();
  }

  @override
  void didUpdateWidget(PasswordStrengthWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.password != widget.password) {
      _calculateStrength();
    }
  }

  void _calculateStrength() {
    if (widget.password.isEmpty) {
      _strength = 'weak';
      _strengthColor = Colors.red;
      _strengthValue = 0.0;
    } else {
      int score = 0;

      // Length check
      if (widget.password.length >= 8) score++;
      if (widget.password.length >= 12) score++;

      // Character variety checks
      if (RegExp(r'[a-z]').hasMatch(widget.password)) score++;
      if (RegExp(r'[A-Z]').hasMatch(widget.password)) score++;
      if (RegExp(r'\d').hasMatch(widget.password)) score++;
      if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(widget.password)) score++;

      // Determine strength
      if (score <= 2) {
        _strength = 'weak';
        _strengthColor = Colors.red;
        _strengthValue = 0.33;
      } else if (score <= 4) {
        _strength = 'medium';
        _strengthColor = Colors.orange;
        _strengthValue = 0.66;
      } else {
        _strength = 'strong';
        _strengthColor = Colors.green;
        _strengthValue = 1.0;
      }
    }

    widget.onStrengthChanged(_strength);

    if (mounted) {
      setState(() {});
    }
  }

  List<Map<String, dynamic>> _getRequirements() {
    return [
      {
        'text': '8+ characters',
        'met': widget.password.length >= 8,
      },
      {
        'text': 'Uppercase letter',
        'met': RegExp(r'[A-Z]').hasMatch(widget.password),
      },
      {
        'text': 'Lowercase letter',
        'met': RegExp(r'[a-z]').hasMatch(widget.password),
      },
      {
        'text': 'Number',
        'met': RegExp(r'\d').hasMatch(widget.password),
      },
      {
        'text': 'Special character',
        'met': RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(widget.password),
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (widget.password.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Strength indicator bar
        Row(
          children: [
            Text(
              'Password strength: ',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              _strength.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: _strengthColor,
              ),
            ),
          ],
        ),

        SizedBox(height: 1.h),

        // Progress bar
        Container(
          height: 4,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(2),
          ),
          child: FractionallySizedBox(
            widthFactor: _strengthValue,
            child: Container(
              decoration: BoxDecoration(
                color: _strengthColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),

        SizedBox(height: 2.h),

        // Requirements checklist
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .surfaceContainerHighest
                .withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Password requirements:',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 2.h),
              ..._getRequirements().map((req) => Padding(
                    padding: EdgeInsets.only(bottom: 1.h),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: req['met']
                              ? 'check_circle'
                              : 'radio_button_unchecked',
                          color: req['met']
                              ? Colors.green
                              : Theme.of(context).colorScheme.outline,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          req['text'],
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            color: req['met']
                                ? Theme.of(context).colorScheme.onSurface
                                : Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                            fontWeight: req['met']
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
