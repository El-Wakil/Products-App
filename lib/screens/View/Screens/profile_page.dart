import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_api_app/cubit/cubit/auth_cubit.dart';
import 'package:product_api_app/cubit/cubit/auth_state.dart';
import 'package:product_api_app/models/camera_shot.dart';
import 'package:product_api_app/models/profile_response.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nationalIdController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    // Fetch profile data when the page loads
    context.read<AuthCubit>().getProfileCubit();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    nationalIdController.dispose();
    genderController.dispose();
    super.dispose();
  }

  void _populateFields(ProfileResponse profileData) {
    // Populate fields with actual user data if available
    if (profileData.user != null) {
      nameController.text = profileData.user!.name;
      emailController.text = profileData.user!.email;
      phoneController.text = profileData.user!.phone;
      nationalIdController.text = profileData.user!.nationalId;
      genderController.text = profileData.user!.gender;
    } else {
      // If no user data, show empty fields
      nameController.clear();
      emailController.clear();
      phoneController.clear();
      nationalIdController.clear();
      genderController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Profile' : 'Profile'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
              });
            },
            icon: Icon(isEditing ? Icons.cancel : Icons.edit),
          ),
        ],
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is ProfileSuccess) {
            _populateFields(state.profileData);
            if (state.profileData.status) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 10),
                      Text('Profile loaded successfully!'),
                    ],
                  ),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
            }
          } else if (state is ProfileUpdateSuccess) {
            setState(() {
              isEditing = false;
            });
            // Reload profile data after successful update
            context.read<AuthCubit>().getProfileCubit();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 10),
                    Text('Profile updated successfully!'),
                  ],
                ),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.error, color: Colors.white),
                    SizedBox(width: 10),
                    Expanded(child: Text(state.message)),
                  ],
                ),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
              ),
            );
          }
        },
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            // Show loading spinner while fetching profile or updating
            if (state is ProfileLoading || state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Profile Photo Section
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        String? profileImageUrl;
                        if (state is ProfileSuccess &&
                            state.profileData.user != null) {
                          profileImageUrl =
                              state.profileData.user!.profileImage;
                        }
                        return Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              if (profileImageUrl != null &&
                                  profileImageUrl.isNotEmpty &&
                                  !isEditing)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.network(
                                    profileImageUrl,
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                              Icons.person,
                                              size: 80,
                                              color: Colors.blue,
                                            ),
                                  ),
                                )
                              else
                                const Icon(
                                  Icons.person,
                                  size: 80,
                                  color: Colors.blue,
                                ),
                              const SizedBox(height: 10),
                              const Text(
                                'Profile Photo',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              if (isEditing) ...[
                                const SizedBox(height: 10),
                                CameraShot(),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 30),

                    // Form Fields
                    _buildTextField(
                      controller: nameController,
                      label: 'Full Name',
                      icon: Icons.person,
                      enabled: isEditing,
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      controller: emailController,
                      label: 'Email',
                      icon: Icons.email,
                      enabled: isEditing,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      controller: phoneController,
                      label: 'Phone Number',
                      icon: Icons.phone,
                      enabled: isEditing,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      controller: nationalIdController,
                      label: 'National ID',
                      icon: Icons.credit_card,
                      enabled: isEditing,
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      controller: genderController,
                      label: 'Gender',
                      icon: Icons.person_outline,
                      enabled: isEditing,
                    ),

                    if (isEditing) ...[
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: state is AuthLoading
                              ? null
                              : () {
                                  if (_validateForm()) {
                                    context
                                        .read<AuthCubit>()
                                        .updateProfileCubit(
                                          name: nameController.text.trim(),
                                          email: emailController.text.trim(),
                                          phone: phoneController.text.trim(),
                                          nationalId: nationalIdController.text
                                              .trim(),
                                          gender: genderController.text.trim(),
                                        );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: state is AuthLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  "Update Profile",
                                  style: TextStyle(fontSize: 18),
                                ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    // Logout Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.read<AuthCubit>().logout();
                          Navigator.of(
                            context,
                          ).pushNamedAndRemoveUntil('/', (route) => false);
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text('Logout'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool enabled,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        filled: !enabled,
        fillColor: enabled ? null : Colors.grey.withOpacity(0.1),
      ),
    );
  }

  bool _validateForm() {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your name'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    if (emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    if (!emailController.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    return true;
  }
}
