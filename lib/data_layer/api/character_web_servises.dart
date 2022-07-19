import '../../constants/strings.dart';
import 'package:dio/dio.dart';

class CharacterWebServises {
  late Dio dio;
  CharacterWebServises() {
    //initit of dio
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true, //200, 404, ...
      connectTimeout: 20 * 1000, //60 seconds try to connect to the server
      receiveTimeout: 20 * 1000,
    );

    dio = Dio(options);
  }

  Future<List<dynamic>> getAllCharacters() async {
    try {
      Response response = await dio.get('characters');
      return response.data;
    } catch (e) {
      print('CharacterWebServiseeeeeeeeeeeeeeeeeeeeeeeeees ${e.toString()}');
      return [];
    }
  }

  Future<List<dynamic>> getAllCharacterQuotes(String charName) async {
    try {
      Response response =
          await dio.get('quote', queryParameters: {'author': charName});
      return response.data;
    } catch (e) {
      print('${e.toString()}');
      return [];
    }
  }
}
