import 'dart:async';

import 'package:chat_gpt/Modules/home/Home_intro.dart';
import 'package:chat_gpt/utils/components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class InAppPurchaseController extends GetxController {
  final inAppPurchaseProductList = <ProductDetails>[].obs;
  final selectedProduct = Rxn<ProductDetails>();
  late StreamSubscription<dynamic> _subscription;

  bool isPurchased = false;

  @override
  void onInit() {
    super.onInit();
    setupInAppPurchaseListener();
    fetchInAppPurchaseItems();
  }

  ///
  /// This method is used to fetch the in App Purchase Items.
  ///
  void fetchInAppPurchaseItems() async {
    final bool available = await InAppPurchase.instance.isAvailable();
    if (!available) {
    } else {
      const Set<String> kIds = <String>{
        'eurosom_monthly',
        // 'eurusom_yearly',
      };
      final res = await InAppPurchase.instance.queryProductDetails(kIds);
      if (res.notFoundIDs.isNotEmpty) {
        // showError("Failed to fetch products");
        print("IN_APP_NOT_FOUND::: ${res.notFoundIDs}");
      } else {
        final list = res.productDetails;
        final monthly = list.firstWhere((element) => element.id == 'eurosom_monthly');
        final yearly = list.firstWhere((element) => element.id == 'eurosom_yearly');
        inAppPurchaseProductList.clear();
        inAppPurchaseProductList.add(monthly);
        inAppPurchaseProductList.add(yearly);
        selectedProduct.value = monthly;
        print("IN_APP ITEMS:: ${inAppPurchaseProductList.length}");
      }
    }
  }

  getTitle(String id) {
    switch (id) {
      case 'yoga_monthly':
        return "Monthly Plan";
      case 'yoga_yearly':
        return "Yearly Plan";
      case 'yoga_lifetime':
        return "Lifetime Premium";
    }
  }

  ///
  /// This method is used to initiate the remove ads flow.
  ///
  purchase() {
    InAppPurchase.instance.buyNonConsumable(
      purchaseParam: PurchaseParam(productDetails: selectedProduct.value!),
    );
  }

  ///
  /// This method is used to initiate the remove ads flow.
  ///
  restorePurchase() {
    InAppPurchase.instance.restorePurchases();
  }

  ///
  /// This method is used to setup in app purchase listener.
  ///
  void setupInAppPurchaseListener() {
    final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      print("ERROR::: ${error}");
    });
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // _showPendingUI();
        print("PENDING:::::");
        await InAppPurchase.instance.completePurchase(purchaseDetails);
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          C.toast(
            msg: "We are unable to complete your purchase right now. Please try again later.",
          );
        } else if (purchaseDetails.status == PurchaseStatus.purchased || purchaseDetails.status == PurchaseStatus.restored) {
          showThanksDialog();
          isPurchased = true;
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(purchaseDetails);
        }
      }
    });
  }

  ///
  /// This method is used to show thanks dialog.
  ///
  void showThanksDialog() {
    if (!isPurchased) {
      Get.defaultDialog(
        title: "Premium",
        middleText: "Congratulations!\nYour purchase is successful.",
        textConfirm: "Thanks!",
        barrierDismissible: false,
        confirmTextColor: Colors.white,
        onConfirm: () {
          Get.offAll(Homepage());
        },
      );
    }
  }
}
