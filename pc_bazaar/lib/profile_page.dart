import 'package:flutter/material.dart';
import 'login_page.dart';
import 'backend.dart';

// ===================================================================
// PROFILE PAGE
// ===================================================================

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "Malik Aizaz";
  String email = "malikaizaz@email.com";
  bool isDarkMode = false;
  bool notificationsEnabled = true;
  String address = "House #123, Lahore, Pakistan";
  String profileImage = 'assets/profile.jpg';

  // ---------------- Edit Profile ----------------
  void _editProfile() {
    final nameController = TextEditingController(text: name);
    final emailController = TextEditingController(text: email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Profile"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Full Name"),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  name = nameController.text;
                  email = emailController.text;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Profile updated")));
              },
              child: const Text("Save")),
        ],
      ),
    );
  }

  // ---------------- Change Password ----------------
  void _changePassword() {
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Change Password"),
        content: TextField(
          controller: passwordController,
          decoration: const InputDecoration(labelText: "New Password"),
          obscureText: true,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Password changed successfully")));
              },
              child: const Text("Change")),
        ],
      ),
    );
  }

  // ---------------- Address Editor ----------------
  void _editAddress() {
    final addressController = TextEditingController(text: address);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Address"),
        content: TextField(
          controller: addressController,
          decoration: const InputDecoration(
            labelText: "Enter your address",
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  address = addressController.text;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Address updated")));
              },
              child: const Text("Save")),
        ],
      ),
    );
  }

  // ---------------- Help & Support ----------------
  void _helpSupport() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          runSpacing: 12,
          children: [
            const Center(
                child: Text(
              "Help & Support",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )),
            ListTile(
              leading: const Icon(Icons.email_outlined, color: Colors.blue),
              title: const Text("Email Support"),
              subtitle: const Text("support@myapp.com"),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Opening email support...")));
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone_outlined, color: Colors.green),
              title: const Text("Call Support"),
              subtitle: const Text("+92 300 1234567"),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Dialing support number...")));
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.orange),
              title: const Text("About App"),
              onTap: () {
                Navigator.pop(context);
                showAboutDialog(
                    context: context,
                    applicationName: "My Flutter App",
                    applicationVersion: "1.0.0",
                    applicationLegalese:
                        "Developed by Malik Aizaz © 2025 All Rights Reserved.");
              },
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- Logout ----------------
  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);

              await Backend.instance.signOut();

              // Navigate to Login Page
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  // ---------------- Main UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: const Color(0xFF0081FF),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --- Profile Header ---
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey.shade800 : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 3))
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage(profileImage),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color:
                                  isDarkMode ? Colors.white : Colors.black)),
                      const SizedBox(height: 4),
                      Text(email,
                          style: TextStyle(
                              color: isDarkMode
                                  ? Colors.grey.shade300
                                  : Colors.grey)),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: _editProfile,
                    icon: const Icon(Icons.edit, color: Colors.blue))
              ],
            ),
          ),
          const SizedBox(height: 20),

          // --- Account Settings ---
          Text("Account Settings",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.grey.shade300 : Colors.grey)),
          const SizedBox(height: 10),
          _buildListTile(Icons.person_outline, "Edit Profile", _editProfile),
          _buildListTile(Icons.lock_outline, "Change Password", _changePassword),
          SwitchListTile(
            value: notificationsEnabled,
            activeThumbColor: Colors.blue,
            title: const Text("Notifications"),
            secondary:
                const Icon(Icons.notifications_none, color: Colors.blue),
            onChanged: (value) =>
                setState(() => notificationsEnabled = value),
          ),
          _buildListTile(Icons.location_on_outlined, "Address", _editAddress),
          const SizedBox(height: 20),

          // --- App Settings ---
          Text("App Settings",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.grey.shade300 : Colors.grey)),
          const SizedBox(height: 10),

          SwitchListTile(
            value: isDarkMode,
            activeThumbColor: Colors.blue,
            title: const Text("Dark Mode"),
            secondary:
                const Icon(Icons.dark_mode_outlined, color: Colors.blue),
            onChanged: (value) => setState(() => isDarkMode = value),
          ),

          // ❌ REMOVED MY PRODUCTS SECTION COMPLETELY ❌

          _buildListTile(Icons.help_outline, "Help & Support", _helpSupport),
          const SizedBox(height: 20),

          // --- Logout Button ---
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            label: const Text(
              "Logout",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  // ---------------- Reusable Tile ----------------
  Widget _buildListTile(IconData icon, String title, VoidCallback onTap) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      color: isDarkMode ? Colors.grey.shade800 : Colors.white,
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF0081FF)),
        title: Text(title,
            style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
