import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

enum _AlertType { like, comment, follow, mention, repost, live, match }

class _Alert {
  final String id, username, message, time;
  final _AlertType type;
  final bool isRead;
  const _Alert({required this.id, required this.username, required this.message,
    required this.time, required this.type, this.isRead = false});
}

const _kAlerts = [
  _Alert(id:'1', username:'sara_x', message:'liked your video', time:'2m', type:_AlertType.like),
  _Alert(id:'2', username:'ahmed_99', message:'started following you', time:'5m', type:_AlertType.follow),
  _Alert(id:'3', username:'nasa', message:'commented: "Amazing! 🔥"', time:'12m', type:_AlertType.comment, isRead:true),
  _Alert(id:'4', username:'nora_m', message:'reposted your Rize', time:'1h', type:_AlertType.repost, isRead:true),
  _Alert(id:'5', username:'dj_setrize', message:'mentioned you in a post', time:'2h', type:_AlertType.mention, isRead:true),
  _Alert(id:'6', username:'fitcoach_l', message:'went Live — Fitness Session 🏋️', time:'3h', type:_AlertType.live, isRead:true),
  _Alert(id:'7', username:'sara_x', message:'It\'s a Match! 💛', time:'1d', type:_AlertType.match, isRead:true),
  _Alert(id:'8', username:'elonmusk', message:'liked your Rize', time:'2d', type:_AlertType.like, isRead:true),
];

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});
  @override State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  @override void initState() { super.initState(); _tabCtrl = TabController(length: 2, vsync: this); }
  @override void dispose() { _tabCtrl.dispose(); super.dispose(); }

  List<_Alert> get _unread => _kAlerts.where((a) => !a.isRead).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(child: Column(children: [
        Padding(padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(children: [
            Text('Alerts', style: AppTextStyles.h4.copyWith(color: AppColors.white, fontWeight: FontWeight.w900)),
            const Spacer(),
            Text('Mark all read', style: AppTextStyles.labelSmall.copyWith(color: AppColors.grey2)),
          ])),
        TabBar(controller: _tabCtrl,
          indicatorColor: AppColors.white, indicatorWeight: 2,
          labelColor: AppColors.white, unselectedLabelColor: AppColors.grey2,
          labelStyle: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.w900),
          unselectedLabelStyle: AppTextStyles.labelLarge,
          tabs: [
            Tab(text: 'All (${_kAlerts.length})'),
            Tab(text: _unread.isEmpty ? 'Unread' : 'Unread (${_unread.length})'),
          ]),
        Expanded(child: TabBarView(controller: _tabCtrl, children: [
          _AlertList(alerts: _kAlerts),
          _unread.isEmpty
            ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.notifications_none, color: AppColors.grey2, size: 48),
                const SizedBox(height: 12),
                Text('All caught up! 🎉', style: AppTextStyles.h5.copyWith(color: AppColors.white)),
                const SizedBox(height: 4),
                Text('No new notifications', style: AppTextStyles.body2.copyWith(color: AppColors.grey2)),
              ]))
            : _AlertList(alerts: _unread),
        ])),
      ])),
    );
  }
}

class _AlertList extends StatelessWidget {
  final List<_Alert> alerts;
  const _AlertList({required this.alerts});
  @override
  Widget build(BuildContext context) => ListView.builder(
    padding: const EdgeInsets.symmetric(vertical: 8),
    itemCount: alerts.length,
    itemBuilder: (_, i) => _AlertTile(alert: alerts[i]));
}

class _AlertTile extends StatelessWidget {
  final _Alert alert;
  const _AlertTile({required this.alert});

  IconData get _icon => switch (alert.type) {
    _AlertType.like    => Icons.favorite,
    _AlertType.comment => Icons.chat_bubble,
    _AlertType.follow  => Icons.person_add,
    _AlertType.mention => Icons.alternate_email,
    _AlertType.repost  => Icons.repeat,
    _AlertType.live    => Icons.live_tv,
    _AlertType.match   => Icons.favorite,
  };

  Color get _color => switch (alert.type) {
    _AlertType.like    => AppColors.neonRed,
    _AlertType.comment => AppColors.white,
    _AlertType.follow  => AppColors.electricBlue,
    _AlertType.mention => AppColors.cyan,
    _AlertType.repost  => AppColors.neonGreen,
    _AlertType.live    => AppColors.live,
    _AlertType.match   => AppColors.dating,
  };

  @override
  Widget build(BuildContext context) => Container(
    color: alert.isRead ? Colors.transparent : AppColors.white.withOpacity(0.03),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Stack(children: [
        CircleAvatar(radius: 24, backgroundColor: AppColors.grey,
          child: const Icon(Icons.person, color: AppColors.white, size: 26)),
        Positioned(bottom: 0, right: 0, child: Container(width: 20, height: 20,
          decoration: BoxDecoration(color: _color, shape: BoxShape.circle,
            border: Border.all(color: AppColors.background, width: 2)),
          child: Icon(_icon, color: AppColors.white, size: 10))),
      ]),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        RichText(text: TextSpan(
          style: AppTextStyles.body2.copyWith(color: AppColors.white, height: 1.4),
          children: [
            TextSpan(text: '@${alert.username} ', style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: alert.message, style: TextStyle(color: AppColors.grey2)),
          ])),
        const SizedBox(height: 4),
        Text(alert.time, style: AppTextStyles.labelSmall.copyWith(color: AppColors.grey2)),
      ])),
      if (!alert.isRead)
        Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle)),
    ]));
}
