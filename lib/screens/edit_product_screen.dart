import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop/Provider/product.dart';
import 'package:shop/Provider/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/edit-product";

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageFocus = FocusNode();
  final _imageUrl = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _existingEditedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = true;
  @override
  void initState() {
    _imageFocus.addListener(_updateImageUrl);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments;
      if (productId != null) {
        _existingEditedProduct = Provider.of<Products>(context, listen: false)
            .findById(productId as String);
        _initValues = {
          'title': _existingEditedProduct.title as String,
          'description': _existingEditedProduct.description as String,
          'price': _existingEditedProduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrl.text = _existingEditedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageFocus.hasFocus) {
      if (_imageUrl.text.isEmpty ||
          (!_imageUrl.text.startsWith('http') &&
              !_imageUrl.text.startsWith('https')) ||
          (!_imageUrl.text.endsWith('.png') &&
              !_imageUrl.text.endsWith('.jpg') &&
              !_imageUrl.text.endsWith('.jpeg'))) {
        return;
      }
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
    /*if (_existingEditedProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_existingEditedProduct.id, _existingEditedProduct);
    }*/
    if (_existingEditedProduct.id == null) {
      Provider.of<Products>(context, listen: false)
          .addProduct(_existingEditedProduct);
    } else {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_existingEditedProduct.id, _existingEditedProduct);
    }
    //  Provider.of<Products>(context, listen: false)
    //    .addProduct(_existingEditedProduct);

    Navigator.of(context).pop();
    //print(_existingEditedProduct.title);
    //print(_existingEditedProduct.description);
    //print(_existingEditedProduct.price);
    //print(_existingEditedProduct.imageUrl);
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
              initialValue: _initValues['title'],
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
                    isFavorite: _existingEditedProduct.isFavorite,
                    title: newValue.toString(),
                    description: _existingEditedProduct.description,
                    price: _existingEditedProduct.price,
                    imageUrl: _existingEditedProduct.imageUrl);
              },
            ),
            TextFormField(
                initialValue: _initValues['price'],
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
                      isFavorite: _existingEditedProduct.isFavorite,
                      title: _existingEditedProduct.title,
                      description: _existingEditedProduct.description,
                      price: double.parse(newValue!),
                      imageUrl: _existingEditedProduct.imageUrl);
                }),
            TextFormField(
                initialValue: _initValues['description'],
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
                      isFavorite: _existingEditedProduct.isFavorite,
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
                          fit: BoxFit.fill,
                        ),
                ),
                Expanded(
                  child: TextFormField(
                      // initialValue: _initValues['imageUrl'],
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
                            isFavorite: _existingEditedProduct.isFavorite,
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
