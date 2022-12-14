import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod/helper/btn.dart';
import 'package:riverpod/helper/image_picer.dart';
import 'package:riverpod/helper/text_form.dart';
import 'package:riverpod/screens/add_products/controller/controller.dart';
import 'package:riverpod/screens/home/view.dart';

class AddProducts extends StatefulWidget{
  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  //[][][][][][]
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  dynamic image;
  //[][][][][][]
  PickedFile? _pickedFile;
  final _picker = ImagePicker();
  Future<void> _pickImage({ImageSource? source}) async {
    _pickedFile = await _picker.getImage(source: source!);
    // _pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (_pickedFile != null) {
      setState(() {
        image = File(_pickedFile!.path);
        print('No image selected.');
      });
    }
  }
  @override
  void initState() {
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    priceController = TextEditingController();
    discountController = TextEditingController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(),
     body: Form(
       key: formKey,
       child: SingleChildScrollView(
         child: Column(
           children: [
             const SizedBox(
               height: 50,
             ),
             Center(
               child: InkWell(
                 onTap: () {
                   openImagePicker(
                       context: context,
                       onCameraTapped: () {
                         _pickImage(
                           source: ImageSource.camera,
                         );
                       },
                       onGalleryTapped: () {
                         _pickImage(
                           source: ImageSource.gallery,
                         );
                         print("***************${image}*******************");
                       });
                 },
                 child: Container(
                   width: 88,
                   height: 88,
                   child: Stack(
                     alignment: Alignment.center,
                     children: [
                       ClipRRect(
                         borderRadius: BorderRadius.circular(15),
                         child: image != null
                             ? Image.file(
                           File(image!.path),
                           height: 150,
                           width: 150,
                           fit: BoxFit.fill,
                         )
                             : Image.network(
                           'https://elreviewz.com/wp-content/uploads/2021/04/beesline-products-review.jpg',
                           fit: BoxFit.fill,
                           width: double.infinity,
                           height: double.infinity,
                         ),
                       ),
                       Container(
                         alignment: Alignment.center,
                         width: double.infinity,
                         height: double.infinity,
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(15),
                           color: const Color.fromARGB(100, 0, 0, 0),
                         ),
                         child: Icon(
                           Icons.camera,
                           size: 20,
                         ),
                       ),
                     ],
                   ),
                 ),
               ),
             ),
             const SizedBox(
               height: 20,
             ),
             TxtField(
               controller: nameController,
               validator: (String? val) {
                 if (val!.isEmpty)
                   return 'Product Name';
                 else {
                   return null;
                 }
               },
               onSaved: (o) {
                 nameController.text = o;
               },
               hintText: 'Product Name',
               enabled: true,
               obscureText: false,
               textInputType: TextInputType.text,
             ),
             const SizedBox(
               height: 15,
             ),
             TxtField(
               controller: descriptionController,
               validator: (String? val) {
                 if (val!.isEmpty)
                   return 'descriptionController';
                 else {
                   return null;
                 }
               },
               onSaved: (o) {
                 descriptionController.text = o;
               },
               hintText: 'descriptionController',
               enabled: true,
               obscureText: false,
               textInputType: TextInputType.text,
             ),
             const SizedBox(
               height: 15,
             ),
             TxtField(
               controller: priceController,
               validator: (String? val) {
                 if (val!.isEmpty)
                   return 'priceController';
                 else {
                   return null;
                 }
               },
               onSaved: (o) {
                 priceController.text = o;
               },
               hintText: 'priceController',
               enabled: true,
               obscureText: false,
               textInputType: TextInputType.number,
             ),
             const SizedBox(
               height: 15,
             ),
             TxtField(
               controller: discountController,
               validator: (String? val) {
                 if (val!.isEmpty)
                   return 'discountController';
                 else {
                   return null;
                 }
               },
               onSaved: (o) {
                 discountController.text = o;
               },
               hintText: 'discountController',
               enabled: true,
               obscureText: false,
               textInputType: TextInputType.number,
             ),
             const SizedBox(
               height: 30,
             ),
             GetBuilder<ApiAddProducts>(
               builder: (data) {
                 return data.isLoading.value ?
                 const Center(
                   child: CircularProgressIndicator(),
                 ) : Btn(
                   onTap: () {
                     setState(() {
                       if (image == null) {
                         print(".........image...image...image..................");
                       } else {
                         if (!formKey.currentState!.validate()) {
                           print(".........validate...validate...validate..................");
                           return;
                         } else {
                           formKey.currentState!.save();
                           data.AddData(
                             image: image,
                             nameController: nameController,
                             descriptionController: descriptionController,
                             discountController: discountController,
                             priceController: priceController,
                           );
                           print(".........getData...getData...getData..................");
                           Navigator.pushAndRemoveUntil(
                             context,
                             MaterialPageRoute(builder: (context) => HomeView()),
                                 (Route<dynamic> route) => false,
                           );
                         }
                       }
                     });
                     // Get.toNamed('/add_products');
                   },
                   txt: 'Add Products',
                 );
               }
             ),
           ],
         ),
       ),
     ),
   );
  }
}