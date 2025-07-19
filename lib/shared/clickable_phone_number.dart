import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ClickablePhoneNumber extends StatelessWidget {
  final String? phoneNumber;
  final TextStyle? style;
  final bool showUnderline;

  const ClickablePhoneNumber({
    super.key,
    required this.phoneNumber,
    this.style,
    this.showUnderline = true,
  });

  @override
  Widget build(BuildContext context) {
    // If no phone number, return placeholder text
    if (phoneNumber == null || phoneNumber!.isEmpty) {
      return Text(
        'No phone number',
        style: style?.copyWith(color: style?.color?.withOpacity(0.5)),
      );
    }

    return GestureDetector(
      onTap: () => _launchSMS(context),
      onLongPress: () => _showOptions(context),
      child: Text(
        phoneNumber!,
        style: (style ?? const TextStyle()).copyWith(
          decoration: showUnderline ? TextDecoration.underline : null,
          decorationColor: style?.color,
        ),
      ),
    );
  }

  Future<void> _launchSMS(BuildContext context) async {
    if (phoneNumber == null || phoneNumber!.isEmpty) return;
    
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
    );

    try {
      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open messaging app'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _makePhoneCall(BuildContext context) async {
    if (phoneNumber == null || phoneNumber!.isEmpty) return;
    
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open phone app'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.message),
                title: const Text('Send Message'),
                onTap: () {
                  Navigator.pop(context);
                  _launchSMS(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Make Call'),
                onTap: () {
                  Navigator.pop(context);
                  _makePhoneCall(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Cancel'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }
}