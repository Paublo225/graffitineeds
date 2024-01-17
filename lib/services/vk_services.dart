import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:graffitineeds/helpers/firebase_names.dart';
import 'package:graffitineeds/models/vkNewsModel.dart';
import 'package:http/http.dart';
import 'package:requests/requests.dart';

class VkService {
  String _accessToken =
      "9224d1d5209d92b0e445d1157d41056a69e838764579492566e4f9e67c9e9cfe9ed0332bb951b3409bf66";
  static getServiceKey(String clientId, String client) async {
    await Requests.get(
        "https://oauth.vk.com/access_token?client_id=$clientId&client_secret=$client&v=5.131&grant_type=client_credentials");
  }

  static String _serviceToken =
      "60650dc460650dc460650dc4cb637061f46606560650dc40482a95e1729552867cae229";
  static Future<VkApiResponse?> getPosts() async {
    VkApiResponse? vkapi;
    final String url = "https://api.vk.com/method/wall.get";

    final vkService =
        await FirebaseFirestore.instance.collection(TEX_RABOTI).doc("tokens");

    await vkService.get().then((value) async {
      var params = {
        "access_token": value.get("vkapi"),
        "owner_id": -138814966,
        "count": 30,
        "v": 5.137
      };
      await Requests.get(url, queryParameters: params).then((value) {
        vkapi = VkApiResponse.fromMap(value.json()["response"]);
      });
    });

    return vkapi;
  }
}
