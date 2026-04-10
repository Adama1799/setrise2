import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final _ctrl = TextEditingController();
  final _focus = FocusNode();
  String _query = '';

  static const _users = [
    {'name':'DJ SetRise','username':'dj_setrize','followers':'48.2K','isVerified':true},
    {'name':'NASA','username':'nasa','followers':'5.4M','isVerified':true},
    {'name':'Sara','username':'sara_x','followers':'12.1K','isVerified':false},
    {'name':'TechCrunch','username':'techcrunch','followers':'310K','isVerified':true},
    {'name':'Ahmed','username':'ahmed_99','followers':'8.4K','isVerified':false},
  ];
  static const _tags = ['#SetRise','#TechTalk','#AlgeriaVibes','#NightLife',
    '#Gaming2025','#ArabicBeats','#FitnessGoals','#LiveNow','#Fashion','#ArtByUs'];

  List get _filteredUsers => _query.isEmpty ? _users
    : _users.where((u) =>
        (u['name'] as String).toLowerCase().contains(_query.toLowerCase()) ||
        (u['username'] as String).toLowerCase().contains(_query.toLowerCase())).toList();

  @override void initState() {
    super.initState();
    _tabCtrl = TabController(length: 4, vsync: this);
    _focus.addListener(() => setState(() {}));
  }
  @override void dispose() { _tabCtrl.dispose(); _ctrl.dispose(); _focus.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final searching = _query.isNotEmpty || _focus.hasFocus;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(child: Column(children: [
        // Search bar
        Padding(padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(children: [
            Expanded(child: Container(height: 42,
              decoration: BoxDecoration(color: AppColors.grey, borderRadius: BorderRadius.circular(21)),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(children: [
                const Icon(Icons.search, color: AppColors.grey2, size: 20),
                const SizedBox(width: 8),
                Expanded(child: TextField(controller: _ctrl, focusNode: _focus,
                  onChanged: (v) => setState(() => _query = v),
                  style: AppTextStyles.body2.copyWith(color: AppColors.white),
                  decoration: InputDecoration(hintText: 'Search SetRise...',
                    hintStyle: AppTextStyles.body2.copyWith(color: AppColors.grey2),
                    border: InputBorder.none))),
                if (_query.isNotEmpty)
                  GestureDetector(onTap: () { _ctrl.clear(); setState(() => _query = ''); },
                    child: const Icon(Icons.close, color: AppColors.grey2, size: 16)),
              ]))),
            if (searching) ...[
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () { _ctrl.clear(); _focus.unfocus(); setState(() => _query = ''); },
                child: Text('Cancel', style: AppTextStyles.body2.copyWith(color: AppColors.white))),
            ],
          ])),
        const SizedBox(height: 8),
        if (!searching) ...[
          TabBar(controller: _tabCtrl,
            indicatorColor: AppColors.white, indicatorWeight: 2,
            labelColor: AppColors.white, unselectedLabelColor: AppColors.grey2,
            isScrollable: true,
            labelStyle: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.w900),
            unselectedLabelStyle: AppTextStyles.labelLarge,
            tabs: const [Tab(text:'For You'), Tab(text:'People'), Tab(text:'Tags'), Tab(text:'Live')]),
          Expanded(child: TabBarView(controller: _tabCtrl, children: [
            _ExploreGrid(),
            _PeopleList(users: _users),
            _TagsList(tags: _tags),
            _ExploreGrid(liveOnly: true),
          ])),
        ] else ...[
          Expanded(child: _filteredUsers.isEmpty
            ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text('🔍', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 12),
                Text('No results for "$_query"', style: AppTextStyles.body1.copyWith(color: AppColors.white)),
              ]))
            : _PeopleList(users: _filteredUsers)),
        ],
      ])),
    );
  }
}

class _ExploreGrid extends StatelessWidget {
  final bool liveOnly;
  const _ExploreGrid({this.liveOnly = false});
  static const _colors = [
    Color(0xFF1A0A2E), Color(0xFF0A1628), Color(0xFF2E1A0A),
    Color(0xFF0A1A0A), Color(0xFF1A000A), Color(0xFF0A2E2E),
    Color(0xFF2E0A0A), Color(0xFF0A0A2E), Color(0xFF1A1A00),
  ];
  @override
  Widget build(BuildContext context) => GridView.builder(
    padding: const EdgeInsets.all(12),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3, crossAxisSpacing: 3, mainAxisSpacing: 3),
    itemCount: 9,
    itemBuilder: (_, i) => Container(
      decoration: BoxDecoration(color: _colors[i % _colors.length], borderRadius: BorderRadius.circular(4)),
      child: Stack(children: [
        Center(child: Icon(Icons.play_circle_outline, color: AppColors.white.withOpacity(0.2), size: 36)),
        if (liveOnly || i % 3 == 0)
          Positioned(top: 6, left: 6, child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(color: AppColors.live, borderRadius: BorderRadius.circular(4)),
            child: const Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)))),
      ])));
}

class _PeopleList extends StatelessWidget {
  final List users;
  const _PeopleList({required this.users});
  @override
  Widget build(BuildContext context) => ListView.builder(
    padding: const EdgeInsets.symmetric(vertical: 8),
    itemCount: users.length,
    itemBuilder: (_, i) {
      final u = users[i];
      return Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(children: [
          CircleAvatar(radius: 24, backgroundColor: AppColors.grey,
            child: const Icon(Icons.person, color: AppColors.white, size: 26)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(u['name'], style: AppTextStyles.labelLarge.copyWith(color: AppColors.white, fontWeight: FontWeight.bold)),
              if (u['isVerified'] as bool) ...[const SizedBox(width: 4),
                const Icon(Icons.verified, color: AppColors.electricBlue, size: 14)],
            ]),
            Text('@${u['username']} · ${u['followers']} followers',
              style: AppTextStyles.labelSmall.copyWith(color: AppColors.grey2)),
          ])),
          Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(border: Border.all(color: AppColors.white, width: 1.5),
              borderRadius: BorderRadius.circular(20)),
            child: Text('Follow', style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.white, fontWeight: FontWeight.bold))),
        ]));
    });
}

class _TagsList extends StatelessWidget {
  final List<String> tags;
  const _TagsList({required this.tags});
  @override
  Widget build(BuildContext context) => ListView.builder(
    padding: const EdgeInsets.symmetric(vertical: 8),
    itemCount: tags.length,
    itemBuilder: (_, i) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.grey.withOpacity(0.3)))),
      child: Row(children: [
        Container(width: 42, height: 42,
          decoration: BoxDecoration(color: AppColors.grey, borderRadius: BorderRadius.circular(10)),
          child: Center(child: Text('#', style: TextStyle(color: AppColors.white.withOpacity(0.5),
            fontSize: 22, fontWeight: FontWeight.bold)))),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(tags[i], style: AppTextStyles.labelLarge.copyWith(color: AppColors.white, fontWeight: FontWeight.bold)),
          Text('${(i + 1) * 12}K posts', style: AppTextStyles.labelSmall.copyWith(color: AppColors.grey2)),
        ]),
        const Spacer(),
        const Icon(Icons.chevron_right, color: AppColors.grey2, size: 20),
      ])));
}
