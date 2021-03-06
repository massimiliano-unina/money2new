import 'package:money2/money2.dart';

void main() {
  ///
  /// Create a currency
  /// USD currency uses 2 decimal places.
  ///
  final usd = Currency.create('USD', 2);
  final aud = Currency.create('AUD', 2);

  ///
  /// Create a money which stores $USD 10.00
  ///
  /// Note: we use the minor unit (e.g. cents) when passing in the
  ///   monetary value.
  /// So $10.00 is 1000 cents.
  ///
  var costPrice = Money.fromInt(1000, usd);
  print(costPrice.toString());
  // > $10.00

  ///
  /// Create a [Money] instance from a String
  /// using [Currency.parse]
  /// The [Currency] of salePrice is USD.
  ///
  var salePrice = usd.parse('\$10.50');
  print(salePrice.format('SCC 0.0'));
  // > $US 10.50

  ///
  /// Create a [Money] instance from a String
  /// using [Money.parse]
  ///
  var taxPrice = Money.parse('\$1.50', usd);
  print(taxPrice.format('CC 0.0 S'));
  // > US 1.50 $

  ///
  /// Create a [Money] instance from a String
  /// with an embedded Currency Code
  /// using [Currencies.parse]
  ///
  Currencies.register(usd);
  Currencies.register(aud);
  var cheapIPhone = Currencies.parse('\$USD1500.0', 'SCCC0.0');
  print(cheapIPhone.format('SCC0.0'));
  // > $US1500.00

  var expensiveIPhone = Currencies.parse('\$AUD2000.0', 'SCCC0.0');
  print(expensiveIPhone.format('SCC0.0'));
  // > $AUD2000.00

  ///
  /// Do some maths
  ///
  final taxInclusive = costPrice * 1.1;

  ///
  /// Output the result using the default format.
  ///
  print(taxInclusive.toString());
  // > $11.00

  ///
  /// Do some custom formatting of the ouput
  /// S - the symbol e.g. $
  /// CC - first two digits of the currency code provided when creating
  ///     the currency.
  /// # - a digit if required
  /// 0 - a digit or the zero character as padding.
  print(taxInclusive.format('SCC #.00'));
  // > $US 11.00

  ///
  /// Explicitly define the symbol and the default pattern to be used
  ///    when calling [Money.toString()]
  ///
  /// JPY - code for japenese yen.
  /// 0 - the number of minor units (e.g cents) used by the currency.
  ///     The yen has no minor units.
  /// ?? - currency symbol for the yen
  /// S0 - the default pattern for [Money.toString()].
  ///      S output the symbol.
  ///      0 - force at least a single digit in the output.
  ///
  final jpy = Currency.create('JPY', 0, symbol: '??', pattern: 'S0');
  var jpyMoney = Money.fromInt(500, jpy);
  print(jpyMoney.toString());
  // > ??500

  ///
  /// Define a currency that has inverted separators.
  /// i.e. The USD uses '.' for the integer/fractional separator
  ///      and ',' for the thousands separator.
  ///      -> 1,000.00
  /// The EURO use ',' for the integer/fractional separator
  ///      and '.' for the thousands separator.
  ///      -> 1.000,00
  ///
  final euro = Currency.create('EUR', 2,
      symbol: '???', invertSeparators: true, pattern: '#.##0,00 S');

  var bmwPrice = Money.fromInt(10025090, euro);
  print(bmwPrice.toString());
  // > 100.250,90 ???

  ///
  /// Formatting examples
  ///
  ///

  // 100,345.30 usd
  var teslaPrice = Money.fromInt(10034530, usd);

  print(teslaPrice.format('###,###'));
  // > 100,345

  print(teslaPrice.format('S###,###.##'));
  // > $100,345.3

  print(teslaPrice.format('CC###,###.#0'));
  // > US100,345.30

  // 100,345.30 EUR
  var euroCostPrice = Money.fromInt(10034530, euro);
  print(euroCostPrice.format('###.###'));
  // > 100.345

  print(euroCostPrice.format('###.###,## S'));
  // > 100.345,3 ???

  print(euroCostPrice.format('###.###,#0 CC'));
  // > 100.345,30 EU

  ///
  /// Make the currencies available globally by registering them
  ///     with the [Currencies] singleton factory.
  ///
  Currencies.register(usd);
  Currencies.register(euro);
  Currencies.register(jpy);

  // use a registered currency by finding it in the registry using
  // the currency code that the currency was created with.
  var usDollar = Currencies.find('USD');

  var invoicePrice = Money.fromInt(1000, usDollar);

  ///
  print(invoicePrice.format('SCCC 0.00'));
  // $USD 10.00

  // Do some maths
  var taxInclusivePrice = invoicePrice * 1.1;
  print(taxInclusivePrice.toString());
  // $11.00

  print(taxInclusivePrice.format('SCC 0.00'));
  // $US 11.00
}
