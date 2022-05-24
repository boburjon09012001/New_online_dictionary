import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:online_data_dictionary/model/model.dart';
import '../url.dart';

class DictionaryService{

  Future<List<DictionaryModel>> getMeaning({String? word}) async{
    final url = "$URL/$word";
    try {
     final req = await  http.get(Uri.parse(url));
     print(req.statusCode);
     if(req.statusCode == 200){
       print(req.body);
       final dictionaryModel = dictionaryModelFromJson(req.body);
       return dictionaryModel;
     }
     else {
       print(req.body);
       final dictionaryModel = dictionaryModelFromJson(req.body);

       return dictionaryModel;

     }
   } on SocketException catch(_) {
     return Future.error("No Network found");
   } catch (_){
     return Future.error("Something occured");
   }
  }
}