import 'package:flutter/material.dart';

class StaffIncentive extends StatelessWidget {
  const StaffIncentive({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body:  SingleChildScrollView(
       child: Padding(
         padding: const EdgeInsets.all(20.0),
         child: Center(
           child: Column(
             children: [
               Align(
                 alignment: Alignment.centerLeft,
                 child: Text(
                   'Staff Incentives',
                   style: TextStyle(
                     fontSize: 20,
                     fontWeight: FontWeight.w600,
                     color: Colors.black,
                   ),
                 ),
               ),
               SizedBox(height: 16),
               // Incentive Management Card
               Container(
                 width: double.infinity,
                 decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.circular(14),
                   border: Border.all(color: Colors.grey.shade200),
                   boxShadow: [
                     BoxShadow(
                       color: Colors.grey.withOpacity(0.05),
                       blurRadius: 8,
                       offset: Offset(0, 1),
                     ),
                   ],
                 ),
                 padding: const EdgeInsets.fromLTRB(15, 18, 15, 18),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(
                       'Incentive Management',
                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                     ),
                     SizedBox(height: 6),
                     Text(
                       'View your incentive slabs and earnings data.',
                       style: TextStyle(color: Colors.grey[700], fontSize: 15),
                     ),
                     SizedBox(height: 18),
                     Text('Month', style: TextStyle(fontSize: 15, color: Colors.grey[700])),
                     SizedBox(height: 15),
                     Container(
                       decoration: BoxDecoration(
                         color: Colors.grey[100],
                         borderRadius: BorderRadius.circular(10),
                         border: Border.all(color: Colors.grey.shade200),
                       ),
                       child: DropdownButtonFormField<String>(
                         decoration: InputDecoration(
                           border: InputBorder.none,
                           contentPadding: EdgeInsets.only(left: 12),
                         ),
                         value: 'November',
                         items: [
                           'January', 'February', 'March', 'April', 'May', 'June', 'July',
                           'August', 'September', 'October', 'November', 'December'
                         ].map((e) => DropdownMenuItem<String>(value: e, child: Text(e))).toList(),
                         onChanged: (val) {},
                       ),
                     ),
                     SizedBox(height: 14),
                     Text('Year', style: TextStyle(fontSize: 15, color: Colors.grey[700])),
                     SizedBox(height: 15),
                     Container(
                       decoration: BoxDecoration(
                         color: Colors.grey[100],
                         borderRadius: BorderRadius.circular(10),
                         border: Border.all(color: Colors.grey.shade200),
                       ),
                       child: DropdownButtonFormField<String>(
                         decoration: InputDecoration(
                           border: InputBorder.none,
                           contentPadding: EdgeInsets.only(left: 12),
                         ),
                         value: '2025',
                         items: ['2025', '2024', '2023'].map(
                                 (e) => DropdownMenuItem<String>(value: e, child: Text(e))
                         ).toList(),
                         onChanged: (val) {},
                       ),
                     ),
                     SizedBox(height: 18),
                     SizedBox(
                       width: double.infinity,
                       child: ElevatedButton.icon(
                         style: ElevatedButton.styleFrom(
                           backgroundColor: Colors.orange,
                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                           padding: EdgeInsets.symmetric(vertical: 12),
                         ),
                         icon: Icon(Icons.filter_alt_rounded),
                         label: Text("Filter", style: TextStyle(fontWeight: FontWeight.w600)),
                         onPressed: () {},
                       ),
                     ),
                   ],
                 ),
               ),
               SizedBox(height: 22),

               Align(
                 alignment: Alignment.centerLeft,
                 child: Text('Incentive Slabs', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
               ),
               SizedBox(height: 10),

               // Incentive Slabs Section with ExpansionTile
               Container(
                 decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.circular(12),
                   border: Border.all(color: Colors.grey.shade300),
                 ),
                 child: Column(
                   children: [
                     Container(
                       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                         color: Colors.grey[50],
                       ),
                       child: Row(
                         children: [
                           Expanded(child: Text('Slab', style: TextStyle(fontWeight: FontWeight.w600))),
                           Expanded(child: Text('Min - Max', style: TextStyle(fontWeight: FontWeight.w600))),
                         ],
                       ),
                     ),
                     Divider(height: 1, color: Colors.grey),

                     ExpansionTile(
                       tilePadding: EdgeInsets.symmetric(horizontal: 12),
                       childrenPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                       title: Row(
                         children: [
                           const Text('–'),
                           Spacer(),
                           Text('₹500 - ₹50,000', style: TextStyle(color: Colors.black)),
                         ],
                       ),
                       trailing: Icon(Icons.expand_more, color: Colors.grey),
                       shape: Border.all(color: Colors.transparent),
                       collapsedBackgroundColor: Colors.transparent,
                       backgroundColor: Colors.transparent,
                       children: [
                         Container(
                           padding: EdgeInsets.symmetric(vertical: 12),
                           decoration: BoxDecoration(
                             color: Colors.grey[50],
                             borderRadius: BorderRadius.circular(8),
                           ),
                           child: Row(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             mainAxisAlignment: MainAxisAlignment.spaceAround,
                             children: [
                               Text('Slab 1', style: TextStyle(fontWeight: FontWeight.w500)),
                               Row(
                                 children: [
                                   Text('Amount:', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)),
                                   SizedBox(width: 8),
                                   Text(
                                     '₹449,900',
                                     style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 15),
                                   ),
                                 ],
                               ),
                             ],
                           ),
                         ),
                       ],
                     ),
                   ],
                 ),
               ),

               SizedBox(height: 20),
               Align(
                 alignment: Alignment.centerLeft,
                 child: Text('Incentive Plan Details (1)', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
               ),
               SizedBox(height: 10),

               // Incentive Plan Details Section
               Container(
                 decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.circular(12),
                   border: Border.all(color: Colors.grey.shade300),
                 ),
                 child: Column(
                   children: [
                     Container(
                       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                         color: Colors.grey[50],
                       ),
                       child: Row(
                         children: [
                           Expanded(child: Text('S.N.', style: TextStyle(fontWeight: FontWeight.w600))),
                           Expanded(child: Text('Date', style: TextStyle(fontWeight: FontWeight.w600))),
                           Expanded(child: Text('Sale (gaj)', style: TextStyle(fontWeight: FontWeight.w600))),
                         ],
                       ),
                     ),
                     Divider(height: 1, color: Colors.grey),
                     Padding(
                       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                       child: Row(
                         children: [
                           Icon(Icons.add, color: Colors.green, size: 22),
                           SizedBox(width: 16),
                           Expanded(child: Text('19/11/2025', style: TextStyle())),
                           Expanded(child: Text('500', style: TextStyle())),
                         ],
                       ),
                     ),
                   ],
                 ),
               ),
               SizedBox(height: 22),
               Container(
                 alignment: Alignment.centerRight,
                 child: Text.rich(
                   TextSpan(
                     text: 'Total Incentive: ',
                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                     children: [
                       TextSpan(
                         text: '₹0',
                         style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                       ),
                     ],
                   ),
                 ),
               ),
               SizedBox(height: 24),

             ],
           ),
         ),
       ),
     ),
    );
  }
}
