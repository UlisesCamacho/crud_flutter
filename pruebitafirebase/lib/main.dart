//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:cloud_firestore_web/cloud_firestore_web.dart';
//import 'package:cloud_firestore_web/cloud_firestore_web.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:carousel_slider/carousel_slider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().then((value){
    runApp(const MyApp());
    
  });
  
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
//LOGIN
class _MyHomePageState extends State<MyHomePage> {
  final myController1 = TextEditingController();
  final myController2 = TextEditingController();

 
  final List <String> usuarios=[];
  int _counter=0;
  final fibinstance = FirebaseFirestore.instance;
  void _incrementCounter() {
    fibinstance.collection("users").add({
      "name": "cruz",
      "job": "programador"
    });
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }
  @override
  void initState() {
    super.initState();
  //  getUsers();
    
  }
  void getUsers() async {
    CollectionReference collectionRef =FirebaseFirestore.instance.collection("peliculas");
    QuerySnapshot users = await collectionRef.get();

    if(users.docs.isNotEmpty)
    {
      for( var doc in users.docs)
      {
        // ignore: avoid_print
        print(doc.data());
        usuarios.add(doc.data.toString());
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo Home Page'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Image.network('https://www.hola.com/imagenes/estar-bien/20190426140762/perro-huevo-pompom-gt/0-669-982/portada-pompom-t.jpg'),

            ),

            Padding(
              padding: EdgeInsets.only(top: 45.0),
              child:Text('Usuario:',),
            ),
            Padding(
              padding: EdgeInsets.all(30.0),
              child:TextField( controller: myController1,),
            ),

            Text('Contraseña:',),
            Padding(
              padding: EdgeInsets.all(30.0),
              child:TextField( controller: myController2, obscureText: true,),

            ),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
      if(myController1.text=="admin" && myController2.text=="admin" ) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SideDrawer()),
        );
      }
      else{
        showDialog(
            context: context,
            builder: (context) {
                return AlertDialog(content: Text("Haz colocado los datos incorrectos"),);

            }
        );
      }
        },
        child: const Icon(Icons.admin_panel_settings_outlined),
      ),
    );
  }
}
InputDecoration decoration(String label) => InputDecoration(
  labelText: label,
  border: OutlineInputBorder(),
);
Future createUser(User user) async {
  final docUser = FirebaseFirestore.instance.collection('peliculas').doc();
  user.id=docUser.id;
  final json = user.toJson();
  await docUser.set(json);
}

class User{
  String id;
  final String name;
  final String gen;
  final String des;
  User({
    this.id='',
    required this.name,
    required this.gen,
    required this.des,
  });
  Map<String,dynamic> toJson() => {
    'id': id,
    'name': name,
    'gen': gen,
    'des': des,
  };
  static User fromJson (Map<String, dynamic>json)=> User(name: json['name'], gen: json['gen'],des: json['des']);
}
 final myControllerNameMovie = TextEditingController();
  final myControllerGenere = TextEditingController();
  final myControllerDesc = TextEditingController();

