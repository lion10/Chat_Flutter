import 'package:flutter/material.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat',
      theme: ThemeData.dark(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
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
            callback: (){},
          ),
          CustomButton(
            label: 'Register',
            callback: (){},
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
