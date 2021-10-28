import 'package:cash_change_calculator/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Praktikumsbewerbung',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _EingabeSchein;
  String? Preis;
  String? Schulden;
  String? _Rueckgeld;
  String? Antwort;


  List<int>_RueckgeldScheineundMuenzen = [];
  List<int> _cashEuroCent = [50000, 20000, 10000, 5000, 2000, 1000, 500, 200, 100, 50, 20, 10, 5, 2, 1];//Mögliche Euro-Geld-Varianten in Cent (Scheine und Münzen)
      



  void _changeResult() async {
    _RueckgeldScheineundMuenzen.clear();//vorherige Geld-Kombination löschen
    if (int.parse(_EingabeSchein!)< int.parse(Preis!)){//Wenn der Kunden zu wenig Geld gezahlt hat:
    } else {
      setState(() {
        rueckgeldzusammensetzung(totalChange(_EingabeSchein!, Preis!)!, _cashEuroCent, _RueckgeldScheineundMuenzen);
      });
    }
    replyToCustomer(_EingabeSchein, Preis);
  }

  //if Preis=Eingabe => "Thank you"


  replyToCustomer(eingabeschein, preis){
    if (int.parse(eingabeschein!)< int.parse(preis!)){//Wenn der Kunden zu wenig Geld gezahlt hat:
      setState(() {
        Antwort = ("Du musst noch "+int.parse(calcdebt(eingabeschein!, preis)!).toStringAsFixed(2)+ " zahlen!");
      });
    } else {
      setState(() {
        Antwort = ("Du kriegst "+int.parse(totalChange(eingabeschein!, preis!)!).toStringAsFixed(2)+ " zurück!");
         });
    }
  }

  String? calcdebt(String eingabeschein, String preis){
      Schulden = (int.parse(preis) - int.parse(eingabeschein)).toString();//Restlich zu zahlenden Betrag berechnen
      return Schulden;
  }

  String? totalChange(String eingabeschein, String preis){
     _Rueckgeld = (int.parse(eingabeschein) - int.parse(preis)).toString();//Gesamtbetrag des Rückgeldes berechnen
     return _Rueckgeld!;
  }

  rueckgeldzusammensetzung(String _rueckgeld, List<int> _geldineuro, List<int>_rueckgeldscheineundmuenzen) { //Funktion zur Berechnung der Rückgeld-Kombination
      for (int i in _geldineuro) {//Loop durch jede Mögliche Euro-Geld-Variante
        while ((int.parse(_rueckgeld)) >= i) {//So lange restlicher Rückgeldbetrag kleiner gleich Euro-Geld-Variante: 
            _rueckgeldscheineundmuenzen.add(i); //Euro-Geld-Variante wird der Rückgeldliste hinzugefügt.
            _rueckgeld = (int.parse(_rueckgeld) - i).toString(); //Restlicher Rückgeldbetrag wird berechnet.
        }
      }
  }



  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: textStyleAppBar)
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
      
                  const Text('Preis: '),
      
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .4,
                    height: MediaQuery.of(context).size.width * .1,
      
                    child: TextFormField(
                      initialValue: 0.toString(),
                      decoration: textInputDecoration,
                      validator: (val) => val!.isEmpty ? 'Please enter the price' : null,
                      onChanged: (val) => setState(() => Preis = val),
                      style: GoogleFonts.roboto(
                        fontSize: MediaQuery.of(context).size.width *.05,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              ),
      
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
      
                  const Text('Eingabe: '),
      
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .4,
                    height: MediaQuery.of(context).size.width * .1,
      
                    child: TextFormField(
                      initialValue: 0.toString(),
                      decoration: textInputDecoration,
                      validator: (val) => val!.isEmpty ? 'Please enter the amount paid' : null,
                      onChanged: (val) => setState(() => _EingabeSchein = val),
                      style: GoogleFonts.roboto(
                        fontSize: MediaQuery.of(context).size.width *.05,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              ),
      
              Text(Antwort.toString()),//Ergebnis
      
              ElevatedButton(
                child: const Text('Calculate'),
                onPressed: (){
                _changeResult();
              }),
      
              SizedBox(
                width: MediaQuery.of(context).size.width * .4,
                    height: MediaQuery.of(context).size.width * .4,
                child: ListView.builder(
                  itemCount: _RueckgeldScheineundMuenzen.length,

                  itemBuilder: (context, index) {
                    final item = _RueckgeldScheineundMuenzen[index];
      
                    return ListTile(
                      title: Text(item.toString()+' Cent'),
                    
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
