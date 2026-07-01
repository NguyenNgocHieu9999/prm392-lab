import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Initialize Local Notifications
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // 2. Initialize Firebase
  bool isFirebaseConfigured = false;
  try {
    await Firebase.initializeApp();
    isFirebaseConfigured = true;
  } catch (e) {
    print('Firebase initialization failed: $e');
  }

  runApp(Lab10FullApp(isFirebaseConfigured: isFirebaseConfigured));
}

class Lab10FullApp extends StatelessWidget {
  final bool isFirebaseConfigured;

  const Lab10FullApp({super.key, required this.isFirebaseConfigured});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 10 - Integrated Auth & Notifications',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
        ).copyWith(
          surface: const Color(0xFF1E293B),
        ),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1E293B),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF334155)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF334155)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
          ),
        ),
      ),
      home: SplashScreen(isFirebaseConfigured: isFirebaseConfigured),
    );
  }
}

// Global notification trigger helper
Future<void> triggerLocalNotification(String title, String body) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'lab10_full_channel_id',
    'Lab 10 Integrated Channel',
    channelDescription: 'Channel for Lab 10 integrated notifications',
    importance: Importance.max,
    priority: Priority.high,
  );
  const NotificationDetails details = NotificationDetails(android: androidDetails);
  await flutterLocalNotificationsPlugin.show(
    DateTime.now().millisecond,
    title,
    body,
    details,
  );
}

class SplashScreen extends StatefulWidget {
  final bool isFirebaseConfigured;
  const SplashScreen({super.key, required this.isFirebaseConfigured});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    await Future.delayed(const Duration(seconds: 2));

