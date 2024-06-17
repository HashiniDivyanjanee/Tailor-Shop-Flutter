import 'package:flutter/material.dart';

class cash_report extends StatefulWidget {
  const cash_report({super.key});

  @override
  State<cash_report> createState() => _cash_reportState();
}

class _cash_reportState extends State<cash_report> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(3, 191, 203, 1),
                Color.fromRGBO(3, 191, 203, 1),
              ],
            ),
          ),
        ),
        title: Text('DAILY CASH  REPORT'),
        actions: [
          IconButton(
            icon: Icon(Icons.message),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {},
          ),
        ],
      ),
      body: DailyCash(),
    );
  }
}

class DailyCash extends StatefulWidget {
  const DailyCash({super.key});

  @override
  State<DailyCash> createState() => _DailyCashState();
}

class _DailyCashState extends State<DailyCash> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
          Divider(
          color: Color.fromARGB(255, 119, 119, 119),
         
          thickness: 10,
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: Text(
              'DAILY CASH  REPORT',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Divider(
          color: Color.fromARGB(255, 119, 119, 119),
          height: 40,
          thickness: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                  height: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Divider(
                        color: Colors.black26,
                      ),
                      Text(
                        "CASH FLOW- CASH REGISTER",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Divider(
                        color: Colors.black26,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 05),
                        child: Row(
                          children: [
                            Expanded(child: Text("OPENING CASH BALANCE",style: TextStyle(fontWeight: FontWeight.w600),)),
                            Expanded(child: Text("20000.00",style: TextStyle(fontWeight: FontWeight.w600),))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 05),
                        child: Row(
                          children: [
                            Expanded(child: Text("CASH - SALES INVOICE",style: TextStyle(fontWeight: FontWeight.w600),)),
                            Expanded(child: Text("20000.00",style: TextStyle(fontWeight: FontWeight.w600),))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 05),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text("CASH CREDIT SETTLEMENT- SALES",style: TextStyle(fontWeight: FontWeight.w600),)),
                            Expanded(child: Text("20000.00",style: TextStyle(fontWeight: FontWeight.w600),))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 05),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text("CASH - SALES INVOICE RETURN",style: TextStyle(fontWeight: FontWeight.w600),)),
                            Expanded(child: Text("20000.00",style: TextStyle(fontWeight: FontWeight.w600),))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 05),
                        child: Row(
                          children: [
                            Expanded(child: Text("QUOTATION CASH ADVANCE",style: TextStyle(fontWeight: FontWeight.w600),)),
                            Expanded(child: Text("20000.00",style: TextStyle(fontWeight: FontWeight.w600),))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 05),
                        child: Row(
                          children: [
                            Expanded(child: Text("ACCOUNT - CASH IN",style: TextStyle(fontWeight: FontWeight.w600),)),
                            Expanded(child: Text("20000.00",style: TextStyle(fontWeight: FontWeight.w600),))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 05),
                        child: Row(
                          children: [
                            Expanded(child: Text("ACCOUNT - CASH OUT",style: TextStyle(fontWeight: FontWeight.w600),)),
                            Expanded(child: Text("20000.00",style: TextStyle(fontWeight: FontWeight.w600),))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 05),
                        child: Row(
                          children: [
                            Expanded(child: Text("STORE CREDIT",style: TextStyle(fontWeight: FontWeight.w600),)),
                            Expanded(child: Text("20000.00",style: TextStyle(fontWeight: FontWeight.w600),))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 05),
                        child: Row(
                          children: [
                            Expanded(child: Text("CASH - GRN/PO",style: TextStyle(fontWeight: FontWeight.w600),)),
                            Expanded(child: Text("20000.00",style: TextStyle(fontWeight: FontWeight.w600),))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 05),
                        child: Row(
                          children: [
                            Expanded(child: Text("CASH - GRN/PO RETURN",style: TextStyle(fontWeight: FontWeight.w600),)),
                            Expanded(child: Text("20000.00",style: TextStyle(fontWeight: FontWeight.w600),))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 05),
                        child: Row(
                          children: [
                            Expanded(child: Text("EXPECTED CASH BALANCE",style: TextStyle(fontWeight: FontWeight.w600),)),
                            Expanded(child: Text("20000.00",style: TextStyle(fontWeight: FontWeight.w600),))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
                 Expanded(
                child: Container(
                  height: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Divider(
                        color: Colors.black26,
                      ),
                      Text(
                        "PAYMENT SUMMARY (SALES)",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Divider(
                        color: Colors.black26,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 05),
                        child: Row(
                          children: [
                            Expanded(child: Text("TOTAL INVOICE AMOUNT",style: TextStyle(fontWeight: FontWeight.w600),)),
                            Expanded(child: Text("20000.00",style: TextStyle(fontWeight: FontWeight.w600),))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 05),
                        child: Row(
                          children: [
                            Expanded(child: Text("CASH PAYMENT",style: TextStyle(fontWeight: FontWeight.w600),)),
                            Expanded(child: Text("20000.00",style: TextStyle(fontWeight: FontWeight.w600),))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 05),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text("CHEQUE PAYMENT",style: TextStyle(fontWeight: FontWeight.w600),)),
                            Expanded(child: Text("20000.00",style: TextStyle(fontWeight: FontWeight.w600),))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 05),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text("CARD PAYMENT",style: TextStyle(fontWeight: FontWeight.w600),)),
                            Expanded(child: Text("20000.00",style: TextStyle(fontWeight: FontWeight.w600),))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 05),
                        child: Row(
                          children: [
                            Expanded(child: Text("ONLINE PAYMENT",style: TextStyle(fontWeight: FontWeight.w600),)),
                            Expanded(child: Text("20000.00",style: TextStyle(fontWeight: FontWeight.w600),))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 05),
                        child: Row(
                          children: [
                            Expanded(child: Text("ADVANCE PAYMENT",style: TextStyle(fontWeight: FontWeight.w600),)),
                            Expanded(child: Text("20000.00",style: TextStyle(fontWeight: FontWeight.w600),))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 05),
                        child: Row(
                          children: [
                            Expanded(child: Text("TOTAL ON-CREDIT",style: TextStyle(fontWeight: FontWeight.w600),)),
                            Expanded(child: Text("20000.00",style: TextStyle(fontWeight: FontWeight.w600),))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 05),
                        child: Row(
                          children: [
                            Expanded(child: Text("TOTAL STORE - CREDIT",style: TextStyle(fontWeight: FontWeight.w600),)),
                            Expanded(child: Text("20000.00",style: TextStyle(fontWeight: FontWeight.w600),))
                          ],
                        ),
                      ),
                     SizedBox(height: 60,) 
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
                  Expanded(
                child: Container(
                  height: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Divider(
                        color: Colors.black26,
                      ),
                      Text(
                        "PAYMENT SUMMARY (GRN)",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Divider(
                        color: Colors.black26,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 05),
                        child: Row(
                          children: [
                            Expanded(child: Text("TOTAL GRN AMOUNT",style: TextStyle(fontWeight: FontWeight.w600),)),
                            Expanded(child: Text("20000.00",style: TextStyle(fontWeight: FontWeight.w600),))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 05),
                        child: Row(
                          children: [
                            Expanded(child: Text("CASH PAYMENT",style: TextStyle(fontWeight: FontWeight.w600),)),
                            Expanded(child: Text("20000.00",style: TextStyle(fontWeight: FontWeight.w600),))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 05),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text("CASH CREDIT SETTLEMENT- SALES",style: TextStyle(fontWeight: FontWeight.w600),)),
                            Expanded(child: Text("20000.00",style: TextStyle(fontWeight: FontWeight.w600),))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 05),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text("CHEQUE PAYMENT",style: TextStyle(fontWeight: FontWeight.w600),)),
                            Expanded(child: Text("20000.00",style: TextStyle(fontWeight: FontWeight.w600),))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 05),
                        child: Row(
                          children: [
                            Expanded(child: Text("CARD PAYMENT",style: TextStyle(fontWeight: FontWeight.w600),)),
                            Expanded(child: Text("20000.00",style: TextStyle(fontWeight: FontWeight.w600),))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 05),
                        child: Row(
                          children: [
                            Expanded(child: Text("ONLINE PAYMENT",style: TextStyle(fontWeight: FontWeight.w600),)),
                            Expanded(child: Text("20000.00",style: TextStyle(fontWeight: FontWeight.w600),))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 05),
                        child: Row(
                          children: [
                            Expanded(child: Text("TOTAL ON - CREDIT",style: TextStyle(fontWeight: FontWeight.w600),)),
                            Expanded(child: Text("20000.00",style: TextStyle(fontWeight: FontWeight.w600),))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 05),
                        child: Row(
                          children: [
                            Expanded(child: Text("TOTAL SETTILEMENT",style: TextStyle(fontWeight: FontWeight.w600),)),
                            Expanded(child: Text("20000.00",style: TextStyle(fontWeight: FontWeight.w600),))
                          ],
                        ),
                      ),
                      SizedBox(height: 60,) 
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
                Expanded(
                child: Container(
                  height: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Divider(
                        color: Colors.black26,
                      ),
                      Text(
                        "ON - CREDIT PAYMENT SUMMARY (SALES)",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Divider(
                        color: Colors.black26,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 05),
                        child: Row(
                          children: [
                            Expanded(child: Text("TOTAL SETTLEMENT",style: TextStyle(fontWeight: FontWeight.w600),)),
                            Expanded(child: Text("20000.00",style: TextStyle(fontWeight: FontWeight.w600),))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 05),
                        child: Row(
                          children: [
                            Expanded(child: Text("CASH SETTLEMENT",style: TextStyle(fontWeight: FontWeight.w600),)),
                            Expanded(child: Text("20000.00",style: TextStyle(fontWeight: FontWeight.w600),))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 05),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text("CHEQUE SETTLEMENT",style: TextStyle(fontWeight: FontWeight.w600),)),
                            Expanded(child: Text("20000.00",style: TextStyle(fontWeight: FontWeight.w600),))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 05),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text("CARD SETTLEMENT",style: TextStyle(fontWeight: FontWeight.w600),)),
                            Expanded(child: Text("20000.00",style: TextStyle(fontWeight: FontWeight.w600),))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 05),
                        child: Row(
                          children: [
                            Expanded(child: Text("ONLINE SETTLEMENT",style: TextStyle(fontWeight: FontWeight.w600),)),
                            Expanded(child: Text("20000.00",style: TextStyle(fontWeight: FontWeight.w600),))
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Divider(
                        color: Colors.black26,
                      ),
                      Text(
                        "EXPENSES - ACCOUNT",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Divider(
                        color: Colors.black26,
                      ),
                        Padding(
                        padding: const EdgeInsets.only(left: 05),
                        child: Row(
                          children: [
                            Expanded(child: Text("ACCOUNT - IN/OUT",style: TextStyle(fontWeight: FontWeight.w600),)),
                            Expanded(child: Text("20000.00",style: TextStyle(fontWeight: FontWeight.w600),))
                          ],
                        ),
                      ),
                        SizedBox(height: 40,) 
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
