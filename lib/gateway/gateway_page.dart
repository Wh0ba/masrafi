import 'package:flutter/material.dart';
import 'package:masrafi/gateway/login_page.dart';
import 'package:masrafi/pages/homepage.dart';

class GatewayPage extends StatefulWidget {
  const GatewayPage({super.key});

  @override
  State<GatewayPage> createState() => _GatewayPageState();
}

//TODO: is logged in logic
class _GatewayPageState extends State<GatewayPage> {
  final bool isLoggedIn = false;
  @override
  Widget build(BuildContext context) {
    return isLoggedIn ? const Homepage() : const LoginPage();
  }
}
