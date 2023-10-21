import 'package:chat_gpt/Modules/subscription/inapp_purchase_controller.dart';
import 'package:chat_gpt/utils/components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AppleSubscriptionPage extends StatefulWidget {
  const AppleSubscriptionPage({super.key});

  @override
  State<AppleSubscriptionPage> createState() => _AppleSubscriptionPageState();
}

class _AppleSubscriptionPageState extends State<AppleSubscriptionPage> {
  final controller = Get.find<InAppPurchaseController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Image.asset("assets/images/close.png", width: 35),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                "Try all Premium Features\nfor Free",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xffEF9733),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 6),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.inAppPurchaseProductList.length,
              itemBuilder: (context, index) => Obx(
                () => InkWell(
                  onTap: () {
                    controller.selectedProduct.value = controller.inAppPurchaseProductList[index];
                  },
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: controller.selectedProduct.value != null &&
                                  controller.selectedProduct.value!.id == controller.inAppPurchaseProductList[index].id
                              ? const Color(0xff2064D1)
                              : const Color(0xff2064D1).withOpacity(.20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 24,
                        ),
                        margin: const EdgeInsets.only(
                          left: 24,
                          right: 24,
                          bottom: 8,
                          top: 8,
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    controller.getTitle(controller.inAppPurchaseProductList[index].id),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: controller.selectedProduct.value != null &&
                                              controller.selectedProduct.value!.id == controller.inAppPurchaseProductList[index].id
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                  Visibility(
                                    visible:
                                        false /*controller
                                            .inAppPurchaseProductList[index]
                                            .id ==
                                        "yoga_yearly"*/
                                    ,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                      ),
                                      child: Text(
                                        "-\t\t3 days free trial",
                                        style: TextStyle(
                                          color: controller.selectedProduct.value != null &&
                                                  controller.selectedProduct.value!.id == controller.inAppPurchaseProductList[index].id
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              controller.inAppPurchaseProductList[index].price,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: controller.selectedProduct.value != null &&
                                        controller.selectedProduct.value!.id == controller.inAppPurchaseProductList[index].id
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 10,
                        child: Visibility(
                          visible: controller.inAppPurchaseProductList[index].id == "yoga_yearly",
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                              color: Color(0xffFBD98C),
                            ),
                            margin: const EdgeInsets.only(right: 24),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: const Text(
                              "Most Popular",
                              style: TextStyle(
                                fontSize: 8,
                                color: Color(0xffEF9733),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 10,
              ),
              child: ElevatedButton(
                onPressed: () {
                  if (controller.selectedProduct.value != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Column(
                          children: [
                            const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Processing Payments!",
                              style: context.theme.textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        behavior: SnackBarBehavior.fixed,
                      ),
                    );
                    controller.purchase();
                  } else {
                    C.toast(msg: "Please select a plan");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff004ECC),
                  foregroundColor: const Color(0xffffffff),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: Size(
                    MediaQuery.of(context).size.width,
                    48,
                  ),
                ),
                child: const Text(
                  "Purchase",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 16,
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      launchUrl(
                        Uri.parse("https://eurosom.com/terms-and-condition.html"),
                      );
                    },
                    child: const Text(
                      "Terms Of Use",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xff004ECC),
                        decoration: TextDecoration.underline,
                        decorationThickness: 2,
                      ),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      controller.restorePurchase();
                    },
                    child: const Text(
                      "TAP TO RESTORE",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xff004ECC),
                        decoration: TextDecoration.underline,
                        decorationThickness: 2,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
