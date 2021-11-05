import 'package:cash_change_calculator/shared/constants.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String? _currentCurrency = 'EUR';
  String? _payedMoney;
  String? _price;
  String? _debt;
  String? _totalChange;
  String? _answer;

  final List<double>_changeCoinsAndBills = [];
  final List<String> currency = ['EUR','USD', 'GBP', 'JPY', 'KRW', 'RUB', 'CNY', 'INR', 'CHF', 'SEK'];
  List<double> _currencySelected = [50000, 20000, 10000, 5000, 2000, 1000, 500, 200, 100, 50, 20, 10, 5, 2, 1];//Mögliche Euro-Geld-Varianten in Euro (Scheine und Münzen)

  //source: https://de.wikipedia.org/wiki/St%C3%BCckelung
  final List<double> _cashEUR = [50000, 20000, 10000, 5000, 2000, 1000, 500, 200, 100, 50, 20, 10, 5, 2, 1];
  final List<double> _cashUSD = [10000, 5000, 2000, 1000, 500, 200, 100, 50, 25, 10, 5, 1];
  final List<double> _cashGBP = [10000, 5000, 2000, 1000, 500, 200, 100, 50, 20, 10, 5, 2, 1];
  final List<double> _cashJPY = [1000000, 500000, 200000, 100000, 50000, 10000, 5000, 1000, 500, 100];
  final List<double> _cashKRW = [5000000, 1000000, 500000, 100000, 50000, 10000, 5000, 1000, 500, 100];
  final List<double> _cashRUB = [500000, 200000, 100000, 50000, 20000, 10000, 5000, 1000, 500, 200, 100, 50, 10, 5, 1];
  final List<double> _cashCNY = [10000, 5000, 2000, 1000, 500, 200, 100, 50, 20, 10, 5, 2, 1];
  final List<double> _cashINR = [200000, 100000, 50000, 20000, 10000, 5000, 2000, 1000, 500, 200, 100, 50, 25, 10];
  final List<double> _cashCHF = [100000, 20000, 10000, 5000, 2000, 1000, 500, 200, 100, 50, 20, 10, 5];
  final List<double> _cashSEK = [100000, 50000, 20000, 10000, 5000, 2000, 1000, 500, 200, 100, 50];


  void selectCurrency(){
    (_currentCurrency == 'EUR') ? setState(() { _currencySelected = _cashEUR; }) :
    (_currentCurrency == 'USD') ? setState(() { _currencySelected = _cashUSD; }) :
    (_currentCurrency == 'GBP') ? setState(() { _currencySelected = _cashGBP; }) :
    (_currentCurrency == 'JPY') ? setState(() { _currencySelected = _cashJPY; }) :
    (_currentCurrency == 'KRW') ? setState(() { _currencySelected = _cashKRW; }) :
    (_currentCurrency == 'RUB') ? setState(() { _currencySelected = _cashRUB; }) :
    (_currentCurrency == 'CNY') ? setState(() { _currencySelected = _cashCNY; }) :
    (_currentCurrency == 'INR') ? setState(() { _currencySelected = _cashINR; }) :
    (_currentCurrency == 'CHF') ? setState(() { _currencySelected = _cashCHF; }) :
                                  setState(() { _currencySelected = _cashSEK; });    
  }

  setPayedMoneyNotNull(){
    if ((_payedMoney == null)){
      setState(() {
        _payedMoney = 0.toString();
      });
    }
  }

  setPriceNotNull(){
    if ((_price == null)){
      setState(() {
        _price = 0.toString();
      });
    }
  }

  replaceCommaWithPoint(){
    _payedMoney=_payedMoney?.replaceAll(',', '.');
    _price=_price?.replaceAll(',', '.');
  }

  setPayedMoneyAndPriceNumeric(){
    bool isNumeric(String s) { if (s == null) {
      return false;
      } return double.tryParse(s) != null;
        } if ((isNumeric(_payedMoney!)==false)|(isNumeric(_price!)==false)){
          setState(() {
            _payedMoney=0.toString();
            _price=0.toString();
            _answer = 'error';
          });} 
  }

  checkIfEnoughPayedAndThenChangeComposition(){
    if (((double.parse(_payedMoney!)*100).toInt()) < ((double.parse(_price!)*100).toInt())){//Wenn der Kunden zu wenig Geld gezahlt hat:
    } else {
      setState(() {
        changeComposition(totalChange(((double.parse(_payedMoney!)*100).toInt()).toString(), ((double.parse(_price!)*100).toInt()).toString())!, _currencySelected, _changeCoinsAndBills);
      });
    }
  }

  String? calcdebt(String eingabeschein, String preis){
      _debt = (double.parse(preis) - double.parse(eingabeschein)).toString();//Restlich zu zahlenden Betrag berechnen
      return _debt;
  }

  String? totalChange(String eingabeschein, String preis){
     _totalChange = (double.parse(eingabeschein) - double.parse(preis)).toString();//Gesamtbetrag des Rückgeldes berechnen
     return _totalChange!;
  }

  changeComposition(String _change, List<double> _cashEUR, List<double>_changeCoinsAndBills) { //Funktion zur Berechnung der Rückgeld-Kombination
      for (double i in _cashEUR) {//Loop durch jede Mögliche Euro-Geld-Variante
        while ((double.parse(_change)) >= i) {//So lange restlicher Rückgeldbetrag kleiner gleich Euro-Geld-Variante: 
            _changeCoinsAndBills.add(i); //Euro-Geld-Variante wird der Rückgeldliste hinzugefügt.
            _change = (double.parse(_change) - i).toString(); //Restlicher Rückgeldbetrag wird berechnet.
        }
      }
  }

  replyToCustomer(payedmoney, price, answer){
    (answer == 'error') ? setState(() { _answer = errorText; })
    :   (double.parse(payedmoney!) == double.parse(price!)) ?//Wenn der Kunden zu wenig Geld gezahlt hat:
              setState(() { _answer = thankYou; })
      :   (double.parse(payedmoney!)< double.parse(price!)) ?//Wenn der Kunden zu wenig Geld gezahlt hat:
            setState(() {
              _answer = (openBillReminderText+double.parse(calcdebt(payedmoney!, price)!).toStringAsFixed(2)+' '+ _currentCurrency!+ "!");
            }):setState(() {
                _answer = (moneyBack1Text+double.parse(totalChange(payedmoney!, price!)!).toStringAsFixed(2)+' '+_currentCurrency!+ moneyBack2Text);
                });
  }

  void _changeResult() {
    selectCurrency();
    setPayedMoneyNotNull();
    setPriceNotNull();
    replaceCommaWithPoint();
    setPayedMoneyAndPriceNumeric();
    _changeCoinsAndBills.clear();//vorherige Geld-Kombination löschen
    checkIfEnoughPayedAndThenChangeComposition();
    replyToCustomer(_payedMoney, _price, _answer);
  }

  _resetFunction(){
     Navigator.pushReplacement(context, MaterialPageRoute(
         builder: (BuildContext context) => super.widget)
    );
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        title: const Text(titleAppBar, style: textStyleAppBar),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * .5,
                  child: DropdownButtonFormField(
                    value: _currentCurrency,
                    decoration: textInputDecoration,
                    items: currency.map((currency) {
                      return DropdownMenuItem(
                        value: currency,
                        child: Text(currency),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _currentCurrency = val as String),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(28.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [


                    Column(children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .4,
                      height: MediaQuery.of(context).size.width * .09,
                            child:  Text(instructionPriceText+_currentCurrency!+':', style: textStyle,)),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .4,
                      height: MediaQuery.of(context).size.width * .09,
                            child:  Text(instructionPayedText+_currentCurrency!+':', style: textStyle,)),
                    ],),

                    Column(children: [
                      SizedBox(
                      width: MediaQuery.of(context).size.width * .4,
                      height: MediaQuery.of(context).size.width * .1,
      
                      child: TextFormField(
                        initialValue: ''.toString(),
                        decoration: textInputDecoration,
                        validator: (val) => val!.isEmpty ? 'Please enter the price' : null,
                        onChanged: (val) => setState(() => _price = val),
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width *.05,
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),

                    SizedBox(
                      width: MediaQuery.of(context).size.width * .4,
                      height: MediaQuery.of(context).size.width * .1,
      
                      child: TextFormField(
                        initialValue: ''.toString(),
                        decoration: textInputDecoration,
                        validator: (val) => val!.isEmpty ? 'Please enter the amount paid' : null,
                        onChanged: (val) => setState(() => _payedMoney = val),
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width *.05,
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    ],),
      
                  ],
                ),
              ),
      
              Text(_answer.toString(), style: textStyle),//Ergebnis
      
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    
                    (_answer == 'error'||_answer == "Ihre Eingabe ist fehlerhaft!") ? ElevatedButton(
                      child: const Text('Reset', style: buttonTextStyle,),
                      onPressed: (){
                      _resetFunction();
                    })
                    :ElevatedButton(
                      child: const Text('Calculate', style: buttonTextStyle,),
                      onPressed: (){
                      _changeResult();
                    }),
                  ],
                ),
              ),
      
              SizedBox(
                width: MediaQuery.of(context).size.width * .4,
                height: MediaQuery.of(context).size.width * 1.3,
                child: ListView.builder(
                  itemCount: _changeCoinsAndBills.length,

                  itemBuilder: (context, index) {
                    final item = _changeCoinsAndBills[index];
      
                    return ListTile(
                      title: Text((item/100).toString()+' '+_currentCurrency!, style: textStyle),
                    
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}