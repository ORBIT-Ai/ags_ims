// ignore_for_file: unnecessary_string_interpolations, prefer_if_null_operators, unnecessary_new, use_function_type_syntax_for_parameters, prefer_const_constructors, avoid_unnecessary_containers, avoid_print, sized_box_for_whitespace

import 'package:ags_ims/services/auth_service.dart';
import 'package:ags_ims/services/firestore_db_service.dart';
import 'package:ags_ims/services/service_locator.dart';
import 'package:ags_ims/utils/theme_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class UI {
  final _fireStoreDB = locator<FireStoreDBService>();
  final _auth = locator<Auth>();

  TextFormField textFormField({
    @required BuildContext context,
    @required TextEditingController controller,
    @required TextInputType keyboardType,
    @required String label,
    @required IconData icon,
    @required Color color,
    String prefixText,
    bool autoFocus,
    int maxLength,
    String initialValue,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter a valid $label';
        }
        return null;
      },
      initialValue: initialValue ?? null,
      maxLength: maxLength != null ? maxLength : null,
      autofocus: autoFocus != null ? autoFocus : false,
      decoration: InputDecoration(
        icon: Icon(
          icon,
          color: color != null ? color : Theme.of(context).primaryColor,
        ),
        prefixText: prefixText,
        hintText: '$label is required *',
        labelText: '$label',
        labelStyle: new TextStyle(
          color: color != null ? color : Theme.of(context).primaryColor,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: color != null ? color : Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  TextFormField textFormFieldSMSCode(
      {@required BuildContext context,
      @required TextEditingController controller,
      @required TextInputType keyboardType,
      @required String label,
      @required IconData icon,
      @required Color color,
      @required void verifyCode()}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter a valid $label';
        }
        return null;
      },
      onChanged: (value) {
        if (value.length == 6) {
          verifyCode();
        }
        return null;
      },
      decoration: InputDecoration(
        icon: Icon(
          icon,
          color: color != null ? color : Theme.of(context).primaryColor,
        ),
        hintText: '$label is required *',
        labelText: '$label',
        labelStyle: new TextStyle(
          color: color != null ? color : Theme.of(context).primaryColor,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: color != null ? color : Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  TextFormField textFormFieldPassword({
    @required BuildContext context,
    @required TextEditingController controller,
    @required TextInputType keyboardType,
    @required String label,
    @required IconData icon,
    @required IconData suffixIcon,
    @required Color color,
    @required void function(),
    @required bool obscureText,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) {
        if (value.length < 8) {
          return 'Password must be longer than 8 characters';
        } else {
          return null;
        }
      },
      obscureText: obscureText,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(suffixIcon),
          onPressed: function,
          color: color != null ? color : Theme.of(context).primaryColor,
        ),
        icon: Icon(
          icon,
          color: color != null ? color : Theme.of(context).primaryColor,
        ),
        hintText: '$label is required *',
        labelText: '$label',
        labelStyle: new TextStyle(
          color: color != null ? color : Theme.of(context).primaryColor,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: color != null ? color : Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  TextFormField textFormFieldMultiLine({
    @required BuildContext context,
    @required TextEditingController controller,
    @required TextInputType keyboardType,
    @required String label,
    @required String hint,
    @required IconData icon,
    @required Color color,
    @required maxLines,
    @required minLines,
    @required maxLength,
    bool enabled,
    String suffix,
    String prefix,
    String content,
    String helperText,
    Color textColor,
    IconData suffixIcon,
    Color suffixIconColor,
    void onChanged(text),
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      enabled: enabled,
      textAlignVertical: TextAlignVertical.top,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter a valid $label';
        }
        return null;
      },
      style: TextStyle(
        color: textColor != null
            ? textColor
            : Theme.of(context).textTheme.subtitle1.color,
      ),
      cursorColor: color,
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: color != null ? color : Theme.of(context).primaryColor,
        ),
        suffixText: suffix,
        prefixText: prefix,
        hintText: '$hint',
        labelText: '$label',
        labelStyle: TextStyle(
          color: color != null ? color : Theme.of(context).primaryColor,
        ),
        suffixIcon: Icon(
          suffixIcon,
          color: suffixIconColor,
        ),
        helperText: helperText != null ? '$helperText' : '',
        helperStyle: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
        helperMaxLines: 4,
        hintStyle: TextStyle(
            color: color != null ? color : Theme.of(context).primaryColor),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: color != null ? color : Theme.of(context).primaryColor,
          ),
        ),
      ),
      onChanged: onChanged,
    );
  }

  TextField textFieldTransNoIcon(
      {@required BuildContext context,
      @required TextEditingController controller,
      @required Color color}) {
    return TextField(
      controller: controller,
      style: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface),
      textAlign: TextAlign.center,
      enabled: false,
      decoration: null,
    );
  }

  TextField textFieldTransIcon(
      {@required BuildContext context,
      @required TextEditingController controller,
      @required IconData icon,
      @required Color color,
      String hint}) {
    return TextField(
      controller: controller,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w300,
        color: color != null ? color : Theme.of(context).primaryColor,
      ),
      textAlign: TextAlign.start,
      textAlignVertical: TextAlignVertical.center,
      enabled: true,
      decoration: InputDecoration(
        hintText: hint != null ? hint : '',
        border: InputBorder.none,
        prefixIcon: Icon(
          icon,
          color: color != null ? color : Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  TextField textFieldTransIconLabel(
      {@required BuildContext context,
      @required TextEditingController controller,
      @required IconData icon,
      @required Color color,
      @required String label,
      void onChanged(text)}) {
    return TextField(
      controller: controller,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w300,
        color: color != null ? color : Theme.of(context).primaryColor,
      ),
      textAlign: TextAlign.start,
      enabled: true,
      decoration: InputDecoration(
        hintText: label,
        //border: InputBorder.none,
        //focusColor: Color(0xFF2960fc),
        icon: Icon(
          icon,
          color: color != null ? color : Theme.of(context).primaryColor,
        ),
      ),
      onChanged: onChanged,
    );
  }

  Text headlineLarge({
    @required BuildContext context,
    @required String content,
    @required Color color,
    @required isDesktop,
    TextAlign textAlign,
  }) {
    return Text(
      content,
      style: TextStyle(
        fontSize: !isDesktop
            ? Theme.of(context).textTheme.headline3.fontSize
            : Theme.of(context).textTheme.headline1.fontSize,
        color: color,
      ),
      maxLines: 5,
      overflow: TextOverflow.visible,
      textAlign: textAlign,
    );
  }

  Text headlineMedium({
    @required BuildContext context,
    @required String content,
    @required Color color,
    @required isDesktop,
    TextAlign textAlign,
  }) {
    return Text(
      content,
      style: TextStyle(
        fontSize: !isDesktop
            ? Theme.of(context).textTheme.headline5.fontSize
            : Theme.of(context).textTheme.headline3.fontSize,
        color: color,
      ),
      maxLines: 5,
      overflow: TextOverflow.visible,
      textAlign: textAlign,
    );
  }

  Text headlineSmall({
    @required BuildContext context,
    @required String content,
    @required Color color,
    @required isDesktop,
    TextAlign textAlign,
  }) {
    return Text(
      content,
      style: TextStyle(
        fontSize: !isDesktop
            ? Theme.of(context).textTheme.subtitle1.fontSize
            : Theme.of(context).textTheme.headline4.fontSize,
        color: color,
      ),
      maxLines: null,
      overflow: TextOverflow.visible,
      textAlign: textAlign,
    );
  }

  Text subheadLarge({
    @required BuildContext context,
    @required String content,
    @required Color color,
    @required isDesktop,
    TextAlign textAlign,
  }) {
    return Text(
      content,
      style: TextStyle(
        fontSize: !isDesktop
            ? Theme.of(context).textTheme.headline5.fontSize
            : Theme.of(context).textTheme.headline4.fontSize,
        color: color,
      ),
      maxLines: 5,
      overflow: TextOverflow.visible,
      textAlign: textAlign,
    );
  }

  Text subheadMedium({
    @required BuildContext context,
    @required String content,
    @required Color color,
    @required isDesktop,
    TextAlign textAlign,
  }) {
    return Text(
      content,
      style: TextStyle(
        fontSize: !isDesktop
            ? Theme.of(context).textTheme.headline6.fontSize
            : Theme.of(context).textTheme.headline5.fontSize,
        color: color,
      ),
      maxLines: 5,
      overflow: TextOverflow.visible,
      textAlign: textAlign,
    );
  }

  Text subheadSmall({
    @required BuildContext context,
    @required String content,
    @required Color color,
    @required isDesktop,
    TextAlign textAlign,
  }) {
    return Text(
      content,
      style: TextStyle(
        fontSize: !isDesktop
            ? Theme.of(context).textTheme.bodyText1.fontSize
            : Theme.of(context).textTheme.headline6.fontSize,
        color: color,
      ),
      maxLines: 5,
      overflow: TextOverflow.visible,
      textAlign: textAlign,
    );
  }

  Text body({
    @required BuildContext context,
    @required String content,
    @required Color color,
    @required isDesktop,
    TextAlign textAlign,
  }) {
    return Text(
      content,
      style: TextStyle(
        fontSize: !isDesktop
            ? Theme.of(context).textTheme.bodyText2.fontSize
            : Theme.of(context).textTheme.bodyText1.fontSize,
        color: color,
      ),
      maxLines: 5,
      overflow: TextOverflow.visible,
      textAlign: textAlign,
    );
  }

  Text caption({
    @required BuildContext context,
    @required String content,
    @required Color color,
    @required isDesktop,
    TextAlign textAlign,
  }) {
    return Text(
      content,
      style: TextStyle(
        fontSize: !isDesktop
            ? Theme.of(context).textTheme.caption.fontSize
            : Theme.of(context).textTheme.bodyText2.fontSize,
        color: color,
      ),
      maxLines: 5,
      overflow: TextOverflow.visible,
      textAlign: textAlign,
    );
  }

  Widget thumbnailLarge(
      {@required BuildContext context,
      @required IconData icon,
      @required Color color,
      @required isDesktop}) {
    return ClipOval(
      child: Container(
          width: isDesktop ? 144 : 72,
          height: isDesktop ? 144 : 72,
          color: color.withAlpha(20),
          child: Icon(
            icon,
            color: color,
            size: isDesktop ? 72 : 36,
          )),
    );
  }

  Widget thumbnailMedium(
      {@required BuildContext context,
      @required IconData icon,
      @required Color color,
      @required isDesktop}) {
    return ClipOval(
      child: Container(
          width: isDesktop ? 112 : 56,
          height: isDesktop ? 112 : 56,
          color: color.withAlpha(20),
          child: Icon(
            icon,
            color: color,
            size: isDesktop ? 56 : 32,
          )),
    );
  }

  Widget thumbnailSmall(
      {@required BuildContext context,
      @required IconData icon,
      @required Color color,
      @required isDesktop}) {
    return ClipOval(
      child: Container(
          width: isDesktop ? 72 : 36,
          height: isDesktop ? 72 : 36,
          color: color.withAlpha(20),
          child: Icon(
            icon,
            color: color,
            size: isDesktop ? 36 : 18,
          )),
    );
  }

  Widget infoNoDataFetched(
      {@required BuildContext context,
      @required isDesktop,
      @required String content}) {
    return Container(
      padding: EdgeInsets.all(50),
      child: isDesktop
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                UI().thumbnailSmall(
                    context: context,
                    icon: Icons.info_outline_rounded,
                    color: Colors.grey,
                    isDesktop: isDesktop),
                SizedBox(
                  height: 20,
                ),
                UI().headlineSmall(
                    context: context,
                    content: content,
                    color: Colors.grey,
                    isDesktop: isDesktop),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                UI().thumbnailSmall(
                    context: context,
                    icon: Icons.info_outline_rounded,
                    color: Colors.grey,
                    isDesktop: isDesktop),
                SizedBox(
                  width: 10,
                ),
                UI().headlineSmall(
                    context: context,
                    content: content,
                    color: Colors.grey,
                    isDesktop: isDesktop),
              ],
            ),
    );
  }

  Widget deviceNotSupported(
      {@required BuildContext context,
      @required isDesktop,
      @required String content}) {
    return Container(
        padding: EdgeInsets.all(50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UI().thumbnailSmall(
                context: context,
                icon: Icons.info_outline_rounded,
                color: Colors.grey,
                isDesktop: isDesktop),
            SizedBox(
              height: 20,
            ),
            UI().headlineSmall(
                context: context,
                content: content,
                color: Colors.grey,
                isDesktop: isDesktop),
          ],
        ));
  }

  Widget coverPhoto({@required String coverUrl, FilterQuality filterQuality}) {
    return CachedNetworkImage(
      fadeInCurve: Curves.fastLinearToSlowEaseIn,
      fadeOutCurve: Curves.easeInOutSine,
      colorBlendMode: BlendMode.srcOver,
      color: Colors.black12,
      // here `bytes` is a Uint8List containing the bytes for the in-memory image
      placeholder: (context, url) => Image.asset(
        "assets/images/sample_cover_photo.jpg",
        fit: BoxFit.cover,
      ),
      imageUrl: coverUrl == null || coverUrl == ""
          ? "https://firebasestorage.googleapis.com/v0/b/orbitai-yder.appspot.com/o/assets%2Fsample_cover_photo.jpg?alt=media&token=1f7b536b-5ef3-498d-b12a-77241000baf0"
          : coverUrl,
      fit: BoxFit.cover,
      filterQuality: filterQuality,
    );
  }

  Widget profilePhoto(
      {@required BuildContext context,
      @required String profileUrl,
      @required FilterQuality filterQuality}) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).canvasColor,
      child: ClipOval(
          child: CachedNetworkImage(
        fadeInCurve: Curves.fastLinearToSlowEaseIn,
        fadeOutCurve: Curves.easeOut,
        // here `bytes` is a Uint8List containing the bytes for the in-memory image
        placeholder: (context, url) => Image.asset(
          "assets/images/sample_profile.jpg",
          color: Theme.of(context).primaryColor,
          colorBlendMode: BlendMode.modulate,
        ),
        imageUrl: profileUrl == null || profileUrl == ""
            ? "https://firebasestorage.googleapis.com/v0/b/orbitai-yder.appspot.com/o/assets%2Fsample_profile.jpg?alt=media&token=1e6be4ca-a800-42c1-968e-2de962273116"
            : profileUrl,
        fit: BoxFit.cover,
        width: 100,
        height: 100,
        filterQuality: filterQuality,
      )),
      radius: 90,
    );
  }

  Widget postProfilePhoto(
      {BuildContext context, String profileUrl, FilterQuality filterQuality}) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).canvasColor,
      child: ClipOval(
          child: CachedNetworkImage(
        fadeInCurve: Curves.fastLinearToSlowEaseIn,
        fadeOutCurve: Curves.easeOut,
        // here `bytes` is a Uint8List containing the bytes for the in-memory image
        placeholder: (context, url) =>
            Image.asset("assets/images/sample_profile.jpg"),
        imageUrl: profileUrl == null || profileUrl == ""
            ? "https://firebasestorage.googleapis.com/v0/b/orbitai-yder.appspot.com/o/assets%2Fsample_profile.jpg?alt=media&token=1e6be4ca-a800-42c1-968e-2de962273116"
            : profileUrl,
        filterQuality: filterQuality,
        fit: BoxFit.fitHeight,
      )),
      radius: 24,
    );
  }

  Widget textButtonIcon(
      {@required BuildContext context,
      @required String label,
      @required Color backgroundColor,
      @required Color foregroundColor,
      @required IconData icon,
      @required void function()}) {
    // ignore: deprecated_member_use
    return TextButton.icon(
      style: TextButton.styleFrom(
        primary: backgroundColor,
        backgroundColor: Colors.transparent,
        shadowColor: Theme.of(context).shadowColor,
        enableFeedback: false,
        //splashFactory: NoSplash.splashFactory,
        alignment: Alignment.center,
      ),
      icon: Icon(
        icon,
        color: foregroundColor,
      ),
      label: label == ''
          ? Container()
          : Text(
              label,
              style: TextStyle(
                color: foregroundColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
      onPressed: function,
    );
  }

  Widget elevatedButtonIcon(
      {@required BuildContext context,
      @required String label,
      @required Color backgroundColor,
      @required Color foregroundColor,
      @required IconData icon,
      @required void function()}) {
    // ignore: deprecated_member_use
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          primary: backgroundColor,
          onPrimary: Theme.of(context).splashColor,
          shadowColor: Theme.of(context).shadowColor),
      icon: Icon(icon, color: foregroundColor),
      label: Text(label,
          style:
              TextStyle(color: foregroundColor, fontWeight: FontWeight.bold)),
      onPressed: function,
    );
  }

  Widget outlinedButtonIcon(
      {@required BuildContext context,
      @required String label,
      @required Color backgroundColor,
      @required Color foregroundColor,
      @required IconData icon,
      @required void function()}) {
    // ignore: deprecated_member_use
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
          primary: foregroundColor,
          side: BorderSide(color: foregroundColor),
          backgroundColor: backgroundColor,
          shadowColor: Theme.of(context).shadowColor),
      icon: Icon(icon, color: foregroundColor),
      label: Text(label,
          style:
              TextStyle(color: foregroundColor, fontWeight: FontWeight.bold)),
      onPressed: function,
    );
  }

  Widget textIcon({
    @required BuildContext context,
    @required String content,
    @required Color iconColor,
    @required Color contentColor,
    @required IconData icon,
    @required String ratio,
    @required bool isDesktop,
  }) {
    return Container(
      padding: EdgeInsets.all(4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(18)),
            child: Container(
              padding: EdgeInsets.all(8),
              color: iconColor.withAlpha(20),
              child: Icon(
                icon,
                color: iconColor,
                size: ratio == "small"
                    ? 14
                    : ratio == "medium"
                        ? 24
                        : 36,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          ratio == "small"
              ? subheadSmall(
                  context: context,
                  content: content,
                  color: contentColor,
                  isDesktop: isDesktop,
                )
              : ratio == "medium"
                  ? subheadMedium(
                      context: context,
                      content: content,
                      color: contentColor,
                      isDesktop: isDesktop,
                    )
                  : subheadLarge(
                      context: context,
                      content: content,
                      color: contentColor,
                      isDesktop: isDesktop,
                    ),
        ],
      ),
    );
  }

  Widget textIconNoBackground({
    @required BuildContext context,
    @required String content,
    @required Color iconColor,
    @required Color contentColor,
    @required IconData icon,
    @required String ratio,
    @required bool isDesktop,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: iconColor,
          size: ratio == "small"
              ? 16
              : ratio == "medium"
                  ? 24
                  : 36,
        ),
        SizedBox(
          width: 5,
        ),
        ratio == "small"
            ? subheadSmall(
                context: context,
                content: content,
                color: contentColor,
                isDesktop: isDesktop,
              )
            : ratio == "medium"
                ? subheadMedium(
                    context: context,
                    content: content,
                    color: contentColor,
                    isDesktop: isDesktop,
                  )
                : subheadLarge(
                    context: context,
                    content: content,
                    color: contentColor,
                    isDesktop: isDesktop,
                  ),
      ],
    );
  }

  Widget iconButton({
    @required BuildContext context,
    @required Color iconColor,
    @required IconData icon,
    @required String ratio,
    @required void function(),
    @required bool isDesktop,
  }) {
    double inkRatio = ratio == "small"
        ? 18
        : ratio == "medium"
            ? 48
            : 56;
    return Ink(
      width: inkRatio,
      height: inkRatio,
      decoration: ShapeDecoration(
        color: iconColor.withAlpha(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: IconButton(
        onPressed: function,
        padding: EdgeInsets.only(left: 0),
        splashColor: iconColor.withAlpha(20),
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        icon: Icon(
          icon,
          color: iconColor,
          size: ratio == "small"
              ? 14
              : ratio == "medium"
                  ? 24
                  : 36,
        ),
      ),
    );
  }

  Widget iconButtonNoBackground({
    @required BuildContext context,
    @required Color iconColor,
    @required IconData icon,
    @required String ratio,
    @required void function(),
    @required bool isDesktop,
  }) {
    double inkRatio = ratio == "small"
        ? 18
        : ratio == "medium"
            ? 48
            : 56;
    return Ink(
      width: inkRatio,
      height: inkRatio,
      decoration: ShapeDecoration(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: IconButton(
        onPressed: function,
        padding: EdgeInsets.only(left: 0),
        splashColor: iconColor.withAlpha(20),
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        icon: Icon(
          icon,
          color: iconColor,
          size: ratio == "small"
              ? 14
              : ratio == "medium"
                  ? 24
                  : 36,
        ),
      ),
    );
  }

  Widget headerCard({
    @required BuildContext context,
    @required String page,
    @required String header,
    @required String subhead,
    String buttonText,
    IconData buttonIcon,
    @required bool hasButton,
    @required bool isDesktop,
    void function(),
  }) {
    String asset = page == "home"
        ? 'home_vector.png'
        : page == "stocks"
            ? 'stocks_vector.png'
            : page == "sales"
                ? 'sale_vector.png'
                : page == "on_hand"
                    ? 'onhand_vector.png'
                    : page == "stock_out"
                        ? 'stockout_vector.png'
                        : page == "scanner"
                            ? 'scanner_vector.png'
                            : page == "print"
                                ? 'print_vector.png'
                                : page == "account"
                                    ? 'account_vector.png'
                                    : page == "about"
                                        ? 'about_vector.png'
                                        : page == "history"
                                            ? 'history_vector.png'
                                            : page == "help"
                                                ? 'help_vector.png'
                                                : '';
    return Card(
      margin: EdgeInsets.only(bottom: 0, left: 10, right: 10),
      color: Theme.of(context).canvasColor,
      child: Padding(
        padding: EdgeInsets.only(top: 0, right: 20, left: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: isDesktop
              ? CrossAxisAlignment.stretch
              : CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/$asset',
                        width: 200,
                        height: 150,
                        color: Theme.of(context).primaryColorLight,
                        colorBlendMode: BlendMode.modulate,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            headlineMedium(
                                context: context,
                                content: header,
                                color: Theme.of(context).primaryColor,
                                isDesktop: isDesktop),
                            SizedBox(
                              height: 5,
                            ),
                            headlineSmall(
                                context: context,
                                content: subhead,
                                color:
                                    Theme.of(context).textTheme.subtitle2.color,
                                isDesktop: isDesktop,
                                textAlign: TextAlign.justify),
                          ],
                        ),
                      )
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/$asset',
                        width: 300,
                        height: 250,
                        color: Theme.of(context).primaryColorLight,
                        colorBlendMode: BlendMode.modulate,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          headlineMedium(
                              context: context,
                              content: header,
                              color: Theme.of(context).primaryColor,
                              isDesktop: isDesktop),
                          SizedBox(
                            height: 5,
                          ),
                          headlineSmall(
                              context: context,
                              content: subhead,
                              color:
                                  Theme.of(context).textTheme.subtitle2.color,
                              isDesktop: isDesktop,
                              textAlign: TextAlign.justify),
                        ],
                      ),
                    ],
                  ),
            SizedBox(
              height: hasButton ? 10 : 0,
            ),
            hasButton != null && hasButton
                ? outlinedButtonIcon(
                    context: context,
                    label: buttonText.toUpperCase(),
                    backgroundColor: Theme.of(context).canvasColor,
                    foregroundColor: Theme.of(context).primaryColor,
                    icon: buttonIcon,
                    function: function,
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  Widget bottomSheetHeader(
      {@required BuildContext context,
      @required String page,
      @required bool isDesktop}) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          thumbnailSmall(
            context: context,
            icon: page == 'self_intro'
                ? Icons.person_rounded
                : page == 'user_post'
                    ? Icons.format_quote_rounded
                    : page == "select_interest"
                        ? Icons.star_rounded
                        : null,
            color: Theme.of(context).primaryColor,
            isDesktop: isDesktop,
          ),
          SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              subheadLarge(
                context: context,
                content: page == 'self_intro'
                    ? "Self Intro"
                    : page == 'user_post'
                        ? 'Post Preferences'
                        : page == "select_interest"
                            ? 'Select Interest'
                            : '',
                color: Theme.of(context).primaryColor,
                isDesktop: isDesktop,
              ),
              subheadSmall(
                context: context,
                content: page == 'self_intro'
                    ? "Few words that describes you."
                    : page == 'user_post'
                        ? 'What do you want to do with this post?'
                        : page == "select_interest"
                            ? 'Choose specific interest based on your post.'
                            : '',
                color: null,
                isDesktop: isDesktop,
              ),
            ],
          ),
        ],
      ),
    );
  }

  scaffoldMessenger(
      {@required BuildContext context, @required String message}) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Widget loadingIndicator({
    @required BuildContext context,
    @required String size,
  }) {
    return SpinKitRipple(
      color: Theme.of(context).canvasColor,
      size: size == 'small'
          ? 18
          : size == 'medium'
              ? 36
              : 48,
    );
  }

  Widget mainSearchBar(
      {@required BuildContext context,
      @required TextEditingController controller,
      @required void function}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Image.asset(
          'assets/images/ic_logo_100_100.png',
          height: 56,
          width: 56,
        ),
        Card(
          elevation: 12,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(24),
          ),
          color: Theme.of(context).canvasColor,
          child: Container(
            height: 48,
            width: 180,
            alignment: Alignment.center,
            padding: EdgeInsets.only(right: 16),
            child: textFieldTransIcon(
                context: context,
                controller: controller,
                icon: Icons.search_rounded,
                color: Theme.of(context).primaryColor,
                hint: 'Search something here..'),
          ),
        ),
        iconButtonNoBackground(
          context: context,
          iconColor: Theme.of(context).iconTheme.color,
          icon: Icons.filter_list_rounded,
          ratio: "medium",
          function: () => function,
          isDesktop: false,
        ),
        iconButtonNoBackground(
          context: context,
          iconColor: Theme.of(context).iconTheme.color,
          icon: Icons.more_vert_rounded,
          ratio: "medium",
          function: () => function,
          isDesktop: false,
        )
      ],
    );
  }

  Widget loadingProfile(
      {@required BuildContext context, @required bool isDesktop}) {
    return Container(
      height: 250,
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            child: SpinKitRipple(
              size: 48,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            child: headlineSmall(
              context: context,
              content: "Loading Profile",
              color: Theme.of(context).textTheme.headline6.color,
              isDesktop: isDesktop,
            ),
          )
        ],
      ),
    );
  }

  Widget profileCollectionsHeader(
      {@required BuildContext context,
      @required String userID,
      bool isDesktop}) {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20),
              child: headlineMedium(
                context: context,
                content: "Collections",
                color: Theme.of(context).textTheme.headline6.color,
                isDesktop: isDesktop,
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5, left: 20),
              child: headlineSmall(
                context: context,
                content: "View uploaded photos, videos, and audios.",
                color: Theme.of(context).textTheme.headline6.color,
                isDesktop: isDesktop,
                textAlign: TextAlign.left,
              ),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.all(10),
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  textButtonIcon(
                    context: context,
                    label: "Photos",
                    backgroundColor: Colors.transparent,
                    foregroundColor: Theme.of(context).primaryColor,
                    icon: Icons.photo_rounded,
                    function: () {},
                  ),
                  textButtonIcon(
                    context: context,
                    label: "Videos",
                    backgroundColor: Colors.transparent,
                    foregroundColor: Theme.of(context).primaryColor,
                    icon: Icons.movie_rounded,
                    function: () {},
                  ),
                  textButtonIcon(
                    context: context,
                    label: "Audios",
                    backgroundColor: Colors.transparent,
                    foregroundColor: Theme.of(context).primaryColor,
                    icon: Icons.multitrack_audio_rounded,
                    function: () {},
                  ),
                  textButtonIcon(
                    context: context,
                    label: "Saved",
                    backgroundColor: Colors.transparent,
                    foregroundColor: Theme.of(context).primaryColor,
                    icon: Icons.save_rounded,
                    function: () {},
                  ),
                  textButtonIcon(
                    context: context,
                    label: "Archived",
                    backgroundColor: Colors.transparent,
                    foregroundColor: Theme.of(context).primaryColor,
                    icon: Icons.archive_rounded,
                    function: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
