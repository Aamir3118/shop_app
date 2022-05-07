import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop/Provider/product.dart';
import 'package:shop/Provider/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/edit-product";
  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageFocus = FocusNode();
  final _imageUrl = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _existingEditedProduct =
      Product(id: '', description: '', imageUrl: '', price: 0, title: '');
  @override
  void initState() {
    _imageFocus.addListener(_updateImageUrl);
    // TODO: implement initState
    /*_imageUrl.addListener(() {
      setState(() {});
    });*/
    super.initState();
  }

  void _updateImageUrl() {
    if (!_imageFocus.hasFocus) {
      setState(() {});
    }
  }

  void dispose() {
    _imageFocus.removeListener(_updateImageUrl);
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageFocus.dispose();
    _imageUrl.dispose();
    super.dispose();
  }

  void _saveForm() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    Provider.of<Products>(context, listen: false)
        .addProduct(_existingEditedProduct);
    Navigator.of(context).pop();
    print(_existingEditedProduct.title);
    print(_existingEditedProduct.description);
    print(_existingEditedProduct.price);
    print(_existingEditedProduct.imageUrl);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(onPressed: _saveForm, icon: Icon(Icons.save)),
        ],
      ),
      body: Form(
        key: _form,
        child: ListView(
          children: [
            TextFormField(
              decoration: InputDecoration(label: Text('Title')),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_priceFocus);
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter Title.';
                }
                return null;
              },
              onSaved: (newValue) {
                _existingEditedProduct = Product(
                    id: _existingEditedProduct.id,
                    title: newValue.toString(),
                    description: _existingEditedProduct.description,
                    price: _existingEditedProduct.price,
                    imageUrl: _existingEditedProduct.imageUrl);
              },
            ),
            TextFormField(
                decoration: InputDecoration(label: Text('Price')),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocus,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocus);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Price.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number.';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Number should be greater than zero.';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _existingEditedProduct = Product(
                      id: _existingEditedProduct.id,
                      title: _existingEditedProduct.title,
                      description: _existingEditedProduct.description,
                      price: double.parse(newValue!),
                      imageUrl: _existingEditedProduct.imageUrl);
                }),
            TextFormField(
                maxLines: 3,
                decoration: InputDecoration(label: Text('Description')),
                //textInputAction: TextInputAction.next,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocus,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Description.';
                  }
                  if (value.length < 10) {
                    return 'Description should be greater than 10.';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _existingEditedProduct = Product(
                      id: _existingEditedProduct.id,
                      title: _existingEditedProduct.title,
                      description: newValue!,
                      price: _existingEditedProduct.price,
                      imageUrl: _existingEditedProduct.imageUrl);
                }),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  margin: EdgeInsets.only(top: 8, right: 10),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.grey),
                  ),
                  child: _imageUrl.text.isEmpty
                      ? Text("Enter a URL")
                      : FittedBox(
                          child: Image.network(_imageUrl.text),
                          fit: BoxFit.cover,
                        ),
                ),
                Expanded(
                  child: TextFormField(
                      decoration: InputDecoration(
                        label: Text('Image Url'),
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrl,
                      focusNode: _imageFocus,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter Image URL.';
                        }
                        if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return 'Please enter a valid URL.';
                        }
                        if (!value.endsWith('.png') &&
                            !value.endsWith('.jpg') &&
                            !value.endsWith('.jpeg')) {
                          return 'Please enter a valid URL.';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _existingEditedProduct = Product(
                            id: _existingEditedProduct.id,
                            title: _existingEditedProduct.title,
                            description: _existingEditedProduct.description,
                            price: _existingEditedProduct.price,
                            imageUrl: newValue!);
                      }),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
