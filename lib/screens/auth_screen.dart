import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import './../providers/auth.dart';

enum AuthMode { Login, Signup }

class AuthScreen extends StatelessWidget {
  static const routeName ='/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(200, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(150, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1]
              )
            ),
          ),
          SingleChildScrollView(
            child: Container(
              width: deviceSize.width,
              height: deviceSize.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      padding: EdgeInsets.symmetric(horizontal: 90, vertical: 8),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).errorColor,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Theme.of(context).errorColor,
                            offset: Offset(0, 2)
                          )
                        ]
                      ),
                      child: Text(
                        'Petty Shop',
                        style: TextStyle(
                          color: Theme.of(context).accentTextTheme.title.color,
                          fontFamily: 'Anton',
                          fontSize: 50,
                          fontWeight: FontWeight.normal
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),      
                  )
                ],
              ),
            ),
          )
        ],
      )
    );
  }

}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> with SingleTickerProviderStateMixin{
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': ''
  };

  AnimationController _animationController;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;

  var _isLoading = false;
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _slideAnimation = Tween<Offset>(
      // TODO: ANIMATION NOT WORKING CORRECTLY. SO ADD 0 IN THE BEGIN
      // begin: Offset(0, -1.5),
      begin: Offset(0, 0),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.fastOutSlowIn)
    );
    _opacityAnimation = Tween(
      // TODO: ANIMATION NOT WORKING CORRECTLY. SO ADD 1.0 IN THE BEGIN
      // begin: 0.0, end: 1.0
      begin: 1.0, end: 1.0
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn)
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  Future<void> _submit() async {
    if(!_formKey.currentState.validate()) {
      // Invalid
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;  
    });
    try {
      if (_authMode == AuthMode.Login) {
        // Login here
        await Provider.of<Auth>(context, listen: false).login(_authData['email'], _authData['password']);
      } else {
        // Sign up here
        await Provider.of<Auth>(context, listen: false).signup(_authData['email'], _authData['password']);
      }
    } on PlatformException catch(error) {
      var errorMessage = 'Authentication Failed';
      if (error.message != null) {
        errorMessage = error.message;
      }
      _showErrorDialog(errorMessage);
    } catch(error) {
      var errorMessage = 'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
    
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Signup) {
      setState(() {
        _authMode = AuthMode.Login;
      });
    } else if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    }
  }

  void _showErrorDialog(errorMsg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error occured'),
        content: Text(errorMsg),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(ctx), 
            child: Text('Okay')
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height: _authMode == AuthMode.Signup ? 320 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        // constraints: BoxConstraints(minHeight: 320),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid E-Mail';
                    }
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: passwordController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Password is too short';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                    maxHeight: _authMode == AuthMode.Signup ? 120: 0
                  ),
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Confirm Password'),
                        obscureText: true,
                        validator: _authMode == AuthMode.Signup 
                          ? (value) {
                          if (value != passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        } : null
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    child: Text('${_authMode == AuthMode.Signup ? 'SIGN UP' : 'LOGIN'}'),
                    onPressed: _submit,
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                    padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                  ),
                FlatButton( 
                  child: Text('${_authMode == AuthMode.Signup ? 'LOGIN' : 'SIGN UP'} INSTEAD'),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(horizontal: 30.0,  vertical: 8.0),
                  textColor: Theme.of(context).primaryColor,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
