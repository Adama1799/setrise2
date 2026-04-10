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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(child: Column(children: [
        // TOP BAR
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(children: [
            GestureDetector(onTap: () => Navigator.pop(context),
              child: Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.grey, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.arrow_back_ios_new, color: AppColors.white, size: 16))),
            const Spacer(),
            const Text('Live', style: TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w900, )),
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
                  // Content
                  if (isVoice)
                    Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Container(width: 60, height: 60, decoration: BoxDecoration(color: AppColors.live.withOpacity(0.3), shape: BoxShape.circle),
                        child: const Icon(Icons.mic, color: AppColors.white, size: 32)),
                      const SizedBox(height: 8),
                      const Text('Voice Room', style: TextStyle(color: AppColors.white, fontSize: 12, )),
                    ]))
                  else
                    Center(child: Icon(Icons.live_tv, color: AppColors.white.withOpacity(0.15), size: 60)),
                  // Live badge
                  Positioned(top: 8, left: 8, child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(color: AppColors.live, borderRadius: BorderRadius.circular(5)),
                    child: const Row(children: [
                      Icon(Icons.circle, color: AppColors.white, size: 6),
                      SizedBox(width: 4),
                      Text('LIVE', style: TextStyle(color: AppColors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                    ]))),
                  // Viewers
                  Positioned(top: 8, right: 8, child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), borderRadius: BorderRadius.circular(5)),
                    child: Row(children: [
                      const Icon(Icons.person, color: AppColors.white, size: 10),
                      const SizedBox(width: 3),
                      Text(Formatters.formatCount(room['viewers'] as int), style: const TextStyle(color: AppColors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ]))),
                  // Bottom info
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
      ])),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 8, top: 10, left: 24, right: 24),
        decoration: BoxDecoration(color: AppColors.background, border: Border(top: BorderSide(color: AppColors.grey.withOpacity(0.4)))),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _nb(Icons.home_outlined, 'Home', () => Navigator.pop(context)),
          _nb(Icons.search, 'Search', () {}),
          _nb(Icons.videocam_outlined, 'Go Live', () {}),
          _nb(Icons.notifications_outlined, 'Alerts', () {}),
          _nb(Icons.person_outline, 'Profile', () {}),
        ]),
      ),
    );
  }

  Widget _nb(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(onTap: onTap, child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, color: AppColors.grey2, size: 26),
      const SizedBox(height: 2),
      Text(label, style: const TextStyle(color: AppColors.grey2, fontSize: 10, )),
    ]));
  }
}

// ===== LIVE ROOM SCREEN =====
class _LiveRoomScreen extends StatefulWidget {
  final Map room;
  const _LiveRoomScreen({required this.room});
  @override
  State<_LiveRoomScreen> createState() => _LiveRoomScreenState();
}

class _LiveRoomScreenState extends State<_LiveRoomScreen> {
  final _chatCtrl = TextEditingController();
  bool _isLiked = false;
  int _likes = 8400;
  final List<Map<String, dynamic>> _chat = [
    {'user':'ahmed_99','msg':'This is 🔥🔥🔥','color':AppColors.neonRed},
    {'user':'sara_x','msg':'Love this content!','color':AppColors.music},
    {'user':'nora_m','msg':'❤️❤️','color':AppColors.dating},
    {'user':'user1234','msg':'Been watching for 2 hours 😭','color':AppColors.neonGreen},
  ];

  @override
  void dispose() { _chatCtrl.dispose(); super.dispose(); }

  void _sendMsg() {
    if (_chatCtrl.text.trim().isEmpty) return;
    setState(() { _chat.add({'user':'me','msg':_chatCtrl.text.trim(),'color':AppColors.white}); _chatCtrl.clear(); });
  }

  @override
  Widget build(BuildContext context) {
    final room = widget.room;
    return Scaffold(
      backgroundColor: room['color'] as Color,
      body: Stack(children: [
        // Background
        Container(decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [(room['color'] as Color), Colors.black]))),
        // Content
        SafeArea(child: Column(children: [
          // Top bar
          Padding(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.live, borderRadius: BorderRadius.circular(6)),
                child: const Row(children: [const Icon(Icons.circle, color: AppColors.white, size: 6), const SizedBox(width: 4), const Text('LIVE', style: TextStyle(color: AppColors.white, fontSize: 10, fontWeight: FontWeight.bold))])),
              const SizedBox(width: 8),
              Row(children: [const Icon(Icons.person, color: AppColors.white, size: 14), const SizedBox(width: 4), Text(Formatters.formatCount(room['viewers'] as int), style: const TextStyle(color: AppColors.white, fontSize: 12, ))]),
              const Spacer(),
              GestureDetector(onTap: () => Navigator.pop(context),
                child: Container(width: 32, height: 32, decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), shape: BoxShape.circle),
                  child: const Icon(Icons.close, color: AppColors.white, size: 18))),
            ])),
          // Host info
          Padding(padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(children: [
              CircleAvatar(radius: 20, backgroundColor: AppColors.grey, child: const Icon(Icons.person, color: AppColors.white, size: 22)),
              const SizedBox(width: 10),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('@${room['host']}', style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 14, )),
                Text(room['title'], style: const TextStyle(color: AppColors.grey2, fontSize: 11, )),
              ]),
              const Spacer(),
              Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(border: Border.all(color: AppColors.white, width: 1.5), borderRadius: BorderRadius.circular(20)),
                child: const Text('Follow', style: TextStyle(color: AppColors.white, fontSize: 12, fontWeight: FontWeight.bold, ))),
            ])),
          const Spacer(),
          // Chat
          SizedBox(height: 200,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemCount: _chat.length,
              itemBuilder: (_, i) {
                final msg = _chat[i];
                return Padding(padding: const EdgeInsets.only(bottom: 6),
                  child: Row(children: [
                    Text('@${msg['user']} ', style: TextStyle(color: msg['color'] as Color, fontSize: 12, fontWeight: FontWeight.bold, )),
                    Flexible(child: Text(msg['msg'], style: const TextStyle(color: AppColors.white, fontSize: 12, ))),
                  ]));
              },
            )),
          // Input
          Padding(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(children: [
              Expanded(child: Container(
                height: 42,
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), borderRadius: BorderRadius.circular(21), border: Border.all(color: AppColors.grey.withOpacity(0.4))),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(controller: _chatCtrl, style: const TextStyle(color: AppColors.white, ),
                  decoration: const InputDecoration(hintText: 'Say something...', hintStyle: TextStyle(color: AppColors.grey2, ), border: InputBorder.none)),
              )),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => setState(() { _isLiked = !_isLiked; _likes += _isLiked ? 1 : -1; }),
                child: Column(children: [
                  Icon(Icons.favorite, color: _isLiked ? AppColors.neonRed : AppColors.white, size: 28),
                  Text(Formatters.formatCount(_likes), style: const TextStyle(color: AppColors.white, fontSize: 10, )),
                ])),
              const SizedBox(width: 10),
              GestureDetector(onTap: _sendMsg,
                child: Container(width: 40, height: 40, decoration: const BoxDecoration(color: AppColors.live, shape: BoxShape.circle),
                  child: const Icon(Icons.send, color: AppColors.white, size: 18))),
            ])),
        ])),
      ]),
    );
  }
}
