import 'package:flutter/material.dart';
import 'package:nexuscrm/models/lead.dart';
import 'package:nexuscrm/widgets/kCard.dart';


class StaffDashboardScreen extends StatelessWidget {

  final List<Map<String, dynamic>> cardItems = [
    {
      'icon': Icons.bar_chart,
      'color': Colors.purple,
      'title': "Productivity",
      'number': "85%"
    },
    {
      'icon': Icons.people,
      'color': Colors.blue,
      'title': "Staff Management",
      'number': "18"
    },
    {
      'icon': Icons.language,
      'color': Colors.orange,
      'title': "Source",
      'number': "100"
    },
    {
      'icon': Icons.card_travel_outlined,
      'color': Colors.red,
      'title': "Freelancers",
      'number': "7"
    },
    {
      'icon': Icons.language,
      'color': Colors.orange,
      'title': "Source",
      'number': "100"
    },
    {
      'icon': Icons.card_travel_outlined,
      'color': Colors.red,
      'title': "Freelancers",
      'number': "7"
    },
  ];

  final List<Lead> leads = [
    Lead(sn: 1, name: "Ravi Kumar", status: "Lead"),
    Lead(sn: 2, name: "Nisha Verma", status: "Interested"),
    Lead(sn: 3, name: "Ajay Solanki", status: "Lead"),
    // Add more leads...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea
        (child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
                children: [
                  //cards for different field
                  GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 80 / 50,
                          // card width / card height ratio
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 5
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cardItems.length,
                      itemBuilder: (context, index) {
                        final item = cardItems[index];
                        return Kcard(
                          icon: item['icon'],
                          color: item['color'],
                          title: item['title'],
                          number: item['number'],
                        );
                      }
                  ),
                  SizedBox(height: 20,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 200,
                        height: 40,
                        child: TextField(
                            decoration:InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                                hoverColor: Colors.white,
                                hintText: "Search",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.orange
                                  ),
                                    borderRadius: BorderRadius.circular(8.0),
                                ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.orange
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            )
                        ),
                      ),
                      SizedBox(
                        width: 120,
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: (){},
                          child: Row(
                            children: [
                              Icon(Icons.add_circle_outline,color: Colors.white,size: 16,),
                              SizedBox(width: 5,),
                              Text(
                                  "Filter"
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Card(
                    color: Colors.grey.withAlpha(20),
                    elevation: 3,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withAlpha(5), // subtle gray shadow
                                spreadRadius: 3,
                                blurRadius: 7,
                                offset: Offset(0, 2),
                              )
                    
                            ],
                            borderRadius: BorderRadius.vertical(top: Radius.circular(14.0))),
                    
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text("S.N.",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              Expanded(
                                  child: Text("Name",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              Expanded(
                                  child: Text("Change Status",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                            ],
                    
                          ),
                    
                        ),
                        Divider(thickness: 1,height: 1),
                        Theme(data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child: Column(
                          children: [
                            ...leads.map((lead) =>
                    ExpansionTile(
                      backgroundColor: Colors.white,
                      collapsedBackgroundColor: Colors.white,
                      tilePadding: EdgeInsets.symmetric(horizontal: 10),
                      childrenPadding: EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      title: Row(
                        children: [
                          Expanded(child: Text("${lead.sn}")),
                          Expanded(
                              child: Text(lead.name,
                                  style: TextStyle(
                    fontWeight: FontWeight.w600))),
                          Expanded(child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(lead.status),
                          )),
                    
                        ],
                      ),
                      children: [
                        Divider(height: 1,thickness: 1,),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Icon(Icons.phone),
                              SizedBox(width: 5),
                              Text("Call"),
                              Spacer(),
                              Icon(
                                  Icons.phone, color: Colors.green, size: 20),
                              SizedBox(width: 5),
                              Text("WhatsApp"),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Padding(
                          padding: EdgeInsets.only(top: 5,bottom: 8,left: 5,right: 5),
                          child: Row(
                            children: [
                              Text("Project", style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500)),
                              Spacer(),
                    
                            ],
                          ),
                        ),
                    
                    
                      ],
                    )
                    
                            ),
                    
                          ],
                    
                        )
                          )
                    
                    
                      ],
                    
                    ),
                  ),
                ]
            ),
          )
      ),),
    );
  }


}
