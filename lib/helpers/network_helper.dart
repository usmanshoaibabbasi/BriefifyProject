import 'dart:convert';

import 'package:briefify/data/urls.dart';
import 'package:briefify/models/category_model.dart';
import 'package:briefify/models/comment_model.dart';
import 'package:briefify/models/post_model.dart';
import 'package:briefify/models/reply_model.dart';
import 'package:briefify/models/user_model.dart';
import 'package:briefify/models/verification_status_model.dart';
import 'package:briefify/screens/create_post_screen.dart';
import 'package:briefify/utils/prefs.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as diopref;

class NetworkHelper {
  /// Login user
  Future<Map> loginUser(String email, String password) async {
    try {
      final response = await post(Uri.parse(uLoginUser), body: {
        'email': email,
        'password': password,
      });
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        if (!decodedResponse['error']) {
          final decodedUser = decodedResponse['user'];
          final UserModel user = UserModel.fromJson(decodedUser);
          return {
            'error': false,
            'user': user,
          };
        } else {
          return {
            'error': true,
            'errorData': decodedResponse['error_data'].toString(),
          };
        }
      } else {
        return {
          'error': true,
          'errorData': response.statusCode == 500
              ? 'Server error : Please try again after a while'
              : response.statusCode == 404
                  ? 'Invalid Request : Not Found'
                  : 'Connection error : Please try again after a while',
        };
      }
    } catch (e) {
      return {
        'error': true,
        'errorData': e.toString(),
      };
    }
  }

  /// Reset password
  Future<Map> resetPassword(String email) async {
    try {
      final response = await post(Uri.parse(uResetPassword), body: {
        'email': email,
      });
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        if (!decodedResponse['error']) {
          return {
            'error': false,
            'message': decodedResponse['error_data'],
          };
        } else {
          return {
            'error': true,
            'errorData': decodedResponse['error_data'].toString(),
          };
        }
      } else {
        return {
          'error': true,
          'errorData': response.statusCode == 500
              ? 'Server error : Please try again after a while'
              : response.statusCode == 404
                  ? 'Invalid Request : Not Found'
                  : 'Connection error : Please try again after a while',
        };
      }
    } catch (e) {
      return {
        'error': true,
        'errorData': e.toString(),
      };
    }
  }

  /// Register user
  Future<Map> registerUser(
    String name,
    String email,
    String password,
    String phone,
    String credibility,
    String dob,
  ) async {
    try {
      String firebaseToken = await FirebaseMessaging.instance.getToken() ?? '';
      var request = MultipartRequest('POST', Uri.parse(uRegisterUser));
      // if (image != null) {
      //   request.files.add(await MultipartFile.fromPath("picture", image.path));
      // }
      request.fields.addAll({
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'credibility': credibility,
        'dob': dob,
      });
      StreamedResponse streamedResponse = await request.send();
      if (streamedResponse.statusCode == 200) {
        var response = await streamedResponse.stream.bytesToString();
        var decodedResponse = jsonDecode(response);
        print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
        print(decodedResponse);
        if (!decodedResponse['error']) {
          /// Good to go
          var decodedUser = decodedResponse['user'];
          return {
            'error': false,
            'user': UserModel.fromJson(decodedUser),
          };
        } else {
          return {
            'error': true,
            'errorData': decodedResponse['error_data'].toString(),
          };
        }
      } else {
        return {
          'error': true,
          'errorData': streamedResponse.statusCode == 500
              ? 'Server error : Please try again after a while 500'
              : streamedResponse.statusCode == 404
                  ? 'Invalid Request : Not Found'
                  : 'Connection error : Please try again after a while 404',
        };
      }
    } catch (e) {
      return {
        'error': true,
        'errorData': e.toString(),
      };
    }
  }

  // Update User Phone

  Future<Map> updateUserphone(
    String phone,
  ) async {
    try {
      final String apiToken = await Prefs().getApiToken();
      print(apiToken);
      var request = MultipartRequest('POST', Uri.parse(uUpdateUserPhone,));
      request.headers["authorization"] = "Bearer $apiToken";
      request.fields.addAll({
        'phone': phone,
        // 'api_token': apiToken,
      });
      print('Sending request');
      print(phone);

      StreamedResponse streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        var response = await streamedResponse.stream.bytesToString();
        print('Response: $response');
        var decodedResponse = jsonDecode(response);
        if (!decodedResponse['error']) {
          print('Response: $response');

          /// Good to go
          var decodedUser = decodedResponse['user'];
          return {
            'error': false,
          };
        } else {
          return {
            'error': true,
            'errorData': decodedResponse['error_data'].toString(),
          };
        }
      } else {
        return {
          'error': true,
          'errorData': streamedResponse.statusCode == 500
              ? 'Server error : Please try again after a while 500'
              : streamedResponse.statusCode == 404
                  ? 'Invalid Request : Not Found'
                  : 'Connection error : Please try again after a while',
        };
      }
    } catch (e) {
      return {
        'error': true,
        'errorData': e.toString(),
      };
    }
  }

  /// update user
  Future<Map> updateUser(
      XFile? image, XFile? cover, Map<String, String> updates) async {
    try {
      // String firebaseToken = await FirebaseMessaging.instance.getToken() ?? '';
      var request = MultipartRequest('POST', Uri.parse(uUpdateUser));
      if (image != null) {
        request.files.add(await MultipartFile.fromPath("image", image.path));
      }
      if (cover != null) {
        request.files.add(await MultipartFile.fromPath("cover", cover.path));
      }
      request.fields.addAll(updates);
      StreamedResponse streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        var response = await streamedResponse.stream.bytesToString();
        var decodedResponse = jsonDecode(response);
        if (!decodedResponse['error']) {
          /// Good to go
          var decodedUser = decodedResponse['user'];
          return {
            'error': false,
            'user': UserModel.fromJson(decodedUser),
          };
        } else {
          return {
            'error': true,
            'errorData': decodedResponse['error_data'].toString(),
          };
        }
      } else {
        return {
          'error': true,
          'errorData': streamedResponse.statusCode == 500
              ? 'Server error : Please try again after a while'
              : streamedResponse.statusCode == 404
                  ? 'Invalid Request : Not Found'
                  : 'Connection error : Please try again after a while',
        };
      }
    } catch (e) {
      return {
        'error': true,
        'errorData': e.toString(),
      };
    }
  }

  /// apply for verification user
  Future<Map> applyForVerification(FilePickerResult document) async {
    try {
      final String apiToken = await Prefs().getApiToken();
      // String firebaseToken = await FirebaseMessaging.instance.getToken() ?? '';
      var request = MultipartRequest('POST', Uri.parse(uRequestVerification));
      if (document.paths.isNotEmpty) {
        request.files.add(
            await MultipartFile.fromPath("document", document.paths[0] ?? ''));
      }
      request.fields.addAll({
        'api_token': apiToken,
      });
      StreamedResponse streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        var response = await streamedResponse.stream.bytesToString();
        var decodedResponse = jsonDecode(response);
        if (!decodedResponse['error']) {
          /// Good to go
          return {
            'error': false,
          };
        } else {
          return {
            'error': true,
            'errorData': decodedResponse['error_data'].toString(),
          };
        }
      } else {
        return {
          'error': true,
          'errorData': streamedResponse.statusCode == 500
              ? 'Server error : Please try again after a while'
              : streamedResponse.statusCode == 404
                  ? 'Invalid Request : Not Found'
                  : 'Connection error : Please try again after a while',
        };
      }
    } catch (e) {
      return {
        'error': true,
        'errorData': e.toString(),
      };
    }
  }

  /// update firebase token
  Future<Map> updateFirebaseToken() async {
    try {
      String firebaseToken = await FirebaseMessaging.instance.getToken() ?? '';
      final String apiToken = await Prefs().getApiToken();
      final response = await post(Uri.parse(uUpdateUser), body: {
        'api_token': apiToken,
        'firebase_token': firebaseToken,
      });
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        if (!decodedResponse['error']) {
          /// Good to go
          var decodedUser = decodedResponse['user'];
          return {
            'error': false,
            'user': UserModel.fromJson(decodedUser),
          };
        } else {
          return {
            'error': true,
            'errorData': decodedResponse['error_data'].toString(),
          };
        }
      } else {
        return {
          'error': true,
          'errorData': response.statusCode == 500
              ? 'Server error : Please try again after a while'
              : response.statusCode == 404
                  ? 'Invalid Request : Not Found'
                  : 'Connection error : Please try again after a while',
        };
      }
    } catch (e) {
      return {
        'error': true,
        'errorData': e.toString(),
      };
    }
  }

  /// like post
  Future<Map> likePost(String id) async {
    try {
      final String apiToken = await Prefs().getApiToken();
      final response = await post(Uri.parse(uLikePost), body: {
        'api_token': apiToken,
        'post_id': id,
      });
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        if (!decodedResponse['error']) {
          /// Good to go
          return {
            'error': false,
          };
        } else {
          return {
            'error': true,
            'errorData': decodedResponse['error_data'].toString(),
          };
        }
      } else {
        return {
          'error': true,
          'errorData': response.statusCode == 500
              ? 'Server error : Please try again after a while'
              : response.statusCode == 404
                  ? 'Invalid Request : Not Found'
                  : 'Connection error : Please try again after a while',
        };
      }
    } catch (e) {
      return {
        'error': true,
        'errorData': e.toString(),
      };
    }
  }

  /// unlike post
  Future<Map> unlikePost(String id) async {
    try {
      final String apiToken = await Prefs().getApiToken();
      final response = await post(Uri.parse(uUnlikePost), body: {
        'api_token': apiToken,
        'post_id': id,
      });
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        if (!decodedResponse['error']) {
          /// Good to go
          return {
            'error': false,
          };
        } else {
          return {
            'error': true,
            'errorData': decodedResponse['error_data'].toString(),
          };
        }
      } else {
        return {
          'error': true,
          'errorData': response.statusCode == 500
              ? 'Server error : Please try again after a while'
              : response.statusCode == 404
                  ? 'Invalid Request : Not Found'
                  : 'Connection error : Please try again after a while',
        };
      }
    } catch (e) {
      return {
        'error': true,
        'errorData': e.toString(),
      };
    }
  }

  /// dislike post
  Future<Map> dislikePost(String id) async {
    try {
      final String apiToken = await Prefs().getApiToken();
      final response = await post(Uri.parse(uDislikePost), body: {
        'api_token': apiToken,
        'post_id': id,
      });
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        if (!decodedResponse['error']) {
          /// Good to go
          return {
            'error': false,
          };
        } else {
          return {
            'error': true,
            'errorData': decodedResponse['error_data'].toString(),
          };
        }
      } else {
        return {
          'error': true,
          'errorData': response.statusCode == 500
              ? 'Server error : Please try again after a while'
              : response.statusCode == 404
                  ? 'Invalid Request : Not Found'
                  : 'Connection error : Please try again after a while',
        };
      }
    } catch (e) {
      return {
        'error': true,
        'errorData': e.toString(),
      };
    }
  }

  /// unDislike post
  Future<Map> unDislikePost(String id) async {
    try {
      final String apiToken = await Prefs().getApiToken();
      final response = await post(Uri.parse(uUnDislikePost), body: {
        'api_token': apiToken,
        'post_id': id,
      });
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        if (!decodedResponse['error']) {
          /// Good to go
          return {
            'error': false,
          };
        } else {
          return {
            'error': true,
            'errorData': decodedResponse['error_data'].toString(),
          };
        }
      } else {
        return {
          'error': true,
          'errorData': response.statusCode == 500
              ? 'Server error : Please try again after a while'
              : response.statusCode == 404
                  ? 'Invalid Request : Not Found'
                  : 'Connection error : Please try again after a while',
        };
      }
    } catch (e) {
      return {
        'error': true,
        'errorData': e.toString(),
      };
    }
  }

  /// delete post
  Future<Map> deletePost(String id) async {
    try {
      final String apiToken = await Prefs().getApiToken();
      final response = await post(Uri.parse(uDeletePost), body: {
        'api_token': apiToken,
        'post_id': id,
      });
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        if (!decodedResponse['error']) {
          /// Good to go
          return {
            'error': false,
          };
        } else {
          return {
            'error': true,
            'errorData': decodedResponse['error_data'].toString(),
          };
        }
      } else {
        return {
          'error': true,
          'errorData': response.statusCode == 500
              ? 'Server error : Please try again after a while'
              : response.statusCode == 404
                  ? 'Invalid Request : Not Found'
                  : 'Connection error : Please try again after a while',
        };
      }
    } catch (e) {
      return {
        'error': true,
        'errorData': e.toString(),
      };
    }
  }

  /// follow user
  Future<Map> followUser(String userID) async {
    try {
      final String apiToken = await Prefs().getApiToken();
      final response = await post(Uri.parse(uFollowUser), body: {
        'api_token': apiToken,
        'opponent_id': userID,
      });
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        if (!decodedResponse['error']) {
          /// Good to go
          return {
            'error': false,
          };
        } else {
          return {
            'error': true,
            'errorData': decodedResponse['error_data'].toString(),
          };
        }
      } else {
        return {
          'error': true,
          'errorData': response.statusCode == 500
              ? 'Server error : Please try again after a while'
              : response.statusCode == 404
                  ? 'Invalid Request : Not Found'
                  : 'Connection error : Please try again after a while',
        };
      }
    } catch (e) {
      return {
        'error': true,
        'errorData': e.toString(),
      };
    }
  }

  /// unfollow user
  Future<Map> unfollowUser(String userID) async {
    try {
      final String apiToken = await Prefs().getApiToken();
      final response = await post(Uri.parse(uUnfollowUser), body: {
        'api_token': apiToken,
        'opponent_id': userID,
      });
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        if (!decodedResponse['error']) {
          /// Good to go
          return {
            'error': false,
          };
        } else {
          return {
            'error': true,
            'errorData': decodedResponse['error_data'].toString(),
          };
        }
      } else {
        return {
          'error': true,
          'errorData': response.statusCode == 500
              ? 'Server error : Please try again after a while'
              : response.statusCode == 404
                  ? 'Invalid Request : Not Found'
                  : 'Connection error : Please try again after a while',
        };
      }
    } catch (e) {
      return {
        'error': true,
        'errorData': e.toString(),
      };
    }
  }

  /// Get categories
  Future<Map> getCategories() async {
    try {
      final String apiToken = await Prefs().getApiToken();
      final response = await post(Uri.parse(uGetCategories), body: {
        'api_token': apiToken,
      });
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        if (!decodedResponse['error']) {
          // print(decodedResponse);
          var a = decodedResponse["categories"];
          print(
              'Here is the list of categories Here is the list of categories Here is the list of categories');
          print(a);

          for (var r in a) {
            var id = r['id'];
            var name = r['name'];
            categorylist2.add(name);
            CategoryModal1 addtomodal = CategoryModal1(
              id: id,
              name: name,
            );
            categorylist.add(addtomodal);
          }

          final List<CategoryModel> _categories = List.empty(growable: true);
          final decodedCategories = decodedResponse['categories'];
          for (final decodeCategory in decodedCategories) {
            _categories.add(CategoryModel.fromJson(decodeCategory));
          }
          return {
            'error': false,
            'categories': _categories,
          };
        } else {
          return {
            'error': true,
            'errorData': decodedResponse['error_data'].toString(),
          };
        }
      } else {
        return {
          'error': true,
          'errorData': response.statusCode == 500
              ? 'Server error : Please try again after a while'
              : response.statusCode == 404
                  ? 'Invalid Request : Not Found'
                  : 'Connection error : Please try again after a while',
        };
      }
    } catch (e) {
      return {
        'error': true,
        'errorData': e.toString(),
      };
    }
  }

  /// Create a post
  Future<Map> createPost(
    String categoryID,
    String heading,
    String summary,
    String articleLink,
    String videoLink,
    FilePickerResult? pdfFile,
    String type,
  ) async {
    try {
      final String apiToken = await Prefs().getApiToken();
      var request = MultipartRequest('POST', Uri.parse(uCreatePost));
      if (pdfFile != null && pdfFile.paths.isNotEmpty) {
        request.files
            .add(await MultipartFile.fromPath("pdf", pdfFile.paths[0] ?? ''));
      }
      request.fields.addAll({
        'api_token': apiToken,
        'category_id': categoryID,
        'heading': heading,
        'summary': summary,
        'article_link': articleLink,
        'video_link': videoLink,
        'type': type,
      });
      StreamedResponse streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        var response = await streamedResponse.stream.bytesToString();

        var decodedResponse = jsonDecode(response);
        if (!decodedResponse['error']) {
          /// Good to go
          var decodedPost = decodedResponse['post'];
          return {
            'error': false,
            'post': PostModel.fromJson(decodedPost),
          };
        } else {
          return {
            'error': true,
            'errorData': decodedResponse['error_data'].toString(),
          };
        }
      } else {
        return {
          'error': true,
          'errorData': streamedResponse.statusCode == 500
              ? 'Server error : Please try again after a while'
              : streamedResponse.statusCode == 404
                  ? 'Invalid Request : Not Found'
                  : 'Connection error : Please try again after a while',
        };
      }
    } catch (e) {
      return {
        'error': true,
        'errorData': e.toString(),
      };
    }
  }

  //Report User is Done Here
  Future<Map> blockUser(
    int whomblocked,
    int whoblocked,
  ) async {
    try {
      final String apiToken = await Prefs().getApiToken();
      var request =
          MultipartRequest('POST', Uri.parse(uBlockPost)); // here change
      request.fields.addAll({
        'api_token': apiToken,
        'whomblocked': whomblocked.toString(),
        'whoblocked': whoblocked.toString(),
      });
      print('Sending request');
      StreamedResponse streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        var response = await streamedResponse.stream.bytesToString();

        print('Response: $response');

        var decodedResponse = jsonDecode(response);
        if (!decodedResponse['error']) {
          /// Good to go
          var decodedPost = decodedResponse['post'];
          return {
            'error': false,
            'post':
                decodedPost != null ? PostModel.fromJson(decodedPost) : null,
          };
        } else {
          return {
            'error': true,
            'errorData': decodedResponse['error_data'].toString(),
          };
        }
      } else {
        return {
          'error': true,
          'errorData': streamedResponse.statusCode == 500
              ? 'Server error : Please try again after a while'
              : streamedResponse.statusCode == 404
                  ? 'Invalid Request : Not Found'
                  : 'Connection error : Please try again after a while',
        };
      }
    } catch (e) {
      return {
        'error': true,
        'errorData': e.toString(),
      };
    }
  }
  //Block User is Done Here

  //Report User is Done Here
  Future<Map> reportUser(
    String description,
    String selectedvalue,
    int userid,
    int postid,
  ) async {
    try {
      final String apiToken = await Prefs().getApiToken();
      var request =
          MultipartRequest('POST', Uri.parse(uReportPost)); // here change
      request.fields.addAll({
        'api_token': apiToken,
        'description': description,
        'title': selectedvalue,
        'user_id': userid.toString(),
        'post_id': postid.toString(),
      });
      print('Sending request');
      StreamedResponse streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        var response = await streamedResponse.stream.bytesToString();
        print('Response: $response');
        var decodedResponse = jsonDecode(response);
        if (!decodedResponse['error']) {
          /// Good to go
          var decodedPost = decodedResponse['post'];
          return {
            'error': false,
            'post':
                decodedPost != null ? PostModel.fromJson(decodedPost) : null,
          };
        } else {
          return {
            'error': true,
            'errorData': decodedResponse['error_data'].toString(),
          };
        }
      } else {
        return {
          'error': true,
          'errorData': streamedResponse.statusCode == 500
              ? 'Server error : Please try again after a while'
              : streamedResponse.statusCode == 404
                  ? 'Invalid Request : Not Found'
                  : 'Connection error : Please try again after a while',
        };
      }
    } catch (e) {
      return {
        'error': true,
        'errorData': e.toString(),
      };
    }
  }
  //Report User is Done Here

  //Edit Post is Done Here
  Future<Map> editPost(
    String categoryID,
    String heading,
    String summary,
    String articleLink,
    String videoLink,
    String postId,
    String userId,
  ) async {
    try {
      final String apiToken = await Prefs().getApiToken();
      var request = MultipartRequest('POST', Uri.parse(uEditPost));
      request.fields.addAll({
        'api_token': apiToken,
        'category_id': categoryID,
        'heading': heading,
        'summary': summary,
        'article_link': articleLink,
        'video_link': videoLink,
        'postId': postId,
        'userId': userId,
      });
      print('Sending request');
      StreamedResponse streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        var response = await streamedResponse.stream.bytesToString();

        print('Response: $response');

        var decodedResponse = jsonDecode(response);
        if (!decodedResponse['error']) {
          /// Good to go
          var decodedPost = decodedResponse['post'];
          return {
            'error': false,
            'post':
                decodedPost != null ? PostModel.fromJson(decodedPost) : null,
          };
        } else {
          return {
            'error': true,
            'errorData': decodedResponse['error_data'].toString(),
          };
        }
      } else {
        return {
          'error': true,
          'errorData': streamedResponse.statusCode == 500
              ? 'Server error : Please try again after a while'
              : streamedResponse.statusCode == 404
                  ? 'Invalid Request : Not Found'
                  : 'Connection error : Please try again after a while',
        };
      }
    } catch (e) {
      return {
        'error': true,
        'errorData': e.toString(),
      };
    }
  }
  //Edit Post is Done Here

  /// Get home posts
  Future<Map> getHomePosts(String url) async {
    try {
      final String apiToken = await Prefs().getApiToken();
      final response = await post(Uri.parse(url), body: {
        'api_token': apiToken,
      });
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        if (!decodedResponse['error']) {
          final decodedPosts = decodedResponse['posts'];
          final int currentPage = decodedPosts['current_page'];
          final int lastPage = decodedPosts['last_page'];
          final String nextPageURL =
              currentPage == lastPage ? '' : decodedPosts['next_page_url'];
          final decodedPostsData = decodedPosts['data'];
          List<PostModel> _posts = List.empty(growable: true);
          for (final decodedPostData in decodedPostsData) {
            _posts.add(PostModel.fromJson(decodedPostData));
          }
          return {
            'error': false,
            'currentPage': currentPage,
            'lastPage': lastPage,
            'nextPageURL': nextPageURL,
            'posts': _posts,
          };
        } else {
          return {
            'error': true,
            'errorData': decodedResponse['error_data'].toString(),
          };
        }
      } else {
        return {
          'error': true,
          'errorData': response.statusCode == 500
              ? 'Server error : Please try again after a while'
              : response.statusCode == 404
                  ? 'Invalid Request : Not Found'
                  : 'Connection error : Please try again after a while',
        };
      }
    } catch (e) {
      return {
        'error': true,
        'errorData': e.toString(),
      };
    }
  }

  /// Get user posts
  Future<Map> getUserPosts(String url, String userID) async {
    try {
      final String apiToken = await Prefs().getApiToken();
      final response = await post(Uri.parse(url), body: {
        'api_token': apiToken,
        'user_id': userID,
      });
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        if (!decodedResponse['error']) {
          final decodedPosts = decodedResponse['posts'];
          final int currentPage = decodedPosts['current_page'];
          final int lastPage = decodedPosts['last_page'];
          final String nextPageURL =
              currentPage == lastPage ? '' : decodedPosts['next_page_url'];
          final decodedPostsData = decodedPosts['data'];
          List<PostModel> _posts = List.empty(growable: true);
          for (final decodedPostData in decodedPostsData) {
            _posts.add(PostModel.fromJson(decodedPostData));
          }
          return {
            'error': false,
            'currentPage': currentPage,
            'lastPage': lastPage,
            'nextPageURL': nextPageURL,
            'posts': _posts,
          };
        } else {
          return {
            'error': true,
            'errorData': decodedResponse['error_data'].toString(),
          };
        }
      } else {
        return {
          'error': true,
          'errorData': response.statusCode == 500
              ? 'Server error : Please try again after a while'
              : response.statusCode == 404
                  ? 'Invalid Request : Not Found'
                  : 'Connection error : Please try again after a while',
        };
      }
    } catch (e) {
      return {
        'error': true,
        'errorData': e.toString(),
      };
    }
  }

  /// Search posts
  Future<Map> searchPosts(String url, String statement) async {
    try {
      final String apiToken = await Prefs().getApiToken();
      final response = await post(Uri.parse(url), body: {
        'api_token': apiToken,
        'statement': statement,
      });
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        if (!decodedResponse['error']) {
          final decodedPosts = decodedResponse['posts'];
          final int currentPage = decodedPosts['current_page'];
          final int lastPage = decodedPosts['last_page'];
          final String nextPageURL =
              currentPage == lastPage ? '' : decodedPosts['next_page_url'];
          final decodedPostsData = decodedPosts['data'];
          List<PostModel> _posts = List.empty(growable: true);
          for (final decodedPostData in decodedPostsData) {
            _posts.add(PostModel.fromJson(decodedPostData));
          }
          return {
            'error': false,
            'currentPage': currentPage,
            'lastPage': lastPage,
            'nextPageURL': nextPageURL,
            'posts': _posts,
          };
        } else {
          return {
            'error': true,
            'errorData': decodedResponse['error_data'].toString(),
          };
        }
      } else {
        return {
          'error': true,
          'errorData': response.statusCode == 500
              ? 'Server error : Please try again after a while'
              : response.statusCode == 404
                  ? 'Invalid Request : Not Found'
                  : 'Connection error : Please try again after a while',
        };
      }
    } catch (e) {
      return {
        'error': true,
        'errorData': e.toString(),
      };
    }
  }

  /// Get category posts
  Future<Map> getPostsByCategory(String url, String categoryID) async {
    try {
      final String apiToken = await Prefs().getApiToken();
      final response = await post(Uri.parse(url), body: {
        'api_token': apiToken,
        'category_id': categoryID,
      });
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        if (!decodedResponse['error']) {
          final decodedPosts = decodedResponse['posts'];
          final int currentPage = decodedPosts['current_page'];
          final int lastPage = decodedPosts['last_page'];
          final String nextPageURL =
              currentPage == lastPage ? '' : decodedPosts['next_page_url'];
          final decodedPostsData = decodedPosts['data'];
          List<PostModel> _posts = List.empty(growable: true);
          for (final decodedPostData in decodedPostsData) {
            _posts.add(PostModel.fromJson(decodedPostData));
          }
          return {
            'error': false,
            'currentPage': currentPage,
            'lastPage': lastPage,
            'nextPageURL': nextPageURL,
            'posts': _posts,
          };
        } else {
          return {
            'error': true,
            'errorData': decodedResponse['error_data'].toString(),
          };
        }
      } else {
        return {
          'error': true,
          'errorData': response.statusCode == 500
              ? 'Server error : Please try again after a while'
              : response.statusCode == 404
                  ? 'Invalid Request : Not Found'
                  : 'Connection error : Please try again after a while',
        };
      }
    } catch (e) {
      return {
        'error': true,
        'errorData': e.toString(),
      };
    }
  }

  /// Get post comments
  Future<Map> getPostComments(String postID) async {
    try {
      final String apiToken = await Prefs().getApiToken();
      final response = await post(Uri.parse(uGetPostComments), body: {
        'api_token': apiToken,
        'post_id': postID,
      });
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        if (!decodedResponse['error']) {
          List<CommentModel> comments = List.empty(growable: true);
          final decodedComments = decodedResponse['post']['comments'];
          for (final decodedComment in decodedComments) {
            comments.add(CommentModel.fromJson(decodedComment));
          }
          return {
            'error': false,
            'comments': List<CommentModel>.from(comments.reversed),
          };
        } else {
          return {
            'error': true,
            'errorData': decodedResponse['error_data'].toString(),
          };
        }
      } else {
        return {
          'error': true,
          'errorData': response.statusCode == 500
              ? 'Server error : Please try again after a while'
              : response.statusCode == 404
                  ? 'Invalid Request : Not Found'
                  : 'Connection error : Please try again after a while',
        };
      }
    } catch (e) {
      return {
        'error': true,
        'errorData': e.toString(),
      };
    }
  }

  /// Create post comment
  Future<Map> createPostComment(String postID, String comment) async {
    try {
      final String apiToken = await Prefs().getApiToken();
      final response = await post(Uri.parse(uCreatePostComment), body: {
        'api_token': apiToken,
        'post_id': postID,
        'comment': comment,
      });
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        if (!decodedResponse['error']) {
          final decodedComment = decodedResponse['comment'];
          CommentModel commentModel = CommentModel.fromJson(decodedComment);
          return {
            'error': false,
            'comment': commentModel,
          };
        } else {
          return {
            'error': true,
            'errorData': decodedResponse['error_data'].toString(),
          };
        }
      } else {
        return {
          'error': true,
          'errorData': response.statusCode == 500
              ? 'Server error : Please try again after a while'
              : response.statusCode == 404
                  ? 'Invalid Request : Not Found'
                  : 'Connection error : Please try again after a while',
        };
      }
    } catch (e) {
      return {
        'error': true,
        'errorData': e.toString(),
      };
    }
  }

  /// Create comment reply
  Future<Map> createCommentReply(String commentID, String replyText) async {
    try {
      final String apiToken = await Prefs().getApiToken();
      final response = await post(Uri.parse(uCreateCommentReply), body: {
        'api_token': apiToken,
        'post_comment_id': commentID,
        'text': replyText,
      });
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        if (!decodedResponse['error']) {
          return {
            'error': false,
          };
        } else {
          return {
            'error': true,
            'errorData': decodedResponse['error_data'].toString(),
          };
        }
      } else {
        return {
          'error': true,
          'errorData': response.statusCode == 500
              ? 'Server error : Please try again after a while'
              : response.statusCode == 404
                  ? 'Invalid Request : Not Found'
                  : 'Connection error : Please try again after a while',
        };
      }
    } catch (e) {
      return {
        'error': true,
        'errorData': e.toString(),
      };
    }
  }

  /// Get comment replies
  Future<Map> getCommentReplies(String commentID) async {
    try {
      final String apiToken = await Prefs().getApiToken();
      final response = await post(Uri.parse(uGetCommentReplies), body: {
        'api_token': apiToken,
        'comment_id': commentID,
      });
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        if (!decodedResponse['error']) {
          List<ReplyModel> replies = List.empty(growable: true);
          final decodedReplies = decodedResponse['replies'];
          for (final decodedReply in decodedReplies) {
            replies.add(ReplyModel.fromJson(decodedReply));
          }
          return {
            'error': false,
            'replies': List<ReplyModel>.from(replies.reversed),
          };
        } else {
          return {
            'error': true,
            'errorData': decodedResponse['error_data'].toString(),
          };
        }
      } else {
        return {
          'error': true,
          'errorData': response.statusCode == 500
              ? 'Server error : Please try again after a while'
              : response.statusCode == 404
                  ? 'Invalid Request : Not Found'
                  : 'Connection error : Please try again after a while',
        };
      }
    } catch (e) {
      return {
        'error': true,
        'errorData': e.toString(),
      };
    }
  }

  /// Get followers
  Future<Map> getFollowers(String userID) async {
    try {
      final String apiToken = await Prefs().getApiToken();
      final response = await post(Uri.parse(uGetUserFollowers), body: {
        'api_token': apiToken,
        'user_id': userID,
      });
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        if (!decodedResponse['error']) {
          final List<UserModel> followers = List.empty(growable: true);
          final decodedFollowers = decodedResponse['followers'];
          for (final decodedFollower in decodedFollowers) {
            followers.add(UserModel.fromJson(decodedFollower));
          }
          return {
            'error': false,
            'followers': followers,
          };
        } else {
          return {
            'error': true,
            'errorData': decodedResponse['error_data'].toString(),
          };
        }
      } else {
        return {
          'error': true,
          'errorData': response.statusCode == 500
              ? 'Server error : Please try again after a while'
              : response.statusCode == 404
                  ? 'Invalid Request : Not Found'
                  : 'Connection error : Please try again after a while',
        };
      }
    } catch (e) {
      return {
        'error': true,
        'errorData': e.toString(),
      };
    }
  }

  /// Get following
  Future<Map> getFollowing(String userID) async {
    try {
      final String apiToken = await Prefs().getApiToken();
      final response = await post(Uri.parse(uGetUserFollowings), body: {
        'api_token': apiToken,
        'user_id': userID,
      });
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        if (!decodedResponse['error']) {
          final List<UserModel> following = List.empty(growable: true);
          final decodedFollowing = decodedResponse['following'];
          for (final decodedFollow in decodedFollowing) {
            following.add(UserModel.fromJson(decodedFollow));
          }
          return {
            'error': false,
            'following': following,
          };
        } else {
          return {
            'error': true,
            'errorData': decodedResponse['error_data'].toString(),
          };
        }
      } else {
        return {
          'error': true,
          'errorData': response.statusCode == 500
              ? 'Server error : Please try again after a while'
              : response.statusCode == 404
                  ? 'Invalid Request : Not Found'
                  : 'Connection error : Please try again after a while',
        };
      }
    } catch (e) {
      return {
        'error': true,
        'errorData': e.toString(),
      };
    }
  }

  /// Get verification status
  Future<Map> getVerificationStatus() async {
    try {
      final String apiToken = await Prefs().getApiToken();
      final response = await post(Uri.parse(uGetVerificationStatus), body: {
        'api_token': apiToken,
      });
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        if (!decodedResponse['error']) {
          VerificationStatusModel verificationStatus =
              VerificationStatusModel.fromJson(decodedResponse);
          return {
            'error': false,
            'verificationStatus': verificationStatus,
          };
        } else {
          return {
            'error': true,
            'errorData': decodedResponse['error_data'].toString(),
          };
        }
      } else {
        return {
          'error': true,
          'errorData': response.statusCode == 500
              ? 'Server error : Please try again after a while'
              : response.statusCode == 404
                  ? 'Invalid Request : Not Found'
                  : 'Connection error : Please try again after a while',
        };
      }
    } catch (e) {
      return {
        'error': true,
        'errorData': e.toString(),
      };
    }
  }
  /// Get Single Post
  Future<Map> getSinglePost(Map<String, String> getpost) async {
    try {
      final String apiToken = await Prefs().getApiToken();
      var request = MultipartRequest('POST', Uri.parse(ugetSinglePost));
      request.headers["authorization"] = "Bearer $apiToken";
      request.fields.addAll(getpost);
      StreamedResponse streamedResponse = await request.send();
      if (streamedResponse.statusCode == 200) {
        print('Enter In 200 Enter In 200');
        var response = await streamedResponse.stream.bytesToString();
        var decodedResponse = jsonDecode(response);
        if (!decodedResponse['error']) {
          print('NO error Found NO error Found');
          var decodedRes = decodedResponse['post'];
          print('decodedResponse decodedResponse decodedResponse');
          print(decodedResponse);
          print('decodedResponse decodedResponse decodedResponse');
          return {
            'error': false,
            'post': PostModel.fromJson(decodedRes),
          };
        } else {
          return {
            'error': true,
            'errorData': decodedResponse['error_data'].toString(),
          };
        }
      } else {
        return {
          'error': true,
          'errorData': streamedResponse.statusCode == 500
              ? 'Server error : Please try again after a while'
              : streamedResponse.statusCode == 404
              ? 'Invalid Request : Not Found'
              : 'Connection error : Please try again after a while',
        };
      }
    } catch (e) {
      return {
        'error': true,
        'errorData': e.toString(),
      };
    }
  }
}


