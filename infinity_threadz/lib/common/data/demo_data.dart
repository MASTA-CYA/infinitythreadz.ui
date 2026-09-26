import 'package:infinity_threadz/cart-component/models/cart_product_model.dart';
import 'package:infinity_threadz/orders-component/models/order_items_model.dart';
import 'package:infinity_threadz/orders-component/models/order_model.dart';
import 'package:infinity_threadz/product-catalogue-component/models/product_model.dart';
import 'package:infinity_threadz/user-component/models/user_model.dart';
import 'package:infinity_threadz/wallet-component/models/account_card_model.dart';
import 'package:infinity_threadz/wallet-component/models/statement_model.dart';
import 'package:infinity_threadz/wallet-component/models/transaction_model.dart';

/// Sample data for the demo build.
///
/// The app has no backend yet, so every screen reads from here. When an API
/// is added, these getters are the seam to replace with real service calls.
class DemoData {
  DemoData._();

  static const Product clocheHat = Product(
    id: 1,
    image: 'assets/images/hat.jpg',
    name: 'Rosette Cloche Hat',
    description:
        'A 1920s-inspired cloche in soft wool felt, finished with a hand-folded '
        'rosette. Packable, warm and made to frame the face.',
    price: 449.00,
  );

  static const Product heritageHats = Product(
    id: 2,
    image: 'assets/images/hat-2.jpg',
    name: 'Heritage Hat Collection',
    description:
        'Fedoras, boaters, bowlers and a classic top hat: pick your silhouette '
        'from our vintage-reproduction range, each blocked by hand.',
    price: 599.00,
  );

  static const Product crewTee = Product(
    id: 3,
    image: 'assets/images/shirt.jpg',
    name: 'Everyday Crew Tee',
    description:
        'Heavyweight 100% cotton with a relaxed fit and ribbed collar that '
        'keeps its shape wash after wash. Shown in Ocean Blue.',
    price: 229.00,
  );

  static const Product vintageTee = Product(
    id: 4,
    image: 'assets/images/shirt-1.jpg',
    name: 'Vintage 1946 Graphic Tee',
    description:
        'Soft-washed navy cotton with a distressed retro print. '
        'Aged to perfection, original parts (mostly).',
    price: 299.00,
  );

  static const Product flares = Product(
    id: 5,
    image: 'assets/images/pants.jpg',
    name: 'Peace & Love Flares',
    description:
        'High-waisted stretch flares in a bold monochrome print, '
        'straight out of 1972. Pair with platforms for full effect.',
    price: 549.00,
  );

  static const Product brogues = Product(
    id: 6,
    image: 'assets/images/shoes.jpg',
    name: 'Leather Brogue Edit',
    description:
        'Full-grain leather brogues, Oxfords and T-bars with cushioned '
        'insoles, hand-finished in warm tan and two-tone.',
    price: 1299.00,
  );

  /// Everything in the catalogue.
  static const List<Product> products = [
    clocheHat,
    crewTee,
    flares,
    brogues,
    vintageTee,
    heritageHats,
  ];

  /// Items saved to the demo shopper's wishlist.
  static const List<Product> wishlist = [heritageHats, flares, brogues];

  /// A fresh copy of the demo cart (cart items track mutable subtotals).
  static List<CartProduct> cart() => [
        CartProduct(product: brogues),
        CartProduct(product: vintageTee),
        CartProduct(product: clocheHat),
      ];

  static const List<Order> orders = [
    Order(
      date: '2023/10/18',
      time: '08:48',
      reference: 'IFT-65465',
      status: 'In Progress',
    ),
    Order(
      date: '2023/09/05',
      time: '02:46',
      reference: 'IFT-54542',
      status: 'Fulfilled',
    ),
    Order(
      date: '2023/08/16',
      time: '13:34',
      reference: 'IFT-84812',
      status: 'Fulfilled',
    ),
    Order(
      date: '2023/06/08',
      time: '10:27',
      reference: 'IFT-48924',
      status: 'Cancelled',
    ),
  ];

  static const List<OrderItem> orderItems = [
    OrderItem(name: 'Leather Brogue Edit', quantity: 1, subtotal: 1299.00),
    OrderItem(name: 'Peace & Love Flares', quantity: 1, subtotal: 549.00),
    OrderItem(name: 'Everyday Crew Tee', quantity: 2, subtotal: 458.00),
  ];

  static const List<Statement> statements = [
    Statement(month: 'September', date: '01 - 30 September'),
    Statement(month: 'August', date: '01 - 31 August'),
    Statement(month: 'July', date: '01 - 31 July'),
  ];

  static const List<AccountTransaction> transactions = [
    AccountTransaction(
      date: '2023/09/18',
      time: '08:48',
      reference: 'IFT-65465',
      amount: 2306.00,
      type: TransactionType.debit,
    ),
    AccountTransaction(
      date: '2023/09/05',
      time: '02:46',
      reference: 'IFT-54542',
      amount: 528.00,
      type: TransactionType.debit,
    ),
    AccountTransaction(
      date: '2023/08/16',
      time: '13:34',
      reference: 'IFT-84812',
      amount: 1748.00,
      type: TransactionType.debit,
    ),
    AccountTransaction(
      date: '2023/06/18',
      time: '08:48',
      reference: 'VOUCHER-48924',
      amount: 1200.00,
      type: TransactionType.credit,
    ),
  ];

  /// Demo cards. Numbers are masked placeholders, not real card numbers.
  static const List<AccountCard> cards = [
    AccountCard(
      id: 0,
      name: 'Ms Jenna Furnell',
      number: '**** **** **** 4821',
      expiry: '10/28',
      type: AccountType.credit,
    ),
    AccountCard(
      id: 1,
      name: 'Ms Jenna Furnell',
      number: '**** **** **** 1937',
      expiry: '04/29',
      type: AccountType.cheque,
    ),
    AccountCard(
      id: 2,
      name: 'Ms Jenna Furnell',
      number: '**** **** **** 6054',
      expiry: '12/27',
      type: AccountType.savings,
    ),
  ];

  /// The fictional shopper every demo session signs in as.
  static User user() => User(
        id: 1,
        image: 'assets/images/jenna.jpg',
        name: 'Jenna Furnell',
        email: 'jenna.furnell@example.com',
        phone: '+27 21 000 0000',
        aboutMeDescription:
            'A fashion connoisseur with a passion for vintage clothing.',
        isVerified: true,
        type: 'Fashionista',
        isDarkMode: false,
      );
}
