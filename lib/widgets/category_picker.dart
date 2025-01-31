import 'package:flutter/material.dart';
import 'package:personal_finance/models/category_model.dart';

class CategoryPicker extends StatefulWidget {
  final void Function(Category selectedCategory) onCategorySelected;

  const CategoryPicker({Key? key, required this.onCategorySelected})
      : super(key: key);

  @override
  State<CategoryPicker> createState() {
    return _CategoryPickerState();
  }
}

class _CategoryPickerState extends State<CategoryPicker> {
  Type? categoryType;

  @override
  Widget build(BuildContext context) {
    final List<Category> categoryByType = categories.where((category) {
      return categoryType == null
          ? category.type == Type.Expense
          : category.type == categoryType;
    }).toList();

    void onSelectedCategory(Category category) {
      widget.onCategorySelected(category);
    }

    return SizedBox(
      height: 750,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            // display the list of type button
            Row(
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      backgroundColor:
                          (categoryType == null || categoryType == Type.Expense)
                              ? Theme.of(context).primaryColor
                              : Colors.white,
                      foregroundColor:
                          (categoryType == null || categoryType == Type.Expense)
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      setState(() {
                        categoryType = Type.Expense;
                      });
                    },
                    child: Text(Type.Expense.name)),
                const Spacer(),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      backgroundColor: (categoryType == Type.Income)
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                      foregroundColor: (categoryType == Type.Income)
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      setState(() {
                        categoryType = Type.Income;
                      });
                    },
                    child: Text(Type.Income.name)),
                const Spacer(),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      backgroundColor: (categoryType == Type.Debts)
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                      foregroundColor: (categoryType == Type.Debts)
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      setState(() {
                        categoryType = Type.Debts;
                      });
                    },
                    child: Text(Type.Debts.name)),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            // display list of categories based on type button
            Expanded(
              child: ListView.builder(
                itemCount: categoryByType.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: InkWell(
                      onTap: () {
                        onSelectedCategory(categoryByType[index]);
                      },
                      child: Container(
                        margin: const EdgeInsets.all(
                          4,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 0.2,
                            color: Colors.black38,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          child: Row(
                            children: [
                              categoryByType[index].getIcon(),
                              const Spacer(),
                              Text(
                                categoryByType[index]
                                    .name, // Use categoryByType here
                                textAlign: TextAlign.center,
                              ),
                              const Spacer(),
                              const Icon(Icons.arrow_right),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
