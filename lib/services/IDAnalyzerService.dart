import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

class IDAnalyzerService {
  final String apiKey = "ur api key"; // Replace with your API key
  final String apiUrl = "https://api2.idanalyzer.com/quickscan"; // EU endpoint

  Future<void> analyzeID(File idImage, File faceImage, String profileId) async {
    final url = Uri.parse(apiUrl);

    // Resize both document and face images
    final resizedDocumentImage = await _resizeImage(idImage);
    final resizedFaceImage = await _resizeImage(faceImage);

    // Convert resized images to base64
    final documentBase64 = base64Encode(resizedDocumentImage);
    final faceBase64 = base64Encode(resizedFaceImage);

    // Build the payload
    final payload = {
      'profile': profileId,
      'document': documentBase64,
      'face': faceBase64,
    };

    // Set headers
    final headers = {
      'X-API-KEY': apiKey,
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'ocrMode': 'advanced',
    };

    // Send the POST request
    final response = await http.post(
      url,
      headers: headers,
      body: json.encode(payload),
    );

    // Handle the response
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      if (responseData['success'] == true) {
        // Extract the required information
        final extractedData = {
          'success': true,
          'age': responseData['data']['age']?.first['value'] ?? null,
          'country': responseData['data']['countryFull']?.first['value'] ?? null,
          'dob': responseData['data']['dob']?.first['value'] ?? null,
          'confidence': responseData['data']['age']?.first['confidence'] ?? null,
          'daysToExpiry': responseData['data']['daysToExpiry']?.first['confidence'] ?? null,
          'cin': responseData['data']['backSideId']?.first['value'] ?? null, // Extract CIN if available
          'firstName': responseData['data']['firstName']?.first['value'] ?? null,
          'lastName': responseData['data']['lastName']?.first['value'] ?? null,
          'adresse': responseData['data']['adresse']?.first['value'] ?? null,
        };
        print("response data ............................");
        print(responseData);
        print(extractedData); // Print the extracted data
      } else {
        print( {
          'success': false,
          'message': 'Image recognition failed. No valid data extracted.'
        });
      }
      // Handle successful response
    } else {
      print("Error: ${response.statusCode}, ${response.body}");
      // Handle error response
    }
  }

  Future<List<int>> _resizeImage(File imageFile) async {
    // Decode the image file to manipulate it
    final image = img.decodeImage(await imageFile.readAsBytes());

    // Resize the image to a width of 800px while keeping the aspect ratio
    final resizedImage = img.copyResize(image!, width: 800);

    // Encode the resized image to JPEG format with reduced quality
    return img.encodeJpg(resizedImage, quality: 85);
  }
}
