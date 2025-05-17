import 'dart:async';
import 'package:flutter/material.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final _otpController1 = TextEditingController();
  final _otpController2 = TextEditingController();
  final _otpController3 = TextEditingController();
  final _otpController4 = TextEditingController();
  int _resendTimer = 30;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer == 0) {
        timer.cancel();
      } else {
        setState(() {
          _resendTimer--;
        });
      }
    });
  }

  @override
  void dispose() {
    _otpController1.dispose();
    _otpController2.dispose();
    _otpController3.dispose();
    _otpController4.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OTP Verification')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Enter the 4-digit code sent to your email'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 50,
                  child: TextField(
                    controller: _otpController1,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: TextField(
                    controller: _otpController2,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: TextField(
                    controller: _otpController3,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: TextField(
                    controller: _otpController4,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Resend code in $_resendTimer seconds',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/main');
              },
              child: const Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}
