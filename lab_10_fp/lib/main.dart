import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'registration_bloc.dart';
import 'profile_bloc.dart';
import 'rest_client.dart';
import 'news_bloc.dart';
import 'news_page.dart';
import 'animation_page.dart';
import 'map_page.dart';
import 'qr_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('kk'),
        Locale('ru'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('ru'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _ready = false;
  bool _loggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final logged = prefs.getBool('logged_in') ?? false;
    setState(() {
      _loggedIn = logged;
      _ready = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return MaterialApp(
        home: const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return BlocProvider(
      create: (_) => RegistrationBloc(),
      child: MaterialApp(
        title: 'Campus News',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: _loggedIn ? const MainPage() : const RegistrationPage(),
      ),
    );
  }
}



class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _pwdFocus = FocusNode();
  final _confirmFocus = FocusNode();

  bool _hidePwd = true;
  bool _hideConfirm = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _pwdCtrl.dispose();
    _confirmCtrl.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _pwdFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  bool _isEmail(String s) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(s);
  }

  void _onSubmitPressed(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<RegistrationBloc>().add(
            RegistrationSubmitted(
              name: _nameCtrl.text.trim(),
              phone: _phoneCtrl.text.trim(),
              email: _emailCtrl.text.trim(),
              password: _pwdCtrl.text,
              confirmPassword: _confirmCtrl.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegistrationBloc, RegistrationState>(
      listener: (context, state) {
        if (state is RegistrationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        if (state is RegistrationSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const MainPage(),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is RegistrationLoading;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Campus Registration'),
            actions: [
              TextButton(
                onPressed: () => context.setLocale(const Locale('kk')),
                child: const Text(
                  'KK',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () => context.setLocale(const Locale('ru')),
                child: const Text(
                  'RU',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _nameCtrl,
                    focusNode: _nameFocus,
                    decoration: InputDecoration(
                      labelText: 'fullName'.tr(),
                      prefixIcon: const Icon(Icons.person),
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty)
                            ? 'Name is required'
                            : null,
                    onFieldSubmitted: (_) => _phoneFocus.requestFocus(),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _phoneCtrl,
                    focusNode: _phoneFocus,
                    decoration: InputDecoration(
                      labelText: 'phone'.tr(),
                      prefixIcon: const Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    textInputAction: TextInputAction.next,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty)
                            ? 'Phone is required'
                            : null,
                    onFieldSubmitted: (_) => _emailFocus.requestFocus(),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailCtrl,
                    focusNode: _emailFocus,
                    decoration: InputDecoration(
                      labelText: 'email'.tr(),
                      prefixIcon: const Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (v) {
                      final t = v?.trim() ?? '';
                      if (t.isEmpty) return 'Email is required';
                      if (!_isEmail(t)) return 'Invalid email';
                      return null;
                    },
                    onFieldSubmitted: (_) => _pwdFocus.requestFocus(),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _pwdCtrl,
                    focusNode: _pwdFocus,
                    decoration: InputDecoration(
                      labelText: 'password'.tr(),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _hidePwd
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _hidePwd = !_hidePwd;
                          });
                        },
                      ),
                    ),
                    obscureText: _hidePwd,
                    textInputAction: TextInputAction.next,
                    validator: (v) {
                      final t = v ?? '';
                      if (t.isEmpty) return 'Password is required';
                      if (t.length < 6) return 'Min 6 characters';
                      return null;
                    },
                    onFieldSubmitted: (_) =>
                        _confirmFocus.requestFocus(),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _confirmCtrl,
                    focusNode: _confirmFocus,
                    decoration: InputDecoration(
                      labelText: 'confirmPassword'.tr(),
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _hideConfirm
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _hideConfirm = !_hideConfirm;
                          });
                        },
                      ),
                    ),
                    obscureText: _hideConfirm,
                    textInputAction: TextInputAction.done,
                    validator: (v) {
                      if ((v ?? '').isEmpty) {
                        return 'Please confirm password';
                      }
                      if (v != _pwdCtrl.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _onSubmitPressed(context),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () => _onSubmitPressed(context),
                      child: isLoading
                          ? const CircularProgressIndicator(
                              strokeWidth: 2,
                            )
                          : Text('submit'.tr()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}


class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dio = Dio();
    final client = RestClient(dio);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProfileBloc(client)..add(LoadProfile()),
        ),
        BlocProvider(
          create: (_) => NewsBloc(Dio())..add(LoadNews()),
        ),
      ],
      child: const _MainScaffold(),
    );
  }
}

class _MainScaffold extends StatefulWidget {
  const _MainScaffold({super.key});

  @override
  State<_MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<_MainScaffold> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const NewsPage(),           // /posts
      const PostPage(),           // /posts/1
      const AnimationPage(),// animation
      const MapPage(),            // map
      const QrPage(),             // QR scanner
    ];

    final titles = ['News', 'Featured', 'Animation', 'Map', 'QR'];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_currentIndex]),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.animation),
            label: 'Anim',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'QR',
          ),
        ],
      ),
    );
  }
}

// ================== Post Page (uses ProfileBloc) ==================

class PostPage extends StatelessWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading || state is ProfileInitial) {
            return const CircularProgressIndicator();
          } else if (state is ProfileFailure) {
            return Text('Error: ${state.message}');
          } else if (state is ProfileLoaded) {
            final p = state.profile;

            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 500),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 30 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('userId: ${p.userId}'),
                        Text('id: ${p.id}'),
                        const SizedBox(height: 8),
                        const Text(
                          'Title:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(p.title),
                        const SizedBox(height: 8),
                        const Text(
                          'Body:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(p.body),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const Text('No data');
          }
        },
      ),
    );
  }
}
