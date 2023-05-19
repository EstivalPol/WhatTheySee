import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:photo_view/photo_view.dart';
import 'package:whattheysee/components/ob_homecontroller.dart';

class PhotoHero extends StatelessWidget {
  const PhotoHero({
    Key? key,
    this.photo,
    this.onTap,
    this.width,
    this.height,
    this.fit,
    this.isHero,
    this.idHero,
  }) : super(key: key);

  final String? photo;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final bool? isHero;
  final String? idHero;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (width != null && width! > 0) ? width : double.infinity,
      height: (height != null && height! > 0) ? height : double.infinity,
      child: isHero == null
          ? InkWell(
              onTap: onTap,
              child: CachedNetworkImage(
                imageUrl: '$photo',
                fit: fit ?? BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(
                            Get.theme.colorScheme.secondary),
                        value: downloadProgress.progress,
                      ),
                    ),
                  ),
                ),
                placeholder: (context, url) => loading(),
                errorWidget: (context, url, error) => Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35.0),
                    color: Get.theme.colorScheme.secondary.withOpacity(0.5),
                  ),
                  child: const Icon(Icons.error),
                ),
                fadeOutDuration: const Duration(milliseconds: 100),
                fadeInDuration: const Duration(milliseconds: 100),
              ),
            )
          : inHero(),
    );
  }

  Widget inHero() {
    //var rand = new Random().nextInt(999); //.nextInt(999999999);
    return Hero(
      tag: "tag-$idHero",
      child: Material(
        //color: Theme.of(context).primaryColor.withOpacity(0.25),
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: CachedNetworkImage(
            imageUrl: '$photo',
            fit: fit ?? BoxFit.cover,
            //color: Get.theme.cursorColor,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                SizedBox(
              height: 20,
              width: 20,
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation(Get.theme.colorScheme.secondary),
                  value: downloadProgress.progress,
                ),
              ),
            ),
            //placeholder: (context, url) => AppTheme.loading(),
            errorWidget: (context, url, error) => Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35.0),
                color: Get.theme.colorScheme.secondary.withOpacity(0.5),
              ),
              child: const Icon(Icons.error),
            ),
            fadeOutDuration: const Duration(milliseconds: 100),
            fadeInDuration: const Duration(milliseconds: 100),
          ),
        ),
      ),
    );
  }

  static Widget loading() {
    return Container(
      alignment: FractionalOffset.center,
      child: LoadingAnimationWidget.waveDots(
        color: Get.theme.colorScheme.secondary,
        size: 30.0,
      ),
    );
  }

  static comingSoon() {
    Get.snackbar(
      "Information",
      "Coming soon...",
      backgroundColor: mainColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  static comingSoon2() {
    Get.snackbar(
      "Chat",
      "Comment with your friends, coming soon...",
      backgroundColor: mainColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  static String convertDateFull(stringDate, bool isEnglish) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime dateNow = dateFormat.parse(stringDate);
    var nameDay = getNameDay(dateNow, isEnglish);

    DateFormat dateFormat1 = DateFormat("dd MMM yyyy HH:mm");
    return "$nameDay, ${dateFormat1.format(dateNow)}";
  }

  static String getNameDay(DateTime? dateNow, bool isEnglish) {
    DateTime? getNow = DateTime.now();
    if (dateNow != null) {
      getNow = dateNow;
    }
    String now = DateFormat('EEEE').format(getNow);
    if (isEnglish) return now;

    String result = "Senin";

    switch (now) {
      case "Sunday":
        result = "Minggu";
        break;
      case "Monday":
        result = "Senin";
        break;
      case "Tuesday":
        result = "Selasa";
        break;
      case "Wednesday":
        result = "Rabu";
        break;
      case "Thursday":
        result = "Kamis";
        break;
      case "Friday":
        result = "Jumat";
        break;
      case "Saturday":
        result = "Sabtu";
        break;
      default:
    }

    return result;
  }

  static List<Widget> sliderTop(List<dynamic> sliders) {
    return sliders
        .map(
          (e) => PhotoHero(
            photo: e['image1'],
          ),
        )
        .toList();
  }

  static List<Widget> sliderTopRadius(List<dynamic> sliders) {
    return sliders
        .map(
          (e) => PhotoHero(
            photo: e['image1'],
            //width: 250,
            fit: BoxFit.contain,
          ),
        )
        .toList();
  }

  static List<Widget> sliderTopWith(List<dynamic> sliders) {
    return sliders
        .map(
          (e) => Stack(
            children: [
              PhotoHero(
                photo: e['image1'],
              ),
              Positioned(
                top: 10,
                left: 5,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    color:
                        Get.theme.textTheme.labelLarge!.color!.withOpacity(.9),
                  ),
                  child: Text(
                    e['title_sitepage'],
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        )
        .toList();
  }

  static Widget photoView(photoUrl) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: Get.theme.appBarTheme.systemOverlayStyle,
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Get.theme.colorScheme.background,
        padding: const EdgeInsets.all(0.0),
        alignment: Alignment.topLeft,
        child: PhotoView(
          loadingBuilder: (context, event) => Center(
            child: loading(),
          ),
          imageProvider: NetworkImage(
            '$photoUrl',
          ),
        ),
      ),
    );
  }

  static showSnackbar(String text) {
    Get.snackbar(
      "Information",
      text,
      backgroundColor: mainColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  static bool checkValidEmail(email) {
    //var email = "tony@starkindustries.com"
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }
}
