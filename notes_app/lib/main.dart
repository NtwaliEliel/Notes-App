import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/notes_provider.dart';
import 'presentation/auth/login_screen.dart';
import 'presentation/notes/notes_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  if(kIsWeb){
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyD0yE9Zex0gjXWyr5NvKpgzfCh6lyE9mKE",
        authDomain: "notes-app-e3f14.firebaseapp.com",
        projectId: "notes-app-e3f14",
        storageBucket: "notes-app-e3f14.firebasestorage.app",
        messagingSenderId: "989597534887",
        appId: "1:989597534887:web:803f4309c8e116078f6982",
        measurementId: "G-ZFVE6FEB5S"
      )
    );
  } else {
  // For non-web platforms, initialize Firebase without options
    await Firebase.initializeApp();
  }
  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NotesProvider()),
      ],
      child: MaterialApp(
        title: 'My Notes App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: Consumer<AuthProvider>(
          builder: (context, auth, _) {
            if (auth.isLoggedIn) {
              return const NotesScreen();
            } else {
              return const LoginScreen();
            }
          },
        ),
      ),
    );
  }
}
