import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

/// A single notification item loaded from Firestore.
class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime createdAt;
  final String category; // 'Booking' | 'Promo' | 'Info'
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.category,
    required this.isRead,
  });

  factory NotificationItem.fromFirestore(
      Map<String, dynamic> data, String docId) {
    return NotificationItem(
      id: docId,
      title: data['title'] as String? ?? '',
      message: data['message'] as String? ?? '',
      createdAt:
          (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      category: data['category'] as String? ?? 'Info',
      isRead: data['isRead'] as bool? ?? false,
    );
  }

  /// Relative time label (e.g. "5 menit lalu").
  String get timeLabel {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    return '${diff.inDays} hari lalu';
  }
}

class NotifikasiScreen extends StatefulWidget {
  const NotifikasiScreen({super.key});

  @override
  State<NotifikasiScreen> createState() => _NotifikasiScreenState();
}

class _NotifikasiScreenState extends State<NotifikasiScreen> {
  String _selectedFilter = 'Semua';

  // ---------------------------------------------------------------------------
  // Firestore helpers
  // ---------------------------------------------------------------------------

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  /// Stream of this user's notifications, newest first.
  Stream<List<NotificationItem>> _stream() {
    final uid = _uid;
    if (uid == null) return const Stream.empty();

    return FirebaseFirestore.instance
        .collection('notifications')
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => NotificationItem.fromFirestore(d.data(), d.id))
            .toList());
  }

  Future<void> _markRead(String docId) async {
    await FirebaseFirestore.instance
        .collection('notifications')
        .doc(docId)
        .update({'isRead': true});
  }

  Future<void> _markAllRead(List<NotificationItem> items) async {
    final batch = FirebaseFirestore.instance.batch();
    for (final item in items.where((i) => !i.isRead)) {
      batch.update(
        FirebaseFirestore.instance.collection('notifications').doc(item.id),
        {'isRead': true},
      );
    }
    await batch.commit();
  }

  Future<void> _delete(String docId) async {
    await FirebaseFirestore.instance
        .collection('notifications')
        .doc(docId)
        .delete();
  }

  // ---------------------------------------------------------------------------

  void _handleBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Booking':
        return Icons.build_circle_outlined;
      case 'Promo':
        return Icons.local_offer_outlined;
      case 'Info':
        return Icons.info_outline;
      default:
        return Icons.notifications_none;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Booking':
        return const Color(0xFFFF3B45);
      case 'Promo':
        return const Color(0xFFEC4899);
      case 'Info':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF64748B);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) _handleBack();
      },
      child: Scaffold(
        backgroundColor: AppColors.softBg,
        appBar: AppBar(
          backgroundColor: AppColors.cardBg,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          title: Text(
            'Notifikasi',
            style: GoogleFonts.poppins(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: _handleBack,
          ),
        ),
        body: StreamBuilder<List<NotificationItem>>(
          stream: _stream(),
          builder: (context, snapshot) {
            final allItems = snapshot.data ?? [];
            final unreadCount = allItems.where((i) => !i.isRead).length;
            final filtered = _selectedFilter == 'Semua'
                ? allItems
                : allItems
                    .where((i) => i.category == _selectedFilter)
                    .toList();

            return Column(
              children: [
                // Mark-all-read action bar (shown only when there are unreads)
                if (unreadCount > 0)
                  Container(
                    color: AppColors.cardBg,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => _markAllRead(allItems),
                          child: Text(
                            'Tandai Semua Dibaca ($unreadCount)',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accentRed,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Category Filter Chips
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  color: Colors.white,
                  child: Row(
                    children:
                        ['Semua', 'Booking', 'Promo', 'Info'].map((filter) {
                      final isSelected = _selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(filter),
                          selected: isSelected,
                          selectedColor: const Color(0xFFFF3B45),
                          labelStyle: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF64748B),
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedFilter = filter);
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // Notification List
                Expanded(
                  child: snapshot.connectionState == ConnectionState.waiting
                      ? const Center(
                          child: CircularProgressIndicator(
                              color: AppColors.accentRed),
                        )
                      : snapshot.hasError
                          ? Center(
                              child: Text(
                                'Gagal memuat notifikasi.',
                                style: GoogleFonts.poppins(
                                    color: AppColors.textMuted),
                              ),
                            )
                          : filtered.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.notifications_off_outlined,
                                          size: 64, color: Colors.grey[400]),
                                      const SizedBox(height: 12),
                                      Text(
                                        'Belum Ada Notifikasi',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      Text(
                                        'Notifikasi terbaru Anda akan muncul di sini',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.separated(
                                  padding: const EdgeInsets.all(20),
                                  itemCount: filtered.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    final item = filtered[index];
                                    final categoryColor =
                                        _getCategoryColor(item.category);

                                    return Dismissible(
                                      key: Key(item.id),
                                      direction: DismissDirection.endToStart,
                                      background: Container(
                                        alignment: Alignment.centerRight,
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade400,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: const Icon(
                                            Icons.delete_outline,
                                            color: Colors.white,
                                            size: 28),
                                      ),
                                      onDismissed: (_) {
                                        _delete(item.id);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text('Notifikasi dihapus',
                                                style: GoogleFonts.poppins()),
                                          ),
                                        );
                                      },
                                      child: InkWell(
                                        onTap: () {
                                          _markRead(item.id);
                                          if (item.category == 'Booking') {
                                            context.go('/status');
                                          } else if (item.category ==
                                              'Promo') {
                                            context.go('/akun/promo');
                                          }
                                        },
                                        borderRadius:
                                            BorderRadius.circular(16),
                                        child: Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: AppColors.cardBg,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            border: Border.all(
                                              color: item.isRead
                                                  ? AppColors.outline
                                                  : const Color(0xFFFF3B45)
                                                      .withValues(alpha: 0.3),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withValues(alpha: 0.03),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: categoryColor
                                                      .withValues(alpha: 0.12),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  _getCategoryIcon(
                                                      item.category),
                                                  color: categoryColor,
                                                  size: 22,
                                                ),
                                              ),
                                              const SizedBox(width: 14),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            item.title,
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize: 14,
                                                              fontWeight: item
                                                                      .isRead
                                                                  ? FontWeight
                                                                      .w600
                                                                  : FontWeight
                                                                      .bold,
                                                              color: AppColors
                                                                  .textPrimary,
                                                            ),
                                                          ),
                                                        ),
                                                        if (!item.isRead)
                                                          Container(
                                                            width: 8,
                                                            height: 8,
                                                            decoration:
                                                                const BoxDecoration(
                                                              color: Color(
                                                                  0xFFFF3B45),
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      item.message,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        color: const Color(
                                                            0xFF64748B),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      item.timeLabel,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 11,
                                                        color: Colors.grey[500],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
