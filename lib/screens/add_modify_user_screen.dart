import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:habit_up_task/constants.dart';
import 'package:habit_up_task/components/rounded_button.dart';
import 'package:http/http.dart' as http;
import 'package:habit_up_task/components/key.dart';

class AddModifyUserScreen extends StatelessWidget {
  late String name;
  late String email;
  late String gender;
  late String status;
  late int id;
  late bool willAdd;

  AddModifyUserScreen(
      {this.email = '',
      this.name = '',
      this.gender = '',
      this.status = '',
      this.id = 0}) {
    willAdd = name.isEmpty;
  }

  Future<int> addUser(
      String name, String email, String gender, String status) async {
    var headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json'
    };
    var request =
        http.Request('POST', Uri.parse('https://gorest.co.in/public/v2/users'));
    request.body = json.encode(
        {"email": email, "name": name, "gender": gender, "status": status});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    final respStr = await response.stream.bytesToString();
    print(respStr);

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
    return response.statusCode;
  }

  Future<int> modifyUser(
      String name, String email, String gender, String status) async {
    var headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'PATCH', Uri.parse('https://gorest.co.in/public/v2/users/$id'));
    request.body = json.encode(
        {"email": email, "name": name, "gender": gender, "status": status});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    final respStr = await response.stream.bytesToString();
    print(respStr);
    return response.statusCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          decoration: const BoxDecoration(
            color: Color(0xffF2F2F2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  willAdd ? 'Add User' : 'Modify User',
                  style: const TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff383838),
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                controller: name.isEmpty
                    ? TextEditingController()
                    : TextEditingController(text: name),
                onChanged: (value) {
                  name = value;
                },
                autofocus: true,
                textAlign: TextAlign.center,
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Enter name.'),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                controller: email.isEmpty
                    ? TextEditingController()
                    : TextEditingController(text: email),
                onChanged: (value) {
                  email = value;
                },
                autofocus: true,
                textAlign: TextAlign.center,
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Enter email.'),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                controller: gender.isEmpty
                    ? TextEditingController()
                    : TextEditingController(text: gender),
                onChanged: (value) {
                  gender = value;
                },
                autofocus: true,
                textAlign: TextAlign.center,
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Enter gender.'),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                controller: status.isEmpty
                    ? TextEditingController()
                    : TextEditingController(text: status),
                onChanged: (value) {
                  status = value;
                },
                autofocus: true,
                textAlign: TextAlign.center,
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Enter status.'),
              ),
              const SizedBox(
                height: 20.0,
              ),
              RoundedButton(
                color: const Color(0xff066163),
                onPressed: () async {
                  if (willAdd) {
                    if (email != '' &&
                        name != '' &&
                        gender != '' &&
                        status != '') {
                      int statusCode =
                          await addUser(name, email, gender, status);
                      if (statusCode == 201) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            duration: Duration(milliseconds: 2000),
                            content: Text(
                              'User added successFully',
                              style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            duration: Duration(milliseconds: 2000),
                            content: Text(
                              'Something went wrong, Please try again!',
                              style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                            ),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                      Navigator.pop(context, statusCode);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(milliseconds: 2000),
                          content: Text(
                            'Fill all the details!',
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                          ),
                          backgroundColor: Color(0xff066163),
                        ),
                      );
                    }
                  } else {
                    int statusCode =
                        await modifyUser(name, email, gender, status);
                    if (statusCode == 200) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(milliseconds: 2000),
                          content: Text(
                            'User Modified successFully',
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(milliseconds: 2000),
                          content: Text(
                            'Something went wrong, Please try again!',
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                          ),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                    Navigator.pop(context, statusCode);
                  }
                },
                title: (willAdd) ? 'Add' : 'Modify',
              )
            ],
          ),
        ),
      ),
    );
  }
}
