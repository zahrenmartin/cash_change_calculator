import 'package:cash_change_calculator/shared/constants.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

//test

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

final List<String> currency = ['Euro','USD'];

List<double> _currencySelected = [50000, 20000, 10000, 5000, 2000, 1000, 500, 200, 100, 50, 20, 10, 5, 2, 1];//Mögliche Euro-Geld-Varianten in Euro (Scheine und Münzen)


String? _currentCurrency = 'Euro';

  String? _payedMoney;
  String? _price;
  String? _debt;
  String? _totalChange;
  String? _answer;


  final List<double>_changeCoinsAndBills = [];
  final List<double> _cashEuroCent = [50000, 20000, 10000, 5000, 2000, 1000, 500, 200, 100, 50, 20, 10, 5, 2, 1];//Mögliche Euro-Geld-Varianten in Euro (Scheine und Münzen)
  final List<double> _cashUSD = [100000, 50000, 20000, 10000, 5000, 2000, 1000, 500, 200, 100, 50, 20, 10, 5, 2, 1];//Mögliche USD-Geld-Varianten in Dollar (Scheine und Münzen)
      
  
  void selectCurrency(){
    if (_currentCurrency == 'Euro'){
      setState(() {
        _currencySelected = _cashEuroCent;
      });
    } else {
      if (_currentCurrency == 'USD'){
        setState(() {
          _currencySelected = _cashUSD;
        });
      }
    }
  }

//check why async and if it is really necessary and why!
  void _changeResult() async {
    selectCurrency();


    if ((_payedMoney == null)){
      setState(() {
        _payedMoney = 0.toString();
      });
    }

    if ((_price == null)){
      setState(() {
        _price = 0.toString();
      });
    }

    _payedMoney=_payedMoney?.replaceAll(',', '.');
    _price=_price?.replaceAll(',', '.');

    bool isNumeric(String s) {
      // ignore: unnecessary_null_comparison
      if (s == null) {
        return false;
      }
      return double.tryParse(s) != null;
    }

    if ((isNumeric(_payedMoney!)==false)| (isNumeric(_price!)==false)){
      setState(() {
        _payedMoney=0.toString();
        _price=0.toString();
        _answer = 'error';
      });
    } else {
      setState(() {
        _payedMoney=_payedMoney;
      });
    }
  
    _changeCoinsAndBills.clear();//vorherige Geld-Kombination löschen
    if (((double.parse(_payedMoney!)*100).toInt()) < ((double.parse(_price!)*100).toInt())){//Wenn der Kunden zu wenig Geld gezahlt hat:
    } else {
      setState(() {
        changeComposition(totalChange(((double.parse(_payedMoney!)*100).toInt()).toString(), ((double.parse(_price!)*100).toInt()).toString())!, _currencySelected, _changeCoinsAndBills);
      });
    }
    replyToCustomer(_payedMoney, _price, _answer);
  }

  replyToCustomer(eingabeschein, preis, answer){
    if (answer == 'error') {
      setState(() {
        _answer = ("Ihre Eingabe ist fehlerhaft!");
      });
    } else {
      if (double.parse(eingabeschein!)==double.parse(preis!)){//Wenn der Kunden zu wenig Geld gezahlt hat:
            setState(() {
              _answer = ("Vielen Dank!");
            });
    }
    else {
      if (double.parse(eingabeschein!)< double.parse(preis!)){//Wenn der Kunden zu wenig Geld gezahlt hat:
        setState(() {
          _answer = ("Sie müssen noch "+double.parse(calcdebt(eingabeschein!, preis)!).toStringAsFixed(2)+' '+ _currentCurrency!+ " zahlen!");
        });
      } else {
        setState(() {
          _answer = ("Sie kriegen "+double.parse(totalChange(eingabeschein!, preis!)!).toStringAsFixed(2)+' '+_currentCurrency!+ " zurück!");
          });
      }}
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

  changeComposition(String _rueckgeld, List<double> _geldineuro, List<double>_rueckgeldscheineundmuenzen) { //Funktion zur Berechnung der Rückgeld-Kombination
      for (double i in _geldineuro) {//Loop durch jede Mögliche Euro-Geld-Variante
        while ((double.parse(_rueckgeld)) >= i) {//So lange restlicher Rückgeldbetrag kleiner gleich Euro-Geld-Variante: 
            _rueckgeldscheineundmuenzen.add(i); //Euro-Geld-Variante wird der Rückgeldliste hinzugefügt.
            _rueckgeld = (double.parse(_rueckgeld) - i).toString(); //Restlicher Rückgeldbetrag wird berechnet.
        }
      }
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

              SizedBox(
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
                  onChanged: (val) => setState(() => _currentCurrency = val as String ),
                ),
              ),

              _currentCurrency == null 
              ? const SizedBox(width: 1,height: 1,) 
              : Text(_currentCurrency!),


              Padding(
                padding: const EdgeInsets.all(28.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [


                    Column(children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .4,
                      height: MediaQuery.of(context).size.width * .09,
                            child:  Text('Preis in '+_currentCurrency!+':', style: textStyle,)),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .4,
                      height: MediaQuery.of(context).size.width * .09,
                            child:  Text('Eingabe in '+_currentCurrency!+':', style: textStyle,)),
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
                      
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (BuildContext context) => super.widget)
                      );
                    }):ElevatedButton(
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