import 'package:flutter/material.dart';
import 'package:tailer_shop/Const/constant.dart';

class SupplierFooter extends StatelessWidget {
  const SupplierFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return 
    
    
    Padding(
      padding: const EdgeInsets.only(),
      child: Container(
        
        height: 50,
           color:cardBackgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 150,
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Container(
                  height: 35,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'View Product',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 29, 29, 29),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
