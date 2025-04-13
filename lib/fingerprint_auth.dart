import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'menu_drawer_page.dart';

class FingerprintAuthPage extends StatefulWidget {
  const FingerprintAuthPage({Key? key}) : super(key: key);

  @override
  _FingerprintAuthPageState createState() => _FingerprintAuthPageState();
}

class _FingerprintAuthPageState extends State<FingerprintAuthPage> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _hasBiometricSupport = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _checkBiometricSupport();
  }

  /// Checks whether the device supports biometric authentication.
  Future<void> _checkBiometricSupport() async {
    bool canCheck = false;
    try {
      canCheck = await _localAuth.canCheckBiometrics;
    } catch (e) {
      print("Error checking biometrics: $e");
      setState(() {
        _errorMessage = 'Error checking biometric support: $e';
      });
    }
    setState(() {
      _hasBiometricSupport = canCheck;
    });
  }

  /// Authenticates the user using biometric sensors.
  Future<void> _authenticateUser() async {
    // First, check if the device supports biometrics.
    if (!_hasBiometricSupport) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Biometric authentication is not available.'),
        ),
      );
      return;
    }

    // Try to get list of available biometrics.
    List<BiometricType> availableBiometrics = [];
    try {
      availableBiometrics = await _localAuth.getAvailableBiometrics();
      print("Available biometrics: $availableBiometrics");
    } catch (e) {
      print("Error retrieving available biometrics: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error retrieving biometrics: $e')),
      );
      return;
    }

    // If no biometrics are set up, inform the user.
    if (availableBiometrics.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No biometrics enrolled on this device.'),
        ),
      );
      return;
    }

    // Attempt to authenticate the user.
    bool authenticated = false;
    try {
      authenticated = await _localAuth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
          useErrorDialogs: true,
        ),
      );
    } catch (e) {
      print("Error during authentication: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Authentication error: $e')),
      );
    }

    // Process the result of the authentication.
    if (authenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Authentication successful'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MenuDrawerPage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Authentication failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fast Fingerprint Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              Text(
                _hasBiometricSupport
                    ? 'Your device supports biometric authentication.'
                    : 'Biometric authentication is not supported.',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _authenticateUser,
                icon: const Icon(Icons.fingerprint),
                label: const Text('Authenticate with Fingerprint'),
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFF1557B0),
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 20),
                  textStyle: const TextStyle(fontSize: 25),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
