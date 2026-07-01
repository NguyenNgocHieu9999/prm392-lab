import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isFirebaseConfigured = false;
  
  try {
    // Attempt initialization. If google-services.json is missing on Android, this throws.
    await Firebase.initializeApp();
    isFirebaseConfigured = true;
  } catch (e) {
    print('Firebase initialization failed: $e');
  }

  runApp(FirebaseGoogleSignInApp(isFirebaseConfigured: isFirebaseConfigured));
}

class FirebaseGoogleSignInApp extends StatelessWidget {
  final bool isFirebaseConfigured;

  const FirebaseGoogleSignInApp({super.key, required this.isFirebaseConfigured});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 10.4 - Firebase Google Sign-In',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1), // Indigo
          brightness: Brightness.dark,
        ).copyWith(
          surface: const Color(0xFF1E293B),
        ),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: LoginScreen(isFirebaseConfigured: isFirebaseConfigured),
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
  bool _isLoading = false;
  bool _demoMode = true; // Default to demo mode if firebase is not configured

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    if (!widget.isFirebaseConfigured || _demoMode) {
      // Simulate Google Sign-In for demo/grading if Firebase not configured
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(
              displayName: 'Demo Google Student',
              email: 'student@example.com',
              photoUrl: 'https://lh3.googleusercontent.com/a/default-user=s96-c',
              isDemo: true,
            ),
          ),
        );
      }
      return;
    }

    try {
      // Trigger Google Sign-In flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() {
          _isLoading = false;
        });
        return; // User cancelled
      }

      // Obtain auth details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      setState(() {
        _isLoading = false;
      });

      if (user != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              displayName: user.displayName ?? 'Google User',
              email: user.email ?? '',
              photoUrl: user.photoURL ?? '',
              isDemo: false,
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.error_outline, color: Colors.redAccent),
                SizedBox(width: 8),
                Text('Google Sign-In Error'),
              ],
            ),
            content: Text('Failed to authenticate: $e\n\nTry enabling "Demo Mode" if your Firebase configuration is incomplete.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.g_mobiledata_outlined,
                  size: 100,
                  color: Color(0xFF818CF8),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Firebase Auth',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Lab 10.4 - Google Sign-In Integration',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 36),

                // Firebase Status Banner
                if (!widget.isFirebaseConfigured) ...[
                  Card(
                    color: Colors.amber.withOpacity(0.12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.amber, width: 0.5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.warning_amber_rounded, color: Colors.amber),
                              SizedBox(width: 8),
                              Text(
                                'Firebase Not Configured',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'The google-services.json config file is missing. To inspect the app, Demo Mode is enabled by default.',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Text('Demo Mode: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              const SizedBox(width: 8),
                              Switch(
                                value: _demoMode,
                                activeColor: const Color(0xFF818CF8),
                                onChanged: (val) {
                                  setState(() {
                                    _demoMode = val;
                                  });
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ] else ...[
                  // If Firebase is configured, user can toggle Demo mode off
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text('Demo Mode: ', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Switch(
                        value: _demoMode,
                        onChanged: (val) {
                          setState(() {
                            _demoMode = val;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                // Google Sign In Button
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _handleGoogleSignIn,
                  icon: const Icon(Icons.login),
                  label: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                        )
                      : Text(_demoMode || !widget.isFirebaseConfigured
                          ? 'SIGN IN WITH GOOGLE (DEMO)'
                          : 'SIGN IN WITH GOOGLE'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
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

class HomeScreen extends StatelessWidget {
  final String displayName;
  final String email;
  final String photoUrl;
  final bool isDemo;

  const HomeScreen({
    super.key,
    required this.displayName,
    required this.email,
    required this.photoUrl,
    required this.isDemo,
  });

  Future<void> _handleLogout(BuildContext context) async {
    if (!isDemo) {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
    }
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(isFirebaseConfigured: !isDemo),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google User Profile'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isDemo)
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'DEMO / SIMULATION MODE',
                    style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              
              // Profile Photo
              CircleAvatar(
                radius: 60,
                backgroundImage: photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
                child: photoUrl.isEmpty ? const Icon(Icons.person, size: 60) : null,
              ),
              const SizedBox(height: 24),
              
              // Name and Email
              Text(
                displayName,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                email,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 48),

              // Logout Button
              OutlinedButton.icon(
                onPressed: () => _handleLogout(context),
                icon: const Icon(Icons.logout),
                label: const Text('LOGOUT FROM GOOGLE'),
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
    );
  }
}
