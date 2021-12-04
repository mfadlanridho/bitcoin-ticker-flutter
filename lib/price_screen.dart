import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'conversion_card.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = currenciesList[0];
  Map<String, String> cryptoPrices = Map<String, String>();
  bool waitingToFetchData;

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> items = [];
    for (String currency in currenciesList) {
      items.add(DropdownMenuItem(
        child: Text(currency),
        value: currency,
      ));
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: items,
      onChanged: updateUI,
    );
  }

  CupertinoPicker iosCupertinoPicker() {
    List<Text> items = [];

    for (String currency in currenciesList) {
      items.add(Text(currency));
    }

    return CupertinoPicker(
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex) {
        updateUI(currenciesList[selectedIndex]);
      },
      children: items,
    );
  }

  void updateUI(String selectedCurrency) async {
    setState(() {
      this.selectedCurrency = selectedCurrency;
    });

    waitingToFetchData = true;
    try {
      Map<String, String> cryptoPrices =
          await CoinData().getConversionData(selectedCurrency);
      waitingToFetchData = false;
      setState(() {
        this.cryptoPrices = cryptoPrices;
      });
    } catch (e) {
      print(e);
    }
  }

  List<ConversionCard> conversionCards() {
    List<ConversionCard> list = [];
    for (String cryptoCurr in cryptoList) {
      list.add(ConversionCard(
          cryptoCurrency: cryptoCurr,
          regularCurrency: selectedCurrency,
          value: waitingToFetchData ? '?' : cryptoPrices[cryptoCurr]));
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
    for (String cryptoCurr in cryptoList) {
      cryptoPrices[cryptoCurr] = '?';
    }
    updateUI(currenciesList[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: conversionCards(),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iosCupertinoPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}
