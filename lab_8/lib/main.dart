import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const RegistrationPage(),
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

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => UserInfoPage(
            name: _nameCtrl.text.trim(),
            email: _emailCtrl.text.trim(),
            phone: _phoneCtrl.text.trim(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Form'),
        actions: [
          TextButton(
            onPressed: () => context.setLocale(const Locale('kk')),
            child: const Text('KK', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => context.setLocale(const Locale('ru')),
            child: const Text('RU', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Full name
              TextFormField(
                controller: _nameCtrl,
                focusNode: _nameFocus,
                decoration: InputDecoration(
                  labelText: 'fullName'.tr(),
                  prefixIcon: const Icon(Icons.person),
                ),
                textInputAction: TextInputAction.next,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                onFieldSubmitted: (_) => _phoneFocus.requestFocus(),
              ),
              const SizedBox(height: 12),

              // Phone
              TextFormField(
                controller: _phoneCtrl,
                focusNode: _phoneFocus,
                decoration: InputDecoration(
                  labelText: 'phone'.tr(),
                  prefixIcon: const Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textInputAction: TextInputAction.next,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Phone is required' : null,
                onFieldSubmitted: (_) => _emailFocus.requestFocus(),
              ),
              const SizedBox(height: 12),

              // Email
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

              // Password
              TextFormField(
                controller: _pwdCtrl,
                focusNode: _pwdFocus,
                decoration: InputDecoration(
                  labelText: 'password'.tr(),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _hidePwd ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () =>
                        setState(() => _hidePwd = !_hidePwd),
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
                onFieldSubmitted: (_) => _confirmFocus.requestFocus(),
              ),
              const SizedBox(height: 12),

              // Confirm Password
              TextFormField(
                controller: _confirmCtrl,
                focusNode: _confirmFocus,
                decoration: InputDecoration(
                  labelText: 'confirmPassword'.tr(),
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _hideConfirm ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () =>
                        setState(() => _hideConfirm = !_hideConfirm),
                  ),
                ),
                obscureText: _hideConfirm,
                textInputAction: TextInputAction.done,
                validator: (v) {
                  if ((v ?? '').isEmpty) return 'Please confirm password';
                  if (v != _pwdCtrl.text) return 'Passwords do not match';
                  return null;
                },
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 20),

              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: Text('submit'.tr()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserInfoPage extends StatelessWidget {
  final String name;
  final String email;
  final String phone;

  const UserInfoPage({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Info')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: $name'),
            const SizedBox(height: 8),
            Text('Email: $email'),
            const SizedBox(height: 8),
            Text('Phone: $phone'),
          ],
        ),
      ),
    );
  }
}