    // Request permissions for notifications
    final androidImplementation = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    
    // Check if Firebase user exists
    User? firebaseUser;
    if (widget.isFirebaseConfigured) {
      firebaseUser = FirebaseAuth.instance.currentUser;
    }

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      // Restore REST session
      final userData = {
        'loginMethod': 'API',
        'accessToken': token,
        'username': prefs.getString('username') ?? '',
        'firstName': prefs.getString('firstName') ?? '',
        'lastName': prefs.getString('lastName') ?? '',
        'email': prefs.getString('email') ?? '',
        'image': prefs.getString('image') ?? '',
      };
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(userData: userData, isFirebaseConfigured: widget.isFirebaseConfigured)),
      );
    } else if (firebaseUser != null) {
      // Restore Firebase session
      final userData = {
        'loginMethod': 'Google',
        'accessToken': 'FirebaseSessionToken',
        'username': firebaseUser.email?.split('@')[0] ?? '',
        'firstName': firebaseUser.displayName ?? 'Google User',
        'lastName': '',
        'email': firebaseUser.email ?? '',
        'image': firebaseUser.photoURL ?? '',
      };
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(userData: userData, isFirebaseConfigured: widget.isFirebaseConfigured)),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen(isFirebaseConfigured: widget.isFirebaseConfigured)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.widgets_outlined, size: 90, color: Color(0xFF818CF8)),
            SizedBox(height: 24),
            Text(
              'Integrated App',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
            SizedBox(height: 8),
            Text('REST API + Firebase Auth + Push notifications', style: TextStyle(color: Colors.grey, fontSize: 13)),
            SizedBox(height: 32),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  final bool isFirebaseConfigured;
  const LoginScreen({super.key, required this.isFirebaseConfigured});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _demoGoogleMode = true; // Default to demo mode if firebase config is missing

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleApiLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    try {
      final response = await http.post(
        Uri.parse('https://dummyjson.com/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        
        // Save session
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', userData['accessToken'] ?? '');
        await prefs.setString('username', userData['username'] ?? '');
        await prefs.setString('firstName', userData['firstName'] ?? '');
        await prefs.setString('lastName', userData['lastName'] ?? '');
        await prefs.setString('email', userData['email'] ?? '');
        await prefs.setString('image', userData['image'] ?? '');

        // Add login method metadata
        final finalUserData = Map<String, dynamic>.from(userData);
        finalUserData['loginMethod'] = 'API';

        // Trigger notification (LO7 Requirement)
        final displayName = userData['firstName'] ?? 'User';
        await triggerLocalNotification(
          'API Sign in Successful!',
          'Welcome back, $displayName. Session saved successfully.',
        );

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(userData: finalUserData, isFirebaseConfigured: widget.isFirebaseConfigured),
            ),
          );
        }
      } else {
        String errorMsg = 'Invalid username or password.';
        try {
          final errorData = jsonDecode(response.body);
          if (errorData['message'] != null) {
            errorMsg = errorData['message'];
          }
        } catch (_) {}
        if (mounted) _showError(errorMsg);
      }
    } catch (_) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) _showError('Network error. Check connection.');
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    if (!widget.isFirebaseConfigured || _demoGoogleMode) {
      // Simulate Google Sign-In
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _isLoading = false;
      });

      final userData = {
        'loginMethod': 'Google',
        'accessToken': 'DemoToken',
        'username': 'demo_google_student',
        'firstName': 'Demo Google Student',
        'lastName': '',
        'email': 'student@example.com',
        'image': 'https://lh3.googleusercontent.com/a/default-user=s96-c',
        'isDemo': true,
      };

      // Trigger notification (LO7 Requirement)
      await triggerLocalNotification(
        'Google Sign in Successful (Demo)!',
        'Welcome back, Demo Google Student. Local notifications active.',
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(userData: userData, isFirebaseConfigured: widget.isFirebaseConfigured),
          ),
        );
      }
      return;
    }

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      setState(() {
        _isLoading = false;
      });

      if (user != null && mounted) {
        final userData = {
          'loginMethod': 'Google',
          'accessToken': 'FirebaseToken',
          'username': user.email?.split('@')[0] ?? 'google_user',
          'firstName': user.displayName ?? 'Google User',
          'lastName': '',
          'email': user.email ?? '',
          'image': user.photoURL ?? '',
        };

        // Trigger notification
        await triggerLocalNotification(
          'Google Sign in Successful!',
          'Welcome back, ${user.displayName ?? 'User'}. Verified by Firebase.',
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(userData: userData, isFirebaseConfigured: widget.isFirebaseConfigured),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        _showError('Google Auth failed: $e\n\nPlease check SHA-1 credentials or try Google Demo Mode.');
      }
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.security_outlined, size: 70, color: Color(0xFF818CF8)),
                  const SizedBox(height: 16),
                  const Text(
                    'Integrated Login',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  
                  // Username
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username (REST API)',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Username is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Password
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  
                  // API sign-in button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleApiLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('SIGN IN WITH API', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  const SizedBox(height: 16),
                  
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text('OR', style: TextStyle(color: Colors.grey)),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Firebase Status Warning / Toggle
                  if (!widget.isFirebaseConfigured) ...[
                    Card(
                      color: Colors.amber.withOpacity(0.12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.amber, width: 0.5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded, color: Colors.amber),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'Firebase not loaded. Demo Google Sign-In is active.',
                                style: TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                            ),
                            Switch(
                              value: _demoGoogleMode,
                              onChanged: (val) {
                                setState(() {
                                  _demoGoogleMode = val;
                                });
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ] else ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text('Google Demo Mode: ', style: TextStyle(fontSize: 11, color: Colors.grey)),
                        Switch(
                          value: _demoGoogleMode,
                          onChanged: (val) {
                            setState(() {
                              _demoGoogleMode = val;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],

                  // Google Button
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _handleGoogleSignIn,
                    icon: const Icon(Icons.login),
                    label: Text(_demoGoogleMode || !widget.isFirebaseConfigured
                        ? 'GOOGLE SIGN-IN (DEMO)'
                        : 'GOOGLE SIGN-IN'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Text('Test API Credentials:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          Text('Username: emilys  |  Password: emilyspass', style: TextStyle(fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final Map<String, dynamic> userData;
  final bool isFirebaseConfigured;

  const HomeScreen({super.key, required this.userData, required this.isFirebaseConfigured});

  Future<void> _handleLogout(BuildContext context) async {
    final loginMethod = userData['loginMethod'] ?? '';
    final isDemo = userData['isDemo'] == true;

    // Clear REST session
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Clear Firebase session
    if (loginMethod == 'Google' && !isDemo && isFirebaseConfigured) {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
    }

    // Trigger logout push notification (LO7 Requirement)
    await triggerLocalNotification(
      'Session Terminated',
      'You have successfully signed out and cleared active login sessions.',
    );

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(isFirebaseConfigured: isFirebaseConfigured),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatarUrl = userData['image'] ?? '';
    final firstName = userData['firstName'] ?? 'User';
    final lastName = userData['lastName'] ?? '';
    final email = userData['email'] ?? '';
    final username = userData['username'] ?? '';
    final loginMethod = userData['loginMethod'] ?? 'API';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Integrated Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _handleLogout(context),
            tooltip: 'Logout',
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: const Color(0xFF6366F1).withOpacity(0.15),
                  backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
                  child: avatarUrl.isEmpty ? const Icon(Icons.person, size: 60) : null,
                ),
                const SizedBox(height: 24),
                
                Text(
                  'Welcome back, $firstName $lastName!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  '@$username • $email',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                
                // Login method badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF6366F1), width: 0.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        loginMethod == 'Google' ? Icons.g_mobiledata : Icons.api,
                        color: const Color(0xFF818CF8),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Logged in via: $loginMethod',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Manual Notification Card
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.notification_add, color: Color(0xFF818CF8)),
                    title: const Text('Test Notification'),
                    subtitle: const Text('Trigger a local push notification manually.'),
                    trailing: IconButton(
                      icon: const Icon(Icons.play_arrow),
                      onPressed: () {
                        triggerLocalNotification(
                          'Test Notification',
                          'Manual trigger from integrated dashboard verified!',
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 36),

                OutlinedButton.icon(
                  onPressed: () => _handleLogout(context),
                  icon: const Icon(Icons.logout),
                  label: const Text('LOGOUT'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.redAccent),
                    foregroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
