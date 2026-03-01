import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';

class IAPService {
  static final IAPService _instance = IAPService._internal();
  factory IAPService() => _instance;

  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  // The predefined Play Store/App Store explicit product IDs
  final Set<String> _productIds = {
    'capy_small_snack',
    'capy_big_snack',
    'capy_feast',
  };

  List<ProductDetails> _products = [];
  bool _isAvailable = false;

  List<ProductDetails> get products => _products;
  bool get isAvailable => _isAvailable;

  // We can use a stream or callbacks to notify UI of successful purchases
  final _purchaseStatusController = StreamController<String>.broadcast();
  Stream<String> get purchaseStatusStream => _purchaseStatusController.stream;

  IAPService._internal();

  /// Must be called early in the app lifecycle (e.g. main.dart)
  Future<void> initialize() async {
    _isAvailable = await _iap.isAvailable();

    // Fallback for local testing if the store itself says it's unavailable (like on an emulator)
    if (!_isAvailable) {
      _isAvailable = true; // Force true for dummy data
    }

    if (_isAvailable) {
      await _loadProducts();
      final purchaseUpdated = _iap.purchaseStream;
      _subscription = purchaseUpdated.listen(
        _onPurchaseUpdate,
        onDone: () {
          _subscription.cancel();
        },
        onError: (error) {
          // Handle stream error
        },
      );
    }
  }

  Future<void> _loadProducts() async {
    final ProductDetailsResponse response = await _iap.queryProductDetails(
      _productIds,
    );
    if (response.error == null && response.productDetails.isNotEmpty) {
      _products = response.productDetails;
      // Sort them by price realistically if needed, or predefined order
      _products.sort((a, b) => a.rawPrice.compareTo(b.rawPrice));
    } else {
      // Load dummy products if store fetch fails or returns empty!
      _products = [
        ProductDetails(
          id: 'capy_small_snack',
          title: 'Small Snack (Dummy)',
          description: 'A tasty little treat for the capybara.',
          price: '\$1.99',
          rawPrice: 1.99,
          currencyCode: 'USD',
        ),
        ProductDetails(
          id: 'capy_big_snack',
          title: 'Big Snack (Dummy)',
          description: 'A generous portion of fresh veggies!',
          price: '\$4.99',
          rawPrice: 4.99,
          currencyCode: 'USD',
        ),
        ProductDetails(
          id: 'capy_feast',
          title: 'Feast (Dummy)',
          description: 'An absolute buffet of the finest greens. 🌿',
          price: '\$9.99',
          rawPrice: 9.99,
          currencyCode: 'USD',
        ),
      ];
    }
  }

  /// Triggers the purchase flow for a consumable tip
  Future<void> buyTip(ProductDetails product) async {
    if (product.id.contains('capy_')) {
      // It's a dummy! Bypass the real IAP flow and just pretend it succeeded.
      Future.delayed(const Duration(seconds: 1), () {
        _purchaseStatusController.add('success');
      });
      return;
    }

    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    // Tip jars should strictly be consumables so they can tip multiple times
    await _iap.buyConsumable(purchaseParam: purchaseParam, autoConsume: true);
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // Show pending UI if needed
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          _purchaseStatusController.add('error');
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          _purchaseStatusController.add('success');
        }

        if (purchaseDetails.pendingCompletePurchase) {
          _iap.completePurchase(purchaseDetails);
        }
      }
    }
  }

  void dispose() {
    _subscription.cancel();
    _purchaseStatusController.close();
  }
}
