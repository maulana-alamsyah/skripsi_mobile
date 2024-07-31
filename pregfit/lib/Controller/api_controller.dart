import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pregfit/Config/config.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:pregfit/Screens/Onboarding/onboarding.dart';

class APIController {
  final client = HttpClient();
  late final String token;
  final String apiKey = "aW5pYXBpa2V5bG9o";

  APIController() {
    final box = GetStorage();
    token = box.read('token') ?? '';
  }

  void signOut() async {
    var box = GetStorage(); 
    await box.remove('token');
  }

  void saveUserInfo(userInfo) async {
    var box = GetStorage();
    await box.write('user', userInfo);
  }


  //check nomor telepon
  Future<int> checkNO(String noHP) async {
    try {
      final requestBodyBytes = utf8.encode(json.encode({'no_hp': noHP}));
      final request =
          await client.postUrl(Uri.parse("${Config.baseURL}/api/check_no"));
      request.headers.set(
          HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
      request.headers.set('Content-Length', requestBodyBytes.length.toString());
      request.write(json.encode({'no_hp': noHP}));

      final response = await request.close();

      return response.statusCode;
    } catch (e) {
      return 0;
    }
  }

  //send OTP
  Future<int> sendOTP(String noHP) async {
    try {
      final requestBodyBytes = utf8.encode(json.encode({'no_hp': noHP}));
      final request =
          await client.postUrl(Uri.parse("${Config.baseURL}/api/send_otp"));
      request.headers.set(
          HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
      request.headers.set('Content-Length', requestBodyBytes.length.toString());
      request.write(json.encode({'no_hp': noHP}));

      final response = await request.close();

      return response.statusCode;
    } catch (e) {
      return 0;
    }
  }

  //verif OTP
  Future<Map<String, dynamic>> verifOTP(String noHP, int action, String otp, {String email=""}) async {
    try {
      final requestBodyBytes = utf8.encode(json.encode({'no_hp': noHP, 'action': action, 'otp': otp, 'email': email}));
      final request =
          await client.postUrl(Uri.parse("${Config.baseURL}/api/verif_otp"));
      request.headers.set(
          HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
      request.headers.set('Content-Length', requestBodyBytes.length.toString());
      request.write(json.encode({'no_hp': noHP, 'action': action, 'otp': otp, 'email': email}));

      final response = await request.close();

      // Read response body as String
      String responseBody = await response.transform(utf8.decoder).join();

      // Parse response body JSON
      Map<String, dynamic> jsonResponse = json.decode(responseBody);

      return jsonResponse; // Return parsed JSON response
    } catch (e) {
      return {'error': 'An error occurred'};
    }
  }

  Future<dynamic> verifOTPMail(String otp, String email) async {
    final requestBodyBytes =
        utf8.encode(json.encode({'otp': otp, 'email': email}));
    try {
      final request =
          await client.postUrl(Uri.parse("${Config.baseURL}/api/verify_otp_mail"));
      request.headers.set(
          HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
      request.headers.set('Content-Length', requestBodyBytes.length.toString());
      request.headers.set('api-key', apiKey);
      request.write(json.encode({'otp': otp, 'email': email}));

      final response = await request.close();

      return response.statusCode;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> sendOTPMail(String email) async {
    final requestBodyBytes = utf8.encode(json.encode({'email': email}));
    try {
      final request =
          await client.postUrl(Uri.parse("${Config.baseURL}/api/send_otp_mail"));
      request.headers.set(
          HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
      request.headers.set('Content-Length', requestBodyBytes.length.toString());
      request.headers.set('api-key', apiKey);
      request.write(json.encode({'email': email}));

      final response = await request.close();

      return response.statusCode;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //login
  Future<dynamic> attemptLogIn(String noHp) async {
    final requestBodyBytes = utf8.encode(json.encode({'no_hp': noHp}));
    try {
      final request =
          await client.postUrl(Uri.parse("${Config.baseURL}/api/signin"));
      request.headers.set(
          HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
      request.headers.set('Content-Length', requestBodyBytes.length.toString());
      request.write(json.encode({'no_hp': noHp}));

      final response = await request.close();

      if (response.statusCode == 200) {
        return jsonDecode(await response.transform(utf8.decoder).join());
      } else {
        return jsonDecode(await response.transform(utf8.decoder).join());
      }
    } catch (e) {
      if (e is SocketException) {
        debugPrint('Network error: ${e.message}');
      } else {
        debugPrint('Error: $e');
      }
    }
  }

  Future<dynamic> attemptLogInhtp(String noHp) async {
      try {
        final url = Uri.parse('${Config.baseURL}/api/signin');
        final headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Basic ${base64Encode(utf8.encode(noHp))}'
        };
        final response = await http.post(url, headers: headers);

        return jsonDecode(response.body);
      } catch (e) {
        if (e is SocketException) {
          debugPrint('Network error: ${e.message}');
        } else {

          debugPrint('Error: $e');
        }
      }
    }
  
  //register
  Future<dynamic> attemptRegister(String noHp) async {
    final requestBodyBytes = utf8.encode(json.encode({'no_hp': noHp}));
    try {
      final request =
          await client.postUrl(Uri.parse("${Config.baseURL}/api/users"));
      request.headers.set(
          HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
      request.headers.set('Content-Length', requestBodyBytes.length.toString());
      request.write(json.encode({'no_hp': noHp}));

      final response = await request.close();

      if (response.statusCode == 201) {
        return jsonDecode(await response.transform(utf8.decoder).join());
      } else if (response.statusCode == 409) {
        return 'nomor sudah terdaftar';
      }
    } catch (e) {
      if (e is SocketException) {
        debugPrint('Network error: ${e.message}');
      } else {
        debugPrint('Error: $e');
      }
    }
  }

  //update no HP
  Future<dynamic> updateNoHP(String noHp, String email) async {
    final requestBodyBytes =
        utf8.encode(json.encode({'no_hp_baru': noHp, 'email': email}));
    try {
      final request =
          await client.postUrl(Uri.parse("${Config.baseURL}/api/update_nohp"));
      request.headers.set(
          HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
      request.headers.set('Content-Length', requestBodyBytes.length.toString());
      request.write(json.encode({'no_hp_baru': noHp, 'email': email}));

      final response = await request.close();

      if (response.statusCode == 200) {
        return jsonDecode(await response.transform(utf8.decoder).join());
      } else if (response.statusCode == 500) {
        return 'No HP tidak dapat digunakan, atau sudah digunakan pengguna lain';
      }
    } catch (e) {
      if (e is SocketException) {
        debugPrint('Network error: ${e.message}');
      } else {
        debugPrint('Error: $e');
      }
    }
  }

  //chatbot predict
  Future<dynamic> chatbotPredict(String message) async {
    try {
      final requestBodyBytes = utf8.encode(json.encode({'message': message}));
      final request =
          await client.postUrl(Uri.parse("${Config.baseURL}/api/chatbot"));
      request.headers.set(
          HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
      request.headers.set('Content-Length', requestBodyBytes.length.toString());
      request.write(json.encode({'message': message}));

      final response = await request.close();

      var responseBody =
          json.decode(await response.transform(utf8.decoder).join());

      return responseBody;
    } catch (e) {
      if (e is SocketException) {
        debugPrint('Network error: ${e.message}');
      } else {
        debugPrint('Error: $e');
      }
    }
  }

  //check email
  Future<dynamic> checkEmail(String email) async {
    try {
      final requestBodyBytes = utf8.encode(json.encode({'email': email}));
      final request =
          await client.postUrl(Uri.parse("${Config.baseURL}/api/check_email"));
      request.headers.set(
          HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
      request.headers.set('Content-Length', requestBodyBytes.length.toString());
      request.write(json.encode({'email': email}));

      final response = await request.close();

      return response.statusCode;
    } catch (e) {
      if (e is SocketException) {
        debugPrint('Network error: ${e.message}');
      } else {
        debugPrint('Error: $e');
      }
    }
  }

  //get history
  Future<dynamic> getHistory(context) async {
    try {
      final request =
          await client.getUrl(Uri.parse("${Config.baseURL}/api/history"));
      request.headers.set(
          HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
      request.headers.set(HttpHeaders.authorizationHeader, "Bearer $token");

      final response = await request.close();

      if (response.statusCode == 200) {
        return jsonDecode(await response.transform(utf8.decoder).join());
      } else if (response.statusCode == 401) {
        signOut();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Onboarding()));
      }
    } catch (e) {
      if (e is SocketException) {
        debugPrint('Network error: ${e.message}');
      } else {
        debugPrint('Error: $e');
      }
    }
  }

  //get popular
  Future<dynamic> getPopular(context) async {
    try {
      final request =
          await client.getUrl(Uri.parse("${Config.baseURL}/api/popular"));
      request.headers.set(
          HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
      request.headers.set(HttpHeaders.authorizationHeader, "Bearer $token");

      final response = await request.close();

      if (response.statusCode == 200) {
        final jsonResponse = await response.transform(utf8.decoder).join();
        final decodedResponse = jsonDecode(jsonResponse) as List<dynamic>;
        final apiResponse = decodedResponse.cast<Map<String, dynamic>>();

        return apiResponse;
      } else if (response.statusCode == 401) {
        signOut();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Onboarding()));
      }
    } catch (e) {
      if (e is SocketException) {
        debugPrint('Network error: ${e.message}');
      } else {
        debugPrint('Error: $e');
      }
    }
  }

  //add history
  Future<dynamic> addHistory(String jenisYoga) async {
    String waktu;
    if (jenisYoga == 'Trimester 1') {
      waktu = '2 Menit';
    } else if (jenisYoga == 'Trimester 2') {
      waktu = '4 Menit';
    } else if (jenisYoga == 'Trimester 3') {
      waktu = '6 Menit';
    } else {
      waktu = '1 Menit';
    }
    try {
      final tanggal = DateFormat("dd/MM/yyyy", "id_ID").format(DateTime.now());
      final request =
          await client.postUrl(Uri.parse("${Config.baseURL}/api/history"));
      request.headers.set(
          HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
      request.headers.set(HttpHeaders.authorizationHeader, "Bearer $token");
      final requestBodyBytes = utf8.encode(json.encode({
        'tanggal': tanggal,
        'waktu': waktu,
        'jenis_yoga': jenisYoga,
      }));

      request.headers.set('Content-Length', requestBodyBytes.length.toString());
      request.write(json.encode({
        'tanggal': tanggal,
        'waktu': waktu,
        'jenis_yoga': jenisYoga,
      }));

      final response = await request.close();

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        return false;
      }
    } catch (e) {
      if (e is SocketException) {
        debugPrint('Network error: ${e.message}');
      } else {
        debugPrint('Error: $e');
      }
    }
  }

  //check token
  Future<dynamic> checkToken(context) async {
    try {
      final request =
          await client.getUrl(Uri.parse("${Config.baseURL}/api/check_token"));
      request.headers.set(
          HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
      request.headers.set(HttpHeaders.authorizationHeader, "Bearer $token");

      final response = await request.close();

      if (response.statusCode == 200) {
        return jsonDecode(await response.transform(utf8.decoder).join());
      } else if (response.statusCode == 401) {
        signOut();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const Onboarding()));
      }
    } catch (e) {
      if (e is SocketException) {
        debugPrint('Network error: ${e.message}');
      } else {
        debugPrint('Error: $e');
      }
    }
  }

  Future<bool> checkTokenMain() async {
    try {
      final request =
          await client.getUrl(Uri.parse("${Config.baseURL}/api/check_token"));
      request.headers.set(
          HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
      request.headers.set(HttpHeaders.authorizationHeader, "Bearer $token");

      final response = await request.close();
      return response.statusCode == 200;
    } catch (e) {
      if (e is SocketException) {
        debugPrint('Network error: ${e.message}');
      } else {
        debugPrint('Error: $e');
      }
      return false;
    }
  }

  //get user
  Future<dynamic> getUser(context) async {
    try {
      final request =
          await client.getUrl(Uri.parse("${Config.baseURL}/api/users"));
      request.headers.set(
          HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
      request.headers.set(HttpHeaders.authorizationHeader, "Bearer $token");

      final response = await request.close();

      if (response.statusCode == 200) {
        return jsonDecode(await response.transform(utf8.decoder).join());
      } else if (response.statusCode == 401) {
        signOut();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const Onboarding()));
      }
    } catch (e) {
      if (e is SocketException) {
        debugPrint('Network error: ${e.message}');
      } else {
        debugPrint('Error: $e');
      }
    }
  }

  Future<dynamic> getUserInfo() async {
    try {
      final request =
          await client.getUrl(Uri.parse("${Config.baseURL}/api/users"));
      request.headers.set(
          HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
      request.headers.set(HttpHeaders.authorizationHeader, "Bearer $token");

      final response = await request.close();

      if (response.statusCode == 200) {
        var userInfo = jsonDecode(await response.transform(utf8.decoder).join());
        saveUserInfo(userInfo);
        return true;
      } else if (response.statusCode == 401) {
        return false;
      }
    } catch (e) {
      if (e is SocketException) {
        debugPrint('Network error: ${e.message}');
      } else {
        debugPrint('Error: $e');
      }
    }
  }

  //update user
  Future<dynamic> updateUser(context,
      String nama, String tanggal, String usiaKandungan, String email) async {
    if (usiaKandungan == 'null') {
      usiaKandungan = '0-4 Bulan';
    }

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    String noHP = decodedToken['no_hp'];
    DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(tanggal);
  String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
    String userInfoJson = json.encode({
      'no_hp': noHP,
      'email': email,
      'nama': nama,
      'usia_kandungan': usiaKandungan,
      'tanggal_lahir': formattedDate,
    });

    // Decode the JSON string back to a map
    Map<String, dynamic> userInfo = json.decode(userInfoJson);

    try {
      final request =
          await client.putUrl(Uri.parse("${Config.baseURL}/api/users"));
      request.headers.set(
          HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
      request.headers.set(HttpHeaders.authorizationHeader, "Bearer $token");
      if (usiaKandungan != 'null') {
        final requestBodyBytes = utf8.encode(json.encode({
          'no_hp': noHP,
          'email': email,
          'nama': nama,
          'usia_kandungan': usiaKandungan,
          'tanggal_lahir': tanggal
        }));

        request.headers
            .set('Content-Length', requestBodyBytes.length.toString());
        request.write(json.encode({
          'no_hp': noHP,
          'email': email,
          'nama': nama,
          'usia_kandungan': usiaKandungan,
          'tanggal_lahir': tanggal
        }));
      } else {
        final requestBodyBytes = json.encode({
          'no_hp': noHP,
          'email': email,
          'nama': nama,
          'usia_kandungan': 'null',
          'tanggal_lahir': tanggal
        });

        request.headers
            .set('Content-Length', requestBodyBytes.length.toString());
        request.write(json.encode({
          'no_hp': noHP,
          'email': email,
          'nama': nama,
          'usia_kandungan': 'null',
          'tanggal_lahir': tanggal
        }));
      }

      final response = await request.close();

      if (response.statusCode == 401) {
        signOut();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Onboarding()));
      }

      if(response.statusCode == 200){
        saveUserInfo(userInfo);
      }
      
      return response.statusCode;
      
    } catch (e) {
      if (e is SocketException) {
        debugPrint('Network error: ${e.message}');
      } else {
        debugPrint('Error: $e');
      }
    }
  }

  //feedback
  Future<dynamic> addFeedback(String komentar) async {
    try {
      final request = await client
          .postUrl(Uri.parse("${Config.baseURL}/api/feedback"));
      request.headers.set(
          HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
      request.headers.set(HttpHeaders.authorizationHeader, "Bearer $token");
      final requestBodyBytes = utf8.encode(json.encode({
        'komentar': komentar,
      }));

      request.headers.set('Content-Length', requestBodyBytes.length.toString());
      request.write(json.encode({
        'komentar': komentar,
      }));

      final response = await request.close();

      if (response.statusCode == 201) {
        return true;
      } else if (response.statusCode == 401) {
        return false;
      } else {
        return false;
      }
    } catch (e) {
      if (e is SocketException) {
        debugPrint('Network error: ${e.message}');
      } else {
        debugPrint(e.toString());
      }
    }
  }
}


