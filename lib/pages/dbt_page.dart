import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class DbtPage extends StatelessWidget {
  const DbtPage({Key? key}) : super(key: key);

  // Grouped Payhip links into modules
  static final List<List<String>> modules = [
    [
      'https://payhip.com/b/yX7HM',
      'https://payhip.com/b/w9Y2W',
      'https://payhip.com/b/gkxPw',
      'https://payhip.com/b/Z083b',
      'https://payhip.com/b/e5xCd',
      'https://payhip.com/b/MrR7c',
      'https://payhip.com/b/6N8mq',
      'https://payhip.com/b/AyGZ4',
      'https://payhip.com/b/NKDjs',
    ],
    [
      'https://payhip.com/b/OVlas',
      'https://payhip.com/b/oNdeK',
      'https://payhip.com/b/jOwa1',
      'https://payhip.com/b/XnYkN',
      'https://payhip.com/b/GeFWn',
      'https://payhip.com/b/0rHQL',
    ],
    [
      'https://payhip.com/b/J1q5L',
      'https://payhip.com/b/dPySc',
      'https://payhip.com/b/S0ECb',
      'https://payhip.com/b/UMj6Y',
      'https://payhip.com/b/DECOA',
      'https://payhip.com/b/uvkOS',
      'https://payhip.com/b/MsYKp',
      'https://payhip.com/b/xOUjM',
      'https://payhip.com/b/v3Xhe',
    ],
    [
      'https://payhip.com/b/PFjY2',
      'https://payhip.com/b/cB1uQ',
      'https://payhip.com/b/WhBK2',
      'https://payhip.com/b/GIWK9',
      'https://payhip.com/b/T8tNH',
      'https://payhip.com/b/1fGs9',
      'https://payhip.com/b/Fo4Zh',
      'https://payhip.com/b/Pdjf2',
      'https://payhip.com/b/w5aJ4',
      'https://payhip.com/b/HrjhE',
    ],
  ];

  // Try to fetch the <title> of the Payhip page
  static Future<String?> fetchTitle(String url) async {
    try {
      final resp = await http.get(Uri.parse(url));
      if (resp.statusCode == 200) {
        final body = resp.body;
        final m = RegExp(r'<title[^>]*>(.*?)<\/title>',
            caseSensitive: false, dotAll: true)
            .firstMatch(body);
        if (m != null) {
          var t = m.group(1) ?? '';
          t = t.replaceAll(RegExp(r'\s+'), ' ').trim();

          // Remove trailing "- Payhip" (any variant like – or |)
          t = t.replaceAll(
              RegExp(r'\s*[-|–]\s*Payhip$', caseSensitive: false), '');

          return t;
        }
      }
    } catch (e) {
      // ignore errors
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Text('DBT Modules', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        ...List.generate(modules.length, (mi) {
          final mod = modules[mi];
          return ExpansionTile(
            title: Text('Module ${mi + 1}'),
            children: mod.asMap().entries.map((entry) {
              final idx = entry.key;
              final url = entry.value;
              return Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Card(
                  child: ListTile(
                    title: FutureBuilder<String?>(
                      future: fetchTitle(url),
                      builder: (c, s) {
                        String title;
                        if (s.connectionState == ConnectionState.waiting) {
                          title = 'Loading...';
                        } else if (s.hasData &&
                            s.data != null &&
                            s.data!.isNotEmpty) {
                          title = s.data!;
                        } else {
                          title = '${mi + 1}.${idx + 1}';
                        }
                        return Text(title,
                            maxLines: 2, overflow: TextOverflow.ellipsis);
                      },
                    ),
                    trailing: ElevatedButton.icon(
                      onPressed: () async {
                        final uri = Uri.parse(url);
                        if (!await launchUrl(uri,
                            mode: LaunchMode.externalApplication)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Could not open link')),
                          );
                        }
                      },
                      icon: const Icon(Icons.shopping_cart),
                      label: const Text('Purchase'),
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }),
        const SizedBox(height: 16),
        Center(
          child: ElevatedButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Workbooks will be available soon.')),
            ),
            icon: const Icon(Icons.book),
            label: const Text('DBT Workbooks (Coming Soon)'),
            style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
