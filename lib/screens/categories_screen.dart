import 'package:briefify/data/constants.dart';
import 'package:briefify/data/image_paths.dart';
import 'package:briefify/data/routes.dart';
import 'package:briefify/helpers/network_helper.dart';
import 'package:briefify/helpers/snack_helper.dart';
import 'package:briefify/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<CategoryModel> _categories = List.empty(growable: true);
  bool _loading = false;
  bool _error = false;

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.all(10),
          child: Image.asset(
            appLogo,
            height: 50,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: kPrimaryColorLight,
                borderRadius: BorderRadius.circular(200),
              ),
              child: const Icon(
                Icons.arrow_back_outlined,
                color: Colors.white,
              )),
          onPressed: () {
            Navigator.pop(context);
          },
          color: kSecondaryColorDark,
          padding: const EdgeInsets.all(0),
        ),
      ),
      body: _loading
          ? const SpinKitCircle(
              size: 50,
              color: kPrimaryColorLight,
            )
          : _error
              ? Center(
                  child: GestureDetector(
                      onTap: () {
                        getCategories();
                      },
                      child: Image.asset(
                        errorIcon,
                        height: 80,
                      )))
              : ListView.builder(
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, postsByCategoryRoute,
                            arguments: {'category': _categories[index]});
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: kPrimaryColorLight, width: 1)),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 10),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            Text(
                              _categories[index].name,
                              style: const TextStyle(
                                color: kPrimaryTextColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                                child: Container(
                                    alignment: Alignment.centerRight,
                                    child: const Icon(Icons.chevron_right))),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: _categories.length,
                ),
    );
  }

  void getCategories() async {
    _error = await false;
    setState(() {
      _loading = true;
    });
    try {
      Map results = await NetworkHelper().getCategories();
      if (!results['error']) {
        _categories = results['categories'];
      } else {
        SnackBarHelper.showSnackBarWithoutAction(context,
            message: results['errorData']);
        _error = true;
      }
    } catch (e) {
      SnackBarHelper.showSnackBarWithoutAction(context, message: e.toString());
      _error = true;
    }
    setState(() {
      _loading = false;
    });
  }
}
