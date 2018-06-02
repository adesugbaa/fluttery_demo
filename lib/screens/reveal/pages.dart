import 'package:flutter/material.dart';
import 'package:fluttery_demo/models/page_view_model.dart';



final pages = [
  PageViewModel(
      const Color(0xFF678FB4),
      'assets/images/reveal/hotels.png',
      'Hotels',
      'All hotels and hostels are sorted by hospitality rating',
      'assets/images/reveal/key.png'
  ),
  PageViewModel(
      const Color(0xFF65B0B4),
      'assets/images/reveal/banks.png',
      'Banks',
      'We carefully verify all banks before adding them into the app',
      'assets/images/reveal/wallet.png'
  ),
  PageViewModel(
    const Color(0xFF9B90BC),
    'assets/images/reveal/stores.png',
    'Store',
    'All local stores are categorized for your convenience',
    'assets/images/reveal/shopping_cart.png',
  ),
];