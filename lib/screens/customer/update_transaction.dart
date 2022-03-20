import 'package:flutter/material.dart';
import './customer_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/transaction.dart';

class UpdateTransaction extends StatefulWidget {
  static const routeName = '/update-transaction';

  UpdateTransaction({Key key, this.db, this.transaction}) : super(key: key);
  Map transaction;
  Transaction db;
  @override
  _UpdateTransactionState createState() => _UpdateTransactionState();
}

class _UpdateTransactionState extends State<UpdateTransaction> {
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;
  String dropdownValue = 'in';
  String transactiontype = '';
  double oldValueFromDb = 0;
  String selectedValue = 'Gold';
  var _transaction = TransactionModel(
    id: '',
    customerName: '',
    // customerId: '',
    date: DateTime.now(),
    amount: 0,
    // transactionType:1  ,
    note: '',
    category: '',
    invoiceNo: '',
  );

  @override
  void initState() {
    super.initState();
    oldValueFromDb = widget.transaction['amount'];
    selectedValue = widget.transaction['category'];

    _transaction = TransactionModel(
                            customerName: _transaction.customerName,
                            customerId: widget.transaction['customerId'],
                            date: _transaction.date,
                            amount: _transaction.amount,
                            transactionType:
                                widget.transaction['transactionType'],
                            note: _transaction.note,
                            invoiceNo: _transaction.invoiceNo,
                            category: selectedValue);
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      Provider.of<Transaction>(context, listen: false).update(
          widget.transaction['id'],
          _transaction,
          transactiontype,
          oldValueFromDb);
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Succes!'),
          content: Text('Saved Successfully'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.pushNamed(context, CustomerScreen.routeName);
                setState(() {});
              },
            )
          ],
        ),
      );
    } catch (err) {
      print('error check =======================');
      print(err);
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occurred!'),
          content: Text('Something went wrong. ${err}'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }
    setState(() {
      _isLoading = false;
      Navigator.of(context).pop();
    });
  }

  Future<void> _delete() async {
    try {
      Provider.of<Transaction>(context, listen: false).delete(
          widget.transaction['id'],
          _transaction,
          transactiontype,
          oldValueFromDb);
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Succes!'),
          content: Text('deleted Successfully'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.pushNamed(context, CustomerScreen.routeName);
                setState(() {});
              },
            )
          ],
        ),
      );
    } catch (err) {
      print('error check =======================');
      print(err);
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occurred!'),
          content: Text('Something went wrong. ${err}'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }
    setState(() {
      _isLoading = false;
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('transaction Edit'),
          actions: [],
        ),
        body: Container(
          child: new SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      initialValue: widget.transaction['amount'].toString(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Amount';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _transaction = TransactionModel(
                            customerName: _transaction.customerName,
                            customerId: widget.transaction['customerId'],
                            date: _transaction.date,
                            amount: double.tryParse(value),
                            transactionType:
                                widget.transaction['transactionType'],
                            note: _transaction.note,
                            invoiceNo: _transaction.invoiceNo,
                            category: _transaction.category);
                      },
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter amount given',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Select Category',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        contentPadding: EdgeInsets.all(10),
                      ),
                      child: ButtonTheme(
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        child: DropdownButton<String>(
                          hint: const Text("Category"),
                          isExpanded: true,
                          value: selectedValue,
                          elevation: 16,
                          underline: DropdownButtonHideUnderline(
                            child: Container(),
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              selectedValue = newValue;
                            });

                            _transaction = TransactionModel(
                                customerName: _transaction.customerName,
                                customerId: widget.transaction['customerId'],
                                date: _transaction.date,
                                amount: _transaction.amount,
                                transactionType:
                                    widget.transaction['transactionType'],
                                note: _transaction.note,
                                invoiceNo: _transaction.invoiceNo,
                                category: selectedValue);
                          },
                          items: <String>[
                            'Gold',
                            'Silver',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      initialValue: widget.transaction['invoiceNo'],
                      onSaved: (value) {
                        _transaction = TransactionModel(
                            customerName: _transaction.customerName,
                            customerId: widget.transaction['customerId'],
                            date: _transaction.date,
                            amount: _transaction.amount,
                            transactionType:
                                widget.transaction['transactionType'],
                            note: _transaction.note,
                            invoiceNo: value,
                            category: _transaction.category);
                      },
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter Invoice No',
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      initialValue: widget.transaction['note'],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Note';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _transaction = TransactionModel(
                          customerName: _transaction.customerName,
                          customerId: widget.transaction['customerId'],
                          date: _transaction.date,
                          amount: _transaction.amount,
                          transactionType:
                              widget.transaction['transactionType'],
                          note: value,
                          invoiceNo: _transaction.invoiceNo,
                          category: _transaction.category,
                        );
                      },
                      maxLines: 8,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter Description',
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: FlatButton(
                          color: Colors.red,
                          onPressed: () {
                            _delete();
                            // Validate returns true if the form is valid, or false otherwise.
                            // if (_formKey.currentState.validate()) {
                            //   // If the form is valid, display a snackbar. In the real world,
                            //   // you'd often call a server or save the information in a database.
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     const SnackBar(content: Text('Processing Data')),
                            //   );
                            // }
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            _saveForm();
                            // Validate returns true if the form is valid, or false otherwise.
                            // if (_formKey.currentState.validate()) {
                            //   // If the form is valid, display a snackbar. In the real world,
                            //   // you'd often call a server or save the information in a database.
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     const SnackBar(content: Text('Processing Data')),
                            //   );
                            // }
                          },
                          child: const Text('Save'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}