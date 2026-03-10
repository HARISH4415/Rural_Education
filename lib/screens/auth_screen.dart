import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pinput/pinput.dart';
import '../services/data_service.dart';
import '../utils/app_theme.dart';

IconData getAvatarIcon(String avatar) {
  switch (avatar) {
    case 'husky':
      return Icons.pets;
    case 'dog':
      return Icons.cruelty_free;
    case 'penguin':
      return Icons.ice_skating;
    case 'chick':
      return Icons.egg;
    case 'bear':
      return Icons.wb_sunny_outlined;
    case 'fox':
      return Icons.pest_control_rodent;
    default:
      return Icons.face;
  }
}

// --- PROFILE DETAILS PAGE ---
class ProfilePage extends StatelessWidget {
  final Map<String, dynamic> userData;
  final VoidCallback? onUpdate;
  const ProfilePage({super.key, required this.userData, this.onUpdate});

  @override
  Widget build(BuildContext context) {
    int stdInt =
        int.tryParse((userData['standard'] ?? '').replaceAll('Class ', '')) ??
        1;
    final theme = AppTheme.getTheme(stdInt);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            const SizedBox(height: 40),
            _buildProfileHeader(context, theme),
            const SizedBox(height: 35),
            _buildInfoCard(theme),
            const SizedBox(height: 35),
            _buildLogoutButton(context, theme),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, AppTheme theme) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: theme.cardGradient),
              ),
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 65,
                  backgroundColor: const Color(0xFFF1F5F9),
                  child: Icon(
                    getAvatarIcon(userData['avatar'] ?? 'husky'),
                    size: 70,
                    color: theme.primaryTextColor,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 5,
              right: 5,
              child: GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(userData: userData),
                    ),
                  );
                  if (result != null && result is Map<String, dynamic>) {
                    // In a real app, we'd use a state management solution or a callback
                    // For now, the user will see changes after navigation or re-load
                    // Since ProfilePage is stateless here, we might need a workaround
                    // if it's not re-built by the parent.
                    if (onUpdate != null) onUpdate!();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.navBarColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          userData['name'] ?? "Student Name",
          style: GoogleFonts.outfit(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: theme.primaryTextColor,
          ),
        ),
        Text(
          userData['email'] ?? "email@school.com",
          style: GoogleFonts.outfit(
            fontSize: 16,
            color: theme.secondaryTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(AppTheme theme) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDetailItem(
            Icons.school_rounded,
            "School",
            userData['school'] ?? "N/A",
            theme,
          ),
          _buildDivider(),
          _buildDetailItem(
            Icons.cake_rounded,
            "Age",
            (userData['age'] ?? 0).toString(),
            theme,
          ),
          _buildDivider(),
          _buildDetailItem(
            Icons.phone_android_rounded,
            "Parent's Phone",
            userData['parent_mobile'] ?? "N/A",
            theme,
          ),
          _buildDivider(),
          _buildDetailItem(
            Icons.layers_rounded,
            "Standard",
            userData['standard'] ?? "N/A",
            theme,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Divider(color: Colors.grey[100], height: 1),
    );
  }

  Widget _buildDetailItem(
    IconData icon,
    String label,
    String value,
    AppTheme theme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: theme.primaryTextColor, size: 22),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: theme.secondaryTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.outfit(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: theme.primaryTextColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, AppTheme theme) {
    return GestureDetector(
      onTap: () {
        Hive.box('settingsBox').delete('last_user_email');
        Hive.box('studentBox').delete('currentStudent');
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/auth', (route) => false);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.navBarColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: theme.navBarColor.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            "Logout Account",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}

// --- EDIT PROFILE PAGE ---
class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;
  const EditProfilePage({super.key, required this.userData});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _schoolController;
  late TextEditingController _ageController;
  late TextEditingController _phoneController;
  String? _selectedStandard;
  String _selectedAvatar = 'husky';
  bool _isLoading = false;

  final List<String> _standards = List.generate(
    12,
    (index) => 'Class ${index + 1}',
  );

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userData['name']);
    _schoolController = TextEditingController(text: widget.userData['school']);
    _ageController = TextEditingController(
      text: (widget.userData['age'] ?? '').toString(),
    );
    _phoneController = TextEditingController(
      text: widget.userData['parent_mobile'],
    );
    _selectedStandard = widget.userData['standard'];
    _selectedAvatar = widget.userData['avatar'] ?? 'husky';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _schoolController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);

    final updatedData = Map<String, dynamic>.from(widget.userData);
    updatedData['name'] = _nameController.text.trim();
    updatedData['school'] = _schoolController.text.trim();
    updatedData['age'] =
        int.tryParse(_ageController.text.trim()) ?? widget.userData['age'];
    updatedData['parent_mobile'] = _phoneController.text.trim();
    updatedData['standard'] = _selectedStandard;
    updatedData['avatar'] = _selectedAvatar;

    try {
      await DataService.saveStudentData(updatedData);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pop(context, updatedData);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating profile: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    int stdInt =
        int.tryParse(
          (widget.userData['standard'] ?? '').replaceAll('Class ', ''),
        ) ??
        1;
    final theme = AppTheme.getTheme(stdInt);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: theme.primaryTextColor,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.primaryTextColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            _buildTextField(
              "Full Name",
              _nameController,
              Icons.person_outline,
              theme,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              "School Name",
              _schoolController,
              Icons.school_outlined,
              theme,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              "Age",
              _ageController,
              Icons.cake_outlined,
              theme,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              "Parent's Mobile",
              _phoneController,
              Icons.phone_android_outlined,
              theme,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            _buildDropdownField(
              "Standard (Class)",
              _selectedStandard,
              _standards,
              Icons.layers_outlined,
              theme,
              (val) => setState(() => _selectedStandard = val),
            ),
            const SizedBox(height: 20),
            _buildAvatarSelector(theme),
            const SizedBox(height: 40),
            _buildSaveButton(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon,
    AppTheme theme, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: theme.primaryTextColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: GoogleFonts.outfit(),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: theme.cardGradient[0]),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              hintText: "Enter $label",
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(
    String label,
    String? currentValue,
    List<String> items,
    IconData icon,
    AppTheme theme,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: theme.primaryTextColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: currentValue,
              hint: Text("Select $label", style: GoogleFonts.outfit()),
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: theme.cardGradient[0],
              ),
              items:
                  items.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: GoogleFonts.outfit()),
                    );
                  }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarSelector(AppTheme theme) {
    final avatars = ['husky', 'dog', 'penguin', 'chick', 'bear', 'fox'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Choose Avatar",
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: theme.primaryTextColor,
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: avatars.length,
            separatorBuilder: (c, i) => const SizedBox(width: 15),
            itemBuilder: (context, index) {
              final avatar = avatars[index];
              final isSelected = _selectedAvatar == avatar;
              return GestureDetector(
                onTap: () => setState(() => _selectedAvatar = avatar),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: isSelected ? theme.cardGradient[0] : Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border:
                        isSelected
                            ? Border.all(color: Colors.white, width: 2)
                            : null,
                  ),
                  child: Icon(
                    getAvatarIcon(avatar),
                    size: 32,
                    color: isSelected ? Colors.white : theme.primaryTextColor,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(AppTheme theme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.navBarColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        child:
            _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                  "Save Changes",
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
      ),
    );
  }
}

// --- AUTH PAGE ---
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  bool isOtpSent = false;
  bool _obscurePassword = true;
  String? generatedOtp;

  final nameController = TextEditingController();
  final schoolController = TextEditingController();
  final ageController = TextEditingController();
  final parentMobileController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final otpController = TextEditingController();

  String? _selectedStandard;
  String _selectedBoard = 'CBSE';
  bool _isScholarshipChecked = false;
  String? _selectedCaste;

  final List<String> _standards = List.generate(
    12,
    (index) => 'Class ${index + 1}',
  );
  final List<String> _casteOptions = ['General', 'OBC', 'SC', 'ST', 'EWS'];

  void _showMsg(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.outfit()),
        backgroundColor:
            isError ? const Color(0xFFEF4444) : const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _sendOTP() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        _selectedStandard == null) {
      _showMsg("Please fill all details", isError: true);
      return;
    }
    generatedOtp = (Random().nextInt(9000) + 1000).toString();
    final Uri smsLaunchUri = Uri.parse(
      'sms:${parentMobileController.text}?body=Your OTP is: $generatedOtp',
    );
    try {
      if (await canLaunchUrl(smsLaunchUri)) {
        await launchUrl(smsLaunchUri, mode: LaunchMode.externalApplication);
        if (mounted) setState(() => isOtpSent = true);
      } else {
        _showMsg("Could not launch SMS. OTP is: $generatedOtp (for testing)");
        if (mounted) setState(() => isOtpSent = true);
      }
    } catch (e) {
      _showMsg("Error launching SMS", isError: true);
    }
  }

  void _verifyAndRegister() async {
    if (otpController.text == generatedOtp) {
      final data = {
        'name': nameController.text,
        'school': schoolController.text,
        'age': int.tryParse(ageController.text) ?? 0,
        'parent_mobile': parentMobileController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'standard': _selectedStandard,
        'board': _selectedBoard,
        'caste': _isScholarshipChecked ? _selectedCaste : 'N/A',
      };
      await DataService.saveStudentData(data);
      _showMsg("Registration Successful! Please Login.");
      if (mounted) {
        setState(() {
          isOtpSent = false;
          isLogin = true;
        });
      }
    } else {
      _showMsg("Invalid OTP!", isError: true);
    }
  }

  void _handleSignIn() async {
    final email = emailController.text.trim();
    final pass = passwordController.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      _showMsg("Enter email and password", isError: true);
      return;
    }

    final box = Hive.box('studentBox');
    final localUser = box.values.firstWhere(
      (u) => u is Map && u['email'] == email && u['password'] == pass,
      orElse: () => null,
    );

    if (localUser != null) {
      _navigateToDashboard(Map<String, dynamic>.from(localUser));
      return;
    } else {
      _showMsg("Invalid credentials!", isError: true);
    }
  }

  void _navigateToDashboard(Map<String, dynamic> data) {
    if (!mounted) return;

    final settings = Hive.box('settingsBox');
    settings.put('last_user_email', data['email']);

    final studentBox = Hive.box('studentBox');
    studentBox.put('currentStudent', data);

    String std = data['standard'] ?? '';
    int stdInt = int.tryParse(std.replaceAll('Class ', '')) ?? 1;

    Navigator.pushReplacementNamed(
      context,
      '/home',
      arguments: {'std': stdInt, 'avatar': 'husky'},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F1FF),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: isOtpSent ? _buildOtpForm() : _buildAuthForm(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthForm() {
    return Column(
      key: ValueKey(isLogin),
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF8B80F8), Color(0xFFFFC6A5)],
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.school_rounded,
              size: 50,
              color: Color(0xFF1E293B),
            ),
          ),
        ),
        const SizedBox(height: 25),
        Text(
          isLogin ? "Welcome Back" : "Start Learning",
          style: GoogleFonts.outfit(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          isLogin
              ? "Sign in to continue your journey"
              : "Create your student profile today",
          style: GoogleFonts.outfit(
            fontSize: 16,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 40),
        isLogin ? _buildSignInFields() : _buildSignUpFields(),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isLogin ? "New student?" : "Already have an account?",
              style: GoogleFonts.outfit(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            TextButton(
              onPressed: () => setState(() => isLogin = !isLogin),
              child: Text(
                isLogin ? "Sign Up" : "Sign In",
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF8B80F8),
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOtpForm() {
    return Column(
      key: const ValueKey("otp_view"),
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFF8B80F8), Color(0xFFBCF0DA)],
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified_user_rounded,
              size: 50,
              color: Color(0xFF1E293B),
            ),
          ),
        ),
        const SizedBox(height: 25),
        Text(
          "Verify Mobile",
          style: GoogleFonts.outfit(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Enter the code sent to your parent's phone",
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            fontSize: 16,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 40),
        Pinput(
          length: 4,
          controller: otpController,
          defaultPinTheme: PinTheme(
            width: 65,
            height: 65,
            textStyle: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
          focusedPinTheme: PinTheme(
            width: 65,
            height: 65,
            textStyle: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF8B80F8), width: 2),
            ),
          ),
          onCompleted: (v) => _verifyAndRegister(),
        ),
        const SizedBox(height: 50),
        _buildActionButton("VERIFY AND CONTINUE", _verifyAndRegister),
      ],
    );
  }

  Widget _buildSignInFields() {
    return Column(
      children: [
        _buildTextField("Email Address", Icons.email_outlined, emailController),
        const SizedBox(height: 20),
        _buildTextField(
          "Password",
          Icons.lock_open_rounded,
          passwordController,
          isPassword: true,
          suffix: IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: Colors.grey[400],
            ),
            onPressed:
                () => setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),
        const SizedBox(height: 35),
        _buildActionButton("SIGN IN", _handleSignIn),
      ],
    );
  }

  Widget _buildSignUpFields() {
    return Column(
      children: [
        _buildTextField(
          "Full Name",
          Icons.person_outline_rounded,
          nameController,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          "School Name",
          Icons.account_balance_outlined,
          schoolController,
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                "Age",
                Icons.cake_outlined,
                ageController,
                type: TextInputType.number,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 2,
              child: _buildTextField(
                "Parent Phone",
                Icons.phone_android_outlined,
                parentMobileController,
                type: TextInputType.phone,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildTextField("Email Address", Icons.email_outlined, emailController),
        const SizedBox(height: 20),
        _buildTextField(
          "Create Password",
          Icons.lock_open_rounded,
          passwordController,
          isPassword: true,
          suffix: IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: Colors.grey[400],
            ),
            onPressed:
                () => setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),
        const SizedBox(height: 20),
        _buildCustomDropdown(
          "Current Standard",
          Icons.layers_outlined,
          _selectedStandard,
          _standards,
          (v) => setState(() => _selectedStandard = v),
        ),
        const SizedBox(height: 25),
        _buildScholarshipTile(),
        if (_isScholarshipChecked) ...[
          const SizedBox(height: 20),
          _buildCustomDropdown(
            "Category",
            Icons.groups_outlined,
            _selectedCaste,
            _casteOptions,
            (v) => setState(() => _selectedCaste = v),
          ),
        ],
        const SizedBox(height: 40),
        _buildActionButton("CREATE ACCOUNT", _sendOTP),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    IconData icon,
    TextEditingController controller, {
    bool isPassword = false,
    TextInputType type = TextInputType.text,
    Widget? suffix,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? _obscurePassword : false,
        keyboardType: type,
        style: GoogleFonts.outfit(
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1E293B),
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.outfit(
            color: Colors.grey[500],
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Icon(icon, color: const Color(0xFF1E293B)),
          ),
          suffixIcon: suffix,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 22),
        ),
      ),
    );
  }

  Widget _buildCustomDropdown(
    String label,
    IconData icon,
    String? value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF1E293B)),
            labelText: label,
            labelStyle: GoogleFonts.outfit(
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
            border: InputBorder.none,
          ),
          value: value,
          icon: const Icon(Icons.expand_more_rounded, color: Colors.grey),
          items:
              items
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(
                        item,
                        style: GoogleFonts.outfit(
                          color: const Color(0xFF1E293B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                  .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildScholarshipTile() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
        ],
      ),
      child: CheckboxListTile(
        title: Text(
          "Scholarship Elite",
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: const Color(0xFF1E293B),
          ),
        ),
        subtitle: Text(
          "Join the elite scholarship group",
          style: GoogleFonts.outfit(fontSize: 13, color: Colors.grey[600]),
        ),
        value: _isScholarshipChecked,
        activeColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        onChanged: (v) => setState(() => _isScholarshipChecked = v!),
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFC6A5).withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.stars_rounded, color: Color(0xFFFFC6A5)),
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1E293B).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
