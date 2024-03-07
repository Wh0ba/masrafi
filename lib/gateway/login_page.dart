import 'package:masrafi/handlers/db.dart';
import 'package:masrafi/models/m_user.dart';
import 'package:masrafi/pages/homepage.dart';
import 'package:masrafi/widgets/progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shared.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String username = '';
  String password = '';
  bool inAsyncCall = false;
  bool hidePassword = true;
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      int userid = prefs.getInt(tokenKey) ?? 0;
      if (userid > 0) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => Directionality(
                      textDirection: TextDirection.rtl,
                      child: Homepage(
                        userid: userid,
                      ),
                    )));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      body: ProgressHUD(
        inAsyncCall: inAsyncCall,
        color: Theme.of(context).colorScheme.primary,
        child: Center(
          child: SingleChildScrollView(
            child: _form(),
          ),
        ),
      ),
    );
  }

  Form _form() {
    return Form(
      key: globalFormKey,
      child: Center(
        child: Container(
          margin: const EdgeInsets.only(left: 25, right: 25),
          padding: const EdgeInsets.only(bottom: 10),
          constraints: const BoxConstraints(maxWidth: 500),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: Theme.of(context).colorScheme.surface,
              boxShadow: const [
                BoxShadow(
                    color: Colors.black38, blurRadius: 20, offset: Offset(0, 5))
              ]),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),

              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.background,
                backgroundImage: const AssetImage('assets/images/logo.jpg'),
                radius: 60,
              ),

              const SizedBox(height: 15),
              const Text(
                "مصروفي",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),

              Text(
                "🩷 الرجاء تسجيل الدخول لعرض مصروفاتكم ",
                style: TextStyle(
                    color: Colors.grey.shade700, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              //Email Textfield
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                onSaved: (input) => username = input!,
                validator: (input) => input!.length < 4
                    ? "يجب ان يكون الاسم اكثر من 4 رموز!!"
                    : null,
                decoration: InputDecoration(
                  hintText: "اسم المستخدم",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.2))),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary)),
                  prefixIcon: Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              //Password Textfield
              TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: hidePassword,
                  onSaved: (input) => password = input!,
                  validator: (input) => input!.length < 4
                      ? "يجب ان تكون كلمة المرور اكثر من 4 رموز!!"
                      : null,
                  decoration: InputDecoration(
                    hintText: "كلمة المرور",
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context)
                                .primaryColor
                                .withOpacity(0.2))),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary)),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.8),
                      icon: Icon(hidePassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                  )),
              const SizedBox(height: 15),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        Theme.of(context).colorScheme.primary)),
                onPressed: () => handleSubmit(),
                child: const Text(
                  "تسجيل الدخول",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        Theme.of(context).colorScheme.secondary)),
                onPressed: () => handleSignup(),
                child: const Text(
                  "إنشاء حساب",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),

              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleSubmit() {
    if (validateAndSave()) {
      setState(() {
        inAsyncCall = true;
      });
      DB.instance.login(username, password).then((MUser user) {
        int token = user.id;
        setState(() {
          inAsyncCall = false;
        });
        if (token > 0) {
          SharedPreferences.getInstance()
              .then((pref) => {pref.setInt(tokenKey, token)});
          const snackBar = SnackBar(content: Text('تم تسجيل الدخول بنجاح'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => Directionality(
                      textDirection: TextDirection.rtl,
                      child: Homepage(
                        userid: token,
                      ))));
        }
      }).catchError((onError) {
        const snackBar =
            SnackBar(content: Text('اسم المستخدم او كلمة المرور غير صحيحة '));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          inAsyncCall = false;
        });
      });
    }
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void handleSignup() {
    if (validateAndSave()) {
      setState(() {
        inAsyncCall = true;
      });
      DB.instance.register(username, password).then((MUser user) {
        int token = user.id;
        setState(() {
          inAsyncCall = false;
        });
        if (token > 0) {
          SharedPreferences.getInstance()
              .then((pref) => {pref.setInt(tokenKey, token)});
          const snackBar = SnackBar(content: Text('تم التسجيل بنجاح'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => Directionality(
                      textDirection: TextDirection.rtl,
                      child: Homepage(
                        userid: token,
                      ))));
        }
      }).catchError((onError) {
        const snackBar = SnackBar(content: Text('اسم المستخدم موجود مسبقاً'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          inAsyncCall = false;
        });
      });
    }
  }
}
