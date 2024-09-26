import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/config/theme_provider.dart';
import 'package:todo_app/screens/completed_page.dart';
import 'package:todo_app/screens/add_or_edit_todo_page.dart';
import 'package:todo_app/screens/home.dart';
import 'package:todo_app/services/auth_service.dart';

class NavigationPage extends StatefulWidget {
  static const String path = "home";

  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late String greeting;
  late bool isDark;
  bool loading = false;
  int tab = 0;

  void _toggleThemeMode(ThemeProvider theme) {
    if (theme.themeMode == ThemeMode.dark) {
      theme.setThemeMode(ThemeMode.light);
      setState(() {
        isDark = false;
      });
    } else {
      theme.setThemeMode(ThemeMode.dark);
      setState(() {
        isDark = true;
      });
    }
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good evening';
    }
  }

  @override
  void initState() {
    getThemeData();
    greeting = getGreeting();
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    _tabController.addListener(() {
      setState(() {
        tab = _tabController.index;
      });
    });
  }

  void getThemeData() {
    ThemeMode mode = context.read<ThemeProvider>().themeMode;
    if (mode == ThemeMode.dark) {
      setState(() {
        isDark = true;
      });
    } else {
      setState(() {
        isDark = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var auth = context.read<AuthProvider>();
    var themeProvider = context.read<ThemeProvider>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          tab == 0 ? "$greeting, ${auth.user!.username}" : "Completed Task",
        ),
        actions: [
          tab == 0
              ? Switch(
                  value: isDark,
                  onChanged: (v) {
                    _toggleThemeMode(themeProvider);
                  },
                )
              : IconButton(
                  onPressed: () async{
                    setState(() {
                      loading = true;
                    });
                    await auth.logoutUser(context);
                    setState(() {
                      loading = false;
                    });
                  },
                  icon:loading ? const CircularProgressIndicator() : const Icon(Icons.logout),
                ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          Home(),
          CompletedPage(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (c) => const AddOrEditTodoPage(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
        ),
        child: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.list),
              text: "All",
            ),
            Tab(
              icon: Icon(Icons.check),
              text: "Completed",
            )
          ],
        ),
      ),
    );
  }
}
