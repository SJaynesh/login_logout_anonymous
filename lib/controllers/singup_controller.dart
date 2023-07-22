import 'package:get/get.dart';
import 'package:signin_singout_anonymous/models/singup_model.dart';
import 'package:signin_singout_anonymous/utills/atributes.dart';

class SingupController extends GetxController{

  SingUpModel singUpModel = SingUpModel(isNotRepert: false,user: null);

  changeTheValue() {
    singUpModel.isNotRepert = true;

    getStore.write("isNotRepert", singUpModel.isNotRepert);
    update();
  }

  getTheUserValue({required Map<String, dynamic> data}) {
    singUpModel.user = data['user'];


    getStore.write("UserName", singUpModel.user?.displayName);
    getStore.write("UserEmail", singUpModel.user?.email);
    getStore.write("UserUid", singUpModel.user?.uid);
    getStore.write("UserImage", singUpModel.user?.photoURL);

  }
}