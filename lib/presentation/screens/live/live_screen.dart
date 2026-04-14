import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';

class LiveScreen extends StatefulWidget {
  const LiveScreen({super.key});
  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  String? _selectedCategory;
  final List<String> _categories = ['All','Music','Gaming','Tech','Fitness','Cooking','Art','Travel','Voice'];

  final List<Map<String, dynamic>> _liveRooms = [
    {'host':'DJ_SetRise','title':'🎵 Late Night Beats Vol.3','viewers':4820,'category':'Music','color':const Color(0xFF1A0A2E),'isHot':true,'duration':'1:24:03','type':'video'},
    {'host':'TechTalk_Z','title':'💻 Building AI App LIVE','viewers':2310,'category':'Tech','color':const Color(0xFF0A1628),'isHot':false,'duration':'0:42:18','type':'video'},
    {'host':'ChefKarim','title':'🍳 Making Couscous from Scratch','viewers':1890,'category':'Cooking','color':const Color(0xFF2E1A0A),'isHot':false,'duration':'0:28:55','type':'video'},
    {'host':'FitCoach_L','title':'🏋️ Full Body Workout','viewers':5640,'category':'Fitness','color':const Color(0xFF0A1A0A),'isHot':true,'duration':'0:55:12','type':'video'},
    {'host':'GamersUnited','title':'🎮 Fortnite World Cup Practice','viewers':12400,'category':'Gaming','color':const Color(0xFF0A0A1A),'isHot':true,'duration':'2:03:44','type':'video'},
    {'host':'ArtByNora','title':'🎨 Speed Painting - Portrait','viewers':890,'category':'Art','color':const Color(0xFF1A000A),'isHot':false,'duration':'0:15:30','type':'video'},
    {'host':'TravelSara','title':'✈️ Live from Tokyo Night Market','viewers':3200,'category':'Travel','color':const Color(0xFF002E2E),'isHot':false,'duration':'1:08:22','type':'video'},
    {'host':'MusicRoom_1','title':'🎤 Voice Chat - Open Mic Night','viewers':420,'category':'Voice','color':const Color(0xFF1A1A00),'isHot':false,'duration':'0:32:10','type':'voice'},
    {'host':'CodeNight','title':'🖥️ Coding Challenge - Voice','viewers':680,'category':'Tech','color':const Color(0xFF001A1A),'isHot':false,'duration':'1:10:00','type':'voice'},
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_selectedCategory == null || _selectedCategory == 'All') return _liveRooms;
    return _liveRooms.where((r) => r['category'] == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // زر Go Live
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(children: [
            const Spacer(),
            Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(color: AppColors.live, borderRadius: BorderRadius.circular(20)),
              child: const Row(children: [
                Icon(Icons.videocam, color: AppColors.white, size: 16), SizedBox(width: 6),
                Text('Go Live', style: TextStyle(color: AppColors.white, fontSize: 12, fontWeight: FontWeight.bold, )),
              ])),
          ]),
        ),
        // CATEGORIES
        SizedBox(height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            itemCount: _categories.length,
            itemBuilder: (_, i) {
              final cat = _categories[i];
              final isSelected = (_selectedCategory == null && i == 0) || _selectedCategory == cat;
              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = i == 0 ? null : cat),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.live : AppColors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(20)),
                  child: Text(cat, style: TextStyle(color: AppColors.white, fontSize: 12, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400, )),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        // ROOMS GRID
        Expanded(child: GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.78),
          itemCount: _filtered.length,
          itemBuilder: (_, i) {
            final room = _filtered[i];
            final isVoice = room['type'] == 'voice';
            return GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => _LiveRoomScreen(room: room))),
              child: Container(
                decoration: BoxDecoration(color: room['color'] as Color, borderRadius: BorderRadius.circular(16)),
                child: Stack(children: [
                  if (isVoice)
                    Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Container(width: 60, height: 60, decoration: BoxDecoration(color: AppColors.live.withOpacity(0.3), shape: BoxShape.circle),
                        child: const Icon(Icons.mic, color: AppColors.white, size: 32)),
                      const SizedBox(height: 8),
                      const Text('Voice Room', style: TextStyle(color: AppColors.white, fontSize: 12, )),
                    ]))
                  else
                    Center(child: Icon(Icons.live_tv, color: AppColors.white.withOpacity(0.15), size: 60)),
                  Positioned(top: 8, left: 8, child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(color: AppColors.live, borderRadius: BorderRadius.circular(5)),
                    child: const Row(children: [
                      Icon(Icons.circle, color: AppColors.white, size: 6),
                      SizedBox(width: 4),
                      Text('LIVE', style: TextStyle(color: AppColors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                    ]))),
                  Positioned(top: 8, right: 8, child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), borderRadius: BorderRadius.circular(5)),
                    child: Row(children: [
                      const Icon(Icons.person, color: AppColors.white, size: 10),
                      const SizedBox(width: 3),
                      Text(Formatters.formatCount(room['viewers'] as int), style: const TextStyle(color: AppColors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ]))),
                  Positioned(bottom: 0, left: 0, right: 0, child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.85)]),
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16))),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(room['title'], style: const TextStyle(color: AppColors.white, fontSize: 11, fontWeight: FontWeight.bold, ), maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 3),
                      Text('@${room['host']} · ${room['duration']}', style: const TextStyle(color: AppColors.grey2, fontSize: 10, )),
                    ]),
                  )),
                ]),
              ),
            );
          },
        )),
      ],
    );
  }
}

// _LiveRoomScreen تبقى كما هي
