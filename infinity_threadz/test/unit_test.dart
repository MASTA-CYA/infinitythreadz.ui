import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infinity_threadz/common/color_helper.dart';
import 'package:infinity_threadz/common/data/demo_data.dart';
import 'package:infinity_threadz/common/functions.dart';
import 'package:infinity_threadz/user-component/models/user_model.dart';

void main() {
  group('Functions.getCrossAxisCount', () {
    test('uses one column on phones', () {
      expect(Functions.getCrossAxisCount(390), 1);
      expect(Functions.getCrossAxisCount(768), 1);
    });

    test('uses two columns on tablets', () {
      expect(Functions.getCrossAxisCount(800), 2);
    });

    test('uses three columns on laptops and up', () {
      expect(Functions.getCrossAxisCount(1024), 3);
      expect(Functions.getCrossAxisCount(1920), 3);
    });
  });

  group('color helpers', () {
    test('parses brand hex colours', () {
      expect(HexColor.fromHex('#0191DA'), const Color(0xFF0191DA));
      expect(HexColor.fromHex('0191DA'), const Color(0xFF0191DA));
    });

    test('round-trips through toHex', () {
      expect(const Color(0xFF0191DA).toHex(), '#ff0191da');
    });

    test('darken(100) is black and lighten(100) is white', () {
      expect(
        darken(const Color(0xFF0191DA), 100).toARGB32(),
        0xFF000000,
      );
      expect(
        lighten(const Color(0xFF0191DA), 100).toARGB32(),
        0xFFFFFFFF,
      );
    });
  });

  group('User', () {
    test('survives a JSON round trip', () {
      final User user = DemoData.user();
      final User copy = User.fromJson(user.toJson());

      expect(copy.id, user.id);
      expect(copy.name, user.name);
      expect(copy.email, user.email);
      expect(copy.isVerified, user.isVerified);
      expect(copy.isDarkMode, user.isDarkMode);
    });
  });

  group('DemoData', () {
    test('product ids are unique', () {
      final ids = DemoData.products.map((p) => p.id).toSet();
      expect(ids.length, DemoData.products.length);
    });

    test('wishlist and cart only contain catalogue products', () {
      for (final product in DemoData.wishlist) {
        expect(DemoData.products, contains(product));
      }
      for (final item in DemoData.cart()) {
        expect(DemoData.products, contains(item.product));
      }
    });

    test('latest order total matches its wallet transaction', () {
      final double itemsTotal = DemoData.orderItems
          .fold(0, (sum, item) => sum + item.subtotal);
      final payment = DemoData.transactions.firstWhere(
        (t) => t.reference == DemoData.orders.first.reference,
      );
      expect(itemsTotal, payment.amount);
    });

    test('demo cards never contain a full card number', () {
      for (final card in DemoData.cards) {
        expect(card.number, startsWith('****'));
      }
    });
  });
}
