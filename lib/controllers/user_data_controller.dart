import 'package:get/get.dart';
import 'package:signin_singout_anonymous/models/user_data_model.dart';
import 'package:signin_singout_anonymous/utills/atributes.dart';

class UserDataController extends GetxController {
  UserDataModel userDataModel = UserDataModel(
    email: getStore.read('email') ?? "",
    uid: getStore.read('uid') ?? "",
    displayName: getStore.read('displayName') ?? "",
    phoneNumber: getStore.read('phoneNumber') ?? "",
    photoURl: getStore.read('photoURl') ?? "",
    token: getStore.read('token') ?? "",
  );

  initilization({
    required String email,
    required String uid,
    required String displayName,
    String? phoneNumber,
    required String photoURI,
    required String token,
  }) {
    userDataModel.email = email;
    userDataModel.uid = uid;
    userDataModel.displayName = displayName;
    userDataModel.phoneNumber = phoneNumber ?? "";
    userDataModel.photoURl = photoURI;
    userDataModel.token = token;

    getStore.write('email', userDataModel.email);
    getStore.write('uid', userDataModel.uid);
    getStore.write('displayName', userDataModel.displayName);
    getStore.write('phoneNumber', userDataModel.phoneNumber);
    getStore.write('photoURl', userDataModel.photoURl);
    getStore.write('token', userDataModel.token);
    update();
  }
}
