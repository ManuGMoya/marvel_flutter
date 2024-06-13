import 'package:api_client/src/check_internet.dart';
import 'package:api_client/src/marvel_interceptor.dart';
import 'package:dio/dio.dart';

class ApiService {
  ApiService(this.dio) {
    dio.interceptors.add(MarvelInterceptor());
  }

  final String baseUrl = 'https://gateway.marvel.com/';
  Dio dio = Dio();

  Future<dynamic> getAllCharacters(int offset, int limit) async {
    if (await CheckInternet.isConnected()) {
      final response = await dio.get('$baseUrl/v1/public/characters',
          queryParameters: {'offset': offset, 'limit': limit});
      return _processResponse(response);
    } else {
      throw Exception('Not Internet connection');
    }
  }

  Future<dynamic> getCharacterById(int characterId) async {
    if (await CheckInternet.isConnected()) {
      final response =
          await dio.get('$baseUrl/v1/public/characters/$characterId');
      final results = _processResponse(response);
      if (results is List<dynamic>) {
        return results[0];
      } else {
        throw Exception('Expected a list but got ${results.runtimeType}');
      }
    } else {
      throw Exception('Not Internet connection');
    }
  }

  Future<dynamic> getCharacterByStartName(
      int offset, int limit, String nameStartsWith) async {
    if (await CheckInternet.isConnected()) {
      final response = await dio.get('$baseUrl/v1/public/characters',
          queryParameters: {
            'offset': offset,
            'limit': limit,
            'nameStartsWith': nameStartsWith
          });
      return _processResponse(response);
    } else {
      throw Exception('Not Internet connection');
    }
  }

  Future<dynamic> getComicsByCharacterId(
      int characterId, int offset, int limit) async {
    if (await CheckInternet.isConnected()) {
      final response = await dio.get(
          '$baseUrl/v1/public/characters/$characterId/comics',
          queryParameters: {'offset': offset, 'limit': limit});
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load data from API');
      }
    } else {
      throw Exception('Not Internet connection');
    }
  }

  dynamic _processResponse(Response response) {
    if (response.statusCode == 200) {
      final decodedResponse = response.data;
      final data = decodedResponse['data'];
      final results = data['results'];
      return results;
    } else {
      throw Exception('Failed to load data from API');
    }
  }
}
