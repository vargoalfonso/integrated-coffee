import 'package:flutter/material.dart';
import 'package:flutter_application_3/Pesanan.dart';
import 'package:flutter_application_3/admin-home-page.dart';
import 'package:flutter_application_3/list-kopi.dart';
import 'package:flutter_application_3/Controller/cTesting.dart';
import 'package:flutter_application_3/listkopitesting.dart';
import 'package:flutter_application_3/model/Cmodel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: LoginForm(),
    );
  }
}

class RegistrationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrasi'),
      ),
      body: RegistrationForm(),
    );
  }
}

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationForm createState() => _RegistrationForm();
}

class _RegistrationForm extends State<RegistrationForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // TextField Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController feedbackController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      FeedbackForm feedbackForm = FeedbackForm(
        nameController.text,
        emailController.text,
        mobileNoController.text,
        feedbackController.text,
        passwordController.text,
      );

      FormController formController = FormController((String response) {
        print("Response: $response");
        if (response == FormController.STATUS_SUCCESS) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
          _showSnackbar("Feedback Submitted");
        } else {
          _showSnackbar("Error Occurred!");
        }
      });

      _showSnackbar("Submitting Feedback");

      // Submit 'feedbackForm' and save it in Google Sheet

      formController.submitForm(feedbackForm);
    }
  }

  // Method to show snackbar with 'message'.
  _showSnackbar(String message) {
    final snackBar = SnackBar(content: Text(message));
    _scaffoldKey.currentState?.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 50, horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Valid Name";
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: "Name"),
                    ),
                    TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Valid Email";
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: "Email"),
                    ),
                    TextFormField(
                      controller: feedbackController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Valid Feedback";
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: "Mobile number"),
                    ),
                    TextFormField(
                      controller: passwordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Valid Feedback";
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: "password"),
                    ),
                    RaisedButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      onPressed: _submitForm,
                      child: Text('Submit'),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Daftar pengguna yang terdaftar (dummy data untuk contoh)
  final Map<String, String> registeredUsers = {
    'natasyatclim@gmail.com': 'tcinlove21',
    'billymj05@gmail.com': 'bijey0505',
    'theodorewanadaya@gmail.com': 'theo134011',
    'warnawarniwo@gmail.com': 'w2photo1',
    'joramlim@gmail.com': 'jab060203',
    'abedn5201@gmail.com': 'abedabed5201',
    'kyrtsocalvin13@gmail.com': 'theo0905',
    'endiputro@ukrida.ac.id': 'endiputro',
    'admin@gmail.com': 'admin123',
  };

  // Initialize the pesanan object
  final Pesanan pesanan = Pesanan();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Welcome to Koffie Bloem"),
          Image.asset(
            "assets/images/Logo.jpg",
            width: 200.0,
            height: 200.0,
          ),
          TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          SizedBox(height: 16),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Ganti dengan logika autentikasi sesuai kebutuhan
              String email = emailController.text;
              String password = passwordController.text;

              if (registeredUsers.containsKey(email) &&
                  registeredUsers[email] == password) {
                // Autentikasi berhasil
                // Simulasi catch API

                if (email == '2' && password == '2') {
                  // Admin login
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminHomePage()),
                  );
                } else {
                  // User login
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CoffeeOrderScreen1()),
                  );
                }
              } else {
                // Tampilkan pesan kesalahan atau lakukan tindakan lain
                print('Login gagal: Email atau password salah');
              }
            },
            child: Text('Login'),
          ),
          SizedBox(height: 16),
          TextButton(
            onPressed: () {
              // Navigasi ke halaman registrasi
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegistrationPage()),
              );
            },
            child: Text('Belum punya akun? Registrasi disini'),
          ),
        ],
      ),
    );
  }
}
