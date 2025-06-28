import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/storage_service.dart';
import 'views/modern_quote_form_view.dart';
import 'viewmodels/quote_viewmodel.dart';
import 'utils/app_theme.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage service
  await StorageService.init();

  runApp(const ProviderScope(child: ShowboardQuotingApp()));
}

class ShowboardQuotingApp extends ConsumerWidget {
  const ShowboardQuotingApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Showboard Quoting App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode == AppThemeMode.light
          ? ThemeMode.light
          : themeMode == AppThemeMode.dark
          ? ThemeMode.dark
          : ThemeMode.system,
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _floatingController;
  late AnimationController _scaleController;
  late Animation<double> _floatingAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 50),
      vsync: this,
    );

    _floatingAnimation = Tween<double>(begin: 0.0, end: 4.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeOutBack),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      _floatingController.forward().then((_) {
        _floatingController.reverse();
      });
      setState(() => _selectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screens = [const ModernQuoteFormView(), const QuoteHistoryView()];

    return Scaffold(
      body: screens[_selectedIndex],
      floatingActionButton: null,
      bottomNavigationBar: _buildPremiumFloatingNav(isDark),
    );
  }

  Widget _buildPremiumFloatingNav(bool isDark) {
    return Container(
      margin: const EdgeInsets.all(20),
      height: 80,
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardBackground : Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isDark
              ? AppTheme.lightGrey.withValues(alpha: 0.3)
              : Colors.grey.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildFloatingNavItem(
            icon: Icons.camera_alt,
            label: 'New Quote',
            index: 0,
            isSelected: _selectedIndex == 0,
            isDark: isDark,
          ),
          _buildFloatingNavItem(
            icon: Icons.folder_open,
            label: 'History',
            index: 1,
            isSelected: _selectedIndex == 1,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
    required bool isDark,
  }) {
    return AnimatedBuilder(
      animation: Listenable.merge([_floatingAnimation, _scaleAnimation]),
      builder: (context, child) {
        return GestureDetector(
          onTapDown: (_) => _scaleController.forward(),
          onTapUp: (_) {
            _scaleController.reverse();
            _onItemTapped(index);
          },
          onTapCancel: () => _scaleController.reverse(),
          child: Transform.scale(
            scale: isSelected && _scaleController.isAnimating
                ? _scaleAnimation.value
                : 1.0,
            child: Transform.translate(
              offset: isSelected
                  ? Offset(0, -_floatingAnimation.value)
                  : Offset.zero,
              child: SizedBox(
                width: 120,
                height: 60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryRed
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Icon(
                        icon,
                        color: isSelected
                            ? Colors.white
                            : isDark
                            ? AppTheme.accentSilver.withValues(alpha: 0.8)
                            : AppTheme.lightTextSecondary,
                        size: isSelected ? 20 : 22,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      label,
                      style: TextStyle(
                        color: isSelected
                            ? AppTheme.primaryRed
                            : isDark
                            ? AppTheme.accentSilver.withValues(alpha: 0.8)
                            : AppTheme.lightTextSecondary,
                        fontSize: isSelected ? 11 : 10,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class QuoteHistoryView extends ConsumerWidget {
  const QuoteHistoryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quotes = ref.watch(quotesProvider);
    final quoteOperations = ref.read(quoteOperationsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: _buildPremiumAppBar(context, ref, isDark),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [AppTheme.primaryBlack, AppTheme.cardBackground]
                : [AppTheme.lightBackground, AppTheme.lightCardBackground],
          ),
        ),
        child: quotes.isEmpty
            ? _buildEmptyState(isDark)
            : ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: quotes.length,
                itemBuilder: (context, index) {
                  final quote = quotes[index];
                  return _buildPremiumQuoteCard(
                    context,
                    quote,
                    quoteOperations,
                    ref,
                    isDark,
                  );
                },
              ),
      ),
    );
  }

  PreferredSizeWidget _buildPremiumAppBar(
    BuildContext context,
    WidgetRef ref,
    bool isDark,
  ) {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.redGradient,
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryRed.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.history, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          const Text(
            'Quote History',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              ref.read(quotesProvider.notifier).refreshQuotes();
            },
          ),
        ),
      ],
      elevation: 0,
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryRed.withValues(alpha: 0.1),
                  AppTheme.primaryRed.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.assignment_outlined,
              size: 64,
              color: AppTheme.primaryRed,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No quotes yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : AppTheme.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first quote to see it here',
            style: TextStyle(
              fontSize: 16,
              color: isDark
                  ? AppTheme.accentSilver
                  : AppTheme.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 32),
          Container(
            decoration: BoxDecoration(
              gradient: AppTheme.redGradient,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryRed.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                // This would switch to the form tab
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Create New Quote',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumQuoteCard(
    BuildContext context,
    quote,
    quoteOperations,
    WidgetRef ref,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppTheme.cardBackground, AppTheme.inputBackground]
              : [AppTheme.lightCardBackground, Colors.white],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryRed.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: AppTheme.redGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.description,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        quote.customerName.isNotEmpty
                            ? quote.customerName
                            : 'Unnamed Quote',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: isDark
                              ? Colors.white
                              : AppTheme.lightTextPrimary,
                        ),
                      ),
                      if (quote.carEventName.isNotEmpty)
                        Text(
                          'Event: ${quote.carEventName}',
                          style: TextStyle(
                            color: AppTheme.primaryRed,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
                _buildPremiumPopupMenu(
                  context,
                  quote,
                  quoteOperations,
                  ref,
                  isDark,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark
                    ? AppTheme.primaryBlack.withValues(alpha: .3)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 16,
                    color: isDark
                        ? AppTheme.accentSilver
                        : AppTheme.lightTextSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Created: ${quote.createdAt.toString().substring(0, 16)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppTheme.accentSilver
                          : AppTheme.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumPopupMenu(
    BuildContext context,
    quote,
    quoteOperations,
    WidgetRef ref,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppTheme.inputBackground.withValues(alpha: 0.5)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: PopupMenuButton(
        icon: Icon(
          Icons.more_vert,
          color: isDark ? AppTheme.accentSilver : AppTheme.lightTextSecondary,
        ),
        color: isDark ? AppTheme.cardBackground : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: AppTheme.primaryRed.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        itemBuilder: (context) => [
          _buildPopupMenuItem(
            icon: Icons.edit,
            text: 'Edit',
            value: 'edit',
            isDark: isDark,
          ),
          _buildPopupMenuItem(
            icon: Icons.picture_as_pdf,
            text: 'Generate PDF',
            value: 'pdf',
            isDark: isDark,
          ),
          _buildPopupMenuItem(
            icon: Icons.share,
            text: 'Share',
            value: 'share',
            isDark: isDark,
          ),
          _buildPopupMenuItem(
            icon: Icons.delete,
            text: 'Delete',
            value: 'delete',
            isDark: isDark,
            isDestructive: true,
          ),
        ],
        onSelected: (value) async {
          switch (value) {
            case 'edit':
              quoteOperations.loadQuote(quote);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ModernQuoteFormView(),
                ),
              );
              break;
            case 'pdf':
              try {
                await ref.read(quoteOperationsProvider).generatePdf();
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
              break;
            case 'share':
              try {
                await ref.read(quoteOperationsProvider).sharePdf();
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
              break;
            case 'delete':
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Quote'),
                  content: const Text(
                    'Are you sure you want to delete this quote?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
              if (confirmed == true) {
                try {
                  await ref.read(quotesProvider.notifier).deleteQuote(quote.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Quote deleted')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error deleting quote: $e')),
                    );
                  }
                }
              }
              break;
          }
        },
      ),
    );
  }

  PopupMenuItem _buildPopupMenuItem({
    required IconData icon,
    required String text,
    required String value,
    required bool isDark,
    bool isDestructive = false,
  }) {
    final color = isDestructive
        ? Colors.red
        : isDark
        ? AppTheme.accentSilver
        : AppTheme.lightTextPrimary;

    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(color: color, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
