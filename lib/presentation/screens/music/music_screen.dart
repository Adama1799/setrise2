import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});
  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> with SingleTickerProviderStateMixin {
  late AnimationController _diskCtrl;
  late TabController _tabCtrl;
  int _currentTrack = 0;
  bool _isPlaying = true;
  bool _isLiked = false;
  double _progress = 0.35;

  final List<Map<String, dynamic>> _tracks = [
    {'title':'Midnight Vibes','artist':'DJ SetRise','duration':'3:24','likes':48200,'color':const Color(0xFF1A0A2E),'genre':'Electronic'},
    {'title':'Desert Rose','artist':'Karim_beats','duration':'4:12','likes':32100,'color':const Color(0xFF2E1A0A),'genre':'Arabic Fusion'},
    {'title':'Neon Dreams','artist':'SynthWave_X','duration':'3:48','likes':21000,'color':const Color(0xFF0A1A2E),'genre':'Synthwave'},
    {'title':'Street Poetry','artist':'Lyric_A','duration':'2:59','likes':18400,'color':const Color(0xFF0A2E0A),'genre':'Hip Hop'},
    {'title':'Ocean Calm','artist':'Relax_Mode','duration':'5:30','likes':14200,'color':const Color(0xFF002E2E),'genre':'Chill'},
    {'title':'Fire Dance','artist':'BeatMaker_Z','duration':'3:15','likes':9800,'color':const Color(0xFF2E0A0A),'genre':'Afrobeat'},
  ];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 4, vsync: this);
    _diskCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat();
  }

  @override
  void dispose() { _diskCtrl.dispose(); _tabCtrl.dispose(); super.dispose(); }

  void _togglePlay() {
    setState(() => _isPlaying = !_isPlaying);
    _isPlaying ? _diskCtrl.repeat() : _diskCtrl.stop();
  }

  @override
  Widget build(BuildContext context) {
    final track = _tracks[_currentTrack];
    return Column(
      children: [
        // TABS
        TabBar(
          controller: _tabCtrl,
          indicatorColor: AppColors.music,
          labelColor: AppColors.music,
          unselectedLabelColor: AppColors.grey2,
          labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, ),
          tabs: const [Tab(text: 'For You'), Tab(text: 'Following'), Tab(text: 'Trending'), Tab(text: 'My Music')],
        ),
        const SizedBox(height: 14),
        // PLAYER CARD
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: (track['color'] as Color).withOpacity(0.8), borderRadius: BorderRadius.circular(24)),
            child: Column(children: [
              RotationTransition(turns: _diskCtrl,
                child: Container(width: 120, height: 120,
                  decoration: BoxDecoration(shape: BoxShape.circle,
                    border: Border.all(color: AppColors.music, width: 3),
                    color: AppColors.grey,
                    boxShadow: [BoxShadow(color: AppColors.music.withOpacity(0.3), blurRadius: 20)]),
                  child: const Icon(Icons.music_note, color: AppColors.music, size: 50))),
              const SizedBox(height: 16),
              Text(track['title'], style: const TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.bold, )),
              const SizedBox(height: 4),
              Text(track['artist'], style: const TextStyle(color: AppColors.music, fontSize: 14, )),
              Text(track['genre'], style: const TextStyle(color: AppColors.grey2, fontSize: 12, )),
              const SizedBox(height: 16),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6)),
                child: Slider(value: _progress, onChanged: (v) => setState(() => _progress = v), activeColor: AppColors.music, inactiveColor: AppColors.grey)),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                GestureDetector(onTap: () => setState(() => _isLiked = !_isLiked),
                  child: Icon(Icons.favorite, color: _isLiked ? AppColors.neonRed : AppColors.grey2, size: 26)),
                GestureDetector(onTap: () => setState(() { if (_currentTrack > 0) _currentTrack--; }),
                  child: const Icon(Icons.skip_previous, color: AppColors.white, size: 36)),
                GestureDetector(onTap: _togglePlay,
                  child: Container(width: 60, height: 60,
                    decoration: const BoxDecoration(color: AppColors.music, shape: BoxShape.circle),
                    child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: AppColors.background, size: 34))),
                GestureDetector(onTap: () => setState(() { if (_currentTrack < _tracks.length - 1) _currentTrack++; }),
                  child: const Icon(Icons.skip_next, color: AppColors.white, size: 36)),
                const Icon(Icons.shuffle, color: AppColors.grey2, size: 26),
              ]),
            ]),
          )),
        const SizedBox(height: 16),
        // TRACK LIST
        Expanded(child: ListView.builder(
          itemCount: _tracks.length,
          itemBuilder: (_, i) {
            final t = _tracks[i];
            final isCurrent = i == _currentTrack;
            return GestureDetector(
              onTap: () => setState(() { _currentTrack = i; _isPlaying = true; _diskCtrl.repeat(); }),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                color: isCurrent ? AppColors.music.withOpacity(0.1) : Colors.transparent,
                child: Row(children: [
                  Container(width: 46, height: 46,
                    decoration: BoxDecoration(color: t['color'] as Color, borderRadius: BorderRadius.circular(10)),
                    child: Center(child: Icon(Icons.music_note, color: isCurrent ? AppColors.music : AppColors.grey2, size: 22))),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(t['title'], style: TextStyle(color: isCurrent ? AppColors.music : AppColors.white, fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal, fontSize: 14, )),
                    Text(t['artist'], style: const TextStyle(color: AppColors.grey2, fontSize: 12, )),
                  ])),
                  Text(t['duration'], style: const TextStyle(color: AppColors.grey2, fontSize: 12, )),
                  const SizedBox(width: 8),
                  Row(children: [
                    const Icon(Icons.favorite, color: AppColors.neonRed, size: 14),
                    const SizedBox(width: 3),
                    Text(Formatters.formatCount(t['likes'] as int), style: const TextStyle(color: AppColors.grey2, fontSize: 11, )),
                  ]),
                ]),
              ),
            );
          },
        )),
      ],
    );
  }
}
