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
  int _totalContributions = 0;

  // GitHub-like Constants
  final double _squareSize = 12.0; 
  final double _gap = 3.0; 
  
  // GitHub Dark Mode Colors
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
         
         int total = 0;
         final List<Map<String, dynamic>> parsed = [];
         for(var item in items) {
            total += (item['count'] as int);
            parsed.add(item as Map<String, dynamic>);
         }

         if (mounted) {
           setState(() {
             _contributions = parsed;
             _totalContributions = total;
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
    // Exact height calculation with a small buffer for safety
    // Header (20px) + 7 * (Square + Gap)
    final double gridHeight = 20.0 + (7 * (_squareSize + _gap));

    int totalWeeks = 53;
    if (!_isLoading && _contributions.isNotEmpty) {
       final firstDate = DateTime.parse(_contributions.first['date']);
       int paddingCount = (firstDate.weekday != 7) ? firstDate.weekday : 0;
       totalWeeks = ((_contributions.length + paddingCount) / 7).ceil();
    }
    
    // Width calculation
    final double contentWidth = 30.0 + 6.0 + (totalWeeks * (_squareSize + _gap)) + 32.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final containerWidth = (contentWidth > constraints.maxWidth) 
            ? constraints.maxWidth 
            : contentWidth;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4.0, bottom: 10),
              child: Text(
                "$_totalContributions contributions in the last year", 
                style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)
              ),
            ),
            Container(
              width: containerWidth,
              decoration: BoxDecoration(
                color: const Color(0xFF0D1117), 
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFF30363D)),
              ),
              padding: const EdgeInsets.all(16),
              child: _isLoading 
                ? SizedBox(height: gridHeight + 30, child: const Center(child: CircularProgressIndicator(color: Color(0xFF39D353))))
                : _error != null 
                  ? SizedBox(height: gridHeight + 30, child: Center(child: Text(_error!, style: GoogleFonts.robotoMono(color: Colors.white30))))
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Labels + Grid Row
                        SizedBox(
                          height: gridHeight + 1.0, // +1px buffer to prevent sub-pixel overflow
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Sticky Day Labels
                              SizedBox(
                                width: 30,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                     const SizedBox(height: 20), // Matches grid header
                                     _DayLabel(label: "", height: _squareSize, gap: _gap, visible: false),
                                     _DayLabel(label: "Mon", height: _squareSize, gap: _gap, visible: true),
                                     _DayLabel(label: "", height: _squareSize, gap: _gap, visible: false),
                                     _DayLabel(label: "Wed", height: _squareSize, gap: _gap, visible: true),
                                     _DayLabel(label: "", height: _squareSize, gap: _gap, visible: false),
                                     _DayLabel(label: "Fri", height: _squareSize, gap: _gap, visible: true),
                                     _DayLabel(label: "", height: _squareSize, gap: _gap, visible: false),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 6), 
                              
                              // Scrollable Grid
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  reverse: true,
                                  physics: const BouncingScrollPhysics(),
                                  child: _buildCalendarGrid(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Legend
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Less", style: GoogleFonts.inter(color: const Color(0xFF7D8590), fontSize: 12)),
                            const SizedBox(width: 4),
                            _LegendSquare(color: _levelColors[0]),
                            _LegendSquare(color: _levelColors[1]),
                            _LegendSquare(color: _levelColors[2]),
                            _LegendSquare(color: _levelColors[3]),
                            _LegendSquare(color: _levelColors[4]),
                            const SizedBox(width: 4),
                            Text("More", style: GoogleFonts.inter(color: const Color(0xFF7D8590), fontSize: 12)),
                          ],
                        )
                      ],
                    ),
            ),
          ],
        ).animate().fadeIn(delay: 900.ms).slideY(begin: 0.2);
      }
    );
  }

  Widget _buildCalendarGrid() {
    if (_contributions.isEmpty) return const SizedBox();

    final firstDate = DateTime.parse(_contributions.first['date']);
    int paddingCount = (firstDate.weekday != 7) ? firstDate.weekday : 0;
    
    final paddedContributions = [
      ...List.generate(paddingCount, (_) => <String, dynamic>{'empty': true}),
      ..._contributions
    ];

    final totalWeeks = (paddedContributions.length / 7).ceil();

    return SizedBox(
      height: 20 + (7 * (_squareSize + _gap)) + 1.0, // Add buffer
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
          
          String? monthLabel;
          bool showMonth = false;
          
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
          if (weekIndex == 0 && monthLabel == null && weekDays.isNotEmpty) {
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
                width: _squareSize, 
                margin: EdgeInsets.only(right: _gap),
                alignment: Alignment.bottomLeft, 
                child: showMonth 
                  ? Transform.translate(
                      offset: const Offset(0, 4), 
                      child: OverflowBox(
                        maxWidth: 60,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          monthLabel ?? "", 
                          style: GoogleFonts.inter(
                            color: const Color(0xFF7D8590), 
                            fontSize: 12, 
                            fontWeight: FontWeight.w500,
                            height: 1.0, // Force strict line height
                          ),
                          softWrap: false,
                        ),
                      ),
                    )
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
                   waitDuration: const Duration(milliseconds: 300),
                   decoration: BoxDecoration(
                     color: const Color(0xFF6E7681).withValues(alpha: 0.9), 
                     borderRadius: BorderRadius.circular(4),
                   ),
                   textStyle: const TextStyle(color: Colors.white, fontSize: 12),
                   child: Container(
                     width: _squareSize,
                     height: _squareSize,
                     margin: EdgeInsets.only(bottom: _gap, right: _gap),
                     decoration: BoxDecoration(
                       color: color,
                       borderRadius: BorderRadius.circular(2),
                       border: level == 0 ? Border.all(color: const Color(0xFF30363D).withValues(alpha: 0.5), width: 1) : null
                     ),
                   ),
                 );
              }),
            ],
          );
        },
      ),
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
    required this.visible,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: EdgeInsets.only(bottom: gap),
      // Align Center for better visual balance with the square
      alignment: Alignment.centerRight, 
      child: visible ? Text(
        label,
        style: GoogleFonts.inter(color: const Color(0xFF7D8590), fontSize: 10, height: 1.0),
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
        border: color == const Color(0xFF161B22) 
           ? Border.all(color: const Color(0xFF30363D).withValues(alpha: 0.5), width: 1) 
           : null
      ),
    );
  }
}
