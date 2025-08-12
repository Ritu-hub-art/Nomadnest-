import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SubscriptionManagementWidget extends StatelessWidget {
  final Map<String, dynamic> accountData;
  final Function(String, dynamic) onSubscriptionChanged;

  const SubscriptionManagementWidget({
    super.key,
    required this.accountData,
    required this.onSubscriptionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final currentPlan = accountData['subscriptionPlan'] ?? 'Free';
    final billingCycle = accountData['billingCycle'] ?? 'Monthly';

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
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'card_membership',
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Subscription Management',
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),

          // Current Plan
          Container(
            margin: EdgeInsets.all(4.w),
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  Theme.of(context)
                      .colorScheme
                      .secondary
                      .withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Plan',
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                          Text(
                            '$currentPlan Plan',
                            style: GoogleFonts.inter(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Text(
                            billingCycle,
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (currentPlan != 'Free')
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          currentPlan == 'Premium' ? '\$9.99/mo' : '\$4.99/mo',
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                  ],
                ),
                if (currentPlan != 'Premium') ...[
                  SizedBox(height: 2.h),
                  ElevatedButton(
                    onPressed: () => _showUpgradeDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      currentPlan == 'Free'
                          ? 'Upgrade to Premium'
                          : 'Upgrade Plan',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          _buildSubscriptionOption(
            context,
            'Billing History',
            'View past invoices and payments',
            'receipt',
            () => _showBillingHistory(context),
          ),

          if (currentPlan != 'Free')
            _buildSubscriptionOption(
              context,
              'Change Billing Cycle',
              'Switch between monthly and yearly',
              'schedule',
              () => _showBillingCycleDialog(context),
            ),

          if (currentPlan != 'Free')
            _buildSubscriptionOption(
              context,
              'Cancel Subscription',
              'Downgrade to free plan',
              'cancel',
              () => _showCancelConfirmation(context),
              isDestructive: true,
            ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionOption(
    BuildContext context,
    String title,
    String subtitle,
    String iconName,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
      leading: CustomIconWidget(
        iconName: iconName,
        color: isDestructive
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.onSurfaceVariant,
        size: 24,
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: isDestructive
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.inter(
          fontSize: 14.sp,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: const CustomIconWidget(
        iconName: 'chevron_right',
        size: 20,
      ),
      onTap: onTap,
    );
  }

  void _showUpgradeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Upgrade Plan',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPlanOption(context, 'Basic', '\$4.99/month', false),
            SizedBox(height: 1.h),
            _buildPlanOption(context, 'Premium', '\$9.99/month', true),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanOption(
      BuildContext context, String plan, String price, bool recommended) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: recommended
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
            : Theme.of(context)
                .colorScheme
                .surfaceContainerHighest
                .withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: recommended
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      plan,
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (recommended) ...[
                      SizedBox(width: 2.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Recommended',
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  price,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onSubscriptionChanged('subscriptionPlan', plan);
            },
            child: const Text('Select'),
          ),
        ],
      ),
    );
  }

  void _showBillingHistory(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Billing History'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildBillingItem(context, 'January 2024', '\$9.99', 'Paid'),
            _buildBillingItem(context, 'December 2023', '\$9.99', 'Paid'),
            _buildBillingItem(context, 'November 2023', '\$9.99', 'Paid'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildBillingItem(
      BuildContext context, String period, String amount, String status) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(period,
                  style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
              Text(status,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: Colors.green.shade600,
                  )),
            ],
          ),
          Text(amount, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  void _showBillingCycleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Billing Cycle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Monthly'),
              subtitle: const Text('Billed every month'),
              value: 'Monthly',
              groupValue: accountData['billingCycle'],
              onChanged: (value) {
                Navigator.pop(context);
                onSubscriptionChanged('billingCycle', value);
              },
            ),
            RadioListTile<String>(
              title: const Text('Yearly'),
              subtitle: const Text('Billed annually (20% discount)'),
              value: 'Yearly',
              groupValue: accountData['billingCycle'],
              onChanged: (value) {
                Navigator.pop(context);
                onSubscriptionChanged('billingCycle', value);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCancelConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Subscription'),
        content: const Text(
            'Are you sure you want to cancel your subscription? You\'ll lose access to premium features at the end of your current billing period.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Subscription'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onSubscriptionChanged('subscriptionPlan', 'Free');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Cancel Subscription'),
          ),
        ],
      ),
    );
  }
}
