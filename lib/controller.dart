import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiController {
  // GET DATA QUESTION
  static Future<List> fetchData(int id) async {
    final response = await http
        .get(Uri.parse("https://prupa.id/dem/questioner/api/question/${id}/"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'] as List<dynamic>;
    } else {
      throw Exception('Failed to load data');
    }
  }

  // GET DATA PROJECT
  static Future<List> projectData() async {
    final response = await http
        .get(Uri.parse("https://prupa.id/dem/questioner/api/project/"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  // GET DATA PROJECT BY ID
  static Future<Map<String, dynamic>> projectDataDetails(int id) async {
    final response = await http
        .get(Uri.parse("https://prupa.id/dem/questioner/api/project/${id}/"));
    if (response.statusCode == 200) {
      final responseData =
          jsonDecode(response.body)['data'][0] as Map<String, dynamic>;
      return responseData;
    } else {
      throw Exception('Failed to load data');
    }
  }

  // POST DATA ANSWER
  static Future<int> sendData(int questionId, String answer) async {
    final response = await http.post(
      Uri.parse("https://prupa.id/dem/questioner/api/answer/"),
      body: jsonEncode({
        'question_id': questionId,
        'answer': answer,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final newId = responseData['id'] as int;
      return newId;
    } else {
      print('Gagal mengirim data 1: ${response.statusCode}');
      throw Exception('Failed to send data');
    }
  }

  // POST DATA RESPONDENT
  static Future<int> sendRespondentsData(
      String name, String phone_number, String email, String froms) async {
    final response = await http.post(
      Uri.parse("https://prupa.id/dem/questioner/api/respondents/"),
      body: jsonEncode({
        'name': name,
        'phone_number': phone_number,
        'email': email,
        'froms': froms,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final newId = responseData['id'] as int;

      return newId;
    } else {
      print('Gagal mengirim data 2: ${response.statusCode}');
      throw Exception('Failed to send data');
    }
  }

  // POST DATA RESPONSE
  static Future<void> sendResponseData(int question_Id, int respondent_id,
      int answer_id, String answer, String email) async {
    final response = await http.post(
      Uri.parse("https://prupa.id/dem/questioner/api/response/"),
      body: jsonEncode({
        'question_id': question_Id,
        'respondent_id': respondent_id,
        'answer_id': answer_id,
        'answer': answer,
        'email': email,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print('input data respondent sukses');
    } else {
      print('Gagal mengirim data 3: ${response.statusCode}');
    }
  }

  static Future<int> sendCheckEmail(int questionId, String email) async {
    final response = await http.post(
      Uri.parse("https://prupa.id/dem/questioner/api/checkEmail/"),
      body: jsonEncode({
        'question_id': questionId,
        'email': email,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData == false) {
        return 1;
      } else {
        return 2;
      }
    } else {
      print('Gagal mengirim data 1: ${response.statusCode}');
      throw Exception('Failed to send data');
    }
  }
}