//TABLA
class tabla extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Retrieve Text Input'),
      ),
      body: ListView( 
        padding: EdgeInsets.all(16),
        children: <Widget>[
          TextField(
            controller: myControllerNameMovie,
            decoration: decoration('Name'),
          ),
            const SizedBox(height: 24),
            TextField(
              controller: myControllerGenere,
              decoration: decoration('Genero'),
            ),
              TextField(
            controller: myControllerDesc,
            decoration: decoration('Descripcion'),
          ),
            const SizedBox(height: 24),
            ElevatedButton(child: Text('Add'),
            onPressed: (){
              final user = User(
                name: myControllerNameMovie.text,
                gen: myControllerGenere.text,
                des: myControllerDesc.text,
              );
              createUser(user);
             // Navigator.pop(context);
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => crudRoute()),
            );
            },)
        ],
      ),
      
    );
    
    
  }
  Widget buildUser(User user) => ListTile(
    title: Text(user.name),
    subtitle: Text(user.gen),
    
  );
  Stream <List<User>> readUsers() => FirebaseFirestore.instance
    .collection('peliculas')
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());
}
//CRUD
class crudRoute extends StatelessWidget {
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: StreamBuilder<List<User>>(
          stream: readUsers(),
          builder: (context,snapshot) {
            if(snapshot.hasError){
              return Text('Something Wronf! ${snapshot.error}');
            }else if(snapshot.hasData){
              final users = snapshot.data!;
            
            return ListView(
                children: users.map(buildUser).toList(),
              );
            }else {return Center(child: CircularProgressIndicator());}
          }
          ),
          //introducir mas botones
          floatingActionButton: FloatingActionButton(onPressed: (){
              final docUser = FirebaseFirestore.instance
                .collection('peliculas')
                .doc('dG0mNvcUNs7oy58SCwYV');//poner nombre
                //update specific fields
                docUser.update(
                  { 'name': 'TOP GUN'}
               );
                //delete
                //.set
              //  docUser.update({
             //     'job':FieldValue.delete(),
            //    });
          },),
          
      );
    
    
  }
  Widget buildUser(User user) => ListTile(
    title: Text(user.name),
    subtitle: Text(user.gen),
    
  );
  Stream <List<User>> readUsers() => FirebaseFirestore.instance
    .collection('peliculas')
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());
}
//MENU
class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: Text(
                'Side menu  FlutterCorner',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.black,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Tabla'),
            onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context)=> tabla()))},
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Galeria'),
            onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context)=> galeria()))},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Noticias'),
            onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context)=> galeria()))},
          ),
          ListTile(
            leading: Icon(Icons.alarm_off_sharp),
            title: Text('Logout'),
            onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context)=> MyApp()))},
          ),
        ],
      ),
    );
  }
}
//galeria
const List<Item> _items = [
  Item(
    name: 'Spinach Pizza',
    totalPriceCents: 1299,
    uid: '1',
    imageProvider: NetworkImage('https://flutter'
        '.dev/docs/cookbook/img-files/effects/split-check/Food1.jpg'),
  ),
  Item(
    name: 'Veggie Delight',
    totalPriceCents: 799,
    uid: '2',
    imageProvider: NetworkImage('https://flutter'
        '.dev/docs/cookbook/img-files/effects/split-check/Food2.jpg'),
  ),
  Item(
    name: 'Chicken Parmesan',
    totalPriceCents: 1499,
    uid: '3',
    imageProvider: NetworkImage('https://flutter'
        '.dev/docs/cookbook/img-files/effects/split-check/Food3.jpg'),
  ),
];

@immutable
class galeria extends StatefulWidget {
  const galeria({Key? key}) : super(key: key);

  @override
  _ExampleDragAndDropState createState() => _ExampleDragAndDropState();
}

class _ExampleDragAndDropState extends State<galeria>
    with TickerProviderStateMixin {
  final List<Customer> _people = [
    Customer(
      name: 'Makayla',
      imageProvider: const NetworkImage('https://flutter'
          '.dev/docs/cookbook/img-files/effects/split-check/Avatar1.jpg'),
    ),
    Customer(
      name: 'Nathan',
      imageProvider: const NetworkImage('https://flutter'
          '.dev/docs/cookbook/img-files/effects/split-check/Avatar2.jpg'),
    ),
    Customer(
      name: 'Emilio',
      imageProvider: const NetworkImage('https://flutter'
          '.dev/docs/cookbook/img-files/effects/split-check/Avatar3.jpg'),
    ),
  ];

  final GlobalKey _draggableKey = GlobalKey();

  void _itemDroppedOnCustomerCart({
    required Item item,
    required Customer customer,
  }) {
    setState(() {
      customer.items.add(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: _buildAppBar(),
      body: _buildContent(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      iconTheme: const IconThemeData(color: Color(0xFFF64209)),
      title: Text(
        'Order Food',
        style: Theme.of(context).textTheme.headline4?.copyWith(
              fontSize: 36,
              color: const Color(0xFFF64209),
              fontWeight: FontWeight.bold,
            ),
      ),
      backgroundColor: const Color(0xFFF7F7F7),
      elevation: 0,
    );
  }

  Widget _buildContent() {
    return Stack(
      children: [
        SafeArea(
          child: Column(
            children: [
              Expanded(
                child: _buildMenuList(),
              ),
              _buildPeopleRow(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: _items.length,
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 12.0,
        );
      },
      itemBuilder: (context, index) {
        final item = _items[index];
        return _buildMenuItem(
          item: item,
        );
      },
    );
  }

  Widget _buildMenuItem({
    required Item item,
  }) {
    return LongPressDraggable<Item>(
      data: item,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: DraggingListItem(
        dragKey: _draggableKey,
        photoProvider: item.imageProvider,
      ),
      child: MenuListItem(
        name: item.name,
        price: item.formattedTotalItemPrice,
        photoProvider: item.imageProvider,
      ),
    );
  }

  Widget _buildPeopleRow() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 20.0,
      ),
      child: Row(
        children: _people.map(_buildPersonWithDropZone).toList(),
      ),
    );
  }

  Widget _buildPersonWithDropZone(Customer customer) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 6.0,
        ),
        child: DragTarget<Item>(
          builder: (context, candidateItems, rejectedItems) {
            return CustomerCart(
              hasItems: customer.items.isNotEmpty,
              highlighted: candidateItems.isNotEmpty,
              customer: customer,
            );
          },
          onAccept: (item) {
            _itemDroppedOnCustomerCart(
              item: item,
              customer: customer,
            );
          },
        ),
      ),
    );
  }
}

