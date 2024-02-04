import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class User {
  String name;
  String email;
  String password;
  String profileImage;
  String cv;
  List<String> schools;
  List<String> courses;

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.profileImage,
    required this.cv,
    required this.schools,
    required this.courses,
  });
}

class AuthManager {
  static List<User> users = [];

  static bool isEmailRegistered(String email) {
    return users.any((user) => user.email == email);
  }

  static bool login(String email, String password) {
    var user = users.firstWhere(
      (user) => user.email == email && user.password == password,
      orElse: () => User(
        name: '',
        email: '',
        password: '',
        profileImage: '',
        cv: '',
        schools: [],
        courses: [],
      ),
    );

    return user.email.isNotEmpty;
  }

  static void register(User user) {
    users.add(user);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Giriş ve Kayıt Ekranı',
     theme: ThemeData(
    primarySwatch: Colors.teal,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: Colors.white, // Özel arkaplan rengi
  ),
      debugShowCheckedModeBanner: false,
      home: LoginSignupScreen(),
    );
  }
}

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({Key? key}) : super(key: key);

  @override
  _LoginSignupScreenState createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  bool _isLogin = true;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

  void _toggleScreen() {
    setState(() {
      _isLogin = !_isLogin;
    });

    if (_isLogin) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            user: User(
              name: '',
              email: _emailController.text,
              password: _passwordController.text,
              profileImage: '',
              cv: '',
              schools: [],
              courses: [],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isLogin ? 'Giriş Yap' : 'Kayıt Ol'),
          centerTitle: true,
          backgroundColor: Colors.blue, // Rengi değiştirildi
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  if (!_isLogin)
                    TextFormField(
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ad Soyad boş olamaz';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Ad Soyad',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(12.0),
                      ),
                    ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'E-posta boş olamaz';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'E-posta',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(12.0),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _isObscure,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Şifre boş olamaz';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Şifre',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(12.0),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        if (_isLogin) {
                          var isLoggedIn = AuthManager.login(
                            _emailController.text,
                            _passwordController.text,
                          );
                          if (isLoggedIn) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                  user: User(
                                    name: '',
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                    profileImage: '',
                                    cv: '',
                                    schools: [],
                                    courses: [],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            // Giriş başarısız
                            // TODO: Hata mesajı göster
                          }
                        } else {
                          var newUser = User(
                            name: _nameController.text,
                            email: _emailController.text,
                            password: _passwordController.text,
                            profileImage: '',
                            cv: '',
                            schools: [],
                            courses: [],
                          );
                          AuthManager.register(newUser);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(user: newUser),
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      padding: EdgeInsets.all(12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      _isLogin ? 'Giriş Yap' : 'Kayıt Ol',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: _toggleScreen,
                    style: TextButton.styleFrom(
                      primary: Colors.blue,
                    ),
                    child: Text(
                      _isLogin
                          ? 'Hesabınız yok mu? Kayıt Olun'
                          : 'Zaten bir hesabınız var mı? Giriş Yapın',
                      style: TextStyle(color: Colors.blue),
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
  final User user;
  final TextEditingController _messageController = TextEditingController();

  HomeScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Ana Ekran'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                _showLogoutDialog(context);
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Ana Menüye Hoşgeldiniz, ${user.name}!',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(user: user),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  padding: EdgeInsets.all(12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text('Profiline Git', style: TextStyle(fontSize: 16)),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _showContactDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  padding: EdgeInsets.all(12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text('İletişime Geçin', style: TextStyle(fontSize: 16)),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _showMessageForm(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  padding: EdgeInsets.all(12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text('Mesaj Gönder', style: TextStyle(fontSize: 16)),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _launchPhoneCall('123-456-7890'); // Telefon numarasını buraya ekleyin
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  padding: EdgeInsets.all(12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text('Telefonla Ara', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('İletişime Geçin'),
          content: Column(
            children: [
              Text('İş Yeri Adresi: İstinye Üniversitesi Cevizlibağ Kampüsü, No: 123, Şehir:İstanbul'),
              SizedBox(height: 8),
              Text('Telefon: 123-456-7890'),
              SizedBox(height: 8),
              Text('Sosyal Medya: @sebsoftware'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                padding: EdgeInsets.all(12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text('Kapat', style: TextStyle(fontSize: 16)),
            ),
            ElevatedButton(
              onPressed: () {
                _launchPhoneCall('123-456-7890'); // Telefon numarasını buraya ekleyin
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                padding: EdgeInsets.all(12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text('Ara', style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  void _launchPhoneCall(String phoneNumber) async {
    final String telUrl = 'tel:$phoneNumber';
    if (await canLaunch(telUrl)) {
      await launch(telUrl);
    } else {
      print('Telefon araması başlatılamıyor: $telUrl');
    }
  }

  void _showMessageForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Mesaj Gönder'),
          content: Column(
            children: [
              Text('Gönderen: ${user.name}'),
              SizedBox(height: 8),
              Text('E-posta: ${user.email}'),
              SizedBox(height: 16),
              TextFormField(
                controller: _messageController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Mesajınız',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  contentPadding: EdgeInsets.all(12.0),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                padding: EdgeInsets.all(12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text('İptal', style: TextStyle(fontSize: 16)),
            ),
            ElevatedButton(
              onPressed: () {
                _sendMessage(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                padding: EdgeInsets.all(12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text('Gönder', style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  void _sendMessage(BuildContext context) {
    String message = _messageController.text;

    print('Message from ${user.name} (${user.email}): $message');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Mesaj Gönderildi'),
          content: Text('Mesajınız başarıyla gönderildi. Teşekkür ederiz!'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                padding: EdgeInsets.all(12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text('Tamam', style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );

    _messageController.clear();
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Çıkış Yap'),
          content: Text('Çıkış yapmak istediğinize emin misiniz?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                padding: EdgeInsets.all(12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text('İptal', style: TextStyle(fontSize: 16)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                padding: EdgeInsets.all(12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text('Çıkış Yap', style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }
}

class ProfileScreen extends StatefulWidget {
  final User user;

  ProfileScreen({required this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _cvController = TextEditingController();
  TextEditingController _schoolController = TextEditingController();
  TextEditingController _courseController = TextEditingController();
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _nameController.text = _user.name;
    _emailController.text = _user.email;
    _cvController.text = _user.cv;
    _schoolController.text = '';
    _courseController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _showEditProfileDialog();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              _user.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'E-posta: ${_user.email}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 16),
            Text(
              'CV',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              _user.cv,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 16),
            Text(
              'Okuduğu Okullar',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _user.schools
                  .map((school) => Text(
                        '- $school',
                        style: TextStyle(fontSize: 16),
                      ))
                  .toList(),
            ),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 16),
            Text(
              'Aldığı Kurslar',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _user.courses
                  .map((course) => Text(
                        '- $course',
                        style: TextStyle(fontSize: 16),
                      ))
                  .toList(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showEditProfileDialog();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                padding: EdgeInsets.all(12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text('Profili Düzenle', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Profil Düzenle'),
          content: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Ad Soyad'),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'E-posta'),
              ),
              TextField(
                controller: _cvController,
                decoration: InputDecoration(labelText: 'CV'),
              ),
              TextField(
                controller: _schoolController,
                decoration: InputDecoration(labelText: 'Okuduğu Okul'),
              ),
              TextField(
                controller: _courseController,
                decoration: InputDecoration(labelText: 'Aldığı Kurs'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                padding: EdgeInsets.all(12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text('İptal', style: TextStyle(fontSize: 16)),
            ),
            ElevatedButton(
              onPressed: () {
                _updateProfile();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                padding: EdgeInsets.all(12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text('Kaydet', style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  void _updateProfile() {
    setState(() {
      _user.name = _nameController.text;
      _user.email = _emailController.text;
      _user.cv = _cvController.text;
      if (_schoolController.text.isNotEmpty) {
        _user.schools.add(_schoolController.text);
        _schoolController.clear();
      }
      if (_courseController.text.isNotEmpty) {
        _user.courses.add(_courseController.text);
        _courseController.clear();
      }
    });
  }
}

//Abdüssamed Eker 222016711 Bilgisayar Programcılığı 2.sınıf İÖ
//Eray Henden 222016738 Bilgisayar Programcılığı 2.sınıf İÖ
//Muharrem Berat Tokuş 222016713 Bilgisayar Programcılığı 2.sınıf İÖ