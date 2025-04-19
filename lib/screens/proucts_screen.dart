import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/responsive.dart';
import '../widgets/product_card.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.width(context, 20),
            vertical: Responsive.height(context, 20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text("Hello, Welcome 👋", style: Theme.of(context).textTheme.titleLarge),
                 
                 
              
              SizedBox(height: Responsive.height(context, 20)),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: Responsive.width(context, 15)),
                      decoration: BoxDecoration(
                        color: AppColors.greyLight,
                        borderRadius: BorderRadius.circular(Responsive.width(context, 15)),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search clothes...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: Responsive.width(context, 10)),
                  Container(
                    padding: EdgeInsets.all(Responsive.width(context, 15)),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(Responsive.width(context, 15)),
                    ),
                    child: Icon(Icons.search, color: AppColors.onPrimary),
                  ),
                ],
              ),
              SizedBox(height: Responsive.height(context, 20)),
              // SizedBox(
              //   height: Responsive.height(context, 40),
              //   child: ListView(
              //     scrollDirection: Axis.horizontal,
              //     children: [
              //       CategoryButton(text: "All Items", selected: true),
              //       SizedBox(width: Responsive.width(context, 10)),
              //       CategoryButton(text: "Dress"),
              //       SizedBox(width: Responsive.width(context, 10)),
              //       CategoryButton(text: "T-Shirt"),
              //       SizedBox(width: Responsive.width(context, 10)),
              //       CategoryButton(icon: Icons.more_horiz),
              //     ],
              //   ),
              // ),
              // SizedBox(height: Responsive.height(context, 20)),
           
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: Responsive.height(context, 20),
                crossAxisSpacing: Responsive.width(context, 20),
                childAspectRatio: 0.65,
                children: [
                  ProductCard(
                    image: "https://thumbs.dreamstime.com/b/set-care-beauty-products-skin-29817248.jpg",
                    name: "Modern Light Clothes",
                    price: 212.99,
                  ),
                  ProductCard(
                    image: "https://thumbs.dreamstime.com/b/set-care-beauty-products-skin-29817248.jpg",
                    name: "Light Dress Bless",
                    price: 162.99,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
    //     selectedItemColor: AppColors.primary,
    //     unselectedItemColor: AppColors.grey,
    //     showSelectedLabels: false,
    //     showUnselectedLabels: false,
    //     items: [
    //       BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
    //       BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: "Bag"),
    //       BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorite"),
    //       BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
    //     ],
    //   ),
     );
  }
}
