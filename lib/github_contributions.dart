import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_animate/flutter_animate.dart';

class GithubContributions extends StatefulWidget {
  const GithubContributions({super.key});

  @override
  State<GithubContributions> createState() => _GithubContributionsState();
}

class _GithubContributionsState extends State<GithubContributions> {
  List<Map<String, dynamic>> _contributions = [];
  bool _isLoading = true;
  String? _error;

  // GitHub-like Constants
  final double _squareSize = 10.0;
  final double _gap = 3.0;
  
  // GitHub Dark Mode Colors
  final Color _emptyColor = const Color(0xFF161B22);
  final List<Color> _levelColors = const [
    Color(0xFF161B22), // Level 0
    Color(0xFF0E4429), // Level 1
    Color(0xFF006D32), // Level 2
    Color(0xFF26A641), // Level 3
    Color(0xFF39D353), // Level 4
  ];

  @override
  void initState() {
    super.initState();
    _fetchContributions();
  }

  Future<void> _fetchContributions() async {
    try {
      final response = await http.get(
        Uri.parse('https://github-contributions-api.jogruber.de/v4/ashimsap?y=last')
      );
      
      if (response.statusCode == 200) {
         final data = json.decode(response.body);
         final List<dynamic> items = data['contributions'];
         
         if (mounted) {
           setState(() {
             _contributions = items.cast<Map<String, dynamic>>();
             _isLoading = false;
           });
         }
      } else {
        throw Exception("Failed to load");
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = "Could not fetch GitHub data";
          _isLoading = false;
        });
      }
    }
  }

  String _monthName(int month) {
    const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "CONTRIBUTIONS (LAST YEAR)", 
          style: GoogleFonts.robotoMono(color: Colors.white54, fontSize: 12, letterSpacing: 2)
        ),
        const SizedBox(height: 15),
        Container(
          width: double.infinity, // Allow it to stretch to max width of parent
          decoration: BoxDecoration(
            color: const Color(0xFF0D1117), // GitHub canvas background
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFF30363D)),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10)
            ]
          ),
          padding: const EdgeInsets.all(16),
          child: _isLoading 
            ? const Center(child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(color: Color(0xFF39D353)),
              ))
            : _error != null 
              ? Center(child: Text(_error!, style: GoogleFonts.robotoMono(color: Colors.white30)))
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true, // Start from the right (latest date)
                  physics: const BouncingScrollPhysics(),
                  child: _buildCalendar(),
                ),
        ),
      ],
    ).animate().fadeIn(delay: 900.ms).slideY(begin: 0.2);
  }

  Widget _buildCalendar() {
    if (_contributions.isEmpty) return const SizedBox();

    final firstDate = DateTime.parse(_contributions.first['date']);
    
    // GitHub grid logic:
    // Rows = Days (0=Sun, 6=Sat) - but commonly displayed starting Mon or Sun.
    // GitHub displays Sun at row 0.
    
    // Pad the start so the first date aligns with its correct weekday row.
    // weekday: 1=Mon ... 7=Sun.
    // We want Sun=0, Mon=1 ... Sat=6.
    int paddingCount = 0;
    if (firstDate.weekday != 7) {
       // if Mon(1), we need 1 padding (Sun).
       paddingCount = firstDate.weekday;
    }
    
    final paddedContributions = [
      ...List.generate(paddingCount, (_) => <String, dynamic>{'empty': true}),
      ..._contributions
    ];

    final totalWeeks = (paddedContributions.length / 7).ceil();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Day Labels (Mon, Wed, Fri)
            Column(
              children: [
                SizedBox(height: 20), // Top margin for month labels
                _DayLabel(label: "Mon", height: _squareSize, gap: _gap, visible: true),
                _DayLabel(label: "", height: _squareSize, gap: _gap, visible: false),
                _DayLabel(label: "Wed", height: _squareSize, gap: _gap, visible: true),
                _DayLabel(label: "", height: _squareSize, gap: _gap, visible: false),
                _DayLabel(label: "Fri", height: _squareSize, gap: _gap, visible: true),
              ],
            ),
            const SizedBox(width: 5),
            
            // Grid
            SizedBox(
              height: (_squareSize + _gap) * 7 + 20, // 7 rows + label row height
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: totalWeeks,
                itemBuilder: (context, weekIndex) {
                  final startIndex = weekIndex * 7;
                  final endIndex = (startIndex + 7 > paddedContributions.length)
                      ? paddedContributions.length
                      : startIndex + 7;
                  final weekDays = paddedContributions.sublist(startIndex, endIndex);
                  
                  // Month Label Logic
                  String? monthLabel;
                  bool showMonth = false;
                  
                  // Check if this week contains the 1st of a month
                  for (var day in weekDays) {
                    if (day['empty'] != true) {
                      final d = DateTime.parse(day['date']);
                      if (d.day == 1) {
                         showMonth = true;
                         monthLabel = _monthName(d.month);
                         break;
                      }
                    }
                  }
                  // Also show label for the very first week if valid
                  if (weekIndex == 0 && monthLabel == null) {
                     for (var day in weekDays) {
                        if (day['empty'] != true) {
                           monthLabel = _monthName(DateTime.parse(day['date']).month);
                           showMonth = true; 
                           break;
                        }
                     }
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Month Label
                      Container(
                        height: 20,
                        width: _squareSize + _gap,
                        alignment: Alignment.bottomLeft,
                        child: showMonth 
                          ? Text(monthLabel ?? "", 
                              style: GoogleFonts.roboto(color: const Color(0xFF8B949E), fontSize: 9))
                          : null,
                      ),
                      
                      // Days
                      ...weekDays.map((day) {
                         if (day['empty'] == true) {
                           return SizedBox(width: _squareSize, height: _squareSize + _gap);
                         }
                      
                         final level = day['level'] as int;
                         final color = _levelColors[level.clamp(0, 4)];

                         return Tooltip(
                           message: "${day['date']}: ${day['count']} contributions",
                           waitDuration: const Duration(milliseconds: 500),
                           child: Container(
                             width: _squareSize,
                             height: _squareSize,
                             margin: EdgeInsets.only(bottom: _gap),
                             decoration: BoxDecoration(
                               color: color,
                               borderRadius: BorderRadius.circular(2),
                             ),
                           ),
                         );
                      }),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 8),
        
        // Legend
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Less", style: GoogleFonts.roboto(color: const Color(0xFF8B949E), fontSize: 10)),
            const SizedBox(width: 4),
            _LegendSquare(color: _levelColors[0]),
            _LegendSquare(color: _levelColors[1]),
            _LegendSquare(color: _levelColors[2]),
            _LegendSquare(color: _levelColors[3]),
            _LegendSquare(color: _levelColors[4]),
            const SizedBox(width: 4),
            Text("More", style: GoogleFonts.roboto(color: const Color(0xFF8B949E), fontSize: 10)),
          ],
        )
      ],
    );
  }
}

class _DayLabel extends StatelessWidget {
  final String label;
  final double height;
  final double gap;
  final bool visible;

  const _DayLabel({
    required this.label, 
    required this.height, 
    required this.gap,
    required this.visible
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: EdgeInsets.only(bottom: gap),
      // To align with the grid rows, we need to skip rows 0 (Sun), 2 (Tue), 4 (Thu), 6 (Sat) 
      // but in the calling code I'm handling positioning manually. 
      // GitHub labels: Mon(row 1), Wed(row 3), Fri(row 5).
      // Row 0 is Sun.
      // So this widget will be used for specific rows.
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 4),
      child: visible ? Text(
        label,
        style: GoogleFonts.roboto(color: const Color(0xFF8B949E), fontSize: 9),
      ) : null,
    );
  }
}

class _LegendSquare extends StatelessWidget {
  final Color color;
  const _LegendSquare({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
