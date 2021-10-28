import 'package:cash_change_calculator/shared/constants.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

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
  String? _payedMoney;
  String? _price;
  String? _debt;
  String? _totalChange;
  String? _answer;


  final List<double>_changeCoinsAndBills = [];
  final List<double> _cashEuroCent = [500, 200, 100, 50, 20, 10, 5, 2, 1, 0.5, 0.2, 0.1, 0.05, 0.02, 0.01];//Mögliche Euro-Geld-Varianten in Euro (Scheine und Münzen)
      



  void _changeResult() async {
    _changeCoinsAndBills.clear();//vorherige Geld-Kombination löschen
    if (double.parse(_payedMoney!)< double.parse(_price!)){//Wenn der Kunden zu wenig Geld gezahlt hat:
    } else {
      setState(() {
        rueckgeldzusammensetzung(totalChange(_payedMoney!, _price!)!, _cashEuroCent, _changeCoinsAndBills);
      });
    }
    replyToCustomer(_payedMoney, _price);
  }

  //if Preis=Eingabe => "Thank you"


  replyToCustomer(eingabeschein, preis){
    if (double.parse(eingabeschein!)< double.parse(preis!)){//Wenn der Kunden zu wenig Geld gezahlt hat:
      setState(() {
        _answer = ("Sie müssen noch "+double.parse(calcdebt(eingabeschein!, preis)!).toStringAsFixed(2)+ " Euro zahlen!");
      });
    } else {
      setState(() {
        _answer = ("Sie kriegen "+double.parse(totalChange(eingabeschein!, preis!)!).toStringAsFixed(2)+ " Euro zurück!");
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

  rueckgeldzusammensetzung(String _rueckgeld, List<double> _geldineuro, List<double>_rueckgeldscheineundmuenzen) { //Funktion zur Berechnung der Rückgeld-Kombination
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
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [


                    Column(children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .4,
                      height: MediaQuery.of(context).size.width * .09,
                            child: const Text('Preis in Euro: ', style: textStyle,)),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .4,
                      height: MediaQuery.of(context).size.width * .09,
                            child: const Text('Eingabe in Euro: ', style: textStyle,)),
                    ],),

                    Column(children: [
                      SizedBox(
                      width: MediaQuery.of(context).size.width * .4,
                      height: MediaQuery.of(context).size.width * .1,
      
                      child: TextFormField(
                        initialValue: 0.toString(),
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
                        initialValue: 0.toString(),
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
      
              ElevatedButton(
                child: const Text('Calculate', style: buttonTextStyle,),
                onPressed: (){
                _changeResult();
              }),
      
              SizedBox(
                width: MediaQuery.of(context).size.width * .4,
                height: MediaQuery.of(context).size.width * 1.3,
                child: ListView.builder(
                  itemCount: _changeCoinsAndBills.length,

                  itemBuilder: (context, index) {
                    final item = _changeCoinsAndBills[index];
      
                    return ListTile(
                      title: Text(item.toString()+' Euro', style: textStyle),
                    
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