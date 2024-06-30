import 'package:ecommerce_responsive/main.dart';
import 'package:ecommerce_responsive/models/model_product.dart';
import 'package:ecommerce_responsive/screens/screen_cart.dart';
import 'package:ecommerce_responsive/utils/colors_constant.dart';
import 'package:ecommerce_responsive/utils/extension/currency_extension.dart';
import 'package:ecommerce_responsive/utils/size_constant.dart';
import 'package:ecommerce_responsive/utils/strings_constant.dart';
import 'package:ecommerce_responsive/utils/widgets/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ecommerce_responsive/screens/screen_product_detail.dart';
import 'package:ecommerce_responsive/utils/images_constant.dart';
import '../models/product_response.dart';

var textFiledBorderStyle = OutlineInputBorder(
    borderRadius: BorderRadius.circular(32.0),
    borderSide: const BorderSide(width: 0, color: sh_editText_background));

InputDecoration formFieldDecoration(String hintText) {
  return InputDecoration(
    labelText: hintText,
    focusColor: sh_colorPrimary,
    counterText: "",
    labelStyle: primaryTextStyle(),
    contentPadding: const EdgeInsets.only(bottom: 2.0),
  );
}

// ignore: must_be_immutable
class ProductHorizontalListV2 extends StatelessWidget {
  List<ProductResponse> productList = [];
  var isHorizontal = false;

  ProductHorizontalListV2(this.productList,
      {super.key, this.isHorizontal = false});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Container(
      height: 270,
      margin: const EdgeInsets.only(top: spacing_standard_new),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: productList.length,
          shrinkWrap: true,
          padding: const EdgeInsets.only(right: spacing_standard_new),
          itemBuilder: (context, index) {
            return Card(
              elevation: 2,
              child: Container(
                width: width * 0.4,
                constraints: const BoxConstraints(maxWidth: 150),
                child: InkWell(
                  onTap: () {
                    Get.toNamed(ScreenProductDetail.tag,
                        parameters: {
                          "productId": productList[index].productId ?? ""
                        },
                   );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.network(productList[index].images![0].src!,
                          height: 200, fit: BoxFit.contain),
                      const SizedBox(height: spacing_standard),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Expanded(
                            child: Text(productList[index].name!,
                                maxLines: 2,
                                style: boldTextStyle().copyWith(fontSize: 13)),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  productList[index]
                                      .price
                                      .toString()
                                      .toCurrencyFormat()!,
                                  style: secondaryTextStyle(
                                          decoration:
                                              TextDecoration.lineThrough)
                                      .copyWith(fontSize: 13),
                                  softWrap: true,
                                ),
                                const SizedBox(width: spacing_control_half),
                                text(
                                  productList[index]
                                      .salePrice
                                      .toString()
                                      .toCurrencyFormat(),
                                  // : productList[index]
                                  //     .price
                                  //     .toString()
                                  //     .toCurrencyFormat(),
                                  textColor: sh_colorPrimary,
                                  fontFamily: fontMedium,
                                  fontSize: 13,
                                ),
                                const SizedBox(width: spacing_control_half),
                              ],
                            ).expand(),
                          )
                        ],
                      ).paddingOnly(left: spacing_standard_new)
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}

Widget divider() {
  return const Divider(
    height: 0.5,
    color: sh_view_color,
  );
}

Widget horizontalHeadingV2(var title, {bool showViewAll = true, var callback}) {
  return Padding(
    padding: const EdgeInsets.only(
      left: spacing_standard_new,
      right: spacing_standard_new,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(title, style: boldTextStyle()),
        showViewAll
            ? GestureDetector(
                onTap: callback,
                child: Container(
                  padding: const EdgeInsets.only(
                      left: spacing_standard_new,
                      top: spacing_control,
                      bottom: spacing_control),
                  child: Text(sh_lbl_view_all,
                      style: boldTextStyle(color: sh_textColorSecondary)),
                ),
              )
            : Container()
      ],
    ),
  );
}

Widget loadingWidgetMaker() {
  return Container(
    alignment: Alignment.center,
    child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: spacing_control,
        margin: const EdgeInsets.all(4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Container(
          width: 45,
          height: 45,
          padding: const EdgeInsets.all(8.0),
          child: const CircularProgressIndicator(
            strokeWidth: 3,
          ),
        )),
  );
}

List<Widget> colorWidget(List<Attribute> attributes) {
  var maxWidget = 6;
  var currentIndex = 0;
  var color;
  List<Widget> list = [];

  attributes.forEach((attribute) {
    if (attribute.name == "Color") {
      color = attribute.options;
    }
  });
  if (color != null) {
    var totalColors = color.length;
    var flag = false;
    color.forEach((color) {
      if (currentIndex < maxWidget) {
        list.add(Container(
          padding: const EdgeInsets.all(6),
          margin: const EdgeInsets.only(right: spacing_middle),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(color: sh_textColorPrimary, width: 0.5),
              color: getColorFromHex(color)),
        ));
        currentIndex++;
      } else {
        if (!flag) list.add(Text('+ ${totalColors - maxWidget} more'));
        flag = true;
        return;
      }
    });
  }

  return list;
}

Widget cartIcon(context, cartCount) {
  return InkWell(
    onTap: () {
      Get.toNamed(ScreenCart.tag);
    },
    radius: spacing_standard_new,
    child: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: 40,
          height: 40,
          margin: const EdgeInsets.only(right: spacing_standard_new),
          padding: const EdgeInsets.all(spacing_standard),
          child: SvgPicture.asset(sh_ic_cart,
              color: appStore.isDarkModeOn ? white : sh_textColorPrimary),
        ),
        cartCount > 0
            ? Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: const EdgeInsets.only(top: spacing_control),
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.red),
                  child: text(cartCount.toString(),
                      textColor: sh_white, fontSize: textSizeSmall),
                ),
              )
            : Container()
      ],
    ),
  );
}

Widget headingText(String content) {
  return Text(content, style: primaryTextStyle());
}