class CustomerCart extends StatelessWidget {
  const CustomerCart({
    Key? key,
    required this.customer,
    this.highlighted = false,
    this.hasItems = false,
  }) : super(key: key);

  final Customer customer;
  final bool highlighted;
  final bool hasItems;

  @override
  Widget build(BuildContext context) {
    final textColor = highlighted ? Colors.white : Colors.black;

    return Transform.scale(
      scale: highlighted ? 1.075 : 1.0,
      child: Material(
        elevation: highlighted ? 8.0 : 4.0,
        borderRadius: BorderRadius.circular(22.0),
        color: highlighted ? const Color(0xFFF64209) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 24.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: SizedBox(
                  width: 46,
                  height: 46,
                  child: Image(
                    image: customer.imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                customer.name,
                style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      color: textColor,
                      fontWeight:
                          hasItems ? FontWeight.normal : FontWeight.bold,
                    ),
              ),
              Visibility(
                visible: hasItems,
                maintainState: true,
                maintainAnimation: true,
                maintainSize: true,
                child: Column(
                  children: [
                    const SizedBox(height: 4.0),
                    Text(
                      customer.formattedTotalItemPrice,
                      style: Theme.of(context).textTheme.caption!.copyWith(
                            color: textColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      '${customer.items.length} item${customer.items.length != 1 ? 's' : ''}',
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: textColor,
                            fontSize: 12.0,
                          ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MenuListItem extends StatelessWidget {
  const MenuListItem({
    Key? key,
    this.name = '',
    this.price = '',
    required this.photoProvider,
    this.isDepressed = false,
  }) : super(key: key);

  final String name;
  final String price;
  final ImageProvider photoProvider;
  final bool isDepressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 12.0,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: SizedBox(
                width: 120,
                height: 120,
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeInOut,
                    height: isDepressed ? 115 : 120,
                    width: isDepressed ? 115 : 120,
                    child: Image(
                      image: photoProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 30.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          fontSize: 18.0,
                        ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    price,
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DraggingListItem extends StatelessWidget {
  const DraggingListItem({
    Key? key,
    required this.dragKey,
    required this.photoProvider,
  }) : super(key: key);

  final GlobalKey dragKey;
  final ImageProvider photoProvider;

  @override
  Widget build(BuildContext context) {
    return FractionalTranslation(
      translation: const Offset(-0.5, -0.5),
      child: ClipRRect(
        key: dragKey,
        borderRadius: BorderRadius.circular(12.0),
        child: SizedBox(
          height: 150,
          width: 150,
          child: Opacity(
            opacity: 0.85,
            child: Image(
              image: photoProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

@immutable
class Item {
  const Item({
    required this.totalPriceCents,
    required this.name,
    required this.uid,
    required this.imageProvider,
  });
  final int totalPriceCents;
  final String name;
  final String uid;
  final ImageProvider imageProvider;
  String get formattedTotalItemPrice =>
      '\$${(totalPriceCents / 100.0).toStringAsFixed(2)}';
}

class Customer {
  Customer({
    required this.name,
    required this.imageProvider,
    List<Item>? items,
  }) : items = items ?? [];

  final String name;
  final ImageProvider imageProvider;
  final List<Item> items;

  String get formattedTotalItemPrice {
    final totalPriceCents =
        items.fold<int>(0, (prev, item) => prev + item.totalPriceCents);
    return '\$${(totalPriceCents / 100.0).toStringAsFixed(2)}';
  }
}




