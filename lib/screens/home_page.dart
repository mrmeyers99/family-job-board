import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../fire_auth.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSendingVerification = false;
  bool _isSigningOut = false;
  late User _currentUser;

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(_currentUser.displayName!),
              accountEmail: Text(_currentUser.email!),
              currentAccountPicture: CircleAvatar(
                // backgroundImage: _getGravatar(user.email), todo: add gravatar
              ),
            ),
            ListTile(
              title: Text('Home'),
              trailing: Icon(Icons.add_circle_outline),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ));
              },
            ),
            ListTile(
              title: Text('Clip Recipe'),
              trailing: Icon(Icons.content_cut), //was attach_file, could use public
              onTap: () {
                showDialog(
                        context: context,
                        builder: (context) => InputAlertDialog("Enter a URL to clip", "url", TextInputType.url))
                    .then((url) async {
                  if (url != null) {
                    var recipe = await clippingService.clipRecipe(url);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditRecipeScreen(recipe),
                        ));
                  }
                });
              },
            ),
            ListTile(
              title: Text('Import JSON'),
              trailing: Icon(Icons.file_download),
              onTap: () async {
                var file = await _openFileExplorer();
                Navigator.pop(context);
                setState(() => _loading = true);
                log.info("uploading $file");
                var recipesToImport = await new File(file)
                    .readAsString()
                    .then((value) => Recipe.fromJsonList(value))
                    .then(recipeService.importRecipes);
//                  log.info(recipesToImport);
                setState(() => _loading = false);
              },
            ),
            ListTile(
              title: Text('Logout'),
              trailing: Icon(Icons.perm_identity), //could use people, lock, perm_identity, exit_to_app
              onTap: () {
                userService.signOut().then((result) => Navigator.pushReplacementNamed(context, LoginViewRoute));
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'NAME: ${_currentUser.displayName}',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(height: 16.0),
            Text(
              'EMAIL: ${_currentUser.email}',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(height: 16.0),
            _currentUser.emailVerified
                ? Text(
                    'Email verified',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.green),
                  )
                : Text(
                    'Email not verified',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.red),
                  ),
            _currentUser.emailVerified
                ? Container()
                : ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isSendingVerification = true;
                      });
                      await _currentUser.sendEmailVerification();
                      setState(() {
                        _isSendingVerification = false;
                      });
                    },
                    child: const Text('Verify email'),
                  ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () async {
                User? user = await FireAuth.refreshUser(_currentUser);
                if (user != null) {
                  setState(() {
                    _currentUser = user;
                  });
                }
              },
            ),
            ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
                child: const Text('Sign out')), // and, signing out the user
          ],
        ),
      ),
    );
  }
}
