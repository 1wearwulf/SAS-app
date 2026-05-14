import 'package:flutter/material.dart';
import 'package:wifi_info_flutter/wifi_info_flutter.dart';
import '../../domain/entities/session_config.dart';

class StartSessionModal extends StatefulWidget {
  final Function(SessionConfig) onStartSession;
  
  const StartSessionModal({super.key, required this.onStartSession});

  @override
  State<StartSessionModal> createState() => _StartSessionModalState();
}

class _StartSessionModalState extends State<StartSessionModal> {
  String? _selectedCourse;
  int _durationMinutes = 60;
  double _geofenceRadius = 100;
  String _room = '';
  bool _enableGeofencing = true;
  bool _enableWifiVerification = false;
  String _allowedSsid = '';
  bool _isDetectingWifi = false;
  String? _detectedSsid;
  
  final List<Map<String, dynamic>> _courses = [
    {"code": "CS401", "name": "Software Engineering", "room": "E202", "students": 44},
    {"code": "CS301", "name": "Data Structures", "room": "LH4", "students": 52},
    {"code": "CS302", "name": "Database Systems", "room": "LH2", "students": 48},
    {"code": "CS403", "name": "Networks & Security", "room": "E101", "students": 43},
  ];
  
  final List<int> _durationPresets = [1, 2, 5, 10, 15, 30, 45, 60, 90, 120];
  final List<String> _durationLabels = ['1m', '2m', '5m', '10m', '15m', '30m', '45m', '1h', '1.5h', '2h'];

  Future<void> _detectCurrentWifi() async {
    setState(() {
      _isDetectingWifi = true;
      _detectedSsid = null;
    });
    
    try {
      final ssid = await WifiInfo().getWifiName();
      if (ssid != null && ssid.isNotEmpty) {
        final cleanSsid = ssid.replaceAll('"', '');
        setState(() {
          _detectedSsid = cleanSsid;
          _allowedSsid = cleanSsid;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Detected WiFi: $cleanSsid'), backgroundColor: Colors.green),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No WiFi detected'), backgroundColor: Colors.orange),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to detect WiFi: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDetectingWifi = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        width: 500,
        constraints: const BoxConstraints(maxHeight: 650),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.withAlpha(25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.play_arrow, color: Colors.blue),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Start New Session',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Course Dropdown
              const Text('Course', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCourse,
                isExpanded: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                hint: const Text('Select a course'),
                items: _courses.map((course) {
                  return DropdownMenuItem<String>(
                    value: course['code'] as String,
                    child: Row(
                      children: [
                        Expanded(child: Text('${course['code']} - ${course['name']}')),
                        Text(
                          '${course['students']} students',
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCourse = value;
                    if (value != null) {
                      final course = _courses.firstWhere((c) => c['code'] == value);
                      _room = course['room'] as String;
                    }
                  });
                },
              ),
              const SizedBox(height: 20),
              
              // Duration with presets
              const Text('Session Duration', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(_durationPresets.length, (index) {
                  final duration = _durationPresets[index];
                  final isSelected = _durationMinutes == duration;
                  return FilterChip(
                    label: Text(_durationLabels[index]),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        _durationMinutes = duration;
                      });
                    },
                    selectedColor: Colors.blue.withAlpha(51),
                    backgroundColor: Colors.white,
                    side: BorderSide(color: isSelected ? Colors.blue : Colors.grey.shade300),
                  );
                }),
              ),
              const SizedBox(height: 20),
              
              // Room
              const Text('Location / Room', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              TextField(
                controller: TextEditingController(text: _room),
                onChanged: (value) => _room = value,
                decoration: InputDecoration(
                  hintText: 'e.g. LH4, E202, Online',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 20),
              
              // Geofencing
              Row(
                children: [
                  Switch(
                    value: _enableGeofencing,
                    onChanged: (value) {
                      setState(() {
                        _enableGeofencing = value;
                      });
                    },
                    activeColor: Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text('Enable Geofencing', style: TextStyle(fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
              
              if (_enableGeofencing) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Radius:', style: TextStyle(fontSize: 13)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Slider(
                        value: _geofenceRadius,
                        min: 50,
                        max: 300,
                        divisions: 5,
                        label: '${_geofenceRadius.toInt()}m',
                        onChanged: (value) {
                          setState(() {
                            _geofenceRadius = value;
                          });
                        },
                      ),
                    ),
                    Container(
                      width: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${_geofenceRadius.toInt()}m',
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Students must be within this radius to mark attendance',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
              
              const SizedBox(height: 20),
              
              // WiFi Verification
              Row(
                children: [
                  Switch(
                    value: _enableWifiVerification,
                    onChanged: (value) {
                      setState(() {
                        _enableWifiVerification = value;
                        if (!value) {
                          _allowedSsid = '';
                          _detectedSsid = null;
                        }
                      });
                    },
                    activeColor: Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text('Verify WiFi Network', style: TextStyle(fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
              
              if (_enableWifiVerification) ...[
                const SizedBox(height: 12),
                
                // Auto-detect button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isDetectingWifi ? null : _detectCurrentWifi,
                    icon: _isDetectingWifi
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.wifi_find, size: 18),
                    label: Text(_isDetectingWifi ? 'Detecting...' : 'Auto-detect (Mobile only)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade50,
                      foregroundColor: Colors.blue,
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Text("Note: WiFi detection works on mobile devices only", style: TextStyle(fontSize: 10, color: Colors.grey)),
                
                if (_detectedSsid != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Detected: $_detectedSsid',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _allowedSsid = _detectedSsid!;
                            });
                          },
                          child: const Text('Use'),
                        ),
                      ],
                    ),
                  ),
                ],
                
                const SizedBox(height: 12),
                
                // Manual SSID entry
                TextField(
                  onChanged: (value) => _allowedSsid = value,
                  controller: TextEditingController(text: _allowedSsid),
                  decoration: InputDecoration(
                    hintText: 'Or enter WiFi SSID manually',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    prefixIcon: const Icon(Icons.wifi),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Students must be connected to this WiFi network',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
              
              const SizedBox(height: 24),
              
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _selectedCourse != null
                          ? () {
                              final course = _courses.firstWhere((c) => c['code'] == _selectedCourse);
                              final config = SessionConfig(
                                courseCode: course['code'] as String,
                                courseName: course['name'] as String,
                                room: _room,
                                durationMinutes: _durationMinutes,
                                geofenceRadius: _enableGeofencing ? _geofenceRadius : 0,
                                enableGeofencing: _enableGeofencing,
                                enableWifiVerification: _enableWifiVerification,
                                allowedSsid: _enableWifiVerification ? _allowedSsid : null,
                              );
                              widget.onStartSession(config);
                              Navigator.pop(context);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Start Session →'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
