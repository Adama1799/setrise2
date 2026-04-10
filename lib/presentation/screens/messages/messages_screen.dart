import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';

// ─── Mock Data ───────────────────────────────────────────────────────────────
class _Convo {
  final String id, name, username, lastMsg, time;
  final int unread;
  final bool isOnline, isVerified;
  final List<_Msg> messages;
  const _Convo({required this.id, required this.name, required this.username,
    required this.lastMsg, required this.time, this.unread = 0,
    this.isOnline = false, this.isVerified = false, this.messages = const []});
}
class _Msg {
  final String id, text, time;
  final bool isMe;
  const _Msg({required this.id, required this.text, required this.time, required this.isMe});
}

const _kConvos = [
  _Convo(id:'1', name:'Sara', username:'sara_x', lastMsg:'omg did you see that video? 😭',
    time:'2m', unread:3, isOnline:true,
    messages:[
      _Msg(id:'1', text:'Hey! 👋', isMe:false, time:'10:20'),
      _Msg(id:'2', text:'Hi! What\'s up?', isMe:true, time:'10:21'),
      _Msg(id:'3', text:'Did you see the new SetRise update?', isMe:false, time:'10:22'),
      _Msg(id:'4', text:'Yeah it\'s 🔥', isMe:true, time:'10:23'),
      _Msg(id:'5', text:'omg did you see that video? 😭', isMe:false, time:'10:25'),
    ]),
  _Convo(id:'2', name:'Ahmed', username:'ahmed_99', lastMsg:'Let\'s collab bro 🤝',
    time:'15m', unread:1, isOnline:true,
    messages:[
      _Msg(id:'1', text:'Bro your content is fire 🔥', isMe:false, time:'09:10'),
      _Msg(id:'2', text:'Thanks man 🙏', isMe:true, time:'09:12'),
      _Msg(id:'3', text:'Let\'s collab bro 🤝', isMe:false, time:'09:15'),
    ]),
  _Convo(id:'3', name:'Nora', username:'nora_m', lastMsg:'Sent you a match request 💛', time:'1h'),
  _Convo(id:'4', name:'DJ SetRise', username:'dj_setrize', lastMsg:'New track dropping tonight 🎵',
    time:'2h', isOnline:true, isVerified:true,
    messages:[_Msg(id:'1', text:'New track dropping tonight 🎵', isMe:false, time:'07:30')]),
  _Convo(id:'5', name:'TechCrunch', username:'techcrunch', lastMsg:'Thanks for the mention!',
    time:'1d', isVerified:true,
    messages:[_Msg(id:'1', text:'Thanks for the mention!', isMe:false, time:'Yesterday')]),
];

// ─── Main Screen ─────────────────────────────────────────────────────────────
class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});
  @override State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override void dispose() { _searchCtrl.dispose(); super.dispose(); }

  List<_Convo> get _filtered => _query.isEmpty ? _kConvos
    : _kConvos.where((c) =>
        c.name.toLowerCase().contains(_query.toLowerCase()) ||
        c.username.toLowerCase().contains(_query.toLowerCase())).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(child: Column(children: [
        // Top bar
        Padding(padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(children: [
            Text('Messages', style: AppTextStyles.h4.copyWith(color: AppColors.white, fontWeight: FontWeight.w900)),
            const Spacer(),
            _iconBtn(Icons.edit_outlined, () {}),
          ])),
        const SizedBox(height: 12),
        // Search
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            height: 40, decoration: BoxDecoration(color: AppColors.grey, borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(children: [
              const Icon(Icons.search, color: AppColors.grey2, size: 18),
              const SizedBox(width: 8),
              Expanded(child: TextField(
                controller: _searchCtrl,
                onChanged: (v) => setState(() => _query = v),
                style: AppTextStyles.body2.copyWith(color: AppColors.white),
                decoration: InputDecoration(
                  hintText: 'Search messages...',
                  hintStyle: AppTextStyles.body2.copyWith(color: AppColors.grey2),
                  border: InputBorder.none),
              )),
              if (_query.isNotEmpty)
                GestureDetector(onTap: () { _searchCtrl.clear(); setState(() => _query = ''); },
                  child: const Icon(Icons.close, color: AppColors.grey2, size: 16)),
            ]),
          )),
        const SizedBox(height: 8),
        // List
        Expanded(child: _filtered.isEmpty
          ? Center(child: Text('No results for "$_query"', style: AppTextStyles.body2.copyWith(color: AppColors.grey2)))
          : ListView.builder(
              itemCount: _filtered.length,
              itemBuilder: (_, i) => _ConvoTile(
                convo: _filtered[i],
                onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => _ChatScreen(convo: _filtered[i]))),
              ))),
      ])),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) => GestureDetector(onTap: onTap,
    child: Container(width: 36, height: 36,
      decoration: BoxDecoration(color: AppColors.grey, borderRadius: BorderRadius.circular(10)),
      child: Icon(icon, color: AppColors.white, size: 18)));
}

