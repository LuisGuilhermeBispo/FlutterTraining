import 'package:flutter/material.dart';

void main() => runApp(BytebankApp());

class BytebankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListaTransferencias(),

      ),
    );
  }
}


class FormularioTransferencia extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FormularioTransferenciaState();
  }
}

class FormularioTransferenciaState extends State<FormularioTransferencia> {
  
  final TextEditingController _controladorCampoConta = TextEditingController(); 
  final TextEditingController _controladorCampoValor = TextEditingController();

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Criando uma nova Transferência'),),
        body: SingleChildScrollView(
                  child: Column(
            children: <Widget>[
             Editor(controlador: _controladorCampoConta, dica: '0000', rotulo: 'Número da Conta:'),
              //2form
              Editor(controlador: _controladorCampoValor, dica: '00.0', rotulo: 'Valor da Transferência:', icone: Icons.monetization_on,),
              RaisedButton(
                child: Text('Confirmar'),
                onPressed: ()=> criaTransferencia(context),
              )
            ],
          ),
        ));
  }
    void criaTransferencia(BuildContext context) {
    final int numeroConta = int.tryParse(_controladorCampoConta.text);
    final double valor = double.tryParse(_controladorCampoValor.text);
    if (numeroConta != null && valor != null) {
     final transferenciaCriada = Transferencia(valor, numeroConta);
     debugPrint('$transferenciaCriada');
     Navigator.pop(context, transferenciaCriada);
    }
  }
}

class Editor extends StatelessWidget {

  final TextEditingController controlador;
  final String rotulo;
  final String dica;
  final IconData icone;

  const Editor({this.controlador, this.rotulo, this.dica, this.icone});


  @override
  Widget build(BuildContext context) {
    return  Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: controlador,
                style: TextStyle(
                  fontSize: 24.0
                ),
                decoration: InputDecoration(
                  icon: icone != null ? Icon(icone) : null,
                  labelText: rotulo,
                  hintText: dica,
                ),
                keyboardType: TextInputType.number,
              ),
            );
  }
}

class ListaTransferencias extends StatefulWidget {
  
  final List<Transferencia> _transferencias = List();

    @override
    State<StatefulWidget> createState(){
    return ListaTransferenciasState();
  }
}

class ListaTransferenciasState extends State<ListaTransferencias> {
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('Itaú'), ),
      body: ListView.builder(
        itemCount: widget._transferencias.length,
        itemBuilder: (context, indice){
          final transferencia = widget._transferencias[indice];
          return ItemTransferencia(transferencia);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add), onPressed: () {
         final Future<Transferencia> future = Navigator.push(context, MaterialPageRoute(builder: (context){
            return FormularioTransferencia();
          }));
          future.then((transferenciaRecebida){
              
            debugPrint('$transferenciaRecebida');
           if (transferenciaRecebida != null) {
             widget._transferencias.add(transferenciaRecebida);
           }
          });
        },
      ),
    );
  }
}

class ItemTransferencia extends StatelessWidget {

  final Transferencia _transferencia;

  const ItemTransferencia(this._transferencia);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      child: ListTile(
        leading: Icon(Icons.monetization_on),
        title: Text(_transferencia.valor.toString()),
        subtitle: Text(_transferencia.numeroConta.toString()),
      ),
    );
  }
}


class Transferencia {
  final double valor;
  final int numeroConta;

  Transferencia(this.valor, this.numeroConta);

  @override
  String toString(){
    return 'Transferencia{valor: $valor, numeroConta: $numeroConta}';
  }

}