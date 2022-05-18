import 'package:flutter/material.dart';
import 'package:habit_up_task/components/rounded_button.dart';
import 'package:habit_up_task/screens/add_modify_user_screen.dart';
import 'package:http/http.dart' as http;
import 'package:habit_up_task/components/key.dart';

class UserDataScreen extends StatelessWidget {
  final String userName;
  final String email;
  final String gender;
  final String status;
  final int id;

  UserDataScreen(
      {required this.userName,
      required this.email,
      required this.gender,
      required this.status,
      required this.id});

  Future<String?> _showAlertDialog(
      BuildContext context, String userName, int id) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'CAUTION !',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete user: $userName ?'),
                const Text('Press yes to delete!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop("no");
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                Navigator.of(context).pop("yes");
                await deleteUser(id);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteUser(int id) async {
    var headers = {'Authorization': 'Bearer $accessToken'};
    var request = http.Request(
        'DELETE', Uri.parse('https://gorest.co.in/public/v2/users/$id'));
    request.body = '''''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff757575),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              userName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 30.0,
                color: Color(0xff383838),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              'E-mail: $email',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20.0,
                color: Color(0xff066163),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              'Gender: $gender',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20.0,
                color: Color(0xff066163),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Status:  ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Color(0xff066163),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  status,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: (status == 'active') ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            RoundedButton(
              color: Colors.red,
              onPressed: () async {
                print('Delete button pressed');
                final result = await _showAlertDialog(context, userName, id);
                Navigator.pop(context, result);
              },
              title: 'Delete User',
            ),
            RoundedButton(
              color: Colors.green,
              onPressed: () async {
                print('Modify button pressed');
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddModifyUserScreen(
                      name: userName,
                      email: email,
                      gender: gender,
                      status: status,
                      id: id,
                    ),
                  ),
                );
                Navigator.pop(context, result);
              },
              title: 'Modify User',
            ),
          ],
        ),
      ),
    );
  }
}