// ─── Convo Tile ───────────────────────────────────────────────────────────────
class _ConvoTile extends StatelessWidget {
  final _Convo convo; final VoidCallback onTap;
  const _ConvoTile({required this.convo, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap,
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(children: [
          Stack(children: [
            CircleAvatar(radius: 26, backgroundColor: AppColors.grey,
              child: const Icon(Icons.person, color: AppColors.white, size: 28)),
            if (convo.isOnline)
              Positioned(bottom: 0, right: 0, child: Container(width: 13, height: 13,
                decoration: BoxDecoration(color: AppColors.neonGreen, shape: BoxShape.circle,
                  border: Border.all(color: AppColors.background, width: 2)))),
          ]),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(convo.name, style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.white,
                fontWeight: convo.unread > 0 ? FontWeight.w900 : FontWeight.w500)),
              if (convo.isVerified) ...[const SizedBox(width: 4),
                const Icon(Icons.verified, color: AppColors.electricBlue, size: 14)],
              const Spacer(),
              Text(convo.time, style: AppTextStyles.labelSmall.copyWith(color: AppColors.grey2)),
            ]),
            const SizedBox(height: 4),
            Row(children: [
              Expanded(child: Text(convo.lastMsg,
                style: AppTextStyles.body2.copyWith(
                  color: convo.unread > 0 ? AppColors.white : AppColors.grey2),
                maxLines: 1, overflow: TextOverflow.ellipsis)),
              if (convo.unread > 0) ...[
                const SizedBox(width: 8),
                Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(10)),
                  child: Text('${convo.unread}', style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.black, fontWeight: FontWeight.bold))),
              ],
            ]),
          ])),
        ])));
  }
}

// ─── Chat Screen ─────────────────────────────────────────────────────────────
class _ChatScreen extends StatefulWidget {
  final _Convo convo;
  const _ChatScreen({required this.convo});
  @override State<_ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<_ChatScreen> {
  final _ctrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  late List<_Msg> _msgs;

  @override
  void initState() { super.initState(); _msgs = List.from(widget.convo.messages); }
  @override
  void dispose() { _ctrl.dispose(); _scrollCtrl.dispose(); super.dispose(); }

  void _send() {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _msgs.add(_Msg(id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text, isMe: true, time: TimeOfDay.now().format(context)));
      _ctrl.clear();
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.white, size: 20),
          onPressed: () => Navigator.pop(context)),
        title: Row(children: [
          Stack(children: [
            CircleAvatar(radius: 18, backgroundColor: AppColors.grey,
              child: const Icon(Icons.person, color: AppColors.white, size: 20)),
            if (widget.convo.isOnline)
              Positioned(bottom: 0, right: 0, child: Container(width: 11, height: 11,
                decoration: BoxDecoration(color: AppColors.neonGreen, shape: BoxShape.circle,
                  border: Border.all(color: AppColors.background, width: 2)))),
          ]),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(widget.convo.name, style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.white, fontWeight: FontWeight.bold)),
              if (widget.convo.isVerified) ...[const SizedBox(width: 4),
                const Icon(Icons.verified, color: AppColors.electricBlue, size: 14)],
            ]),
            Text(widget.convo.isOnline ? 'Online' : 'Offline',
              style: AppTextStyles.labelSmall.copyWith(
                color: widget.convo.isOnline ? AppColors.neonGreen : AppColors.grey2)),
          ]),
        ]),
        actions: [
          IconButton(icon: const Icon(Icons.videocam_outlined, color: AppColors.white, size: 22), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_horiz, color: AppColors.white, size: 22), onPressed: () {}),
        ],
      ),
      body: Column(children: [
        Divider(color: AppColors.grey.withOpacity(0.3), height: 1),
        Expanded(child: _msgs.isEmpty
          ? Center(child: Text('Say hi to ${widget.convo.name}! 👋',
              style: AppTextStyles.body1.copyWith(color: AppColors.grey2)))
          : ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _msgs.length,
              itemBuilder: (_, i) => _Bubble(msg: _msgs[i]))),
        // Input
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(color: AppColors.background,
            border: Border(top: BorderSide(color: AppColors.grey.withOpacity(0.3)))),
          child: Row(children: [
            const Icon(Icons.add_circle_outline, color: AppColors.grey2, size: 26),
            const SizedBox(width: 10),
            Expanded(child: Container(
              constraints: const BoxConstraints(maxHeight: 120),
              decoration: BoxDecoration(color: AppColors.grey, borderRadius: BorderRadius.circular(22)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              child: TextField(controller: _ctrl, maxLines: null,
                style: AppTextStyles.body2.copyWith(color: AppColors.white),
                decoration: InputDecoration(hintText: 'Message...',
                  hintStyle: AppTextStyles.body2.copyWith(color: AppColors.grey2),
                  border: InputBorder.none)),
            )),
            const SizedBox(width: 10),
            GestureDetector(onTap: _send,
              child: Container(width: 40, height: 40,
                decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
                child: const Icon(Icons.send, color: AppColors.black, size: 18))),
          ]),
        ),
        SizedBox(height: MediaQuery.of(context).padding.bottom),
      ]),
    );
  }
}

class _Bubble extends StatelessWidget {
  final _Msg msg;
  const _Bubble({required this.msg});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: msg.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!msg.isMe) ...[
            const CircleAvatar(radius: 14, backgroundColor: AppColors.grey,
              child: Icon(Icons.person, color: AppColors.white, size: 16)),
            const SizedBox(width: 8),
          ],
          Column(
            crossAxisAlignment: msg.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: msg.isMe ? AppColors.white : AppColors.grey,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18), topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(msg.isMe ? 18 : 4),
                    bottomRight: Radius.circular(msg.isMe ? 4 : 18))),
                child: Text(msg.text, style: AppTextStyles.body2.copyWith(
                  color: msg.isMe ? AppColors.black : AppColors.white))),
              const SizedBox(height: 3),
              Text(msg.time, style: AppTextStyles.labelSmall.copyWith(color: AppColors.grey2)),
            ]),
        ]));
  }
}
