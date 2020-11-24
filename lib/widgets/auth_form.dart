import 'dart:io';

import 'package:FlutterChat/models/auth_data.dart';
import 'package:FlutterChat/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(AuthData authData) onSubmit;

  AuthForm(this.onSubmit);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final AuthData _authdata = AuthData();

  _submit() {
    bool isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_authdata.image == null && _authdata.isSignup) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Precisamos da sua foto!!!'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (isValid) {
      widget.onSubmit(_authdata);
    }
  }

  _handlePickedImage(File image) {
    _authdata.image = image;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    if (_authdata.isSignup) UserImagePicker(_handlePickedImage),
                    if (_authdata.isSignup)
                      TextFormField(
                        key: ValueKey('name'),
                        decoration: InputDecoration(
                          labelText: 'Nome',
                        ),
                        initialValue: _authdata.name,
                        onChanged: (value) => _authdata.name = value,
                        validator: (value) {
                          if (value == null || value.trim().length < 4) {
                            return 'Nome deve ter no mínimo 4 caracteres.';
                          }
                          return null;
                        },
                      ),
                    TextFormField(
                      key: ValueKey('email'),
                      decoration: InputDecoration(
                        labelText: 'E-mail',
                      ),
                      initialValue: _authdata.email,
                      onChanged: (value) => _authdata.email = value,
                      validator: (value) {
                        if (value == null || !value.contains('@')) {
                          return 'Forneça um e-mail válido.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      key: ValueKey('password'),
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                      ),
                      initialValue: _authdata.password,
                      onChanged: (value) => _authdata.password = value,
                      validator: (value) {
                        if (value == null || value.trim().length < 7) {
                          return 'Senha deve ter no mínimo 7 caracteres.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    RaisedButton(
                      onPressed: _submit,
                      child: Text(_authdata.isLogin ? 'Entrar' : 'Cadastrar'),
                    ),
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          _authdata.toggleMode();
                        });
                      },
                      textColor: Theme.of(context).primaryColor,
                      child: Text(_authdata.isLogin
                          ? 'Criar uma nova conta?'
                          : 'Já possui uma conta?'),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
