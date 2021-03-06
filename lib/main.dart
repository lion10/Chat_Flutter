import 'package:chat/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat',
      theme: ThemeData.dark(),
      initialRoute: MyHomePage.id,
      routes: {
        MyHomePage.id: (context) =>MyHomePage(),
        Registration.id: (context) =>Registration(),
        Login.id: (context) =>Login(),
        Chat.id: (context) =>Chat(),
      },
    );
  }
}



class MyHomePage extends StatelessWidget {
   static const String id = "HOMESCREEN" ;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        crossAxisAlignment:CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            crossAxisAlignment:CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
           children: <Widget>[
             Hero(
               tag:'logo',
               child: Container(
                 width: 100,
                 child: Image.asset('assets/logo.png'),
               ),
             ),
             Text(
               'Chat',
               style: TextStyle(fontSize: 80,color: Colors.white),
             )
           ],
          ),
          SizedBox(height: 50.0,),
          CustomButton(
            label: 'Log in',
            callback: (){
              Navigator.of(context).pushNamed(Login.id);
            },
          ),
          CustomButton(
            label: 'Register',
            callback: (){
              Navigator.of(context).pushNamed(Registration.id);
            },
          )
        ],
      ),
    );
  }
}



class CustomButton extends StatelessWidget {
  final VoidCallback callback ;
  final String label;

  const CustomButton({Key key, this.callback, this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:const EdgeInsets.all(8.0),
      child: Material(
        color: Colors.blueGrey,
        elevation: 6.0,
        borderRadius: BorderRadius.circular(100.0),
        child: MaterialButton(
          onPressed: callback ,
          minWidth: 200,
          height: 45.0,
          child: Text(label),
        ),
      ),
    );
  }
}


// Registration

class Registration extends StatefulWidget {
  static const String id = "REGISTRATION" ;

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  String email ;
  String password ;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> registerUser() async {
    FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    )).user;

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context)=> Chat(user: user),
        )
      );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Text("Chat"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Hero(
              tag: 'logo',
              child: Container(
                child: Image.asset('assets/logo.png'),
              ),
            ),
          ),
          SizedBox(height: 20,),
          TextField(
            onChanged: (value)=> email = value,
            keyboardType: TextInputType.emailAddress,
            decoration: textInputDecoration.copyWith(hintText: "enter your Email please"),
          ),
          SizedBox(height: 20,),
          TextField(
            onChanged: (value)=> password = value ,
            autocorrect: false,
            obscureText: true,
            decoration: textInputDecoration.copyWith(hintText: "enter your Password please"),
          ),
          SizedBox(height: 10,),
          CustomButton(
            label: "Register",
            callback: () async{
              await registerUser();
            },
          )
        ],
      ),
    );
  }
}

// Login
class Login extends StatefulWidget {
  static const String id = "LOGIN" ;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email ;
  String password ;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> LoginUser() async {
    FirebaseUser user = (await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    )).user;

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context)=> Chat(user: user,),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Text("Chat"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Hero(
              tag: 'logo',
              child: Container(
                child: Image.asset('assets/logo.png'),
              ),
            ),
          ),
          SizedBox(height: 20,),
          TextField(
            onChanged: (value)=> email = value,
            keyboardType: TextInputType.emailAddress,
            decoration: textInputDecoration.copyWith(hintText: "enter your Email please"),
          ),
          SizedBox(height: 20,),
          TextField(
            onChanged: (value)=> password = value ,
            autocorrect: false,
            obscureText: true,
            decoration: textInputDecoration.copyWith(hintText: "enter your Password please"),
          ),
          SizedBox(height: 10,),
          CustomButton(
            label: "Log In",
            callback: () async{
              await LoginUser();
            },
          )
        ],
      ),
    );;
  }
}


// chat

class Chat extends StatefulWidget {
  static const String id = "CHAT" ;
  final FirebaseUser user ;

  const Chat({Key key ,this.user}) :super(key :key);
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final Firestore firestore = Firestore.instance ;

  TextEditingController _textEditingController = TextEditingController();  // for edit text input
  ScrollController scrollController = ScrollController(); // for list view

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
        leading: Hero(
          tag: 'logo',
          child: Container(
            height: 40,
            child: Image.asset('assets/logo.png'),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon:Icon(Icons.close),
            onPressed: (){
              firebaseAuth.signOut();
              Navigator.of(context).popUntil((route) => route.isFirst );
            },
          )
        ],
      ),
    body: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore.collection('message').snapshots(),
              builder: (context,snapshot){
                if (!snapshot.hasData){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView();
              },
            ),
          ),
          Container(
            child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller:_textEditingController ,
                      decoration:  textInputDecoration.copyWith(hintText: "enter message"),

                    ),
                  ),
                  SendButton(
                    text : "Send",
                    callback: (){ },
                  )
                ],

            ),
          )
        ],
      ),
    ),
    );
  }
}

class SendButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;


  const SendButton({Key key,this.text, this.callback}): super(key : key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: callback,
      child: Text(text),
      color: Colors.red,
    );
  }
}

