import 'package:bitcoin_ticker/networking.dart';

const coinApiURL = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = '11186855-5CFB-497D-A9AE-4953E7C8E3ED';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  Future<Map<String, String>> getConversionData(String selectedCurrency) async {
    Map<String, String> cryptoPrices = Map<String, String>();

    for (String cryptoCurr in cryptoList) {
      String url = '$coinApiURL/$cryptoCurr/$selectedCurrency?apikey=$apiKey';
      dynamic data = await NetworkHelper(url: url).getData();

      if (data != null)
        cryptoPrices[cryptoCurr] = data['rate'].toStringAsFixed(2);
      else
        cryptoPrices[cryptoCurr] = '?';
    }

    return cryptoPrices;
  }
}
