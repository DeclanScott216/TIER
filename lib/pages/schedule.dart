// lib/pages/schedule_page.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final List<Map<String, String>> services = [
    {
      'title': 'Introductory Consultation',
      'price': 'Free',
      'desc': 'Explanation of Services and Needs Assessment'
    },
    {
      'title': 'Life Coach Sessions (half-hour)',
      'price': '\$100',
      'desc': 'Improve Quality of Life and "Achieve with Balance"'
    },
    {
      'title': 'Life Coach Sessions (sliding scale)',
      'price': 'Sliding Scale',
      'desc': 'Sliding Scale and Scholarships Available'
    },
    {
      'title': 'Specialists Life Coach Sessions',
      'price': '\$200-500 / hour',
      'desc': 'Specific field specialists, experienced with athletes & executives'
    },
    {
      'title': 'Six-Month Guaranteed Recovery Program',
      'price': '\$7,500',
      'desc': 'Weekly 1-hour sessions — financing available'
    },
    {
      'title': 'Remote Therapy Monitoring Access',
      'price': 'Varies',
      'desc': 'Patient monthly access/apps — \$19.99/month typical'
    },
    {
      'title': 'Clinician Monthly Access',
      'price': 'Free',
      'desc': 'Provider access'
    },
    {
      'title': 'Self-Guided Discovery',
      'price': '\$4.99',
      'desc': 'Per product'
    },
    {
      'title': 'Pharmacogenomics Testing (PGx)',
      'price': '\$250',
      'desc': 'Cash Pay option; insured accepted where applicable'
    },
  ];

  Future<void> _contactEmail(String subject) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'scheduling@elitelywell.com',
      queryParameters: {'subject': subject},
    );

    try {
      final launched = await launchUrl(
        emailLaunchUri,
        mode: LaunchMode.externalApplication, // ensures system mail app opens
      );

      if (!launched) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No email app found on this device.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Text(
          'Services & Pricing',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        ...services.map(
              (s) => Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              title: Text(s['title']!),
              subtitle: Text('${s['price']} — ${s['desc']}'),
              trailing: ElevatedButton.icon(
                icon: const Icon(Icons.email),
                label: const Text('Contact'),
                onPressed: () => _contactEmail(s['title']!),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Card(
          child: ListTile(
            leading: Icon(Icons.info),
            title: Text('Scheduling Email'),
            subtitle: Text('scheduling@elitelywell.com'),
          ),
        ),
      ],
    );
  }
}
