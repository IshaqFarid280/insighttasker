import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:insighttasker/app_localizations.dart';
import 'package:insighttasker/languageProvider.dart';
import 'package:insighttasker/locale_constants.dart';
import 'package:insighttasker/todomodels/todomodle.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());
  await Hive.openBox<Todo>('todos');

  runApp(
    Builder(builder: (context) {
      final mq = MediaQuery.of(context);
      return ChangeNotifierProvider(
        create: (context) => LanguageProvider(),
        child: TodoApp(),
      );
    }),
  );
}

class TodoApp extends StatefulWidget {
  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _initializeLocale();
  }

  void _initializeLocale() async {
    Locale locale = await LocaleConstants.getLocale();
    setState(() {
      _locale = locale;
    });
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
      return MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale?.languageCode == locale?.languageCode &&
                supportedLocale?.countryCode == locale?.countryCode) {
              return supportedLocale;
            }
          }
          return supportedLocales?.first;
        },
        locale: _locale,
        supportedLocales: const [
          Locale('ar', ''),
          Locale('en', ''),
          Locale('es', ''),
          Locale('ru', ''),
        ],
        // locale: Locale('en'), // Set the default locale
        home: HomeScreen(),
      );
    });
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _todosBox = Hive.box<Todo>('todos');
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  String _currentLanguage = 'en';

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString('language_code') ?? 'en';

    await _loadDemoData();
    await _updateDemoData();
  }

  Future<void> _loadDemoData() async {
    if (_todosBox.isEmpty) {
      _todosBox.add(Todo(title: 'Task 1', description: 'This is task 1'));
      _todosBox.add(Todo(title: 'Task 2', description: 'This is task 2'));
      _todosBox.add(Todo(title: 'Task 3', description: 'This is task 3'));
    } else {
      await _updateDemoData();
    }
  }

  Future<void> _updateDemoData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('language_code', _currentLanguage);

    switch (_currentLanguage) {
      case 'es':
        _todosBox.putAt(
            0, Todo(title: 'Tarea 1', description: 'Esta es la tarea 1'));
        _todosBox.putAt(
            1, Todo(title: 'Tarea 2', description: 'Esta es la tarea 2'));
        _todosBox.putAt(
            2, Todo(title: 'Tarea 3', description: 'Esta es la tarea 3'));
        break;
      case 'ar':
        _todosBox.putAt(
            0, Todo(title: 'مهمة 1', description: 'هذه هي المهمة 1'));
        _todosBox.putAt(
            1, Todo(title: 'مهمة 2', description: 'هذه هي المهمة 2'));
        _todosBox.putAt(
            2, Todo(title: 'مهمة 3', description: 'هذه هي المهمة 3'));
        break;
      case 'ru':
        _todosBox.putAt(
            0, Todo(title: 'Задача 1', description: 'Это задача 1'));
        _todosBox.putAt(
            1, Todo(title: 'Задача 2', description: 'Это задача 2'));
        _todosBox.putAt(
            2, Todo(title: 'Задача 3', description: 'Это задача 3'));
        break;
      default:
        _todosBox.putAt(
            0, Todo(title: 'Task 1', description: 'This is task 1'));
        _todosBox.putAt(
            1, Todo(title: 'Task 2', description: 'This is task 2'));
        _todosBox.putAt(
            2, Todo(title: 'Task 3', description: 'This is task 3'));
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Language changed to $_currentLanguage'),
        duration: Duration(seconds: 2),
      ),
    );

    setState(() {}); // Manually trigger a rebuild when language changes
  }

  Future<void> _onRefresh() async {
    await _loadDemoData();
    print('rebuild in refresh');
    await _updateDemoData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);

    print('rebuild in build locale=${languageProvider.locale}');
    return Scaffold(
      drawer: Drawer(
          backgroundColor: Colors.black38,
          child: ListView(
            children: [
              DrawerHeader(
                child: SvgPicture.asset('assets/svg/aboutus.svg',
                    height: 100, width: 100),
              ),
              listTileDrawer(
                assetsvg: 'assets/svg/setting.svg',
                title: 'Setting',
              ),
              listTileDrawer(
                assetsvg: 'assets/svg/facebooklogo.svg',
                title: 'Facebook',
              ),
              listTileDrawer(
                assetsvg: 'assets/svg/sync.svg',
                title: 'Sync',
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.16,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 38.0, right: 38),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/svg/premiumlogo.svg',
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Get Premium',
                              style: TextStyle(
                                fontFamily: "Poppins",
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          )),
      appBar: AppBar(
        backgroundColor: Colors.indigo[200],
        title: Text(languageProvider.translate('app_title')),
        actions: [
          DropdownButton<String>(
            value: _currentLanguage,
            items: const [
              DropdownMenuItem(
                value: 'en',
                child: Text('English'),
              ),
              DropdownMenuItem(
                value: 'es',
                child: Text('Spanish'),
              ),
              DropdownMenuItem(
                value: 'ar',
                child: Text('Arabic'),
              ),
              DropdownMenuItem(
                value: 'ru',
                child: Text('Russian'),
              ),
            ],
            onChanged: (value) async {
              languageProvider.changeLanguage(value!);
              setState(() {
                _currentLanguage = value!;
              });
              await _onRefresh();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _onRefresh,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.height * 0.1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color(0xff5694F2),
                            ),
                            child: Center(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white38,
                                      child: Icon(
                                        Icons.cyclone,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'On Going',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '24 Tasks',
                                        style: TextStyle(
                                            color: Colors.black38,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w200),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.height * 0.1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color(0xffFEC347),
                            ),
                            child: Center(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white38,
                                      child: Icon(
                                        Icons.cyclone,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Process',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '12 Tasks',
                                        style: TextStyle(
                                            color: Colors.black38,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w200),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: MediaQuery.of(context).size.height * 0.1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color(0xffF26E56),
                            ),
                            child: Center(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white38,
                                      child: Icon(
                                        Icons.cyclone,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Completed',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '24 Tasks',
                                        style: TextStyle(
                                            color: Colors.black38,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w200),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.height * 0.1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color(0xff53C2C5),
                            ),
                            child: Center(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.cyclone,
                                    color: Colors.white,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Canceled',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '12 Tasks',
                                        style: TextStyle(
                                            color: Colors.black38,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w200),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final todo = _todosBox.getAt(index);
                  return InkWell(
                    onTap: () {},
                    hoverColor: Colors.blue,
                    splashColor: Colors.yellow,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, left: 8.0, right: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.indigo[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(
                            todo!.title,
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Row(
                            children: [
                              Icon(Icons.check_circle),
                              Text('${todo.description}'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                childCount: _todosBox.length,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(languageProvider.translate('add_todo')),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: languageProvider.translate('title'),
                      ),
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: languageProvider.translate('description'),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(languageProvider.translate('cancel')),
                  ),
                  TextButton(
                    onPressed: () async {
                      _todosBox.add(Todo(
                        title: _titleController.text,
                        description: _descriptionController.text,
                      ));
                      Navigator.pop(context);
                      await _onRefresh();
                    },
                    child: Text(languageProvider.translate('add')),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class listTileDrawer extends StatelessWidget {
  final String? title;
  final String assetsvg;
  listTileDrawer({this.title, required this.assetsvg});
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: InkWell(
        hoverColor: Colors.yellow[100],
        splashColor: Colors.purple[100],
        focusColor: Colors.tealAccent[100],
        child: ListTile(
          leading: Padding(
            padding: const EdgeInsets.all(2.0),
            child: SvgPicture.asset(
              assetsvg,
              width: 15,
              height: 18,
              color: Colors.white,
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              title!,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: "Poppins",
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
