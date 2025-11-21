import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_vault_seller/core/data/model/user_model.dart';
import 'package:game_vault_seller/core/theme/app_colors.dart';
import 'package:game_vault_seller/features/auth/screens/blocs/auth_cupit.dart';
import 'package:game_vault_seller/features/auth/screens/blocs/auth_state.dart';
import 'package:game_vault_seller/features/dashboard/data/account_model.dart';
import 'package:game_vault_seller/features/dashboard/screens/blocs/account_state.dart';
import 'package:game_vault_seller/features/dashboard/screens/blocs/accounts_cupit.dart';
import 'package:image_picker/image_picker.dart';

class AddAccountScreen extends StatefulWidget {
  final AccountModel? existingAccount;
  const AddAccountScreen({super.key, this.existingAccount});

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  final List<XFile> _images = [];
  late TextEditingController accountName;
  late TextEditingController accountDescription;
  late TextEditingController price;
  bool isLoadingImages = false;
  bool isLoadingScreen = false;
  UserModel? user;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    accountName = TextEditingController();
    accountDescription = TextEditingController();
    price = TextEditingController();
    if (widget.existingAccount != null) {
      accountName.text = widget.existingAccount!.accountTitle;
      accountDescription.text = widget.existingAccount!.accountDescription;
      price.text = widget.existingAccount!.price.toString();
      _images.addAll(
        widget.existingAccount!.imageUrls.map((url) => XFile(url)).toList(),
      );
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userState = context.read<AuthCupit>().state;
      if (userState is AuthenticatedWithUserState) {
        user = userState.user;
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('User not authenticated')));
        context.read<AuthCupit>().signOut();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    accountName.dispose();
    accountDescription.dispose();
    price.dispose();
  }

  Future<void> onSubmit() async {
    if (user == null || isLoadingImages || isLoadingScreen) {
      return;
    }

    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Adding account, please wait...')),
        );
        context.read<AccountsCubit>().addAccount(
          accountName: accountName.text,
          accountDescription: accountDescription.text,
          price: double.parse(price.text),
          images: _images,
          user: user!,
        );
        final state = context.read<AccountsCubit>().state;
        if (state is AccountError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    log('Building AddAccountScreen. loading state is $isLoadingScreen');
    // Ensure only numbers are entered in price field
    price.addListener(() {
      final text = price.text;
      log('Price Text: $text');
      if (text.isNotEmpty && double.tryParse(text[text.length - 1]) == null) {
        price.text = text.substring(0, text.length - 1);
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Add Account'), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: buildTextField(
                  label: 'Account Name',
                  hint: 'Enter account name',
                  controller: accountName,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Account name cannot be empty'
                      : null,
                ),
              ),
              buildTextField(
                label: 'Account Description',
                hint: 'Enter account description',
                controller: accountDescription,
                validator: (value) => value == null || value.isEmpty
                    ? 'Account description cannot be empty'
                    : null,
              ),
              buildTextField(
                label: 'Price',
                hint: '10% service fee will be added',
                keyboardType: TextInputType.number,
                controller: price,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Price cannot be empty';
                  }
                  final parsedValue = double.tryParse(value);
                  if (parsedValue == null) {
                    return 'Please enter a valid number';
                  }
                  if (parsedValue <= 0) {
                    return 'Price must be greater than zero';
                  }
                  return null;
                },
              ),
              if (_images.isNotEmpty)
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    scrollDirection: Axis.horizontal,
                    itemCount: _images.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                title: Text(
                                  'Delete Image',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                content: Text(
                                  'Are you sure you want to delete this image?',
                                  style: TextStyle(color: Colors.black87),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _images.removeAt(index);
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Delete'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: _images[index].path.startsWith('http')
                              ? Image.network(
                                  _images[index].path,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  File(_images[index].path),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      );
                    },
                  ),
                ),
              addImagePicker(),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: isLoadingScreen ? null : onSubmit,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: isLoadingScreen
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Save Account'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required String label,
    required String hint,
    TextInputType? keyboardType,
    TextEditingController? controller,
    FormFieldValidator<String>? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          TextFormField(
            validator: validator,

            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.grey.shade400, width: 0),
              ),
              labelText: label,
              hintText: hint,
              fillColor: Colors.grey.shade200,
              // remove border
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2.0,
                ),
              ),
              filled: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget addImagePicker() {
    return GestureDetector(
      onTap: () async {
        setState(() {
          isLoadingImages = true;
        });
        final ImagePicker picker = ImagePicker();
        final List<XFile> images = await picker.pickMultiImage();
        if (images.isNotEmpty) {
          setState(() {
            _images.addAll(images);
          });
        }
        setState(() {
          isLoadingImages = false;
        });
      },
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Center(
          child: isLoadingImages
              ? CircularProgressIndicator(color: Color(AppColors.primary))
              : Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
        ),
      ),
    );
  }
}
