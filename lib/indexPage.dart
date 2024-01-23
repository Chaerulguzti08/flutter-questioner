import 'package:flutter/material.dart';
import 'package:question1/controller.dart';
import 'package:flutter/services.dart';
import 'package:question1/home.dart';

class IndexPage extends StatefulWidget {
  // const IndexPage({super.key});
  final int selectedValue;
  IndexPage({Key? key, required this.selectedValue}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  List _listData = [];
  List _listProject = [];
  List<String> _textFormFieldValues = [];
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController from = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _dataProjectDetails = '';

  @override
  void initState() {
    _fetchData();
    _projectDataDetails();
    _projectData();
    super.initState();
  }

  Future<void> _fetchData() async {
    try {
      final data = await ApiController.fetchData(widget.selectedValue);
      setState(() {
        _listData = data;
        _textFormFieldValues = List.generate(data.length, (index) => '');
      });
    } catch (e) {
      print(e);
    }
  }

  void _onTextFormFieldChanged(int index, String newValue) {
    setState(() {
      _textFormFieldValues[index] = newValue;
    });
  }

  Future<void> _sendData() async {
    int? newId;
    int? checkEmail;
    try {
      checkEmail =
          await ApiController.sendCheckEmail(_listData[0]['id'], email.text);

      if (checkEmail == 1) {
        newId = await ApiController.sendRespondentsData(
          name.text,
          phoneNumber.text,
          email.text,
          from.text,
        );
      } else {
        newId = null;
      }
    } catch (e) {
      print(e);
    }

    if (newId != null) {
      for (int i = 0; i < _listData.length; i++) {
        try {
          final new_id_answer = await ApiController.sendData(
              _listData[i]['id'], _textFormFieldValues[i]);

          await ApiController.sendResponseData(_listData[i]['id'], newId,
              new_id_answer, _textFormFieldValues[i], email.text);
        } catch (e) {
          print(e);
        }
      }
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Thank You'),
            content: Text('Input Data Success.'),
            actions: [
              TextButton(
                onPressed: () {},
                child: DropdownButtonFormField(
                  hint: Text('Select Project'),
                  items: _listProject.map((item) {
                    return DropdownMenuItem(
                      value: item['id'],
                      child: Text(item['name'].toString()),
                    );
                  }).toList(),
                  onChanged: (newVal) {
                    setState(() {
                      dropdownvalue = newVal;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              IndexPage(selectedValue: dropdownvalue),
                        ),
                      );
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
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => home(),
                      ),
                    );
                  },
                  child: Text('Back'),
                ),
              )
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Email ini sudah di pakai.'),
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
  }

  Future<void> _projectDataDetails() async {
    try {
      final apiResponse =
          await ApiController.projectDataDetails(widget.selectedValue);
      final name = apiResponse['name'];
      setState(() {
        _dataProjectDetails = name;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _projectData() async {
    try {
      final data = await ApiController.projectData();
      setState(() {
        _listProject = data;
      });
    } catch (e) {
      print(e);
    }
  }

  var dropdownvalue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_dataProjectDetails),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => home(),
              ),
            );
          },
        ),
        backgroundColor: Color.fromARGB(255, 61, 61, 61),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 61, 61, 61),
          ),
        ),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(16.0),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: BorderSide(color: Colors.grey.shade300, width: 1.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          color: Color.fromARGB(255, 61, 61, 61),
                          padding: EdgeInsets.all(5.0),
                          child: Center(
                            child: Text(
                              "Data Respondent",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          controller: name,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.0), // Beri jarak vertikal
                        TextFormField(
                          controller: email,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email address.';
                            } else if (!RegExp(
                                    r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                                .hasMatch(value)) {
                              return 'Please enter a valid email address.';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.0), // Beri jarak vertikal
                        TextFormField(
                          controller: phoneNumber,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(),
                          ),
                          // keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.0), // Beri jarak vertikal
                        TextFormField(
                          controller: from,
                          decoration: InputDecoration(
                            labelText: 'From',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'From is Required';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _listData.length,
              itemBuilder: ((context, index) {
                return Card(
                  margin: EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          "${index + 1}. ${_listData[index]['question']}",
                        ),
                      ),
                      _listData[index]['type'] == "2"
                          ? Column(
                              children: [
                                RadioListTile(
                                  title: Text("Ya"),
                                  value: "Ya",
                                  groupValue: _textFormFieldValues[index],
                                  onChanged: (value) {
                                    setState(() {
                                      _textFormFieldValues[index] = value ?? "";
                                    });
                                  },
                                ),
                                RadioListTile(
                                  title: Text("Tidak"),
                                  value: "Tidak",
                                  groupValue: _textFormFieldValues[index],
                                  onChanged: (value) {
                                    setState(() {
                                      _textFormFieldValues[index] = value ?? "";
                                    });
                                  },
                                ),
                                RadioListTile(
                                  title: Text("Mungkin"),
                                  value: "Mungkin",
                                  groupValue: _textFormFieldValues[index],
                                  onChanged: (value) {
                                    setState(() {
                                      _textFormFieldValues[index] = value ?? "";
                                    });
                                  },
                                ),
                              ],
                            )
                          : Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                onChanged: (newValue) {
                                  _onTextFormFieldChanged(index, newValue);
                                },
                                decoration: InputDecoration(
                                  labelText: 'jawab',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                    ],
                  ),
                );
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // showDialog(
                    //   context: context,
                    //   builder: (context) {
                    //     return AlertDialog(
                    //       title: Text('Thank You'),
                    //       content: Text('Input Data Success.'),
                    //       actions: [
                    //         TextButton(
                    //           onPressed: () {
                    //             // Navigator.push(
                    //             //   context,
                    //             //   MaterialPageRoute(
                    //             //     builder: (context) => IndexPage(
                    //             //         selectedValue: widget.selectedValue),
                    //             //   ),
                    //             // );
                    //           },
                    //           child: DropdownButtonFormField(
                    //             hint: Text('Select Project'),
                    //             items: _listProject.map((item) {
                    //               return DropdownMenuItem(
                    //                 value: item['id'],
                    //                 child: Text(item['name'].toString()),
                    //               );
                    //             }).toList(),
                    //             onChanged: (newVal) {
                    //               setState(() {
                    //                 dropdownvalue = newVal;
                    //                 Navigator.push(
                    //                   context,
                    //                   MaterialPageRoute(
                    //                     builder: (context) => IndexPage(
                    //                         selectedValue: dropdownvalue),
                    //                   ),
                    //                 );
                    //               });
                    //             },
                    //             value: dropdownvalue,
                    //             decoration: InputDecoration(
                    //               border: OutlineInputBorder(),
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     );
                    //   },
                    // );
                    _sendData();
                  }
                },
                child: Icon(Icons.send),
                backgroundColor: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

 // Expanded(
          //   child: ListView.builder(
          //     itemCount: _listData.length,
          //     itemBuilder: ((context, index) {
          //       return Card(
          //         margin: EdgeInsets.all(5.0),
          //         child: ExpansionTile(
          //           title: Text(
          //             "${index + 1}. ${_listData[index]['question']}",
          //           ),
          //           children: [
          //             _listData[index]['type'] == "2"
          //                 ? Column(
          //                     children: [
          //                       RadioListTile(
          //                         title: Text("Ya"),
          //                         value: "Ya",
          //                         groupValue: _textFormFieldValues[index],
          //                         onChanged: (value) {
          //                           setState(() {
          //                             _textFormFieldValues[index] = value ?? "";
          //                           });
          //                         },
          //                       ),
          //                       RadioListTile(
          //                         title: Text("Tidak"),
          //                         value: "Tidak",
          //                         groupValue: _textFormFieldValues[index],
          //                         onChanged: (value) {
          //                           setState(() {
          //                             _textFormFieldValues[index] = value ?? "";
          //                           });
          //                         },
          //                       ),
          //                       RadioListTile(
          //                         title: Text("Mungkin"),
          //                         value: "Mungkin",
          //                         groupValue: _textFormFieldValues[index],
          //                         onChanged: (value) {
          //                           setState(() {
          //                             _textFormFieldValues[index] = value ?? "";
          //                           });
          //                         },
          //                       ),
          //                     ],
          //                   )
          //                 : Padding(
          //                     padding: EdgeInsets.all(8.0),
          //                     child: TextFormField(
          //                       onChanged: (newValue) {
          //                         _onTextFormFieldChanged(index, newValue);
          //                       },
          //                       decoration: InputDecoration(
          //                         labelText: 'Answer',
          //                         border: OutlineInputBorder(),
          //                       ),
          //                     ),
          //                   ),
          //           ],
          //         ),
          //       );
          //     }),
          //   ),
          // ),