import 'package:flutter/material.dart';
import 'package:question1/controller.dart';
import 'package:question1/indexPage.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);
  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  // List<Map<String, dynamic>> _listData = [];
  List _listData = [];

  @override
  void initState() {
    _projectData();
    super.initState();
  }

  Future<void> _projectData() async {
    try {
      final data = await ApiController.projectData();
      setState(() {
        _listData = data;
      });
    } catch (e) {
      print(e);
    }
  }

  var dropdownvalue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logob.png',
              width: 300,
            ),
            SizedBox(height: 5),
            Text(
              'Questioner',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 250,
              child: DropdownButtonFormField(
                hint: Text('Select Project'),
                items: _listData.map((item) {
                  return DropdownMenuItem(
                    value: item['id'],
                    child: Text(item['name'].toString()),
                  );
                }).toList(),
                onChanged: (newVal) {
                  setState(() {
                    dropdownvalue = newVal;
                  });
                },
                value: dropdownvalue,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                if (dropdownvalue != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          IndexPage(selectedValue: dropdownvalue),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Please select item.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 61, 61, 61),
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 32,
                ),
              ),
              child: Text(
                'Submit',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
