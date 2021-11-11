// ignore_for_file: avoid_print, prefer_const_constructors

import 'package:ags_ims/core/enums/history_types.dart';
import 'package:ags_ims/core/models/images.dart';
import 'package:ags_ims/core/models/user_details.dart';
import 'package:ags_ims/core/view_models/history_view_model.dart';
import 'package:ags_ims/services/auth_service.dart';
import 'package:ags_ims/services/cloud_storage_service.dart';
import 'package:ags_ims/services/firestore_db_service.dart';
import 'package:ags_ims/services/service_locator.dart';
import 'package:ags_ims/utils/base_utils.dart';
import 'package:ags_ims/views/home_page.dart';
import 'package:ags_ims/views/login_page.dart';
import 'package:flutter/material.dart';

class UserProfileViewModel {
  final _fireStoreDB = locator<FireStoreDBService>();
  final _auth = locator<Auth>();
  final _baseUtils = locator<BaseUtils>();
  final _cloudStorage = locator<CloudStorageService>();
  final _notificationsViewModel = locator<HistoryViewModel>();

  Future<void> setUserInfo({
    @required BuildContext context,
    @required String userID,
    @required String email,
    @required String phoneNumber,
    @required String position,
    @required String userName,
    @required String idNumber,
    @required imageFile,
  }) async {
    _fireStoreDB.getUserDetails(userID: userID).then((value) {
      final userDetails = UserDetails(
        userID: userID,
        emailAddress: email,
        profileUrl: null,
        phoneNumber: phoneNumber,
        position: position,
        userName: userName,
        idNumber: idNumber,
      );

      _fireStoreDB.setUserDetails(userDetails: userDetails).whenComplete(() {
        print('USER CREDENTIALS ADDED SUCCESSFULLY');
        uploadProfilePhoto(
          context: context,
          imageFile: imageFile,
          userID: userID,
        ).then((value) {
          updateUserInfo(context: context, userID: userID, url: value)
              .whenComplete(() {
            _notificationsViewModel.newHistory(
              userID: _auth.getCurrentUserID(),
              historyType: HistoryTypes.newUser,
              tag: "",
              tagID: "",
            );
            Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
            BaseUtils().snackBarNoProgress(
                context: context, content: "Registered Successfully");
          });
        });
      });
    });
  }

  Future<void> updateUserInfo({
    @required BuildContext context,
    @required String userID,
    @required String url,
  }) async {
    _fireStoreDB.getUserDetails(userID: userID).then((value) {
      final userDetails = UserDetails(
        userID: value.userID,
        emailAddress: value.emailAddress,
        profileUrl: url,
        phoneNumber: value.phoneNumber,
        position: value.position,
        userName: value.userName,
        idNumber: value.idNumber,
      );

      _fireStoreDB.setUserDetails(userDetails: userDetails).whenComplete(() {
        print('USER CREDENTIALS UPDATED SUCCESSFULLY');
      });
    });
  }

  Future<String> uploadProfilePhoto({
    @required BuildContext context,
    @required imageFile,
    @required String userID,
  }) async {
    final imageID = _baseUtils.timeStamp();
    String url;
    await _cloudStorage
        .setProfilePhoto(userID: _auth.getCurrentUserID(), imageFile: imageFile)
        .then((value) async {
      url = await value.getDownloadURL();
      if (value != null) {
        Images image = Images(
          imageID: imageID,
          userID: userID,
          date: _baseUtils.currentDate(),
          time: _baseUtils.currentTime(),
          url: await value.getDownloadURL(),
        );
        _fireStoreDB
            .setProfilePhoto(profilePhoto: image)
            .whenComplete(() async {
          print("PROFILE PHOTO UPLOADED SUCCESSFULLY");
        });
      }
    });
    return url;
  }

  Future<void> deleteUserData({
    @required BuildContext context,
    @required String userID,
  }) async {
    _notificationsViewModel.newHistory(
      userID: userID,
      historyType: HistoryTypes.deletedUser,
      tag: "",
      tagID: "",
    );
    _fireStoreDB.deleteUserDetails(userID: userID).whenComplete(() {
      _auth.deleteAccount().whenComplete(() {
        _auth.signOut().whenComplete(() {
          print("USER ACCOUNT DELETED SUCCESSFULLY");
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        });
      });
    });
  }
}
